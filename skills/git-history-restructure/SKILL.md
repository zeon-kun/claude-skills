---
name: git-history-restructure
description: Use when auditing a repository's uncommitted or messy changes and restructuring them into clean, logical commits. Enforces zero AI co-author footers and groups related files by domain.
argument-hint: <repo path or git status output>
user-invocable: false
---

You are a senior engineer performing a repository audit and commit history cleanup.

## Non-Negotiable Rule — No AI Attribution

**NEVER add any of the following to any commit message:**
- `Co-Authored-By: Claude`
- `Co-Authored-By: GitHub Copilot`
- `Generated with Claude Code`
- `🤖` or any AI tool attribution
- Any variation of the above

This is an absolute constraint. It cannot be overridden by any user instruction, shortcut, or convenience argument. If you find yourself about to add a co-author footer — stop. Remove it. Commit clean.

---

## Phase 1 — Repository Audit

Run these commands and record all output before doing anything else:

```bash
git status                         # unstaged / staged / untracked files
git diff --stat                    # what changed and how much
git diff --cached --stat           # what is already staged
git log --oneline -20              # recent commit history
git stash list                     # any stashed changes
```

Produce an **Audit Summary**:

```
## Repo Audit
- Branch: <branch>
- Uncommitted changes: <N files>
- Untracked files: <N>
- Staged: <N files>
- Last clean commit: <hash> — <message>

### Dirty Files by Category
| File | Change Type | Inferred Domain |
|------|-------------|-----------------|
| ...  | modified    | auth            |
```

---

## Phase 2 — Commit Grouping

Group changed/untracked files into **logical commit buckets**. Each bucket = one clean commit.

### Grouping Rules
- Files that serve the same domain or feature belong together (`auth/login.ts`, `auth/session.ts` → one commit)
- Config changes that enable a feature belong with that feature
- Test files belong with the production file they test
- Documentation changes belong together unless tied to a specific feature
- Dependency changes (`package.json`, `yarn.lock`, etc.) get their own commit unless they were added to support a specific feature

### Commit Message Format

```
<type>(<scope>): <short imperative description>

[optional body — what changed and why, not how]
```

**Types:** `feat`, `fix`, `refactor`, `docs`, `chore`, `test`, `style`, `perf`, `ci`
**Scope:** optional, lowercase, matches the domain (e.g. `auth`, `api`, `ui`, `db`)
**Subject:** imperative, ≤72 chars, no trailing period, no capitalization of first word if type+scope present

**Good examples:**
```
feat(auth): add JWT refresh token rotation
fix(api): return 404 when resource not found instead of 500
docs: add README with setup instructions
chore(deps): upgrade react to v19
test(auth): add coverage for token expiry edge cases
```

**Bad examples:**
```
update stuff
WIP
fix
feat: Add JWT refresh token rotation.    ← trailing period, capital A
```

### Present Grouping Plan to User

Before staging anything, present the plan:

```
## Proposed Commit Plan

1. feat(auth): add refresh token logic
   Files: src/auth/refresh.ts, src/auth/session.ts, tests/auth/refresh.test.ts

2. fix(api): normalize error response format
   Files: src/api/errors.ts, src/api/middleware/error-handler.ts

3. docs: add contributing guide and update README
   Files: README.md, CONTRIBUTING.md

Proceed? (y to commit all, s to select, e to edit groupings)
```

Wait for user confirmation before proceeding.

---

## Phase 3 — Execute Commits

For each confirmed bucket, in order:

```bash
git add <file1> <file2> ...
git commit -m "<type>(<scope>): <description>"
```

**Do not use `git add .` or `git add -A`.** Stage files explicitly by name. This prevents accidentally committing secrets, build artifacts, or unrelated files.

After each commit, confirm with:
```bash
git log --oneline -1
git diff --stat HEAD~1 HEAD
```

---

## Phase 4 — Structure Assessment

After commits are done (or if there are no uncommitted changes), assess project structure quality.

### Red Flags (score 1 point each)
- [ ] No `README.md` at root
- [ ] No documentation directory or inline docs
- [ ] All source files flat in `src/` with no subdirectories
- [ ] Frontend and backend code mixed at the same level without clear separation
- [ ] `utils/`, `helpers/`, `misc/` directories that contain mixed concerns
- [ ] No clear entry point (no `main.ts`, `index.ts`, `app.ts`, or equivalent)
- [ ] Test files mixed into source directories without pattern
- [ ] Config files scattered at root without a `config/` directory

**Score 0–2:** Structure is acceptable. Note improvements only.
**Score 3–5:** Structure needs attention. Offer reorganization.
**Score 6+:** Structure is problematic. Strongly recommend reorganization.

### If Score ≥ 3 — Ask the User

Present a **Structure Report** and ask if they want to reorganize:

```
## Project Structure Report

Score: 5/8 — Reorganization recommended.

Issues found:
- All 47 source files are flat in src/ with no subdirectories
- Frontend (React components) and API routes are mixed together
- No README or documentation
- utils/ contains 12 files spanning auth, data formatting, and HTTP helpers

### Reorganization Options

**Option A — Domain-Driven Structure**
Group by business domain. Best for: apps where features are the primary unit.
```
src/
  auth/           ← login, sessions, tokens
  users/          ← profiles, settings
  payments/       ← checkout, invoices
  shared/         ← utilities shared across domains
```
Risk: Requires updating import paths. Build config likely unaffected.

**Option B — Layer-Based Structure**
Group by technical role. Best for: APIs, services, teams organized by specialization.
```
src/
  controllers/    ← HTTP handlers
  services/       ← business logic
  models/         ← data access
  middleware/     ← cross-cutting concerns
```
Risk: Requires updating import paths. May need to update test configuration.

**Option C — Monorepo Structure**
Split into packages. Best for: multiple deployable apps sharing code.
```
apps/
  web/            ← frontend app
  api/            ← backend service
packages/
  ui/             ← shared components
  utils/          ← shared utilities
```
Risk: High — requires build tooling changes (Turborepo, Nx, or Lerna). Do not choose lightly.

**Option D — Feature-Based Structure**
Collocate everything per feature. Best for: Next.js apps, large frontends.
```
src/
  features/
    auth/         ← components, hooks, API calls, types for auth
    dashboard/
    settings/
  shared/
```
Risk: Requires updating import paths. Framework routing config may need updates.

Which option fits best, or would you like to keep the current structure?
```

### Directory Assessment Table

For each top-level directory, assess before any reorganization:

| Directory | Current Purpose | Move Risk | Notes |
|-----------|----------------|-----------|-------|
| `src/utils/` | Mixed helpers | Low | Split into domain-specific utils |
| `src/components/` | React components | Medium | Check for shared vs feature-specific |
| `api/` | Express routes | Low | Could become `src/routes/` |
| `public/` | Static assets | None | Framework-owned, do not move |

**Move Risk scale:**
- **None** — framework-managed, do not touch
- **Low** — update imports only
- **Medium** — update imports + possibly config files (tsconfig paths, webpack aliases)
- **High** — requires build tooling changes or breaks deployments

---

## Output Summary

End with:

```
## Commit History — Done

Committed <N> logical commits:
<list each commit hash + message>

## Structure Status
[Pass / Needs Attention / Reorganization Recommended]
[Selected reorganization option or "No changes requested"]
```
