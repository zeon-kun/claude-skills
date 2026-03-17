# claude-skills

> Cross-provider agent skills, tools, and orchestration patterns for software houses.

Built following [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice).
All skills work as system prompts with **any LLM provider** — Claude, GPT-4o, Gemini, MiniMax, Kimi, and others.

---

## Skills (29 total)

### Tier 0 — Frontend & Design System (React · Next.js · shadcn/ui · Tailwind · Framer Motion · GSAP)
| Skill | Command | Description |
|-------|---------|-------------|
| `brand-intake` | `/brand-intake` | Brand discovery interview → structured Brand Profile |
| `design-system-audit` | `/design-system-audit <dir>` | Scan codebase, extract implicit design system |
| `design-system-init` | `/design-system-init` | Generate globals.css tokens, Typography, providers |
| `layout-design` | `/layout-design <type>` | Bento grid, dashboard, hero, magazine, masonry layouts |
| `component-design` | `/component-design <name>` | Typed React component with CVA variants + shadcn/ui |
| `animation-design` | `/animation-design <component>` | Framer Motion / GSAP animations with reduced-motion support |
| `frontend-review` | `/frontend-review <file>` | React/Next.js review: a11y, performance, design tokens |

### Tier 1 — Core Development
| Skill | Command | Description |
|-------|---------|-------------|
| `plan-feature` | `/plan-feature <feature>` | Feature planning with phases, criteria, and risk assessment |
| `code-review` | `/code-review <file>` | Severity-tagged code review (CRITICAL→LOW) |
| `write-tests` | `/write-tests <file>` | Comprehensive test suite generation |
| `debug` | `/debug <error>` | Root cause analysis and fix |
| `security-audit` | `/security-audit <file>` | OWASP Top 10 vulnerability scan |
| `estimate` | `/estimate <task>` | T-shirt sizing and story point estimation |

### Tier 2 — Architecture
| Skill | Command | Description |
|-------|---------|-------------|
| `api-design` | `/api-design <resource>` | REST/GraphQL API with schema, errors, versioning |
| `db-schema` | `/db-schema <model>` | Database schema with indexes and migration plan |
| `adr` | `/adr <decision>` | Architecture Decision Record |
| `breakdown` | `/breakdown <epic>` | Epic → stories → tasks for sprint planning |

### Tier 3 — DevOps
| Skill | Command | Description |
|-------|---------|-------------|
| `dockerfile` | `/dockerfile <app>` | Multi-stage, production-ready Dockerfile |
| `ci-pipeline` | `/ci-pipeline <platform>` | GitHub Actions / GitLab CI pipeline |

### Tier 4 — Documentation
| Skill | Command | Description |
|-------|---------|-------------|
| `write-docs` | `/write-docs <topic>` | README, runbooks, guides |
| `changelog` | `/changelog <version>` | Structured changelog from commits |
| `explain-code` | `/explain-code <file>` | Code explanation with diagrams |

### Tier 5 — Quality
| Skill | Command | Description |
|-------|---------|-------------|
| `refactor` | `/refactor <file>` | Behavior-preserving code cleanup |
| `perf-audit` | `/perf-audit <file>` | Performance bottleneck analysis |
| `inspect-secrets` | `/inspect-secrets <dir>` | Safe config/secrets structure report |
| `save-output` | *(agent-internal)* | Prompt user to save agent output as a markdown spec file |

### Tier 6 — SDLC Pipeline
| Skill | Command | Description |
|-------|---------|-------------|
| `codebase-ingest` | `/codebase-ingest <dir>` | Systematic codebase analysis — architecture, patterns, brand, doc health |
| `session-plan` | `/session-plan <goals>` | Token-aware session planning with prioritized TASKS.md generation |
| `doc-sync` | *(agent-internal)* | Sync provider docs and TASKS.md after task execution |

---

## Agents (10 orchestrators)

