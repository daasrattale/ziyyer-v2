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

## Design Spec

All UI must follow these rules. Do NOT deviate.

### Card Styling (Home + Insights + all screens)

- **Background:** `AppColors.surface(context)`
- **Border:** `Border.all(color: AppColors.divider(context), width: 1)`
- **Border radius:** `AppConstants.defaultBorderRadius` (32) for section cards, `AppConstants.defaultBorderRadius - 4` (28) for inner/detail cards
- **NO box shadows** — flat design throughout
- **Padding:** `AppConstants.defaultPadding` (24) inside cards
- **Margin:** `AppConstants.screenMargin` (24) horizontal on section wrappers

### Category Items (SpendingCategorySection pattern)

- Icon circle: `color.withAlpha(40)` background, `AppIcons.categoryIconFor()`, size 16
- Border on outer container: `Border.all(color: baseColor.withAlpha(40), width: 1)`
- Progress bar: `height: 6`, `AppColors.divider(context).withValues(alpha: 0.5)` track, `borderRadius: 3.0`
- Title: `textTheme.bodyLarge` fontWeight w600
- Amount: `textTheme.bodyLarge` fontWeight w700, `currencySymbol${spent.toInt()}`

### Summary Cards (SummaryCardsRow pattern)

- Icon circle: `iconBackgroundColor` (color.withAlpha(20)), size 20, padding 10
- Title: `textTheme.labelMedium` color textSecondary, letterSpacing 1.2, UPPERCASE
- Amount: `textTheme.displaySmall` fontWeight w700
- Subtitle: `textTheme.bodyMedium` color textSecondary

### Accent Card (BudgetSummary pattern)

- Background: `AppColors.accentColor(context)`
- Title: `textTheme.labelSmall` color darkTextPrimary, fontWeight w600, letterSpacing 1.5, UPPERCASE
- Amount: `textTheme.displayLarge` color darkTextPrimary, fontWeight w500, height 1
- Badge: `Colors.white.withValues(alpha: 0.10)` background, borderRadius 16
- Divider: `Colors.white.withValues(alpha: 0.14)`
- Summary columns: `textTheme.labelLarge` color white withValues(alpha: 0.7), letterSpacing 2.2

### Spacing Constants

- `spacingExtraSmall`: 4
- `spacingSmall`: 8
- `spacingMedium`: 12
- `spacingLarge`: 24
- `screenMargin`: 24
- `defaultPadding`: 24
- `defaultBorderRadius`: 32

### Responsive Layouts

- Never use fixed widths for grid cells. Use `Expanded` or `LayoutBuilder` to calculate sizes dynamically.
- For calendar grids, use `LayoutBuilder` to compute `cellSize = constraints.maxWidth / columns`.
- Dot/icon sizes should scale: `dotSize = (cellSize * 0.7).clamp(min, max)`.
- Use `FittedBox(fit: BoxFit.scaleDown)` for text that might overflow.
