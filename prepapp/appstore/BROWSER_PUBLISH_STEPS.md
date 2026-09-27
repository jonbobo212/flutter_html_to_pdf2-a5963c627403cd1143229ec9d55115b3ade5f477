# Aspira — browser-only publishing steps (App Store Connect)

For a Chrome session (or a browser agent) already signed in to
developer.apple.com / appstoreconnect.apple.com with the **active** Apple
Developer account.

**Scope — read this first.** A browser can do everything below. A browser
**cannot**: create the signing certificate, Archive, upload the binary, or take
screenshots. Those are Xcode on the Mac. Order of play: do PART A + B here, do
the Xcode Archive/Upload, then come back for PART C–G.

All values below are final and length-checked against Apple's limits.

---

## PART A — App ID (developer.apple.com)

Often unnecessary: with **Automatically manage signing**, Xcode registers the
App ID for you on first Archive. Do this only if `study.aspira.app` is missing
from the App Store Connect bundle-ID dropdown.

1. developer.apple.com/account → **Certificates, Identifiers & Profiles** → **Identifiers** → **＋**
2. **App IDs** → Continue → **App** → Continue
3. Description: `Aspira`
4. Bundle ID: **Explicit** → `study.aspira.app`
5. Capabilities: leave defaults → **Continue** → **Register**

## PART B — Create the app record (App Store Connect)

1. appstoreconnect.apple.com → **My Apps** → **＋** → **New App**
2. Platforms: **iOS**
3. Name: `Aspira`
4. Primary Language: **English (U.S.)**
5. Bundle ID: `study.aspira.app`
6. SKU: `aspira-001`
7. User Access: **Full Access** → **Create**

→ **Now go to Xcode: Product → Archive → Distribute App → App Store Connect → Upload.**
Return here once the build shows under TestFlight (5–15 min processing).

## PART C — App Information (left sidebar → App Information)

| Field | Value |
|---|---|
| Name | `Aspira` |
| Subtitle | `Learn English, reach your goal` |
| Category (primary) | **Education** |
| Category (secondary) | **Reference** |
| Content Rights | Contains no third-party content *(see note)* |

> Subtitle was trimmed from "…reach your dream" (31 chars) to fit Apple's 30-char
> limit. Do not re-lengthen it — the field will reject it.
> Content Rights note: the app **links out** to Goethe/British Council material
> but does not host it. If Apple queries this, answer that all third-party
> material is linked, attributed to its publisher, and not redistributed.

## PART D — Pricing and Availability

1. **Pricing** → Price Schedule → **Free**
2. Availability → **All countries and regions** *(or restrict to UZ/TJ/KZ/KG
   first if you want a soft launch — you can widen later)*

## PART E — Version information (the "1.0 Prepare for Submission" page)

**Promotional Text** (≤170):
```
Prep IELTS, get instant AI essay feedback, and discover universities and scholarships that fit your dream — in your language.
```

**Keywords** (≤100 — this exact string is 95):
```
IELTS,English,study abroad,scholarship,university,essay,speaking,practice,exam,TOEFL,vocabulary
```

**Description**:
```
Aspira is your calm, personal guide to studying abroad.

• Find your level with a quick English placement test
• Practice IELTS Reading, Listening, Speaking and Writing
• Get instant, kind feedback on your essays from an AI tutor
• Learn German from A1 with short lessons and quizzes
• Learn new words and keep a daily streak
• See which universities and scholarships match your level
• Study in your language — English, Uzbek, Russian

Built for students who are just starting out. Simple words, small steps,
real progress toward your dream.
```

**URLs**
- Support URL: `https://aspira.study/support`
- Marketing URL: `https://aspira.study`
- Privacy Policy URL: `https://aspira.study/privacy`  ← **must be live before submitting**

**Screenshots**: 6.7" and 6.5" iPhone, captured from the real running app.
Apple rejects mock-ups. This is the one PART C–G item a browser can't produce.

## PART F — App Privacy (left sidebar → App Privacy → Get Started)

Answer **Yes**, you collect data. Then tick these, all **Linked to the user**,
all purpose **App Functionality**, and **No** to "used for tracking":

| Category | Items |
|---|---|
| Contact Info | Name, Email Address, Phone Number |
| User Content | Other User Content *(essays, adviser messages)* |
| Identifiers | User ID |
| Usage Data | Product Interaction *(also tick **Analytics**)* |
| Other Data | Other Data Types *(study level, target university)* |

Do **not** tick: Location, Financial Info, Health, Contacts, Browsing History,
Search History, Purchases, Sensitive Info. None are collected.

## PART G — Age rating + TestFlight + submit

**Age Rating** (App Information → Age Rating → Edit): answer all **None**;
expected result **4+**.
⚠️ If Aspira is *directed at* under-13s you must use the **Kids Category**, which
forbids third-party analytics and needs a parental gate. Decide this
deliberately — it changes the privacy answers above.

**TestFlight**
1. TestFlight tab → the processed build → answer **Export Compliance**:
   *"Does your app use encryption?"* → **No** (standard HTTPS only).
2. **Internal Testing** → ＋ → add yourself → install via the TestFlight app.

**Submit for Review**
1. Version page → attach the build → confirm metadata, screenshots, privacy URL
2. **Add for Review → Submit**. Typically ~24h.

---

## Blockers that will stop a submission

1. **`aspira.study/privacy` must return a real page.** The policy text is in
   `prepapp/appstore/PRIVACY_POLICY.md`; it is not published yet. Submission
   cannot pass without it.
2. **`aspira.study/support` must exist too.** Copy is in
   `prepapp/appstore/STORE_EXTRAS.md`.
3. **The webview trap** — `/plan`'s external links open with no way back in the
   shell. A reviewer will likely hit it. Fix before public release (TestFlight
   is fine).
4. **Supabase free tier auto-pauses after 7 idle days** and already took the app
   down once. If it pauses during review, Apple sees a broken app.
