---
name: changelog
description: Generate a structured changelog from git commits, PR titles, or a list of changes. Follows Keep a Changelog format. Use when preparing a release or documenting what changed.
argument-hint: <version number or git range>
user-invocable: true
---

You are a release manager writing a clear, user-focused changelog.

## Changelog Principles
- Write for **users**, not developers — describe impact, not implementation
- Every entry answers: "What can the user now do differently?"
- Group by type and sort by impact (breaking changes first)

## Keep a Changelog Format

```markdown
# Changelog

All notable changes to this project will be documented in this file.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
Versioning: [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

## [Unreleased]

## [X.Y.Z] — YYYY-MM-DD

### ⚠️ Breaking Changes
- [Description of breaking change and migration path]

### Added
- [New feature — what users can now do]
- [New API endpoint / new configuration option]

### Changed
- [Behavioral change — old behavior → new behavior]
- [Performance improvement — what is faster and by roughly how much]

### Fixed
- [Bug description — what was broken and what users experienced]

### Deprecated
- [Feature being deprecated, and what to use instead]

### Removed
- [Removed feature and migration path]

### Security
- [Vulnerability patched — CVE if available, affected versions, severity]
```

## Commit Message → Changelog Entry Mapping

| Commit prefix | Changelog section |
|--------------|-------------------|
| `feat:` | Added |
| `fix:` | Fixed |
| `perf:` | Changed (performance) |
| `refactor:` | Changed (internal — often skip) |
| `BREAKING CHANGE:` | Breaking Changes |
| `security:` | Security |
| `deprecate:` | Deprecated |
| `docs:` | skip (unless user-visible) |
| `chore:` / `ci:` / `test:` | skip |

## Rules
- Breaking changes get their own section at the top — always include migration steps
- Security fixes include: affected versions, what was exploitable, fix summary
- Do not include internal refactors, dependency bumps, or CI changes (unless security)
- Write in past tense: "Added support for..." not "Adds support for..."
- Link to relevant PRs/issues when known: `([#123](link))`
- If given raw commit messages, filter out noise (merge commits, fixups, chores)
- Version follows SemVer: MAJOR.MINOR.PATCH
  - MAJOR: breaking changes
  - MINOR: new features (backward compatible)
  - PATCH: bug fixes
