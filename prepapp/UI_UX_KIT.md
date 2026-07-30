# Aspira UI/UX motion kit

Live prototype (open on a phone): the artifact published from this session shows
the dawn-over-night Home screen with all the effects below, rebuilt
self-contained. This doc maps them to real libraries for the `prepapp` app.

## Libraries (all React + copy-paste friendly; MIT)

- **React Bits** (reactbits.dev) — animated primitives you paste in, not a dep:
  ShinyText / GradientText, SpotlightCard, TiltedCard, CountUp, AnimatedList,
  Aurora / Threads backgrounds, MagnetButton, BlurText.
- **Framer Motion** (`npm i framer-motion`) — the base for reveals, layout
  transitions, shared-element (dream card → dream detail), gesture springs.
- **Aceternity UI / Magic UI** — spotlight, meteors, animated gradient, marquee,
  number-ticker, confetti. Copy-paste, Tailwind-based.
- **Optional:** `canvas-confetti` for the achievement burst; `gsap` only if you
  need timeline-orchestrated hero sequences.

## Map effect → screen → source

| Aspira surface | Effect | Use |
|---|---|---|
| Dream hero card | GradientText + SpotlightCard + TiltedCard | the emotional anchor; parallax on pointer |
| Level ring | animated SVG ring + CountUp | band fills on load, number counts up |
| Streak flame | subtle loop (Framer keyframes) | alive, not distracting |
| Daily Words | flip card (Framer `rotateY`) + AnimatedList | tap to reveal; SRS queue from `due_vocab` |
| Chancing meter | grow-in bars (Framer `whileInView`) | tiers from `university_fit()` |
| Achievement | confetti + slide-in toast | on "requirement MET" |
| Screen entry | staggered BlurText / rise reveals | `staggerChildren` on route mount |
| Bottom tabs | layoutId active indicator | shared-element pill slides between tabs |

## Install / adopt (when `prepapp` is attached)

```bash
npm i framer-motion canvas-confetti
# React Bits / Aceternity: paste each component into components/ui/ (no dep)
```
- Gate all motion behind `useReducedMotion()` (Framer) so it respects the OS
  setting — the prototype already does this in plain JS.
- Keep byte-stable, GPU-friendly transforms (`transform`, `opacity`); avoid
  animating layout properties on scroll.
- Theme: drive every color from CSS variables (the prototype defines a full
  light "morning" + dark "night" token set) so both themes stay first-class.

## Backing data already live (no app-repo needed)

- `get_daily_words(band, field, limit)` — daily-stable word set.
- `due_vocab(student, band, field, limit)` + `review_vocab(student, word, quality)`
  + table `vocab_reviews` — spaced repetition (SM-2 lite).
- `university_fit(student)` — returns each active university tagged
  safe / match / reach with band gap; powers the chancing meter.

Wire the UI to these RPCs via `supabase.rpc('...')` and the screens above become real.
