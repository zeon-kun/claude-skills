---
name: generate-rules
description: Converts a structured decisions document into .claude/rules/ files (frontend.md, backend.md, security.md, infra.md). Called by the rules-writer agent after architect or rules-lock interview completes.
argument-hint: <decisions document>
user-invocable: false
---

You are a rules codifier. You receive a structured decisions document and write it into modular `.claude/rules/` files that will be auto-loaded by Claude Code on every session.

## Input

Expect a decisions document with these sections (not all required):
- **Brand & Frontend** — design system, component library, styling approach, animation level
- **Backend Architecture** — framework, patterns, API style, service boundaries
- **Database** — schema approach, ORM, migration strategy
- **Security Posture** — auth strategy, rate limits, input validation, secrets management
- **Infrastructure** — deployment target, containerization, CI/CD approach
- **Code Patterns** — imperative vs declarative, error handling style, strict vs loose typing

## Output Protocol

Write exactly these files (skip any for which no decisions were made):

### `.claude/rules/frontend.md`

```markdown
# Frontend Rules

## Stack
- [framework, version]
- [component library]
- [styling approach]

## Design System
- [design tokens source]
- [component patterns]
- [animation level and library]

## Conventions
- [naming, file structure, import style]
- [state management approach]
- [accessibility standard]
```

### `.claude/rules/backend.md`

```markdown
# Backend Rules

## Architecture
- [pattern: MVC / hexagonal / layered / etc.]
- [API style: REST / GraphQL / tRPC / etc.]
- [service boundaries]

## Framework & Runtime
- [framework + version]
- [runtime + version]

## Conventions
- [error handling pattern]
- [logging approach]
- [validation layer]
```

### `.claude/rules/security.md`

```markdown
# Security Rules

## Authentication
- [strategy: JWT / session / OAuth / etc.]
- [token storage]
- [refresh strategy]

## Rate Limiting
- [implementation: middleware / edge / etc.]
- [limits: N req/min per IP, N req/min per user]

## Input Validation
- [library and where validation happens]
- [sanitization approach]

## Secrets Management
- [where secrets live: env vars / vault / etc.]
- [never hardcode: list of secret types]

## Guardrails
- [CORS policy]
- [CSP headers]
- [other headers]
```

### `.claude/rules/infra.md`

```markdown
# Infrastructure Rules

## Deployment
- [target: Vercel / AWS / GCP / self-hosted / etc.]
- [environment strategy: staging / prod / etc.]

## Containerization
- [Docker: yes/no, base image]
- [compose: yes/no]

## CI/CD
- [platform: GitHub Actions / GitLab CI / etc.]
- [pipeline stages: lint → test → build → deploy]

## Monitoring
- [error tracking]
- [logging platform]
```

## Rules

- Only write files for sections that have actual decisions — do not write placeholder-filled files
- Each written value must come from the input document — do not invent decisions
- After writing, list which files were created and confirm: "Rules written to `.claude/rules/`. These will be auto-loaded on every Claude Code session."
