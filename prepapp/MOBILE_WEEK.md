# Working from mobile / tablet for a week — what still moves

No Mac needed for most of it. The trick: **GitHub's web editor** works in a phone
or tablet browser, and pushing to `main` triggers your Vercel deploy. So real
code changes can ship from an iPad.

---

## What each side can do this week

| Work | Who | Needs Mac? |
|---|---|---|
| Database engines, RPCs, content, data fixes | **me, directly** | no |
| Front-end code changes (adviser prompt, screens) | **you paste, I write** | no — GitHub web editor |
| Deploy web + PWA (both = live app) | automatic on push (Vercel) | no |
| Android build / Google Play | Appflow or Codemagic cloud | no |
| **iOS certificate (.p12 via Keychain)** | — | **yes** |
| iOS build/TestFlight *if* using Codemagic automatic signing | maybe (see below) | maybe not |

**Important:** your iOS app loads `aspira.study`. So **any web change you deploy
this week appears in the iOS app too**, the moment it's installed. You are not
blocked from improving the mobile app — only from *first-time publishing* it.

---

## The workflow (works on tablet)

1. Open **github.com/jonbobo212/prepapp** in the browser, sign in.
2. Navigate to the file (or press **`t`** / use the search box to find it by name).
3. Tap the **pencil ✏️ icon** → edit → scroll down → **Commit changes** to `main`.
4. Vercel builds automatically. Check **vercel.com** → your project → Deployments.
5. Open aspira.study — the change is live.

> Tip: a tablet with a keyboard makes this genuinely comfortable. On a phone,
> stick to small edits (like the adviser prompt) rather than whole new screens.

**Even easier for big files:** github.com → the file → pencil → **select all,
delete, paste** the full file I give you. No merge conflicts, no partial edits.

---

## Order of work for the week

**1. Feature 2 — adviser prompt (best first: one text block, huge effect)**
- Find the adviser code: on GitHub, use the repo search for `study_adviser`
  or browse `app/api/`. Tell me the file path and I'll give you the exact
  replacement text.
- Effect: every adviser reply becomes short, warm, plain English, no `**`.

**2. Feature 2b — calm home (hide SAT / test-plan / checklist cards)**
- A few lines of conditional logic in the home screen component.

**3. Feature 3 — daily habit (spaced repetition + streak)**
- Engine is live; the screen needs a moderate edit. Good tablet task.

**4. Feature 1 — chancing screen (new page)**
- Biggest UI. Best saved for the Mac, or I can write a complete drop-in page
  file you paste in one go.

**5. Meanwhile, I keep shipping DB-side** — more content, engines, data quality.
No approval or device needed from you.

---

## iOS while away — one thing worth trying

Appflow needs a `.p12` certificate, which needs **Keychain Access on a Mac**.
**But Codemagic** (codemagic.io) supports **automatic iOS code signing** using an
**App Store Connect API key** — a `.p8` file you can download from
appstoreconnect.apple.com in a browser. If your tablet can download the `.p8` and
upload it to Codemagic, a cloud iOS build may be possible with **no Mac at all**.

Worth 20 minutes to try:
1. appstoreconnect.apple.com → **Users and Access → Integrations → App Store
   Connect API** → generate a key → download the `.p8` (**you can only download
   it once**).
2. codemagic.io → sign in with GitHub → add `prepapp` → **Teams/Settings → code
   signing identities** → upload the `.p8` (Issuer ID + Key ID).
3. Start an iOS build → publish to TestFlight.

If any step refuses to work on tablet, park it — it all works on the Mac later.
Also: register the App ID (`study.aspira.app`) at developer.apple.com in the
browser now; that part is mobile-friendly and needed either way.

---

## Google Play in parallel (no Mac, no wait)

Your repo already has `android/`. Google Play is a **one-time $25**, and Google
can manage the signing key for you — so a cloud build (Appflow/Codemagic) can
produce the `.aab`, and you upload it in the Play Console browser. This can
genuinely finish from a tablet while Apple waits.
