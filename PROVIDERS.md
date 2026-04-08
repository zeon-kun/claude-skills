# Cross-Provider Compatibility Guide

Skills in this repository are designed as model-agnostic instruction sets.
A skill's `SKILL.md` body is a system prompt that can be injected into any LLM.

---

## Installation by Tool

### Claude Code (Anthropic)

**Option A — Plugin manifest (recommended)**

Clone the repo and point Claude Code at the plugin manifest:

```bash
git clone https://github.com/YOUR_ORG/claude-skills.git
```

In your Claude Code settings, add the plugin path:

```json
{
  "plugins": ["/path/to/claude-skills/.claude-plugin/plugin.json"]
}
```

Claude Code reads `plugin.json`, discovers `skills/`, `.claude/agents/`, and
`.claude/commands/` automatically. All skills appear as slash commands and
all agents become available for invocation.

**Option B — install.sh (global copy)**

```bash
cd claude-skills
./install.sh                          # copy everything to ~/.claude/
./install.sh --skills code-review debug
./install.sh --agents code-reviewer
./install.sh --project                # copy to current project's .claude/
```

**Option C — Manual**

```bash
cp -r skills/code-review ~/.claude/skills/
cp .claude/agents/code-reviewer.md ~/.claude/agents/
```

---

### OpenCode

claude-skills ships a zero-dependency JS plugin at `.opencode/plugins/claude-skills.js`.
The plugin is the `main` entry in `package.json` and requires no `npm install`.

**Install from GitHub**

Add to your `opencode.json`:

```json
{
  "plugins": [
    "git+https://github.com/YOUR_ORG/claude-skills.git"
  ]
}
```

**Install from local clone**

```bash
git clone https://github.com/YOUR_ORG/claude-skills.git
```

Then in `opencode.json`:

```json
{
  "plugins": ["/path/to/claude-skills"]
}
```

OpenCode resolves the `main` field (`package.json`) and loads the plugin automatically.
See `.opencode/INSTALL.md` for full details.

---

### Codex CLI (OpenAI)

```bash
npm install -g @openai/codex
# AGENTS.md is read automatically when you run codex inside this repo
codex

# Or inject a specific skill
./scripts/load-skill.sh code-review "Review src/auth.ts"
./scripts/load-skill.sh --combine "plan-feature,breakdown" "Add OAuth2 login"
./scripts/load-skill.sh --list   # see all skills
```

`AGENTS.md` is read automatically by `@openai/codex` when run inside this repo.
For use in another project, symlink `skills/` and copy `AGENTS.md`:

```bash
ln -s /path/to/claude-skills/skills ~/.agents/skills/claude-skills
```

---

## Provider Invocation Patterns

### Claude Code — Native Integration

Skills integrate via the Skill tool and agent frontmatter:

```yaml
# In .claude/agents/my-agent.md frontmatter
skills:
  - plan-feature
  - code-review
```

Or user-invocable: `/plan-feature user authentication module`

### OpenAI Codex / GPT-4o — API/SDK

Inject the SKILL.md body as a system message:

```python
import re, openai

def load_skill(name: str) -> str:
    with open(f"skills/{name}/SKILL.md") as f:
        content = f.read()
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

### MiniMax / Kimi / Other OpenAI-compatible APIs

All OpenAI-compatible providers accept the same system message pattern:

```python
client = openai.OpenAI(
    api_key="your-key",
    base_url="https://api.minimax.chat/v1"  # or Kimi endpoint
)
# Same messages[] structure as above
```

---

## Frontmatter Reference

SKILL.md files use YAML frontmatter for Claude Code integration:

```yaml
---
name: skill-name
description: One-line description used for skill discovery
argument-hint: <optional: what args the user can pass>
user-invocable: true          # Show in /slash commands
disable-model-invocation: false
---
```

`allowed-tools` and `model` belong in agent definitions (`.claude/agents/`), not skill files.

For other providers, only `name` and `description` matter — the body is the system prompt.

---

## Portability Checklist

When writing a new skill, ensure:
- [ ] No Claude-specific tool names in the body (use generic terms like "search", "read file")
- [ ] Output format is plain text or Markdown (universally renderable)
- [ ] No hardcoded Claude model names in examples
- [ ] Skill body works as a standalone system prompt without any framework

---

## CLI Skill Injection

Use the helper script to inject any skill into Codex CLI sessions:

```bash
# List all available skills
./scripts/load-skill.sh --list

# Print skill system prompt (pipe anywhere)
./scripts/load-skill.sh code-review

# Run single skill via auto-detected CLI
./scripts/load-skill.sh code-review "Review src/auth.ts"

# Combine skills (simulate an agent)
./scripts/load-skill.sh --combine "code-review,security-audit" "Review PR #42"
```

The script auto-detects `codex` in PATH. If Codex is not installed,
it prints the system prompt for manual use.

---

## Monitoring Setup

See `monitoring/` for:
- `docker-compose.yml` — LiteLLM proxy with dashboard (`localhost:4000/ui`)
- `dashboard.py` — Local TUI for skill/agent activity (`pip install rich`)
- `hooks/` — Claude Code hooks for zero-token skill event logging

---

## Helper: Strip Frontmatter

```python
import re

def extract_skill_prompt(skill_md_content: str) -> str:
    """Extract the system prompt body from a SKILL.md file."""
    # Remove YAML frontmatter (--- ... ---)
    body = re.sub(r'^---\n.*?\n---\n', '', skill_md_content, flags=re.DOTALL)
    return body.strip()
```
