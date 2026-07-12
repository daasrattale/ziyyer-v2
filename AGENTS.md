# Ziyyer — Flutter Project

Flutter project using FVM (see `.fvmrc`). Uses drift for local DB, go_router for navigation.

## Commands

- `flutter analyze` — lint check (required before any commit)
- `dart run build_runner build --delete-conflicting-outputs` — regenerate drift & codegen
- `fvm flutter gen-l10n` — regenerate localization files after ARB changes
- `flutter test` — run tests

## Project Structure

- `lib/` — main app source
- `test/` — tests
- `scripts/` — build/release helpers
- `DATABASE.md` — drift schema docs; update when DB schema changes

## Conventions

- **Conventional Commits** for commit messages (`feat:`, `fix:`, `docs:`, `refactor:`, etc.)
- Keep changes minimal. Don't refactor unrelated code.
- Regenerate codegen after drift/DB changes.
- Run `flutter analyze` before committing — no warnings.

## Internationalization (i18n)

**Supported locales:** English (`en`), French (`fr`), Spanish (`es`)

### ARB Files

- `lib/l10n/app_en.arb` — English (template, add new keys here first)
- `lib/l10n/app_fr.arb` — French
- `lib/l10n/app_es.arb` — Spanish

After editing any ARB file, run `fvm flutter gen-l10n` to regenerate.

### Usage in Code

```dart
import 'package:ziyyer/l10n/app_localizations.dart';

// In build method:
AppLocalizations.of(context)!.someKey

// With parameters:
AppLocalizations.of(context)!.deleteTransactionDesc(description)
```

Always use `AppLocalizations.of(context)!.` (with `!` null assertion).

### Locale-Aware Utilities

- `DateTime` extensions (`prettyDate()`, `monthAndYear()`, `fullDateTime()`) accept `BuildContext?` to auto-detect locale
- Currency names in `app_constants.dart` / `currencies.dart` are data values, NOT translated (keep as-is)

### Settings / Locale Switching

- `LocaleProvider` (`lib/shared/services/locale_provider.dart`) manages locale state, persists via `shared_preferences`
- Language selection screen: `lib/features/settings/widgets/language_widget.dart`
- Settings route: `/settings` (tab), `/language` (pushes full-screen)

### Adding a New Locale

1. Create `lib/l10n/app_<code>.arb`
2. Add locale to `supportedLocales` in `main.dart`
3. Add locale option to `language_widget.dart`
4. Run `fvm flutter gen-l10n`

## opencode-Specific

- Use Plan mode (Tab) to propose changes before building.
- For safe batch operations, use `/init` to refresh `AGENTS.md`.
- Subagents (@explore, @general) can be invoked for research.
- Project docs: `doc/` folder (features, dependencies, database schema, technologies)
