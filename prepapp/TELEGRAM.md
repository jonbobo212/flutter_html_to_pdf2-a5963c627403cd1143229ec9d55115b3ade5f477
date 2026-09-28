# Aspira — Telegram login and reminders

Written 2026-09-28. Both features were broken; this is what was wrong, what
replaced them, and how to operate them.

---

## What was actually broken

**Login had never worked once.** 0 of 25 students had a `telegram_id`.
The Login Widget asks `oauth.telegram.org` to render a button for the page's
origin, and that answered:

```
$ curl -s "https://oauth.telegram.org/embed/aspiraa_bot?origin=https%3A%2F%2Fwww.aspira.study&size=large"
Bot domain invalid
```

Same for the apex. The bot's login domain was never registered with BotFather
(`/setdomain`), so the button could never appear for any student.

**Reminders had never fired either.** `/api/cron/nudge` requires `CRON_SECRET`,
and that variable did not exist in Vercel at all — so every daily run returned:

```
503 {"error":"nudge not configured"}
```

Two independent faults. Fixing either alone would still have left the feature
dead.

## Why the widget wasn't just re-enabled

Registering the domain would have fixed the button on desktop, and left two
problems that matter more:

1. **The widget links an account without opening a chat with the bot.**
   Telegram only delivers a message to a user who has started that chat. So
   widget-linked students could never receive a reminder — which is why the app
   had a separate "now press Start" card, a step most people skip.
2. **It is a popup OAuth flow**, which is fragile inside the Capacitor
   WKWebView being shipped to the App Store, and it makes the student type a
   phone number and an SMS code on a device where the Telegram app is already
   installed and logged in.

## What replaced it

The bot's own deep link, `t.me/aspiraa_bot?start=<token>`:

1. `/account` (or `/login`) calls `POST /api/auth/telegram/start`, which mints
   a token and a poll secret and stores only their sha256.
2. The student taps through to the **native Telegram app** and presses Start.
3. Telegram calls `POST /api/telegram/webhook`, which links the account.
4. The waiting page polls `POST /api/auth/telegram/status` and becomes that
   student.

**Pressing Start is the login.** No registered domain is needed, it works in
the webview, and the bot chat is guaranteed open afterwards — so the daily
nudge can actually be delivered. The separate "press Start" card is gone.

### The two secrets

| Value | Travels where | Authorises |
|---|---|---|
| `token` | inside the deep link → lands in a Telegram message | nothing except redeeming the link, once |
| `poll_secret` | never leaves the device that started the flow | reading back the linked student id |

The token must be treated as visible: anyone looking at that chat can read it.
So it cannot be what reveals the account. They are kept in **`tg_link_tokens`**,
deliberately *not* `signin_tokens` — a token seen in a chat must never be
redeemable at `/api/auth/link` as a full sign-in credential.

### Recovery on a new phone

A device with no account sends `student_id: null`. The webhook then resolves the
student from the Telegram id alone and returns it (`recovered: true`). If that
Telegram is already attached to a student, the link **resolves to that student
rather than relinking** — `students.telegram_id` is UNIQUE, and recovering the
existing account is what the student wants anyway.

## Files

| Path | Role |
|---|---|
| `lib/telegram.ts` | bot token, Bot API calls, trilingual bot copy |
| `app/api/auth/telegram/start/route.ts` | mint token + poll secret |
| `app/api/auth/telegram/status/route.ts` | poll (needs the poll secret) |
| `app/api/telegram/webhook/route.ts` | link, `/stop`, `/resume`, `/help`, blocks |
| `app/api/telegram/setup/route.ts` | register the webhook, report health |
| `components/telegram-login.tsx` | the Connect button, polling, desktop QR |
| `app/api/cron/nudge/route.ts` | the daily reminder |

Deleted as dead: `components/telegram-start.tsx`, and the widget verification
route `app/api/auth/telegram/route.ts`.

## Environment

| Variable | Status |
|---|---|
| `TELEGRAM_BOT_TOKEN` | already existed |
| `NEXT_PUBLIC_TELEGRAM_BOT` | already existed (`aspiraa_bot`) |
| `CRON_SECRET` | **added** — was missing, which killed the cron |
| `TELEGRAM_WEBHOOK_SECRET` | **added** — authenticates the webhook |

## Operating it

Health check (safe, read-only):

```
GET https://www.aspira.study/api/telegram/setup?secret=<CRON_SECRET>
```

Re-register the webhook, e.g. after changing domain:

```
GET https://www.aspira.study/api/telegram/setup?secret=<CRON_SECRET>&install=1&url=https%3A%2F%2Fwww.aspira.study
```

> `url` matters. `aspira.study` 308-redirects to `www.aspira.study`, and
> **Telegram does not follow redirects when delivering webhooks** — the
> registered URL must be the canonical host exactly.

This endpoint exists so the bot token never has to be pasted into a terminal, a
chat, or a browser. It stays in the Vercel environment and only the server
reads it.

Run the nudge by hand:

```
curl https://www.aspira.study/api/cron/nudge -H "Authorization: Bearer <CRON_SECRET>"
```

## Verified 2026-09-28, against production

| Check | Result |
|---|---|
| `getMe` | ok — `aspiraa_bot`, id 8474714652 |
| `setWebhook` | ok — `https://www.aspira.study/api/telegram/webhook` |
| webhook without the secret header | **401** |
| mint → pending → Start → linked | student id returned correctly |
| replaying a used token | ignored, no second link |
| new device, no student id | resolved to the same student, `recovered: true` |
| `/stop` → `/resume` | `notify_opt_out` true, then false |
| nudge without the secret | **401** (was 503 every day) |
| nudge with the secret | ran, 1 candidate, reached Telegram |

Done with a throwaway student and a fake telegram id; every test row deleted
afterwards (back to 25 students, 0 tokens).

## Still needs a human

**Nothing blocks login any more** — the deep link needs no BotFather change.

Optional polish, in rough order of value:

1. **BotFather → `/setcommands`** so `/stop`, `/resume` and `/help` appear in
   the bot's menu. The commands already work; this only makes them visible.
2. **BotFather → `/setdescription`** and a bot profile photo — it is the first
   screen a student sees when the deep link opens.
3. `NEXT_PUBLIC_APP_URL` is `https://aspira.study`, so every reminder button
   costs the student one redirect hop to `www`. Harmless; set it to the `www`
   form to remove it.
4. `/setdomain` is now only needed if the Login Widget is ever wanted back on
   desktop. Nothing depends on it.

## Rollback

```sql
drop table if exists public.tg_link_tokens;
```

Then revert the app commits. Note this restores a login that never worked, so
rolling back is only sensible together with registering the BotFather domain.
