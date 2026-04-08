# Changelog

All notable changes to this project will be documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project uses [semantic versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [0.3.0] — 2026-04-08

### Added
- `package.json` — NPM metadata with version, description, license, and `main` entry pointing at the OpenCode plugin
- `.claude-plugin/plugin.json` — Claude Code plugin manifest; references `skills/`, `.claude/agents/`, and `.claude/commands/` without duplicating content
- `.claude-plugin/marketplace.json` — Claude marketplace listing metadata
- `.opencode/INSTALL.md` — Installation instructions for OpenCode users
- `.opencode/plugins/claude-skills.js` — Zero-dependency JS plugin adapter; reads `skills/` at load time and registers each skill as a named system-prompt provider
- `.version-bump.json` — Multi-file version sync config listing `package.json`, `.claude-plugin/plugin.json`, and `.claude-plugin/marketplace.json`
- `scripts/bump-version.sh` — Bash script to synchronize the version string across all files in `.version-bump.json`

### Changed
- `PROVIDERS.md` — Restructured into install-by-tool sections (Claude Code, OpenCode, Codex CLI); added OpenCode and Claude Code plugin install instructions; removed stale `allowed-tools`/`model` frontmatter fields from the Frontmatter Reference
- `README.md` — Replaced discovery-path-only Installation section with multi-tool install instructions (Claude Code plugin, OpenCode, Codex CLI, direct install); updated project structure tree to show `.claude-plugin/` and `.opencode/` directories and `bump-version.sh`

---

## [0.2.0] — 2026-04-08

### Changed
- Removed Gemini CLI support — GEMINI.md, `.gemini/settings.json`, and all Gemini branches in `scripts/load-skill.sh` deleted; Gemini references stripped from CLAUDE.md, README.md, AGENTS.md, and PROVIDERS.md
- Fixed stale `sprint-planner` agent reference in CLAUDE.md — now correctly references `feature-planner`
- Updated skill count to 31 and agent count to 13 in AGENTS.md and README.md
- Added `generate-rules` to Tier 5 and `git-history-restructure` to Tier 7 in AGENTS.md
- Fixed project structure comment in README.md: agents count corrected from 12 to 13, skills count from 29 to 31

### Fixed
- `skills/git-history-restructure/SKILL.md` — added missing `argument-hint` and `user-invocable` frontmatter fields to match standard skill spec

### Added
- CHANGELOG.md bootstrapped in Keep-a-Changelog format, seeded as v0.1.0
- `task/session-1/superpowers-findings.md` — research findings on superpowers repo structure for future distribution reshape

---

## [0.1.0] — 2026-03-14

Initial release. Production-grade skills, agents, and commands for software development teams built on the Claude Code skill/agent model.

### Added

#### Skills (31)

**Tier 0 — Frontend & Design System**
- `brand-intake` — Brand discovery interview producing a structured Brand Profile
- `design-system-audit` — Extract implicit design system from codebase
- `design-system-init` — Generate Tailwind + shadcn design tokens and globals.css
- `layout-design` — Bento grid, dashboard, hero, magazine, and masonry layouts
- `component-design` — Typed React component with CVA variants + shadcn/ui
- `animation-design` — Framer Motion / GSAP animations with reduced-motion support
- `frontend-review` — React/Next.js review: a11y, performance, design tokens

**Tier 1 — Core Development**
- `plan-feature` — Feature planning with phases, acceptance criteria, and risk register
- `code-review` — Severity-tagged code review (CRITICAL → LOW)
- `write-tests` — Comprehensive test suite generation across happy path, edge cases, error paths
- `debug` — Root cause analysis following a structured hypothesis-test-fix protocol
- `security-audit` — OWASP Top 10 vulnerability scan with concrete fixes
- `estimate` — T-shirt sizing and story point estimation

**Tier 2 — Architecture**
- `api-design` — REST/GraphQL API design with schema, error codes, and versioning
- `db-schema` — Database schema with indexes, constraints, and zero-downtime migration plan
- `adr` — Architecture Decision Record template
- `breakdown` — Epic → stories → tasks for sprint planning

**Tier 3 — DevOps**
- `dockerfile` — Multi-stage, production-ready Dockerfile with non-root user and health check
- `ci-pipeline` — GitHub Actions CI/CD pipeline with lint, test, build, and deploy stages

**Tier 4 — Documentation**
- `write-docs` — README, runbooks, and feature guides
- `changelog` — Structured changelog from git commit history
- `explain-code` — Code explanation with analogy, ASCII diagram, step-by-step walkthrough

**Tier 5 — Quality**
- `refactor` — Behavior-preserving code cleanup with named refactoring patterns
- `perf-audit` — Performance bottleneck analysis (DB queries, algorithm complexity, N+1, memory)
- `inspect-secrets` — Safe config/secrets structure report (read-only, never outputs secret values)
- `save-output` — Prompt user to save session output as a markdown spec file
- `generate-rules` — Convert a decisions document into `.claude/rules/` files

**Tier 6 — SDLC Pipeline**
- `codebase-ingest` — Systematic codebase analysis: architecture, patterns, brand, doc health
- `session-plan` — Token-aware session planning with prioritized TASKS.md generation
- `doc-sync` — Sync provider docs and TASKS.md after task execution

**Tier 7 — Repository**
- `git-history-restructure` — Audit messy repo state, group changes into clean logical commits

#### Agents (13)

**SDLC Pipeline**
- `scout` — Codebase digest at session start (codebase-ingest + explain-code + design-system-audit)
- `navigator` — Task planning and TASKS.md generation (session-plan + breakdown + estimate)
- `forge` — Task executor from TASKS.md (all execution skills)
- `scribe` — Provider doc sync after execution (doc-sync + write-docs + changelog)

**Specialist**
- `architect` — Greenfield project intake: brand, API, DB, ADR, design system
- `rules-writer` — Codify project decisions into `.claude/rules/` files
- `repo-historian` — Repo audit and clean commit restructuring
- `design-system-architect` — Bootstrap or formalize a design system
- `frontend-component-designer` — Design any component, section, or page
- `frontend-reviewer` — PR reviews for React/Next.js code
- `code-reviewer` — Deep PR reviews with security scan
- `feature-planner` — Sprint planning with estimates
- `devops-engineer` — Infrastructure setup

#### Commands (7)
- `/dev-session` — Phase-aware SDLC pipeline: greenfield, existing, or prototype routing
- `/init-design-system` — Full design system bootstrap: brand interview → tokens → globals.css
- `/design-component` — Design a component with layout + tokens + animation
- `/design-page` — Design a full Next.js page section by section
- `/plan-sprint` — Full sprint plan: scope → stories → estimates
- `/review-pr` — Code review + security audit in one pass
- `/ship-feature` — End-to-end: plan → implement → test → review → docs

#### Infrastructure
- `install.sh` — Copy skills/agents/commands to `~/.claude/` or project `.claude/`
- `scripts/load-skill.sh` — Inject any skill into Codex CLI as a system prompt
- `AGENTS.md` — Codex CLI entry point (auto-read by `@openai/codex`)
- `.claude/rules/security.md` — Non-negotiable security rules loaded by all agents
- `.claude/rules/code-quality.md` — Code generation and review standards

[Unreleased]: https://github.com/yourorg/claude-skills/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/yourorg/claude-skills/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/yourorg/claude-skills/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/yourorg/claude-skills/releases/tag/v0.1.0
