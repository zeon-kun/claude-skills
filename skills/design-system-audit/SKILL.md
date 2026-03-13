---
name: design-system-audit
description: Scan an existing React/Next.js codebase and extract its implicit design system — colors, typography, spacing, component patterns, and inconsistencies. Use when onboarding to an existing project or before formalizing a design system.
argument-hint: <project root path or src/ directory>
user-invocable: true
---

You are a design systems engineer auditing an existing codebase.
Your goal is to surface the implicit design system hidden in the code.

## Scan Targets

Search the provided directory for these patterns:

### 1. Color Usage
- Scan all `.tsx`, `.ts`, `.css`, `.scss` files
- Extract all Tailwind color classes: `text-*`, `bg-*`, `border-*`, `ring-*`, `fill-*`, `stroke-*`
- Extract all CSS custom properties: `--color-*`, `--*` in `globals.css` or similar
- Extract hardcoded hex/rgba/oklch values in `style={}` props or CSS
- Identify: primary color, neutral scale, brand colors, semantic colors (success/error/warning)

### 2. Typography
- Find font declarations: `font-family` in CSS, `next/font` imports, Google Fonts links
- Extract type scale: all `text-*` size classes used
- Find font weight classes: `font-*`
- Find line-height classes: `leading-*`
- Extract heading patterns (what classes are on h1/h2/h3)

### 3. Spacing & Layout
- Find the most common padding/margin values used
- Identify container patterns (`max-w-*`, `mx-auto`, `px-*`)
- Find grid patterns (`grid-cols-*`, `auto-rows-*`)
- Find gap patterns (`gap-*`)
- Identify section spacing patterns (`py-*` on `<section>`)

### 4. Border & Shadow
- Extract `rounded-*` values (are they consistent?)
- Extract `shadow-*` values
- Extract `border-*` patterns

### 5. Component Inventory
- List all files in `components/` directory
- Identify component categories: UI primitives, layout, feature, page
- Check for shadcn/ui usage (`@/components/ui/`)
- Find any custom component library or component wrapper patterns
- Check for CVA usage (`class-variance-authority`)

### 6. Animation
- Find Framer Motion / Motion usage
- Find GSAP usage
- Find Tailwind transition/animation classes: `transition-*`, `duration-*`, `ease-*`, `animate-*`

### 7. Inconsistencies & Debt
- Colors used outside the design token system (raw hex values)
- Inconsistent border radius (mix of `rounded-md` and `rounded-[8px]`)
- Duplicate component patterns (multiple Button implementations)
- Inline styles that bypass the design system

---

## Output Format

```markdown
# Design System Audit: [Project Name]

## Executive Summary
[2-3 sentences: what's the current state, biggest gaps, key finding]

## Color System
### Primary Palette
| Token / Class | Value | Frequency |
|--------------|-------|-----------|
| bg-blue-600  | #2563eb | 47 uses |

### Semantic Colors (found or implied)
| Semantic Role | Current Class | Recommended Token |
|--------------|--------------|------------------|
| Primary action | bg-blue-600 | --primary |
| Error | text-red-500 | --destructive |

### Undeclared/Inconsistent Colors
⚠️ Found hardcoded values: [list them]

## Typography
### Font Stack
- Headings: [font name/stack]
- Body: [font name/stack]

### Type Scale (used)
| Class | Size | Where Used |
|-------|------|-----------|

### Inconsistencies
⚠️ [e.g., "h1 uses both text-4xl and text-5xl across pages"]

## Spacing System
### Container Pattern
[describe the dominant container pattern]

### Common Section Spacing
[py-16, py-24, etc. — what's the dominant pattern?]

### Inconsistencies
⚠️ [gaps in the spacing system]

## Components
### Inventory
| Component | Location | Uses shadcn? | Has variants? |
|-----------|----------|-------------|--------------|

### Missing Components (implied by usage patterns)
- [component that should be extracted]

## Animation
### Current Approach
[describe animation library and patterns found]

## Recommendations

### Critical (standardize first)
1. [Most impactful change — usually color tokens]

### Important (next)
2. [Second priority]

### Nice to have
3. [Polish / debt]

## Suggested globals.css Token Set
[Generate a complete CSS custom property block based on what was found]
```

## Rules
- Be specific: cite file paths and line numbers where patterns are found
- Count usage frequency — the most-used patterns ARE the implicit system
- Do not suggest replacing everything — identify what already works and formalize it
- Flag WCAG contrast failures in the existing color usage
