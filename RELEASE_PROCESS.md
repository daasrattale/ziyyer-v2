# Release Process

This project uses GitHub Actions to automate the release process. The workflow is triggered on pushes to the `release/*` branch.

## How to Release

### Automatic Release (Recommended)

1. **Create a release branch** from `main`:

   ```bash
   git checkout main
   git pull origin main
   git checkout -b release/v1.2.3
   ```

2. **Push to release branch** to trigger the workflow:

   ```bash
   git push origin release/v1.2.3
   ```

3. **GitHub Actions will automatically**:
   - ✅ Run `flutter analyze` (linting)
   - ✅ Run `flutter test` (unit/widget tests)
   - ✅ Generate changelog using `git-cliff`
   - ✅ Build Android APK (release)
   - ✅ Build iOS app (release)
   - ✅ Create a GitHub Release with artifacts
   - ✅ Tag the commit with version

### Manual Workflow Dispatch

Alternatively, trigger the workflow manually:

1. Go to GitHub repository → **Actions** → **Release Pipeline**
2. Click **Run workflow**
3. Select version bump type: `major`, `minor`, or `patch`
4. Click **Run workflow**

## Requirements

- All tests must pass
- Code must pass linting checks
- Commits should follow [Conventional Commits](https://www.conventionalcommits.org/) format for better changelog generation

## Conventional Commit Format

The changelog is generated from commit messages. Use these prefixes:

- `feat:` - New features
- `fix:` - Bug fixes
- `perf:` - Performance improvements
- `docs:` - Documentation updates
- `refactor:` - Code refactoring
- `test:` - Tests
- `chore:` - Build process, dependencies
- `ci:` - CI/CD configuration
- `style:` - Code formatting

Example:

```
feat: Add transaction filtering by date range
fix: Resolve memory leak in budget calculations
docs: Update API documentation
```

## Workflow Details

### Stages

1. **Lint & Test** (Ubuntu latest)
   - Runs on `release/*` branches
   - Lints code with `flutter analyze`
   - Runs tests with `flutter test`
   - Builds Android APK

2. **iOS Build** (macOS latest)
   - Runs on macOS for proper iOS compilation
   - Builds iOS app
   - Creates IPA package

### Outputs

- 📱 **app-release.apk** - Android APK for release
- 📦 **app-release.ipa** - iOS IPA for TestFlight/release
- 📝 **CHANGELOG.md** - Auto-generated from commits
- 🏷️ **Git Tag** - Automatically created (v1.2.3)
- 📄 **GitHub Release** - With all artifacts and changelog

## Version Numbering

Follows [Semantic Versioning](https://semver.org/):

- `MAJOR.MINOR.PATCH+BUILD_NUMBER`
- Example: `1.2.3+5`

Each release increments:

- The chosen version component (MAJOR, MINOR, or PATCH)
- The build number

## Troubleshooting

### Tests Failing

- Check test output in the Actions workflow
- Fix issues locally: `flutter test`
- Commit fixes and push again

### Linting Issues

- Review `flutter analyze` output
- Fix issues locally: `flutter analyze` or `dart fix --apply`
- Commit and push

### Build Failures

- Check the specific build logs in Actions
- Test locally: `flutter build apk --release` and `flutter build ios --release`

## After Release

1. Merge the `release/v*` branch back to `main`:

   ```bash
   git checkout main
   git pull origin main
   git merge release/v1.2.3
   git push origin main
   ```

2. Optionally delete the release branch:

   ```bash
   git branch -d release/v1.2.3
   git push origin --delete release/v1.2.3
   ```

3. Monitor the GitHub Release page for download links

## Configuration

- **Flutter Version**: 3.10.3 (configured in `.github/workflows/release.yml`)
- **Changelog Format**: Configured in `cliff.toml`
- **Build Configurations**:
  - Android: Release APK
  - iOS: Release (unsigned, for TestFlight)

## References

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [git-cliff Documentation](https://git-cliff.org/)
- [Flutter Release Documentation](https://flutter.dev/docs/deployment)
