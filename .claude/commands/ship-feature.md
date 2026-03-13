# Ship Feature

End-to-end workflow: plan → implement → test → document → review.

This command orchestrates multiple agents to take a feature from idea to production-ready code.

## Usage
`/ship-feature <feature description>`

## Workflow
1. `feature-planner` agent — scope and plan the feature
2. Human gate — confirm the plan before implementation
3. Implementation (guided by the plan)
4. `write-tests` skill — generate tests
5. `code-reviewer` agent — review the implementation
6. `write-docs` skill — generate documentation

---

$ARGUMENTS

You are orchestrating a complete feature delivery workflow. The feature to implement is:

**$ARGUMENTS**

## Step 1: Plan
First, use the `feature-planner` agent to produce a complete plan. Present the plan to the user and ask:
"Does this plan look correct? Should I proceed with implementation, or do you want to adjust the scope?"

**Wait for user confirmation before proceeding.**

## Step 2: Implement
Once confirmed, implement the feature according to the plan:
- Follow the technical breakdown phase by phase
- Read existing code before writing new code
- Match existing patterns and conventions

## Step 3: Test
After implementation, use the `write-tests` skill to generate tests for the new code.

## Step 4: Review
Use the `code-reviewer` agent to review what was written.

## Step 5: Document
Use the `write-docs` skill to generate a short feature guide or update the README.

## Final Output
Summarize:
- What was built
- Files changed
- Tests added
- Any follow-up work needed
