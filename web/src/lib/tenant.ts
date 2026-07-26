import "server-only";
import { cache } from "react";
import { db } from "./db";

export type TenantType = "school" | "agency" | "language_center" | "teacher" | "influencer";
export type TenantStatus = "draft" | "generating" | "review" | "live" | "suspended";

/** Trilingual value: keys are locale codes (uz/tg/ky + ru + en). */
export type L10n = Record<string, string>;

export interface Tenant {
  id: string;
  slug: string;
  type: TenantType;
  template: "school" | "agency" | "center" | "teacher_card" | "linkbio";
  name: string;
  city: string | null;
  country: "uz" | "tj" | "kg";
  locales: string[];
  default_locale: string;
  brand: { primary?: string; accent?: string; logo_url?: string };
  contact: { phone?: string; address?: L10n; telegram?: string; instagram?: string };
  partner_code: string | null;
  status: TenantStatus;
}

export interface Post {
  id: string;
  kind: "news" | "achievement" | "announcement";
  title: L10n;
  body: L10n;
  cover_url: string | null;
  published_at: string | null;
}

export interface Section {
  id: string;
  page: string;
  kind: string;
  position: number;
  content: Record<string, unknown>;
  visible: boolean;
}

export const getTenant = cache(async (slug: string): Promise<Tenant | null> => {
  const { data, error } = await db()
    .from("vitrina_tenants")
    .select("*")
    .eq("slug", slug)
    .maybeSingle();
  if (error) throw new Error(`tenant lookup failed: ${error.message}`);
  if (!data || data.status === "suspended") return null;
  return data as Tenant;
});

export const getSections = cache(async (tenantId: string, page: string): Promise<Section[]> => {
  const { data, error } = await db()
    .from("vitrina_sections")
    .select("id, page, kind, position, content, visible")
    .eq("tenant_id", tenantId)
    .eq("page", page)
    .eq("visible", true)
    .order("position");
  if (error) throw new Error(`sections lookup failed: ${error.message}`);
  return (data ?? []) as Section[];
});

export async function getPosts(tenantId: string, kind?: Post["kind"], limit = 12): Promise<Post[]> {
  let q = db()
    .from("vitrina_posts")
    .select("id, kind, title, body, cover_url, published_at")
    .eq("tenant_id", tenantId)
    .not("published_at", "is", null)
    .order("published_at", { ascending: false })
    .limit(limit);
  if (kind) q = q.eq("kind", kind);
  const { data, error } = await q;
  if (error) throw new Error(`posts lookup failed: ${error.message}`);
  return (data ?? []) as Post[];
}

export async function getPost(tenantId: string, id: string): Promise<Post | null> {
  const { data, error } = await db()
    .from("vitrina_posts")
    .select("id, kind, title, body, cover_url, published_at")
    .eq("tenant_id", tenantId)
    .eq("id", id)
    .not("published_at", "is", null)
    .maybeSingle();
  if (error) throw new Error(`post lookup failed: ${error.message}`);
  return (data as Post) ?? null;
}

/** Resolve the effective locale for a request ("_" = tenant default). */
export function resolveLocale(tenant: Tenant, raw: string): string | null {
  if (raw === "_") return tenant.default_locale;
  return tenant.locales.includes(raw) ? raw : null;
}

/** Pick a localized string with graceful fallback (locale → default → ru → en → any). */
export function pick(value: L10n | undefined | null, locale: string, fallback = ""): string {
  if (!value) return fallback;
  for (const key of [locale, "ru", "en"]) {
    const v = value[key];
    if (typeof v === "string" && v.length > 0) return v;
  }
  const first = Object.values(value).find((v) => typeof v === "string" && v.length > 0);
  return (first as string) ?? fallback;
}

/** Locale-prefixed path on the tenant's own domain (default locale is unprefixed). */
export function localePath(tenant: Tenant, locale: string, path = "/"): string {
  const clean = path.startsWith("/") ? path : `/${path}`;
  return locale === tenant.default_locale ? clean : `/${locale}${clean === "/" ? "" : clean}`;
}
