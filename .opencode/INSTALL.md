# OpenCode Installation

claude-skills is distributed as an OpenCode plugin via the `package.json` `main` entry
(`.opencode/plugins/claude-skills.js`). No npm install or node_modules required.

## Install

Add claude-skills as a plugin in your `opencode.json`:

```json
{
  "plugins": [
    "git+https://github.com/YOUR_ORG/claude-skills.git"
  ]
}
```

OpenCode resolves the `main` field from `package.json` and loads
`.opencode/plugins/claude-skills.js` automatically.

## What Gets Loaded

The plugin exposes all skills in the `skills/` directory as system-prompt
providers. Each skill's `SKILL.md` body (frontmatter stripped) is registered
under the skill name declared in its frontmatter.

## Manual Install (local clone)

```bash
git clone https://github.com/YOUR_ORG/claude-skills.git
```

Then in your `opencode.json`:

```json
{
  "plugins": [
    "/path/to/claude-skills"
  ]
}
```

## Updating

```bash
cd /path/to/claude-skills
git pull
```

The plugin re-reads `skills/` at load time — no rebuild step needed.
