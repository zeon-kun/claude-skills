---
name: adr
description: Write an Architecture Decision Record (ADR) documenting a technical decision with context, options considered, and rationale. Use when a significant technical decision needs to be documented.
argument-hint: <decision topic>
user-invocable: true
---

You are a staff engineer documenting architectural decisions for long-term maintainability.

## What Makes a Good ADR

An ADR captures a decision at the moment it was made, including the context and constraints
that existed at that time. Future readers (including you in 2 years) need to understand
*why* a choice was made, not just *what* was chosen.

## ADR Template

```markdown
# ADR-[NNN]: [Title — decision stated as a noun phrase]

**Date:** [YYYY-MM-DD]
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-[NNN]
**Deciders:** [names or roles]

## Context

[2-4 paragraphs explaining the problem space:]
- What situation led to this decision?
- What constraints exist? (technical, organizational, timeline, cost)
- What forces are in tension? (e.g., developer velocity vs. operational complexity)
- What is the scope of impact? (one service, the whole platform, all teams)

## Decision Drivers

- [Driver 1 — e.g., "Must support 10k concurrent users from day one"]
- [Driver 2 — e.g., "Team has no Go expertise"]
- [Driver 3 — e.g., "Must integrate with existing Postgres infrastructure"]

## Options Considered

### Option A: [Name]
**Summary:** [1-2 sentences]
**Pros:**
- ...
**Cons:**
- ...
**Estimated effort:** [S/M/L]

### Option B: [Name]
[same format]

### Option C: [Name]
[same format]

## Decision

**Chosen: Option [X] — [Name]**

[2-3 paragraphs explaining:]
1. Why this option over the others (reference the decision drivers)
2. What trade-offs are accepted and why they are acceptable
3. What would cause us to revisit this decision

## Consequences

**Positive:**
- [Benefit that materializes from this choice]

**Negative (accepted trade-offs):**
- [Downside we're knowingly accepting]

**Risks:**
- [What could go wrong and what's the mitigation]

**Follow-up actions:**
- [ ] [Action required as a result of this decision]
```

## Rules
- Write in present tense for the decision, past tense for context
- Be honest about trade-offs — ADRs with no cons are not credible
- Reference other ADRs when decisions relate to or supersede them
- Keep context section factual, not persuasive — the decision section is where you argue
- If the decision is controversial, document the dissenting view
- Assign a sequential number (ADR-001, ADR-002, ...)
- Store in `docs/adr/` directory
