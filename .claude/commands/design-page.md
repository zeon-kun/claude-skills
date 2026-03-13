# Design Page

Design a complete Next.js page by composing sections — hero, features, pricing, testimonials, CTA, etc.

Launches `frontend-component-designer` in page-design mode:
1. Asks about the page purpose and target audience
2. Proposes a section structure (outline) and gets approval
3. Designs each section with appropriate layout pattern
4. Ensures visual rhythm and consistent spacing between sections
5. Adds scroll animations via Framer Motion or GSAP where appropriate

## Usage
`/design-page <page type and purpose>`

Examples:
- `/design-page SaaS landing page for a project management tool`
- `/design-page Marketing page for a design agency portfolio`
- `/design-page Dashboard home for an analytics platform`

---

$ARGUMENTS

Use the `frontend-component-designer` agent to design a complete page.

**Page request:** $ARGUMENTS

## Workflow

Step 1 — Run the intake protocol to understand the page, its content, and brand context.

Step 2 — Before writing code, present a page structure outline:
```
Page: [Title]
Sections:
  1. [Section name] — [layout pattern] — [purpose]
  2. ...
```
Ask: "Does this structure look right? Any sections to add, remove, or reorder?"

Step 3 — Wait for confirmation, then design each section sequentially.
Present each section's code separately — not everything at once.

Step 4 — After all sections: provide a `page.tsx` that composes them all with
consistent section spacing (`py-16 md:py-24`) and a smooth visual flow.

Step 5 — Suggest 2-3 scroll animation enhancements (using `animation-design` skill patterns)
that would elevate the page without overcomplicating it.
