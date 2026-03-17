# Dev Session

Launch the full SDLC pipeline for a development session.

This command orchestrates the complete development lifecycle:

```
scout → navigator → [user confirms] → forge → scribe
  ↓          ↓                           ↓        ↓
digest    task plan                   execute   sync docs
```

## Pipeline Stages

| Stage | Agent | Does |
|-------|-------|------|
| 1. Ingest | `scout` | Digest codebase: architecture, patterns, brand, doc health |
| 2. Plan | `navigator` | Show digest, list agents, ask goals, write TASKS.md |
| 3. Execute | `forge` | Run Session 1 tasks from TASKS.md using appropriate skills |
| 4. Sync | `scribe` | Update CLAUDE.md, CHANGELOG.md, TASKS.md, provider docs |

## Usage

```
/dev-session                        # Full pipeline from scratch
/dev-session --skip-scout           # Skip ingest, start from navigator
/dev-session --exec-only            # Skip to forge (TASKS.md already exists)
/dev-session --sync-only            # Run scribe only (docs out of sync)
```

## What You Get

1. **Codebase Digest** — architecture map, code patterns, doc health report
2. **TASKS.md** — prioritized checklist with session planning and token estimates
3. **Executed changes** — features, fixes, tests, or docs delivered by forge
4. **Synced provider docs** — CLAUDE.md, GEMINI.md, AGENTS.md, WARP.md up to date
5. **CHANGELOG.md entry** — structured record of what was done

---

$ARGUMENTS

## Execution

Parse `$ARGUMENTS` for flags:
- `--skip-scout` → skip scout, go directly to navigator
- `--exec-only` → skip scout + navigator, load TASKS.md and invoke forge
- `--sync-only` → skip scout + navigator + forge, invoke scribe only
- No flags → run full pipeline

### Full Pipeline (default)

**Stage 1 — Scout**
Invoke the `scout` agent:
> "Digest the codebase at the current working directory. Produce a full Codebase Digest."

Present the digest output to the user. Pause and confirm:
> "Digest complete. Proceed to session planning? (y/n)"

**Stage 2 — Navigator**
Invoke the `navigator` agent with the codebase digest:
> "Here is the Codebase Digest: {digest}. Run the session planning workflow."

The navigator will ask what to accomplish and produce TASKS.md. Pause here until the user confirms TASKS.md.

**Stage 3 — Forge**
Invoke the `forge` agent:
> "TASKS.md is ready. Execute all Session 1 tasks."

**Stage 4 — Scribe**
Invoke the `scribe` agent with forge's handoff summary:
> "Session complete. Here is the forge handoff: {handoff}. Sync all provider docs and close the session."

### Handoff Between Stages

Pass the output of each stage as input to the next.
If any stage fails or is blocked, stop the pipeline and report the blocker clearly.
Do not auto-continue past a confirmation pause.
