# Aspira — App Store Launch Kit

Prepared 2026-07-28. Everything here is submission-ready copy + a runbook.
It does **not** include the app binary — that has to be built from the Aspira
app repo (not attached to this session). Read "The honest timeline" first.

---

## The honest timeline (read this)

Aspira today is a **web app / PWA** on `aspira.study` (Next.js on Vercel).
The Apple App Store does not accept a URL — it needs a **native iOS binary**.
A realistic, accepted App Store launch **cannot be guaranteed for tomorrow**.
Here's why, and the fastest real paths:

**Hard gates that are outside my control:**
1. **Apple Developer Program** membership ($99/yr). If not already active,
   enrolment + identity verification alone can take 24–48h.
2. **A native build.** The fastest route is wrapping the PWA with **Capacitor**
   (or PWABuilder). Building/uploading needs a **Mac + Xcode** or a cloud
   builder (Codemagic / EAS / Ionic Appflow).
3. **App Review.** Usually ~24h now, but **not guaranteed**, and Apple often
   **rejects thin web wrappers** under Guideline **4.2 (Minimum Functionality)** —
   "a website in a shell" gets bounced. This is the #1 risk to a fast launch.

**Fastest paths, pick per goal:**
- **Mobile presence *today*, zero gatekeeping:** ship the PWA as
  "Add to Home Screen." Real, installable, no Apple review. (Not the App Store.)
- **App Store, realistically:** Capacitor wrap **+ real native value** (push
  notifications, offline lessons, native share for the 9:16 cards) to clear 4.2 →
  build → submit tomorrow **if** the Apple account + Mac/CI are ready →
  approval likely **1–3 days**, rejection possible.
- **Want a fast store win anyway?** **Google Play** via a TWA (PWABuilder) is
  much faster and more lenient than Apple — often live within a day.

**What "prepare everything for tomorrow" means in practice:** get the account,
wrapper, and assets ready tonight so tomorrow is *submission*, not scramble. The
copy, privacy policy, and checklist below are that prep.

---

## Decisions I need from you

1. Is the **Apple Developer account** already active? (If no → that's the
   critical-path blocker; start enrolment now.)
2. Do you have a **Mac/Xcode** or should we use a **cloud builder** (Codemagic)?
3. **Wrapper approach:** Capacitor (recommended) vs a from-scratch native app?
4. **Attach the Aspira app repo** to a session so the wrapper + native features
   can actually be built. Which repo — `jonbobo212/aspira`? `prepapp`?
5. **Minors:** what's the youngest intended user, and which markets? This drives
   the age rating and whether Apple's Kids Category rules apply (see below).

---

## Store listing copy (ready to paste)

- **App Name (30 char max):** `Aspira: IELTS & Study Abroad`
- **Subtitle (30):** `Learn English, reach your dream`
- **Promotional text (170):** `Prep IELTS, get instant AI essay feedback, and
  discover universities and scholarships that fit your dream — in your language.`
- **Keywords (100, comma-sep):**
  `IELTS,English,study abroad,scholarship,university,essay,speaking,practice,exam,TOEFL,vocabulary,learn`
- **Description:** *(fill from the draft below; keep it honest — no "guaranteed
  admission" claims, which Apple/consumer rules dislike)*

```
Aspira is your calm, personal guide to studying abroad.

• Find your level with a quick English placement test
• Practice IELTS Reading, Listening, Speaking and Writing
• Get instant, kind feedback on your essays from an AI tutor
• Learn new words and keep a daily streak
• Explore universities and scholarships that match your goal
• Study in your language — English, Uzbek, Russian

Built for students who are just starting out. Simple words, small steps,
real progress toward your dream.
```

- **Support URL:** `https://aspira.study/support` *(must exist before submit)*
- **Marketing URL:** `https://aspira.study`
- **Privacy Policy URL:** `https://aspira.study/privacy` *(publish the drafted
  `PRIVACY_POLICY.md` there — required)*

## App Privacy "nutrition label" (App Store Connect answers)

Data **collected and linked** to the user, used for **App Functionality**
(and Analytics where noted). **Not** used for Tracking; **no** third-party ads.

- **Contact Info:** name, email, phone number.
- **User Content:** essays and other text submitted (adviser/essay checker).
- **Identifiers:** user ID; Telegram ID (if notifications enabled).
- **Usage Data:** product interaction / progress (App Functionality + Analytics).
- **Education/Other:** study goals, level, target university.

Answer "Yes" to data collection; map each item above; mark all as **linked to
identity**, purpose **App Functionality** (Usage Data may also be **Analytics**),
**not used for tracking**.

## Minors / age rating

Aspira's audience includes young students. Two implications:
- **Age rating questionnaire:** content is educational → likely **4+**, but
  answer truthfully (user-generated text + web links may raise it).
- **Kids Category / COPPA:** if the app is *directed to children under 13*, Apple
  requires the Kids Category with strict rules (no third-party analytics/ads,
  parental gates). **Decide with legal** whether to (a) position as general
  education 12+/13+ with an age gate, or (b) enter the Kids Category. This
  materially affects analytics and the privacy policy. Do this before submitting.

## Assets checklist

- [ ] **App icon** 1024×1024 (no alpha). *(I can generate an icon concept via the
      image tool when it's connected — say the word.)*
- [ ] **Screenshots** — 6.7" and 6.5" iPhone required, 5.5" optional; iPad if
      supported. **Must be real app screens** (Apple forbids fabricated UI) —
      these come from the running wrapped app, so they need the repo + a build.
- [ ] App preview video (optional).
- [ ] Privacy policy live at the URL above.
- [ ] Support + marketing URLs live.

## Submission runbook

1. Confirm Apple Developer account active; create the App ID + App Store Connect
   record (bundle id e.g. `study.aspira.app`).
2. In the Aspira app repo: `npm i @capacitor/core @capacitor/cli`, add iOS,
   set `server`/bundle config, add **≥1 genuine native capability** (push /
   offline / native share) to clear Guideline 4.2.
3. Build in Xcode (or Codemagic) → archive → upload to App Store Connect.
4. Fill listing copy, upload icon + real screenshots, complete App Privacy +
   age rating, attach privacy/support URLs.
5. Submit for review. Expect 1–3 days; be ready to answer a 4.2 query with the
   native features list.
6. (Parallel, optional) Google Play TWA via PWABuilder for a faster first store.

---

## Where this belongs

These files were created here because the Aspira app repo isn't attached to this
session. Move `PRIVACY_POLICY.md` and this kit into the Aspira app repo (and
publish the policy page) as part of the launch branch.
