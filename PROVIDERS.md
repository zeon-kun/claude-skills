# Cross-Provider Compatibility Guide

Skills in this repository are designed as model-agnostic instruction sets.
A skill's `SKILL.md` body is a system prompt that can be injected into any LLM.

## CLI Installation

Each provider has its own CLI tool. Engineers install whichever they use:

```bash
# Claude Code (reads CLAUDE.md)
npm install -g @anthropic-ai/claude-code

# Codex CLI (reads AGENTS.md)
npm install -g @openai/codex

# Gemini CLI (reads GEMINI.md)
npm install -g @google/gemini-cli
```

All three CLIs pick up their respective config files automatically when run inside
this repo. Skills are available via `scripts/load-skill.sh` for Codex and Gemini.

## Provider Invocation Patterns

### Claude Code (Anthropic)
Skills integrate natively via the Skill tool and agent frontmatter:
```yaml
# In .claude/agents/my-agent.md frontmatter
skills:
  - plan-feature
  - code-review
```
Or user-invocable: `/plan-feature user authentication module`

### OpenAI Codex / GPT-4o
Inject the SKILL.md body as a system message:
```python
import anthropic  # or openai

with open("skills/plan-feature/SKILL.md") as f:
    skill_prompt = extract_body(f.read())  # strip YAML frontmatter

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": skill_prompt},
        {"role": "user", "content": "Plan the user authentication module"}
    ]
)
```

### Google Gemini
```python
import google.generativeai as genai

model = genai.GenerativeModel(
    model_name="gemini-2.0-flash",
    system_instruction=skill_prompt
)
response = model.generate_content("Plan the user authentication module")
```

### MiniMax / Kimi / Other OpenAI-compatible APIs
All OpenAI-compatible providers accept the same system message pattern:
```python
client = openai.OpenAI(
    api_key="your-key",
    base_url="https://api.minimax.chat/v1"  # or Kimi endpoint
)
# Same messages[] structure as Codex example above
```

## Frontmatter Reference

SKILL.md files use YAML frontmatter for Claude Code integration:

```yaml
---
name: skill-name
description: One-line description used for skill discovery
argument-hint: <optional: what args the user can pass>
user-invocable: true          # Show in /slash commands
allowed-tools: Read,Grep,Glob # Minimal tool set
model: sonnet                 # haiku | sonnet | opus | inherit
context: fork                 # fork = isolated subagent context
disable-model-invocation: false
---
```

For other providers, only `name` and `description` matter — the body is the system prompt.

## Portability Checklist

When writing a new skill, ensure:
- [ ] No Claude-specific tool names in the body (use generic terms like "search", "read file")
- [ ] Output format is plain text or Markdown (universally renderable)
- [ ] No hardcoded Claude model names in examples
- [ ] Skill body works as a standalone system prompt without any framework

## CLI Skill Injection

Use the helper script to inject any skill into Codex or Gemini CLI sessions:

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

The script auto-detects `codex` or `gemini` in PATH. If neither is installed,
it prints the system prompt for manual use.

## Monitoring Setup

See `monitoring/` for:
- `docker-compose.yml` — LiteLLM proxy with dashboard (`localhost:4000/ui`)
- `dashboard.py` — Local TUI for skill/agent activity (`pip install rich`)
- `hooks/` — Claude Code hooks for zero-token skill event logging

## Helper: Strip Frontmatter

```python
import re

def extract_skill_prompt(skill_md_content: str) -> str:
    """Extract the system prompt body from a SKILL.md file."""
    # Remove YAML frontmatter (--- ... ---)
    body = re.sub(r'^---\n.*?\n---\n', '', skill_md_content, flags=re.DOTALL)
    return body.strip()
```