### SDLC Pipeline Agents
| Agent | Skills Preloaded | Best For |
|-------|-----------------|---------|
| `scout` | codebase-ingest + explain-code + design-system-audit | Codebase digest at session start |
| `navigator` | session-plan + breakdown + estimate | Task planning and TASKS.md generation |
| `forge` | All execution skills | Executing tasks from TASKS.md |
| `scribe` | doc-sync + write-docs + changelog | Syncing provider docs after execution |

### Specialist Agents
| Agent | Skills Preloaded | Best For |
|-------|-----------------|---------|
| `design-system-architect` | brand-intake + design-system-init + design-system-audit | Bootstrap or formalize a design system |
| `frontend-component-designer` | component-design + layout-design + animation-design | Design any component, section, or page |
| `frontend-reviewer` | frontend-review + code-review | PR reviews for React/Next.js code |
| `code-reviewer` | code-review + security-audit | Deep PR reviews |
| `feature-planner` | plan-feature + breakdown + estimate + api-design | Sprint planning |
| `devops-engineer` | dockerfile + ci-pipeline | Infrastructure setup |

## Commands (7 workflows)

| Command | Description |
|---------|-------------|
| `/dev-session` | Full SDLC pipeline: scout → navigator → forge → scribe |
| `/init-design-system` | Full design system bootstrap: brand interview → tokens → globals.css |
| `/design-component` | Design a component with layout + tokens + animation |
| `/design-page` | Design a full Next.js page section by section |
| `/plan-sprint` | Full sprint plan: scope → stories → estimates |
| `/review-pr` | Code review + security audit in one pass |
| `/ship-feature` | End-to-end: plan → implement → test → review → docs |

---

## Installation

### Discovery Paths (Claude Code)

| Component | Global (all projects) | Project-only |
|-----------|----------------------|--------------|
| Skills | `~/.claude/skills/<name>/` | `.claude/skills/<name>/` |
| Agents | `~/.claude/agents/<name>.md` | `.claude/agents/<name>.md` |

The `skills/` and `.claude/agents/` in this repo are the **distribution source**.
Use the install script to copy them to the correct discovery paths.

**Install everything globally (recommended):**
```bash
git clone https://github.com/yourorg/claude-skills
cd claude-skills
./install.sh
```

**Install specific skills and/or agents globally:**
```bash
./install.sh --skills code-review security-audit debug
./install.sh --agents code-reviewer feature-planner
```

**Install to a specific project (run from inside that project):**
```bash
cd /path/to/myproject
/path/to/claude-skills/install.sh --project
./install.sh --project --skills code-review --agents code-reviewer
```

**Manual (copy one):**
```bash
cp -r skills/code-review ~/.claude/skills/         # skill
cp .claude/agents/code-reviewer.md ~/.claude/agents/ # agent
```

After installation:
```
# Skills appear as slash commands
/code-review src/auth.ts
/plan-feature Add OAuth2 login

# Agents are invocable by Claude
Agent(subagent_type="code-reviewer", prompt="review src/auth.ts")

# Browse installed agents interactively
/agents
```

---

## Using with Claude Code

Skills are automatically available as slash commands. Agents can be invoked:

```
# User-invocable skill
/plan-feature Add user authentication with OAuth2

# Agent invocation (from within Claude Code)
Agent(subagent_type="code-reviewer", prompt="review src/auth.ts")

# Workflow command
/ship-feature Dark mode support for the dashboard
```

## Using with Codex CLI (OpenAI)

```bash
npm install -g @openai/codex
# AGENTS.md is read automatically when you run codex inside this repo
codex

# Or inject a specific skill
./scripts/load-skill.sh code-review "Review src/auth.ts"
./scripts/load-skill.sh --combine "plan-feature,breakdown" "Add OAuth2 login"
./scripts/load-skill.sh --list   # see all skills
```

## Using with Gemini CLI (Google)

```bash
npm install -g @google/gemini-cli
# GEMINI.md + .gemini/settings.json are read automatically
gemini

# Or inject a specific skill
./scripts/load-skill.sh code-review "Review src/auth.ts"
```

