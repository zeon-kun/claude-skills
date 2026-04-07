# Dev Session

Launch the full SDLC pipeline for a development session, routed by project phase.

This command detects (or reads) the current project phase and dispatches to the appropriate pipeline variant:

```
greenfield:  architect → rules-writer → navigator → forge → scribe
existing:    (rules-lock check) → scout → navigator → forge → scribe
prototype:   scout(--shallow) → navigator → forge → scribe(--lean)
```

## Usage

```
/dev-session                        # Full pipeline (phase-aware)
/dev-session --skip-scout           # Skip ingest, start from navigator
/dev-session --exec-only            # Skip to forge (tasks already planned)
/dev-session --sync-only            # Run scribe only
/dev-session --set-phase <phase>    # Override phase (greenfield|existing|prototype)
/dev-session --phase <phase>        # Alias for --set-phase
```

## What You Get

1. **Codebase Digest** — architecture map, code patterns, doc health report
2. **Session tasks file** — prioritized checklist in task/session-N/tasks.md
3. **Executed changes** — features, fixes, tests, or docs delivered by forge
4. **Synced provider docs** — CLAUDE.md, GEMINI.md, AGENTS.md, WARP.md up to date
5. **CHANGELOG.md entry** — structured record of what was done

---

$ARGUMENTS

## Execution

### Phase Resolution (always runs first)

Parse `$ARGUMENTS` for `--set-phase <phase>` or `--phase <phase>` flags.

**Step 1 — Check for explicit phase override:**
If `--set-phase` or `--phase` is present in arguments:
- Use the provided value as the resolved phase
- Write `.claude/phase.md` with content: `phase: {value}`
- Skip bootstrap detection

**Step 2 — Read existing phase file:**
If no flag was passed, attempt to read `.claude/phase.md`.
- If the file exists, extract the phase from the first line (`phase: <value>`)
- Use that as the resolved phase
- Skip bootstrap detection

**Step 3 — Bootstrap detection (only if `.claude/phase.md` does not exist):**
Gather these signals:
- Git log commit count — fewer than 10 commits suggests greenfield
- Presence of `CHANGELOG.md` — suggests existing project
- Presence of any `.md` files in `.claude/rules/` — suggests existing project with decisions codified
- Count of source files in `src/` or `app/` or root — fewer than 20 files suggests greenfield or prototype

Evaluate signals and form a verdict. Present it to the user:

> "I detected this project is likely **{phase}** based on: {signals}. Does this look right? (y / override with: greenfield | existing | prototype)"

- On `y` or confirmation: write `.claude/phase.md` with `phase: {phase}`
- On override (user types `greenfield`, `existing`, or `prototype`): write `.claude/phase.md` with the overridden value

Resolved phase is now set. Proceed to the Phase Router.

---

### Phase Router

After resolving phase, check `$ARGUMENTS` for shortcut flags first:
- `--sync-only` → skip to [Scribe Stage] regardless of phase
- `--exec-only` → skip to [Forge Stage] regardless of phase
- `--skip-scout` → skip scout/architect stage, go directly to [Navigator Stage]
  - **Greenfield note:** In greenfield phase, `--skip-scout` skips architect + rules-writer. Only use this flag if `.claude/rules/` files already exist or you plan to provide decisions manually to navigator.
- No shortcut flags → run the full pipeline for the resolved phase

---

### Greenfield Pipeline

For `phase: greenfield`, run:

```
architect → rules-writer → navigator → forge → scribe
```

**Stage 1 — Architect**
Invoke the `architect` agent:
> "Conduct greenfield intake for this project. Cover brand, API design, DB schema, security patterns, and code conventions. Produce a decisions document summarizing all agreed patterns."

Capture the decisions document as `{architect_handoff}`.

**Stage 2 — Rules Writer**
Invoke the `rules-writer` agent with the decisions document:
> "Convert these decisions into .claude/rules/ files, one file per concern (e.g. frontend.md, backend.md, security.md, infra.md). Here are the decisions: {architect_handoff}"

After rules are written, update `.claude/phase.md` to `phase: existing`.
This auto-transitions the project out of greenfield so the next session uses the existing pipeline.

**Stage 3 — Navigator**
Invoke the `navigator` agent using the architect handoff as the codebase digest:
> "Here is the project decisions document from the architect: {architect_handoff}. Run the session planning workflow."

Pause for user confirmation on TASKS.md before continuing. Capture the session path as `{session_path}` from the navigator handoff.

**Stage 4 — Forge**
Invoke the `forge` agent:
> "Tasks are ready at {session_path}tasks.md. Execute the session tasks."

Capture forge output as `{forge_handoff}`.

**Stage 5 — Scribe**
Invoke the `scribe` agent:
> "Session complete. Here is the forge handoff: {forge_handoff}. Session path: {session_path}. Sync all provider docs and close the session."

---

### Existing Pipeline

For `phase: existing`, run:

```
(rules-lock check) → scout → navigator → forge → scribe
```

**Rules-Lock Check**
Check whether `.claude/rules/` contains at least one `.md` file.

If no rules files are found, prompt:
> "No rules found in `.claude/rules/`. Run rules-writer to codify your project decisions first? (y/n)"

- If `y`: invoke `rules-writer` agent:
  > "Interview me about this project's frontend, backend, security, and infrastructure decisions. Then generate .claude/rules/ files."
- If `n`: continue to scout

**Stage 1 — Scout**
Invoke the `scout` agent:
> "Digest the codebase at the current working directory. Produce a full Codebase Digest."

Capture the digest as `{digest}`.

**Stage 2 — Navigator**
Invoke the `navigator` agent with the digest:
> "Here is the Codebase Digest: {digest}. Run the session planning workflow."

Pause for user confirmation on TASKS.md before continuing. Capture the session path as `{session_path}` from the navigator handoff.

**Stage 3 — Forge**
Invoke the `forge` agent:
> "Tasks are ready at {session_path}tasks.md. Execute the session tasks."

Capture forge output as `{forge_handoff}`.

**Stage 4 — Scribe**
Invoke the `scribe` agent:
> "Session complete. Here is the forge handoff: {forge_handoff}. Session path: {session_path}. Sync all provider docs and close the session."

---

### Prototype Pipeline

For `phase: prototype`, run:

```
scout(--shallow) → navigator → forge → scribe(--lean)
```

**Stage 1 — Scout (shallow)**
Invoke the `scout` agent with the `--shallow` flag:
> "Run a shallow digest for this task: {user_task}. Focus only on directly relevant files. Do not map the full codebase."

Pass `--shallow` to scout. Capture the shallow digest as `{digest}`.

**Stage 2 — Navigator**
Invoke the `navigator` agent with the shallow digest:
> "Here is the shallow Codebase Digest: {digest}. Run the session planning workflow. Note: this is a prototype session — skip the user-file prompt and keep the task plan lean."

Navigator will auto-skip the user-file prompt in prototype mode.

Pause for user confirmation on TASKS.md before continuing. Capture the session path as `{session_path}` from the navigator handoff.

**Stage 3 — Forge**
Invoke the `forge` agent:
> "Tasks are ready at {session_path}tasks.md. Execute the session tasks."

Capture forge output as `{forge_handoff}`.

**Stage 4 — Scribe (lean)**
Invoke the `scribe` agent with the `--lean` flag:
> "Session complete. Here is the forge handoff: {forge_handoff}. Session path: {session_path}. Run in --lean mode: skip full provider doc sync."

---

### Handoff Between Stages

Pass the output of each stage as the input context for the next stage.
If any stage fails or is blocked, stop the pipeline immediately and report the blocker clearly.
Never auto-continue past a confirmation pause.
