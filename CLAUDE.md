# claude-skills — Cross-Provider Agent Skills for Software Houses

## Purpose
Production-grade skills, agents, and tools for software development teams.
Built against [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice).
All components are model-agnostic and work across Claude, Codex, Gemini, MiniMax, Kimi, and others.

## Architecture

### Component Types
| Type | Location | Purpose |
|------|----------|---------|
| Skills | `skills/<name>/SKILL.md` | Reusable instruction sets, preloaded into agents |
| Agents | `.claude/agents/<name>.md` | Specialized subagents with scoped tools |
| Commands | `.claude/commands/<name>.md` | User-invocable workflows (`/command-name`) |
| Rules | `.claude/rules/<name>.md` | Modular rule sets loaded by agents |

### Skill Tiers (Software House)
- **Tier 0 — Frontend**: `brand-intake`, `design-system-audit`, `design-system-init`, `layout-design`, `component-design`, `animation-design`, `frontend-review`
- **Tier 1 — Core**: `plan-feature`, `code-review`, `write-tests`, `debug`, `security-audit`, `estimate`
- **Tier 2 — Architecture**: `api-design`, `db-schema`, `adr`, `breakdown`
- **Tier 3 — DevOps**: `dockerfile`, `ci-pipeline`
- **Tier 4 — Documentation**: `write-docs`, `changelog`, `explain-code`
- **Tier 5 — Quality**: `refactor`, `perf-audit`, `inspect-secrets`

### Agents
- `design-system-architect` — brand-intake + design-system-init + design-system-audit
- `frontend-component-designer` — component-design + layout-design + animation-design
- `frontend-reviewer` — frontend-review + code-review
- `code-reviewer` — code-review + security-audit
- `feature-planner` — plan-feature + breakdown + estimate + api-design
- `devops-engineer` — dockerfile + ci-pipeline

### Commands
- `/init-design-system`, `/design-component`, `/design-page`
- `/plan-sprint`, `/review-pr`, `/ship-feature`

## Key Patterns

### Skill Invocation
Agent skills (preloaded via frontmatter `skills:` field):
```
Agent(subagent_type="code-reviewer", prompt="review PR #42")
```
User-invocable skills (via Skill tool):
```
Skill(skill="plan-feature", args="user authentication module")
```

### Cross-Provider Compatibility
All SKILL.md files are plain markdown with YAML frontmatter — portable to any model.
See `PROVIDERS.md` for provider-specific invocation patterns.

### Orchestration Pattern
Command → Agent (with preloaded skills) → Output
Example: `/plan-sprint` → `sprint-planner` agent (with `estimate` + `breakdown` skills) → Jira-ready backlog

## Rules
- Keep CLAUDE.md files under 200 lines — split into `.claude/rules/` for longer content
- Security skills run in read-only mode by default
- Agents default to `sonnet` model; upgrade to `opus` only for architecture decisions

## Standards
- All skills use only supported SKILL.md frontmatter: `name`, `description`, `argument-hint`, `user-invocable`, `disable-model-invocation`
- `allowed-tools` and `model` belong in agent definitions (`.claude/agents/`), NOT in skill files
- All components are model-agnostic — no provider-specific APIs in skill bodies
- Tool lists are explicit and minimal (principle of least privilege)

## Doc Maintenance Rule — ALWAYS ENFORCE
**Whenever a new skill, agent, or command is added to this repository, immediately update:**

1. **`README.md`** — add a row to the correct tier table in the Skills section, update agent/command tables, and update the project structure tree
2. **`CLAUDE.md`** — add the component name to the correct tier/section list

Do this in the same response as creating the component — never defer it.
Check for staleness: any name in CLAUDE.md or README.md that has no matching file is a stale reference and must be removed.
