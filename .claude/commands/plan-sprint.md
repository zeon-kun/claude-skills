# Plan Sprint

Invoke the feature-planner agent to plan a sprint or feature from scratch.

Launches the `feature-planner` agent which orchestrates:
- Feature scoping (plan-feature skill)
- Story decomposition (breakdown skill)
- Effort estimation (estimate skill)
- API surface design if needed (api-design skill)

## Usage
`/plan-sprint <feature or epic description>`

## What you'll get
1. Feature plan with acceptance criteria
2. Story breakdown ready for sprint planning
3. Effort estimates with confidence levels
4. API endpoint sketches (if applicable)
5. Open questions to resolve before development starts

---

$ARGUMENTS

Use the `feature-planner` agent to produce a complete sprint plan for the following:

$ARGUMENTS

If no arguments were provided, ask the user: "What feature or epic would you like to plan for this sprint?"
