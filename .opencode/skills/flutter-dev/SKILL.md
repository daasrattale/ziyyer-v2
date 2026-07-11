---
name: flutter-dev
description: "Flutter/Dart development for the Ziyyer project. Covers drift (SQLite ORM), go_router, Streams + setState state management, feature-based architecture, and all conventions observed in the codebase."
---

## Commands

- `flutter analyze` — lint check (no warnings)
- `dart run build_runner build --delete-conflicting-outputs` — regenerate drift & codegen
- `flutter test` — run tests
- `dart format .` — format all Dart files

## Project Architecture

```
lib/
  config/           — app_constants, app_icons, app_router, currencies
  features/         — one folder per feature
    add_expenses/
    budget_overview/
    budget_setup/
    transaction_details/
    transactions_list/
  shared/
    database/       — drift tables + persistence layer
    extensions/     — DateTime, String extensions
    models/         — plain Dart model classes
    screens/        — thin Scaffold wrappers that delegate to feature widgets
    services/       — business logic, exposes Stream<T>
    ui/             — CustomCard, Buttons (static factory), Loader
    utils/          — Toaster, AmountFormatter
  widgets/          — CustomStepper, AddExpenseButton
  theme.dart        — AppColors, AppTextStyles (GoogleFonts.inter), AppTheme
```

## State Management

**No state management library.** Pattern: Services expose `Stream<T>` via drift `.watch()` + `rxdart` `Rx.combineLatest3`. Widgets use `StreamBuilder`. Local state uses `setState()` in `StatefulWidget`. Data flows via constructor parameters. Services accessed through `ServiceLocator`.

## Routing (go_router)

- `StatefulShellRoute.indexedStack` with 5 branches for bottom nav: `/`, `/history`, `/insights`, `/add-expense`, `/budget`
- Full-screen routes with `parentNavigatorKey: rootNavigatorKey`: `/transactions`, `/transaction-details`
- Route args via `state.extra` with typed Args classes (`TransactionsScreenArgs`, `TransactionsDetailsScreenArgs`)
- `BackboneScreen` wraps `StatefulNavigationShell` with custom floating bottom bar

## Database (drift)

- `@DriftDatabase(tables: [...])` on `AppDatabase`, codegen produces `*.g.dart`
- Connection: `LazyDatabase` wrapping `NativeDatabase.createInBackground()`
- Table pattern: `@DataClassName('Transaction') class TransactionTable extends Table`
- Foreign keys: `.references(OtherTable, #id, onDelete: KeyAction.cascade)`
- Persistence layer: thin classes in `shared/database/persistence/` with `create()`, `update()`, `deleteById()`, `watch() -> Stream<List<T>>`
- Accessed via `PersistenceLocator` (initialized in `main.dart`)

## Naming Conventions

| Item | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `transaction_model.dart` |
| Classes | `PascalCase` | `TransactionModel` |
| Private members | `_prefixedCamelCase` | `_budgetService` |
| Enums/static classes | Trailing `s` | `AppColors`, `Buttons` |
| Directories | `snake_case/` | `add_expenses/` |
| Table files | `*_table.dart` | `transaction_table.dart` |
| Model files | `*_model.dart` | `transaction_model.dart` |
| Service files | `*_service.dart` | `budget_service.dart` |
| Persistence files | `*_persistence.dart` | `transaction_persistence.dart` |
| Screen files | `*_screen.dart` | `home_screen.dart` |
| Route params | `*Args` | `TransactionsScreenArgs` |
| Config files | `app_*.dart` | `app_router.dart` |

## Models

Plain Dart classes with:
- `const` constructor and `final` fields (immutable pattern preferred)
- `factory ModelName.init()` for default instance
- `ModelName copyWith({...})` for partial updates
- `factory ModelName.fromDriftType(DriftType x)` to map from generated drift types

## Services

Plain Dart classes holding references to `PersistenceLocator` singletons. Expose:
- Reactive streams via `watch() -> Stream<T>` (using rxdart `Rx.combineLatest3` when merging)
- Imperative methods: `persist()`, `delete()`, `update()`

## UI Patterns

- Screens are thin wrappers (Scaffold + delegate to feature widget)
- `CustomCard` for reusable containers
- `Buttons` static class: `primaryButton()`, `secondaryButton()`, `textButton()`, `iconButton()`, `fab()`
- `Loader` for loading states (uses `LoadingAnimationWidget.threeRotatingDots`)
- `CustomStepper` for multi-step forms
- `Toaster` wraps `toastification` for snackbars
- `AmountFormatter` for currency display

## Misc

- `DATABASE.md` is stale — describes Isar but actual code uses drift. Update when schema changes.
- Commit messages follow Conventional Commits (`feat:`, `fix:`, `refactor:`, `docs:`, etc.)
- FVM manages Flutter SDK version (see `.fvmrc`)
