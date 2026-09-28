# Build 1.0 (5) — adding the native layer

Written 2026-09-28. Why this build exists, and the exact commands.

---

## Why a new binary is needed at all

Almost nothing needs one. The shell loads `https://www.aspira.study`, so every
web change — Telegram login, account deletion, layout fixes — is already inside
**build 1.0 (4)** with no upload. That is worth remembering before assuming a
rebuild.

This build is the exception, because native plugins are compiled in.

## What changed

The app shipped with **no Capacitor plugins at all** — `core`, `ios`, `android`
and `cli` only, and no plugin call anywhere in app code. A WKWebView pointing at
a URL and doing nothing a browser can't is the shape Apple rejects under
**guideline 4.2** (minimum functionality). `IOS_GROUNDWORK.md` had called this
out as not optional; it was never done.

It also hid two features that were dead inside the app:

| | Before | Now |
|---|---|---|
| Daily reminder | Telegram only. A student who never linked got nothing. | On-device notification at 19:00 local for exactly those students. |
| Share an achievement | `navigator.share`, else `<a download>`. WKWebView has neither, so the button did nothing. | Native share sheet. |

Plus haptics on the reminder toggle and a successful share.

A student with Telegram linked is deliberately **skipped** for the local
notification — the bot already messages them, and two reminders for one day is
worse than one. `/me` re-asserts the schedule on every visit, so it survives a
reinstall, a language change, or linking Telegram on another screen.

All of it sits behind `isNative()` with dynamic imports (`lib/native.ts`), so
the web build never loads the plugin code.

## Commands (on the Mac, in `~/prepapp`)

```bash
git pull
npm install
npx cap sync ios
```

`cap sync` resolves the four new plugins through SPM. This project has **no
CocoaPods** — there is only `App.xcodeproj`, no `App.xcworkspace`. Never pass
`-workspace`.

Bump the build number, then archive and upload:

```bash
cd ios/App
xcodebuild -project App.xcodeproj -scheme App -configuration Release \
  -destination 'generic/platform=iOS' -archivePath build/App.xcarchive \
  CURRENT_PROJECT_VERSION=5 archive
```

Then export and upload exactly as for build 4 (`exportArchive`, then
`xcrun altool --upload-app` with the App Store Connect key at
`~/.appstoreconnect/private_keys/AuthKey_A8QVQ323JT.p8`).

> The `.p8` is a private credential. It stays on the Mac, chmod 600. Never
> commit it, never paste it into a chat or a browser.

## First launch after installing

iOS asks for notification permission the first time reminders are switched on
in `/me` — not at launch. If you want to see it: install 1.0 (5), open **Me**,
turn reminders off and on again while **not** linked to Telegram.

Worth doing before submitting, because it is also the clearest 4.2 evidence to
show a reviewer.

## Still open

- Appflow is still wired up and still failing; it treats the project as Cordova
  and looks for a `config.xml`. The local pipeline works. Disable it.
- `NEXT_PUBLIC_APP_URL` is `https://aspira.study`, which 308s to `www`. Harmless
  — one redirect hop per reminder tap.
