# Init Design System

Bootstrap a complete design system for a React/Next.js + shadcn/ui + Tailwind CSS project.

Launches the `design-system-architect` agent which:
1. Interviews you about brand, colors, typography, and aesthetic (brand-intake)
2. Generates `globals.css` with OKLCH color tokens + Tailwind v4 `@theme` mapping
3. Produces Typography component, `lib/utils.ts`, and theme providers
4. Outputs a Design Token Reference Card for the whole team

---

$ARGUMENTS

Use the `design-system-architect` agent for this project:

**Context:** $ARGUMENTS

If a directory path was provided, first audit the existing codebase with the `design-system-audit`
skill, then run the brand discovery focused on filling gaps. If no path was provided, start fresh
with a full brand-intake interview.

At the end, produce all design system artifacts ready to copy into the project.
