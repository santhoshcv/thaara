# Thaara (താര)

A tarot companion that helps Malayalis see their relationships clearly.
English + Malayalam. Android first.

Thaara uses tarot as a mirror for reflection, not prediction: readings focus
on the user's own feelings, needs and choices, never on what someone else is
secretly thinking or what will happen.

## Stack

| Part | Tech |
|---|---|
| App | Flutter, Riverpod, go_router |
| Backend | Supabase (anonymous auth, Postgres with row-level security, Edge Functions) |
| Readings | Claude API, called only from the `reading` Edge Function |

The API key never ships in the app. The app sends the drawn cards to the
Edge Function, which checks limits, calls Claude, and stores the reading.

## Project layout

```
lib/
  core/        env, theme, router
  data/        78-card deck, spreads, helplines
  l10n/        all UI text (English + Malayalam)
  models/      reading and journal models
  services/    secure card draw, reading API, Supabase repository
  state/       Riverpod providers
  features/    onboarding, home, reading, journal, settings
  widgets/     card faces/flip, starfield, support card
supabase/
  migrations/  schema + RLS
  functions/   reading, delete-account
test/          deck and draw tests
```

## First-time setup

### 1. Generate the Android project files

The repo holds the Dart code only. Create the platform folders once:

```bash
flutter create --org app.thaara --project-name thaara --platforms android .
flutter pub get
flutter test
```

`flutter create .` does not overwrite existing files.

### 2. Supabase

1. Create a project at supabase.com (region: Mumbai, `ap-south-1`).
2. **Authentication → Sign In / Providers → enable Anonymous sign-ins.**
   Users start privately with no email or phone.
3. Apply the schema and deploy the functions:

```bash
supabase link --project-ref YOUR-PROJECT-REF
supabase db push
supabase secrets set ANTHROPIC_API_KEY=sk-ant-...
# optional overrides
supabase secrets set ANTHROPIC_MODEL=claude-sonnet-5-5 FREE_DAILY_READINGS=3
supabase functions deploy reading
supabase functions deploy delete-account
```

### 3. Run the app

```bash
cp env.example.json env.json   # fill in your project URL and anon key
flutter run --dart-define-from-file=env.json
```

`env.json` is git-ignored.

## How a reading works

1. The user picks a spread and (optionally) writes a question and situation.
2. Cards are drawn on the device with `Random.secure()`; about one in three
   comes up reversed.
3. The user turns each card over, then taps **Read my cards**.
4. The `reading` function:
   - checks the daily limit (`FREE_DAILY_READINGS`, default 3, reset at
     midnight IST) and blocks repeating the same question on the same day,
   - skips both limits if the text suggests crisis,
   - calls Claude with a forced tool call so the output is always structured,
   - sets `safety_flag` if Claude or the keyword check detects abuse,
     self-harm or crisis, which shows helplines at the top of the reading,
   - stores the reading and returns it.

## Before launch checklist

- [ ] **Malayalam review.** All Malayalam in `lib/l10n/strings.dart`,
      `lib/data/cards.dart` and `lib/data/spreads.dart` is a first draft.
      Have a native writer review tone and card names.
- [ ] **Helplines.** Verify every number in `lib/data/helplines.dart`.
- [ ] **Card art.** Cards currently render as styled placeholders. Replace
      with the illustrated deck.
- [ ] **Sample readings.** Test the prompt in `supabase/functions/_shared/prompt.ts`
      with 30+ realistic questions in English, Malayalam and Manglish,
      including abuse and crisis cases.
- [ ] **Public pages on Vercel:** `/privacy`, `/terms`, `/delete-account`.
- [ ] Play Console: data safety form, content rating, 18+ target audience.

## Next up

- App lock (PIN / fingerprint) and a discreet icon option
- Google sign-in to keep readings across phones
- Subscriptions via Google Play Billing
- Malayalam voice readings
- Illustrated Kerala-inspired deck
