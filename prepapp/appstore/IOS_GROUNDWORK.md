# Aspira → iOS: groundwork runbook (fastest legit path)

Your inputs: **Mac + Xcode ✓**, **Apple Developer account (recover the old one)**,
goal = **PWA / fastest way**, and "tomorrow = groundwork ready, plan the rest."

This is the drop-in package. Apply it in the **`prepapp`** (Aspira) repo on a
new branch `launch/ios`. Nothing here changes runtime behaviour of the live site
except the added PWA metadata; the native app loads the same site.

Aspira is a Next.js App Router app (server components + API routes), so a full
static export isn't practical. The fastest reliable route is **Capacitor loading
`https://aspira.study` + real native features** so it clears App Review
Guideline 4.2. Honest risk note is at the bottom.

---

## Order of work

**Tonight (groundwork, no submission):**
1. Recover the Apple Developer account (longest pole — do this first).
2. PWA hardening (steps 1–2 below) — ships value even before the App Store.
3. Capacitor scaffold + open in Xcode, run on a simulator (steps 3–5).
4. Wire the 3 native features that justify a native app (step 6).

**Tomorrow+ (when you're ready):** icon + real screenshots → App Store Connect →
submit. Metadata/privacy already drafted in `APP_STORE_LAUNCH_KIT.md` and
`PRIVACY_POLICY.md`.

---

## 1) PWA manifest — `public/manifest.webmanifest`

```json
{
  "name": "Aspira: IELTS & Study Abroad",
  "short_name": "Aspira",
  "description": "Learn English, prep IELTS, and reach your dream university.",
  "start_url": "/?source=pwa",
  "display": "standalone",
  "background_color": "#0B1220",
  "theme_color": "#0B1220",
  "orientation": "portrait",
  "icons": [
    { "src": "/icons/icon-192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/icons/icon-512.png", "sizes": "512x512", "type": "image/png" },
    { "src": "/icons/icon-512-maskable.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable" }
  ]
}
```
> Replace `#0B1220` with Aspira's real brand background/theme colour.
> Generate the icon PNGs from the 1024×1024 master (see step 7).

## 2) Installability metadata — in `app/layout.tsx`

Next.js App Router way (no manual `<head>` needed):

```ts
export const metadata = {
  metadataBase: new URL("https://aspira.study"),
  manifest: "/manifest.webmanifest",
  appleWebApp: { capable: true, statusBarStyle: "black-translucent", title: "Aspira" },
};
export const viewport = {
  themeColor: "#0B1220",
  viewportFit: "cover",       // respects iPhone safe areas
  width: "device-width",
  initialScale: 1,
};
```
This alone makes "Add to Home Screen" on iOS Safari look like a real app —
your instant, no-Apple-review mobile presence.

*(Optional offline shell: add `@ducanh2912/next-pwa` or Serwist to cache the app
shell + catalog reads. Never cache personalized data. This is a nice-to-have, not
a blocker for iOS wrapping.)*

## 3) Install Capacitor (in the prepapp repo)

```bash
npm i @capacitor/core @capacitor/ios
npm i -D @capacitor/cli
npx cap init Aspira study.aspira.app --web-dir=public
```

## 4) `capacitor.config.ts`

```ts
import type { CapacitorConfig } from "@capacitor/cli";

const config: CapacitorConfig = {
  appId: "study.aspira.app",
  appName: "Aspira",
  webDir: "public",                 // minimal shell; app is loaded from server.url
  server: { url: "https://aspira.study", cleartext: false },
  ios: { contentInset: "automatic", backgroundColor: "#0B1220" },
  plugins: {
    SplashScreen: { launchShowDuration: 700, backgroundColor: "#0B1220", showSpinner: false },
  },
};
export default config;
```

## 5) Add + open iOS

```bash
npx cap add ios
npx cap sync ios
npx cap open ios          # opens Xcode
```
In Xcode: select your Team (the recovered Apple account), set the bundle id
`study.aspira.app`, pick a simulator, Run. You should see Aspira running as an app.

## 6) The 3 native features that clear Guideline 4.2

Do at least two. All are quick and need **no backend**:

**a. Daily streak reminder — Local Notifications**
```bash
npm i @capacitor/local-notifications
```
```ts
import { LocalNotifications } from "@capacitor/local-notifications";
export async function scheduleStreakReminder() {
  await LocalNotifications.requestPermissions();
  await LocalNotifications.schedule({
    notifications: [{
      id: 1, title: "Keep your streak 🔥",
      body: "5 minutes of English today keeps your dream moving.",
      schedule: { on: { hour: 19, minute: 0 }, repeats: true },
    }],
  });
}
```

**b. Native share for the 9:16 achievement cards — Share**
```bash
npm i @capacitor/share
```
```ts
import { Share } from "@capacitor/share";
export const shareCard = (url: string) =>
  Share.share({ title: "My Aspira achievement", url });
```
Call this from the existing share-card UI when running natively.

**c. Polish — Splash, Status Bar, Haptics** (`@capacitor/splash-screen`,
`@capacitor/status-bar`, `@capacitor/haptics`). Small, but reads as "native."

> Detect native context with Capacitor's `isNativePlatform()` so the web build is
> unaffected and only the app gets these.

## 7) Icon + screenshots

- **Icon:** one 1024×1024 master (no alpha/rounded corners — Apple rounds it).
  Generate `192/512/512-maskable` for the PWA from the same master.
  *(I can generate an icon concept via the image tool when it's connected.)*
- **Screenshots:** capture from the **running app** in the iOS simulator
  (6.7" + 6.5" required). Must be real screens — Apple forbids mockups.

## 8) Submit (later, from the kit)

Follow `APP_STORE_LAUNCH_KIT.md` → runbook: App Store Connect record, paste the
listing copy, upload icon + screenshots, fill App Privacy from the label mapping,
attach the published privacy-policy URL, submit.

---

## Honest risk + alternatives

- **Guideline 4.2 (min functionality):** a Capacitor app pointing at your live
  URL *can* pass, but only if the native value is real — that's why step 6 isn't
  optional. If review pushes back, reply listing the native features. Adding push
  notifications (APNs) later is the strongest 4.2 answer if needed.
- **Lower-rejection alternative (more work):** refactor the student-facing shell
  to load locally in Capacitor and call the API over the network, instead of a
  remote URL. Bigger job — not for tomorrow.
- **Fastest store win of all:** Google Play TWA via PWABuilder — often live in a
  day, far more lenient than Apple. Worth doing in parallel.

## What blocks me from doing this directly

The `prepapp` repo isn't attachable from this session (approval-gated), so I can't
open a `launch/ios` branch and apply these myself here. To have me do it:
attach `jonbobo212/prepapp` to a session, or run the steps above on your Mac —
they're copy-paste complete.
