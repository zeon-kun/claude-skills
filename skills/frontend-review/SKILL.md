---
name: frontend-review
description: Review React/Next.js frontend code for correctness, accessibility, performance, design system adherence, and best practices. Produces a severity-tagged report. Use when reviewing frontend PRs or auditing existing components.
argument-hint: <file path or component code>
user-invocable: true
---

You are a senior frontend engineer reviewing React/Next.js code.
Review across 5 dimensions: correctness, accessibility, performance, design system adherence, and code quality.

---

## Review Dimensions

### 🔴 CRITICAL
- Server component using client-only APIs without `"use client"` directive
- Missing `key` prop in React lists (causes silent rendering bugs)
- `useEffect` with missing or incorrect dependencies (stale closure)
- Direct DOM mutation bypassing React state
- Hardcoded secrets, API keys in client-side code
- XSS via `dangerouslySetInnerHTML` with unescaped user input

### 🟠 HIGH — Accessibility (a11y)
- Interactive `<div>` / `<span>` without `role`, `tabIndex`, and keyboard handlers
- Images missing `alt` attribute (or `alt=""` for decorative — must be intentional)
- Form inputs missing associated `<label>` (or `aria-label` / `aria-labelledby`)
- Color contrast below WCAG AA (4.5:1 for text, 3:1 for UI elements)
- Modal / dialog not trapping focus
- No visible focus indicator on interactive elements
- `onClick` without equivalent `onKeyDown`/`onKeyUp` handler

### 🟠 HIGH — Performance
- Images without `next/image` (missing lazy loading, size optimization)
- Large client components that could be Server Components
- `useEffect` used for data fetching (should use `use()` hook or server fetching)
- Expensive computation in render without `useMemo`
- New object/array created in render causing unnecessary child re-renders
- Missing `loading.tsx` / `Suspense` boundaries for async data

### 🟡 MEDIUM — Design System Adherence
- Hardcoded color values (hex/rgb) instead of CSS custom properties / design tokens
- Hardcoded spacing (arbitrary `px-[13px]`) instead of Tailwind scale
- Inconsistent border radius (mixing `rounded-md`, `rounded-[6px]`, `rounded`)
- `font-size` in px instead of `text-*` scale
- Using `text-gray-500` instead of `text-muted-foreground`
- Using `bg-blue-600` instead of `bg-primary`
- Inline `style={}` for values that have Tailwind equivalents

### 🟡 MEDIUM — Next.js Patterns
- Using `useRouter` for navigation instead of `<Link>` component
- Client component at the route level when only leaf components need interactivity
- Missing `metadata` export on page components
- `<img>` instead of `<Image>` from next/image
- Layout work done in page component instead of `layout.tsx`
- Missing error boundary (`error.tsx`) for data-heavy routes

### 🟡 MEDIUM — React Patterns
- Props drilling more than 2 levels (candidate for context or composition)
- `useState` for server-derivable state
- Component doing too many things (>100 lines, multiple unrelated states)
- Missing loading and error states for async data
- `useEffect` used for state sync that belongs in event handlers

### 🟢 LOW / NIT
- Missing TypeScript types on component props (implicit `any`)
- `className` string literals instead of `cn()` for conditional classes
- Component file exported without display name (`Component.displayName`)
- Named imports not used (dead import)
- Non-semantic HTML (`<div>` where `<section>`, `<article>`, `<nav>` is appropriate)

---

## Output Format

```
## Frontend Review: [component/file name]

### Component Overview
[1-2 sentences: what this component does, stack used]

### Findings

#### 🔴 CRITICAL
**[File:Line]** — [Title]
Problem: [what's wrong]
Fix:
```tsx
// Before
[problematic code]
// After
[corrected code]
```

#### 🟠 HIGH — Accessibility
[same format]

#### 🟠 HIGH — Performance
[same format]

#### 🟡 MEDIUM — Design System
[same format]

#### 🟡 MEDIUM — Next.js / React
[same format]

#### 🟢 LOW / NIT
- [file:line] — [one-line description]

### Accessibility Score: [X / 10]
[Notes on a11y posture]

### What's Done Well
[Specific good practices found — reinforce patterns]

### Verdict
[ ] APPROVE   [X] REQUEST CHANGES   [ ] APPROVE WITH NITS
```

---

## Quick Reference: React/Next.js Best Practices

### Server vs Client Components
```
Default: Server Component (no "use client")
  → async/await works, no hooks, no browser APIs
  → Direct DB/API access, better performance

Need "use client" when:
  → useState, useEffect, useContext, useRef
  → Event listeners (onClick, onChange)
  → Browser APIs (window, document, localStorage)
  → Framer Motion, GSAP animations
  → Third-party libs that use React hooks

Strategy: push "use client" to leaf components,
keep parents as Server Components
```

### cn() Pattern (Always Use)
```tsx
// ❌ Wrong — doesn't merge, can produce conflicting classes
className={`base-class ${condition ? 'a' : 'b'} ${customClass}`}

// ✅ Correct — clsx + twMerge handles conflicts
className={cn("base-class", condition && "a", !condition && "b", customClass)}
```

### Design Token Usage
```tsx
// ❌ Wrong — hardcoded, breaks dark mode, breaks theming
<div className="bg-slate-900 text-gray-100 border-slate-700">

// ✅ Correct — semantic tokens, light/dark mode works automatically
<div className="bg-background text-foreground border-border">
```
