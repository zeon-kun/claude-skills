# claude-skills — Gemini CLI Configuration

> Cross-provider agent skills for software development teams.
> This file is read automatically by the Gemini CLI (`@google/gemini-cli`).

## What This Repo Provides

29 production-grade skills, 10 agents, and 7 slash commands organized into tiers.
Each skill in `skills/<name>/SKILL.md` is a standalone system prompt — portable to any Gemini session.
Commands in `.claude/commands/<name>.md` are Claude Code slash commands (`/command-name`).

## How to Use Skills with Gemini CLI

### Quick Start
```bash
# Install Gemini CLI
npm install -g @google/gemini-cli

# Run a skill directly
gemini --system-prompt "$(./scripts/load-skill.sh code-review)" \
  "Review the auth module in src/auth.ts"

# Or use the helper script (auto-injects skill as system prompt)
./scripts/load-skill.sh code-review "Review src/auth.ts"
```

### Project Settings
Gemini CLI reads `.gemini/settings.json` for project-level configuration.
See `.gemini/settings.json` in this repo for the configured system prompt
that loads the repo context automatically.

### Available Skills

**Tier 0 — Frontend**
- `brand-intake` — Brand discovery interview
- `design-system-audit` — Extract implicit design system from codebase
- `design-system-init` — Generate Tailwind + shadcn design tokens
- `layout-design` — Page/section layout in React + Tailwind
- `component-design` — Typed React component with CVA variants
- `animation-design` — Framer Motion / GSAP animations
- `frontend-review` — React/Next.js review: a11y, perf, design tokens

**Tier 1 — Core**
- `plan-feature` — Feature planning with phases and risk
- `code-review` — Severity-tagged code review
- `write-tests` — Comprehensive test suite generation
- `debug` — Root cause analysis and fix
- `security-audit` — OWASP Top 10 scan
- `estimate` — T-shirt sizing and story points

**Tier 2 — Architecture**
- `api-design` — REST/GraphQL API design
- `db-schema` — Database schema with migrations
- `adr` — Architecture Decision Record
- `breakdown` — Epic → stories → tasks

**Tier 3 — DevOps**
- `dockerfile` — Multi-stage production Dockerfile
- `ci-pipeline` — GitHub Actions / GitLab CI pipeline

**Tier 4 — Documentation**
- `write-docs` — README, runbooks, guides
- `changelog` — Structured changelog from git history
- `explain-code` — Code explanation with diagrams

**Tier 5 — Quality**
- `refactor` — Clean up without changing behavior
- `perf-audit` — Performance bottleneck analysis
- `inspect-secrets` — Safely audit config/secrets structure
- `save-output` — Save session output as markdown spec

**Tier 6 — SDLC Pipeline**
- `codebase-ingest` — Systematic codebase analysis (architecture, patterns, brand, doc health)
- `session-plan` — Token-aware session planning with prioritized TASKS.md generation
- `doc-sync` — Sync provider docs and TASKS.md after task execution

## Commands (Claude Code Slash Commands)

Commands in `.claude/commands/` are invoked as `/command-name` in Claude Code.
Gemini CLI does not natively support slash commands — use the equivalent skill combination instead.

| Command | Purpose | Gemini Equivalent |
|---|---|---|
| `/dev-session` | Full SDLC pipeline: scout → navigator → forge → scribe | Run each agent skill combination in sequence |
| `/plan-sprint` | Sprint planning with estimates and backlog | `session-plan` + `breakdown` + `estimate` |
| `/review-pr` | Full PR review with security scan | `code-review` + `security-audit` |
| `/ship-feature` | Feature implementation end-to-end | `plan-feature` + execution skills |
| `/init-design-system` | Bootstrap design system | `brand-intake` + `design-system-init` |
| `/design-component` | Design a React component | `component-design` |
| `/design-page` | Design a full page layout | `layout-design` + `component-design` |

## Agent Equivalents

Gemini CLI runs a single context per session. Combine skills by loading multiple
SKILL.md files as system prompt sections:

```bash
# Simulate the code-reviewer agent
SYSTEM=$(cat skills/code-review/SKILL.md skills/security-audit/SKILL.md | \
  sed '/^---$/,/^---$/d')
gemini --system-prompt "$SYSTEM" "Review PR #42"

# Simulate the scout agent (SDLC stage 1)
SYSTEM=$(cat skills/codebase-ingest/SKILL.md skills/explain-code/SKILL.md | \
  sed '/^---$/,/^---$/d')
gemini --system-prompt "$SYSTEM" "Digest this codebase"
```

| Claude Agent | Gemini Skill Combination |
|---|---|
| `scout` | `codebase-ingest` + `explain-code` + `design-system-audit` |
| `navigator` | `session-plan` + `breakdown` + `estimate` |
| `forge` | All execution skills combined for the task at hand |
| `scribe` | `doc-sync` + `write-docs` + `changelog` |
| `code-reviewer` | `code-review` + `security-audit` |
| `feature-planner` | `plan-feature` + `breakdown` + `estimate` |
| `devops-engineer` | `dockerfile` + `ci-pipeline` |
| `frontend-component-designer` | `component-design` + `layout-design` + `animation-design` |

## Standards
- Read files before suggesting changes
- Errors must be actionable — cite file:line with concrete fix
- Security first, correctness second, style third
- No hardcoded secrets or credentials in generated code
- All user input is untrusted — validate at boundaries
