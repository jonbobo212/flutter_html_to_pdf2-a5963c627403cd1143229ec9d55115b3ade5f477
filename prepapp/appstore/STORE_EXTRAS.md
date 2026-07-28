# Store extras — Google Play (fast win) + support/marketing page copy

Companion to `APP_STORE_LAUNCH_KIT.md` and `IOS_GROUNDWORK.md`.

## Google Play via TWA (often live within a day — do in parallel with iOS)

A Trusted Web Activity wraps your PWA for Android with far less friction than
Apple. Requires the PWA metadata from `IOS_GROUNDWORK.md` step 1–2 to be live.

1. Go to **PWABuilder.com**, enter `https://aspira.study`, let it score the PWA
   (fix any manifest/service-worker gaps it flags).
2. Generate the **Android package** → download the `.aab` + the
   `assetlinks.json`.
3. Host `assetlinks.json` at `https://aspira.study/.well-known/assetlinks.json`
   (verifies you own the domain; removes the browser URL bar).
4. Google Play Console ($25 one-time) → create app → upload `.aab` →
   fill listing (reuse the App Store copy) → Data safety form (mirror the App
   Privacy label mapping) → submit. Review is usually fast.

Note: Play also allows PWABuilder without a Mac, so Android can ship even before
the iOS build is ready.

## Support page copy — publish at `https://aspira.study/support`

App Store requires a working support URL. Minimal, honest version:

```
# Aspira Support

Need help? We're here.

Email: [SUPPORT EMAIL]        (we reply within [1–2] working days)
Telegram: [@handle, optional]

Common questions
- How do I reset my level? Settings → Retake placement test.
- How do I turn off reminders? Settings → Notifications.
- How do I delete my account and data? Email us and we'll remove it.

Privacy: https://aspira.study/privacy
```

## Marketing one-liner (App Store marketing URL / social)

> Aspira helps students learn English, prep IELTS, and find the right university
> and scholarship — one small step at a time, in their own language.

## Reminder: no fabricated assets

- App icon: generate a real 1024×1024 master (I can draft an icon concept via the
  image tool once it's connected).
- Screenshots: capture from the running app only. No mockups (both stores reject
  fabricated UI).
