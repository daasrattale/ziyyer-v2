# Ziyyer — Flutter Project

Flutter project using FVM (see `.fvmrc`). Uses drift for local DB, go_router for navigation.

## Commands

- `flutter analyze` — lint check (required before any commit)
- `dart run build_runner build --delete-conflicting-outputs` — regenerate drift & codegen
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

## opencode-Specific

- Use Plan mode (Tab) to propose changes before building.
- For safe batch operations, use `/init` to refresh `AGENTS.md`.
- Subagents (@explore, @general) can be invoked for research.
- Project docs: `doc/` folder (features, dependencies, database schema, technologies)
