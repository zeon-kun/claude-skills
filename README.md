# claude-skills

> Cross-provider agent skills, tools, and orchestration patterns for software houses.

Built following [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice).
All skills work as system prompts with **any LLM provider** — Claude, GPT-4o, MiniMax, Kimi, and others.

---

## Skills (31 total)

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
| `generate-rules` | *(agent-internal)* | Convert a decisions document into .claude/rules/ files |

### Tier 6 — SDLC Pipeline
| Skill | Command | Description |
|-------|---------|-------------|
| `codebase-ingest` | `/codebase-ingest <dir>` | Systematic codebase analysis — architecture, patterns, brand, doc health |
| `session-plan` | `/session-plan <goals>` | Token-aware session planning with prioritized TASKS.md generation |
| `doc-sync` | *(agent-internal)* | Sync provider docs and TASKS.md after task execution |

### Tier 7 — Repository
| Skill | Command | Description |
|-------|---------|-------------|
| `git-history-restructure` | *(agent-internal)* | Audit dirty repo state, group changes into clean logical commits, assess project structure |

---

## Agents (13 orchestrators)

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
| `architect` | brand-intake + api-design + db-schema + adr + design-system-init | Greenfield intake: brand, API, DB, security, code patterns |
| `rules-writer` | generate-rules | Codify project decisions into .claude/rules/ files |
| `design-system-architect` | brand-intake + design-system-init + design-system-audit | Bootstrap or formalize a design system |
| `frontend-component-designer` | component-design + layout-design + animation-design | Design any component, section, or page |
| `frontend-reviewer` | frontend-review + code-review | PR reviews for React/Next.js code |
| `code-reviewer` | code-review + security-audit | Deep PR reviews |
| `feature-planner` | plan-feature + breakdown + estimate + api-design | Sprint planning |
| `devops-engineer` | dockerfile + ci-pipeline | Infrastructure setup |
| `repo-historian` | codebase-ingest + git-history-restructure | Repo audit, clean commit restructuring, structure assessment |

## Commands (7 workflows)

| Command | Description |
|---------|-------------|
| `/dev-session` | Phase-aware SDLC pipeline: greenfield, existing, or prototype routing |
| `/init-design-system` | Full design system bootstrap: brand interview → tokens → globals.css |
| `/design-component` | Design a component with layout + tokens + animation |
| `/design-page` | Design a full Next.js page section by section |
| `/plan-sprint` | Full sprint plan: scope → stories → estimates |
| `/review-pr` | Code review + security audit in one pass |
| `/ship-feature` | End-to-end: plan → implement → test → review → docs |

---

## Installation

### Claude Code (plugin manifest — recommended)

```bash
git clone https://github.com/YOUR_ORG/claude-skills.git
```

Add to Claude Code settings:

```json
{ "plugins": ["/path/to/claude-skills/.claude-plugin/plugin.json"] }
```

Claude Code reads `plugin.json` and discovers all skills, agents, and commands automatically.

### OpenCode (NPM-style plugin)

Add to `opencode.json`:

```json
{ "plugins": ["git+https://github.com/YOUR_ORG/claude-skills.git"] }
```

OpenCode resolves `package.json` → `.opencode/plugins/claude-skills.js`. No `npm install` needed.
See `.opencode/INSTALL.md` for local-clone instructions.

### Codex CLI (symlink)

```bash
git clone https://github.com/YOUR_ORG/claude-skills.git
# AGENTS.md is read automatically when you run codex inside this repo
# Or symlink skills/ to your global agents directory:
ln -s /path/to/claude-skills/skills ~/.agents/skills/claude-skills
```

### Direct install (`install.sh`)

```bash
git clone https://github.com/YOUR_ORG/claude-skills.git
cd claude-skills
./install.sh                           # copy everything to ~/.claude/
./install.sh --skills code-review debug
./install.sh --agents code-reviewer
./install.sh --project                 # copy to current project's .claude/
```

**Manual (copy one):**
```bash
cp -r skills/code-review ~/.claude/skills/
cp .claude/agents/code-reviewer.md ~/.claude/agents/
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
**MiniMax**, **Kimi** (Moonshot AI), any OpenAI-compatible API.

---

## Project Structure

```
claude-skills/
├── CLAUDE.md                        # Project memory, architecture, doc maintenance rules
├── README.md                        # This file
├── PROVIDERS.md                     # Cross-provider usage guide (CLI + API/SDK)
├── AGENTS.md                        # Codex CLI entry point (auto-read by @openai/codex)
├── CHANGELOG.md
├── package.json                     # NPM metadata: version, main entry, license
├── .version-bump.json               # Multi-file version sync config
├── install.sh                       # Install skills/agents to ~/.claude/ or project .claude/
│
├── .claude-plugin/                  # Claude Code plugin manifest
│   ├── plugin.json                  # Plugin entry point (skills, agents, commands paths)
│   └── marketplace.json             # Claude marketplace listing metadata
│
├── .opencode/                       # OpenCode plugin adapter
│   ├── INSTALL.md                   # OpenCode install instructions
│   └── plugins/
│       └── claude-skills.js         # Zero-dependency JS plugin (main per package.json)
│
├── .claude/
│   ├── settings.json                # Project-level permissions
│   ├── agents/                      # Specialized subagents (13)
│   │   ├── repo-historian.md        # Repo audit + commit restructuring
│   │   ├── scout.md                 # SDLC: codebase digestor
│   │   ├── navigator.md             # SDLC: session planner
│   │   ├── forge.md                 # SDLC: task executor
│   │   ├── scribe.md                # SDLC: doc sync
│   │   ├── architect.md             # Greenfield intake
│   │   ├── rules-writer.md          # Codify decisions into rules
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
├── scripts/
│   ├── load-skill.sh                # Inject any skill into Codex CLI sessions
│   └── bump-version.sh              # Bump version across all files in .version-bump.json
│
└── skills/                          # Skill definitions — 31 total
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
    ├── generate-rules/
    │
    │   # Tier 6 — SDLC Pipeline
    ├── codebase-ingest/
    ├── session-plan/
    ├── doc-sync/
    │
    │   # Tier 7 — Repository
    └── git-history-restructure/
```

---

## Standards

- Skills follow the [claude-code-best-practice](https://github.com/shanraisshan/claude-code-best-practice) SKILL.md spec
- All components are model-agnostic (no provider-specific APIs in skill bodies)
- Security skills default to read-only, never mutate files
- Every skill produces structured, actionable output — no vague guidance
