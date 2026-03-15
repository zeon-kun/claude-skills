# claude-skills — Codex CLI Configuration

> Cross-provider agent skills for software development teams.
> This file is read automatically by the Codex CLI (`@openai/codex`).

## What This Repo Provides

26 production-grade skills organized into tiers. Each skill in `skills/<name>/SKILL.md`
is a standalone system prompt — inject it into any Codex session.

## How to Use Skills with Codex CLI

### Quick Start
```bash
# Install Codex CLI
npm install -g @openai/codex

# Run a skill directly
codex --instructions "$(cat skills/code-review/SKILL.md | sed '/^---$/,/^---$/d')" \
  "Review the auth module in src/auth.ts"

# Or use the helper script
./scripts/load-skill.sh code-review "Review src/auth.ts"
```

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

## Agent Equivalents

Claude-specific subagents are not natively supported in Codex CLI, but you can
simulate them by combining skills:

| Claude Agent | Codex Equivalent |
|---|---|
| `code-reviewer` | `code-review` + `security-audit` skills |
| `feature-planner` | `plan-feature` + `breakdown` + `estimate` |
| `devops-engineer` | `dockerfile` + `ci-pipeline` |
| `frontend-component-designer` | `component-design` + `layout-design` + `animation-design` |

## Standards
- Read files before suggesting changes
- Errors must be actionable — cite file:line with concrete fix
- Security first, correctness second, style third
- No hardcoded secrets or credentials in generated code
- All user input is untrusted — validate at boundaries