## Using with Other Providers (API/SDK)

See [PROVIDERS.md](./PROVIDERS.md) for full instructions. Quick example:

```python
import re, openai

def load_skill(name: str) -> str:
    with open(f"skills/{name}/SKILL.md") as f:
        content = f.read()
    # Strip YAML frontmatter
    return re.sub(r'^---\n.*?\n---\n', '', content, flags=re.DOTALL).strip()

client = openai.OpenAI()  # works with any OpenAI-compatible endpoint

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": load_skill("code-review")},
        {"role": "user", "content": open("src/auth.ts").read()}
    ]
)
```

Compatible providers: **Claude** (Anthropic), **GPT-4o / Codex** (OpenAI),
**Gemini** (Google), **MiniMax**, **Kimi** (Moonshot AI), any OpenAI-compatible API.

---

## Project Structure

```
claude-skills/
├── CLAUDE.md                        # Project memory, architecture, doc maintenance rules
├── README.md                        # This file
├── PROVIDERS.md                     # Cross-provider usage guide (CLI + API/SDK)
├── AGENTS.md                        # Codex CLI entry point (auto-read by @openai/codex)
├── GEMINI.md                        # Gemini CLI entry point (auto-read by @google/gemini-cli)
├── install.sh                       # Install skills/agents to ~/.claude/ or project .claude/
│
├── .claude/
│   ├── settings.json                # Project-level permissions
│   ├── agents/                      # Specialized subagents (10)
│   │   ├── scout.md                 # SDLC: codebase digestor
│   │   ├── navigator.md             # SDLC: session planner
│   │   ├── forge.md                 # SDLC: task executor
│   │   ├── scribe.md                # SDLC: doc sync
│   │   ├── design-system-architect.md
│   │   ├── frontend-component-designer.md
│   │   ├── frontend-reviewer.md
│   │   ├── code-reviewer.md
│   │   ├── feature-planner.md
│   │   └── devops-engineer.md
│   ├── commands/                    # Slash command workflows (7)
│   │   ├── dev-session.md           # Full SDLC pipeline
│   │   ├── init-design-system.md
│   │   ├── design-component.md
│   │   ├── design-page.md
│   │   ├── plan-sprint.md
│   │   ├── review-pr.md
│   │   └── ship-feature.md
│   └── rules/                       # Modular rule sets
│       ├── security.md
│       └── code-quality.md
│
├── .gemini/
│   └── settings.json                # Gemini CLI project config
│
├── scripts/
│   └── load-skill.sh                # Inject any skill into Codex/Gemini CLI sessions
│
└── skills/                          # Skill definitions — 29 total
    │
    │   # Tier 0 — Frontend & Design System
    ├── brand-intake/
    ├── design-system-audit/
    ├── design-system-init/
    ├── layout-design/
    ├── component-design/
    ├── animation-design/
    ├── frontend-review/
    │
    │   # Tier 1 — Core Development
    ├── plan-feature/
    ├── code-review/
    ├── write-tests/
    ├── debug/
    ├── security-audit/
    ├── estimate/
    │
    │   # Tier 2 — Architecture
    ├── api-design/
    ├── db-schema/
    ├── adr/
    ├── breakdown/
    │
    │   # Tier 3 — DevOps
    ├── dockerfile/
    ├── ci-pipeline/
    │
    │   # Tier 4 — Documentation
    ├── write-docs/
    ├── changelog/
    ├── explain-code/
    │
    │   # Tier 5 — Quality
    ├── refactor/
    ├── perf-audit/
    ├── inspect-secrets/
    ├── save-output/
    │
    │   # Tier 6 — SDLC Pipeline
    ├── codebase-ingest/
    ├── session-plan/
    └── doc-sync/
```

---

## Standards

- Skills follow the [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) SKILL.md spec
- All components are model-agnostic (no provider-specific APIs in skill bodies)
- Security skills default to read-only, never mutate files
- Every skill produces structured, actionable output — no vague guidance
