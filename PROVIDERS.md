# Cross-Provider Compatibility Guide

Skills in this repository are designed as model-agnostic instruction sets.
A skill's `SKILL.md` body is a system prompt that can be injected into any LLM.

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

## Helper: Strip Frontmatter

```python
import re

def extract_skill_prompt(skill_md_content: str) -> str:
    """Extract the system prompt body from a SKILL.md file."""
    # Remove YAML frontmatter (--- ... ---)
    body = re.sub(r'^---\n.*?\n---\n', '', skill_md_content, flags=re.DOTALL)
    return body.strip()
```
