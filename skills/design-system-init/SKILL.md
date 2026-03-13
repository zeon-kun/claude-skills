---
name: design-system-init
description: Bootstrap a complete design system for a React/Next.js project using shadcn/ui + Tailwind CSS v4. Generates globals.css tokens, tailwind.config, font setup, and a base component theme. Requires a Brand Profile from brand-intake first.
argument-hint: <Brand Profile or project description>
user-invocable: true
---

You are a design systems engineer scaffolding a production-ready design system.
Before generating, confirm you have a Brand Profile (from brand-intake skill).
If not, ask the user for: primary color, neutral tone, font preference, border radius, and dark/light/system theme.

## What to Generate

Produce all 5 artifacts:

---

### Artifact 1: `src/app/globals.css`

Complete CSS custom properties file with Tailwind v4 integration:

```css
@import "tailwindcss";

/* ── Typography ────────────────────────────────────────────────────────── */
@import url("https://fonts.googleapis.com/css2?family=[HeadingFont]:wght@400;500;600;700;800&family=[BodyFont]:wght@300;400;500;600&display=swap");

@theme {
  --font-sans: "[BodyFont]", system-ui, -apple-system, sans-serif;
  --font-heading: "[HeadingFont]", var(--font-sans);
  --font-mono: "JetBrains Mono", "Fira Code", "Consolas", monospace;
}

/* ── Light Mode Tokens ─────────────────────────────────────────────────── */
:root {
  color-scheme: light;

  /* Radius */
  --radius:    [value]rem;  /* e.g., 0.625 for subtle, 0.375 for sharp, 1 for round */
  --radius-sm: calc(var(--radius) - 0.25rem);
  --radius-md: calc(var(--radius) - 0.125rem);
  --radius-lg: var(--radius);
  --radius-xl: calc(var(--radius) + 0.25rem);
  --radius-2xl:calc(var(--radius) + 0.75rem);

  /* Core semantic colors (OKLCH) */
  --background:           oklch([L] [C] [H]);
  --foreground:           oklch([L] [C] [H]);
  --card:                 oklch([L] [C] [H]);
  --card-foreground:      oklch([L] [C] [H]);
  --popover:              oklch([L] [C] [H]);
  --popover-foreground:   oklch([L] [C] [H]);
  --primary:              oklch([L] [C] [H]);
  --primary-foreground:   oklch([L] [C] [H]);
  --secondary:            oklch([L] [C] [H]);
  --secondary-foreground: oklch([L] [C] [H]);
  --muted:                oklch([L] [C] [H]);
  --muted-foreground:     oklch([L] [C] [H]);
  --accent:               oklch([L] [C] [H]);
  --accent-foreground:    oklch([L] [C] [H]);
  --destructive:          oklch(0.577 0.245 27.325);
  --destructive-foreground: oklch(0.985 0 0);
  --success:              oklch(0.723 0.190 142.495);
  --success-foreground:   oklch(0.985 0 0);
  --warning:              oklch(0.795 0.184 86.047);
  --warning-foreground:   oklch(0.145 0 0);
  --border:               oklch([L] [C] [H]);
  --input:                oklch([L] [C] [H]);
  --ring:                 oklch([L] [C] [H]);

  /* Chart colors */
  --chart-1: oklch([L] [C] [H]);
  --chart-2: oklch([L] [C] [H]);
  --chart-3: oklch([L] [C] [H]);
  --chart-4: oklch([L] [C] [H]);
  --chart-5: oklch([L] [C] [H]);

  /* Sidebar */
  --sidebar:              oklch([L] [C] [H]);
  --sidebar-foreground:   oklch([L] [C] [H]);
  --sidebar-primary:      var(--primary);
  --sidebar-primary-foreground: var(--primary-foreground);
  --sidebar-accent:       oklch([L] [C] [H]);
  --sidebar-accent-foreground: oklch([L] [C] [H]);
  --sidebar-border:       var(--border);
  --sidebar-ring:         var(--ring);
}

/* ── Dark Mode Tokens ──────────────────────────────────────────────────── */
.dark {
  color-scheme: dark;

  --background:           oklch([L] [C] [H]);
  --foreground:           oklch([L] [C] [H]);
  /* ... all tokens overridden for dark */
}

/* ── Tailwind Token Mapping ────────────────────────────────────────────── */
@theme inline {
  /* Colors */
  --color-background:          var(--background);
  --color-foreground:          var(--foreground);
  --color-card:                var(--card);
  --color-card-foreground:     var(--card-foreground);
  --color-popover:             var(--popover);
  --color-popover-foreground:  var(--popover-foreground);
  --color-primary:             var(--primary);
  --color-primary-foreground:  var(--primary-foreground);
  --color-secondary:           var(--secondary);
  --color-secondary-foreground:var(--secondary-foreground);
  --color-muted:               var(--muted);
  --color-muted-foreground:    var(--muted-foreground);
  --color-accent:              var(--accent);
  --color-accent-foreground:   var(--accent-foreground);
  --color-destructive:         var(--destructive);
  --color-destructive-foreground: var(--destructive-foreground);
  --color-success:             var(--success);
  --color-success-foreground:  var(--success-foreground);
  --color-warning:             var(--warning);
  --color-warning-foreground:  var(--warning-foreground);
  --color-border:              var(--border);
  --color-input:               var(--input);
  --color-ring:                var(--ring);
  --color-chart-1:             var(--chart-1);
  --color-chart-2:             var(--chart-2);
  --color-chart-3:             var(--chart-3);
  --color-chart-4:             var(--chart-4);
  --color-chart-5:             var(--chart-5);
  --color-sidebar:             var(--sidebar);
  --color-sidebar-foreground:  var(--sidebar-foreground);
  --color-sidebar-primary:     var(--sidebar-primary);
  --color-sidebar-primary-foreground: var(--sidebar-primary-foreground);
  --color-sidebar-accent:      var(--sidebar-accent);
  --color-sidebar-accent-foreground: var(--sidebar-accent-foreground);
  --color-sidebar-border:      var(--sidebar-border);
  --color-sidebar-ring:        var(--sidebar-ring);

  /* Radius */
  --radius-sm:  var(--radius-sm);
  --radius-md:  var(--radius-md);
  --radius-lg:  var(--radius-lg);
  --radius-xl:  var(--radius-xl);
  --radius-2xl: var(--radius-2xl);

  /* Fonts */
  --font-sans:    var(--font-sans);
  --font-heading: var(--font-heading);
  --font-mono:    var(--font-mono);
}

/* ── Base Styles ───────────────────────────────────────────────────────── */
@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground font-sans antialiased;
  }
  h1, h2, h3, h4, h5, h6 {
    @apply font-heading tracking-tight;
  }
}
```

---

### Artifact 2: `components/ui/typography.tsx`

Typed typography component using the design tokens:

```tsx
import { cn } from "@/lib/utils";
import { cva, type VariantProps } from "class-variance-authority";

const textVariants = cva("", {
  variants: {
    variant: {
      h1: "scroll-m-20 text-5xl font-extrabold tracking-tight lg:text-6xl font-heading",
      h2: "scroll-m-20 text-3xl font-semibold tracking-tight font-heading",
      h3: "scroll-m-20 text-2xl font-semibold tracking-tight font-heading",
      h4: "scroll-m-20 text-xl font-semibold tracking-tight font-heading",
      p:  "leading-7",
      lead: "text-xl text-muted-foreground",
      large: "text-lg font-semibold",
      small: "text-sm font-medium leading-none",
      muted: "text-sm text-muted-foreground",
      code: "relative rounded bg-muted px-[0.3rem] py-[0.2rem] font-mono text-sm font-semibold",
    },
  },
  defaultVariants: { variant: "p" },
});

const tagMap = {
  h1: "h1", h2: "h2", h3: "h3", h4: "h4",
  p: "p", lead: "p", large: "div", small: "small", muted: "p", code: "code",
} as const;

interface TypographyProps
  extends React.HTMLAttributes<HTMLElement>,
    VariantProps<typeof textVariants> {}

export function Typography({ variant = "p", className, ...props }: TypographyProps) {
  const Tag = tagMap[variant!] as keyof JSX.IntrinsicElements;
  return <Tag className={cn(textVariants({ variant }), className)} {...props} />;
}
```

---

### Artifact 3: `lib/utils.ts`

```typescript
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

---

### Artifact 4: `components/providers.tsx`

Theme provider setup with `next-themes`:

```tsx
"use client";
import { ThemeProvider } from "next-themes";

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <ThemeProvider
      attribute="class"
      defaultTheme="system"
      enableSystem
      disableTransitionOnChange
    >
      {children}
    </ThemeProvider>
  );
}
```

---

### Artifact 5: Design Token Reference Card

A quick-reference markdown table of all generated tokens with their values, for sharing with designers:

```markdown
# [Project] Design Tokens

## Colors
| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `--primary` | #... | #... | CTAs, key actions, links |
| `--secondary` | #... | #... | Secondary actions |
...

## Typography
| Scale | Class | Size | Weight | Use |
|-------|-------|------|--------|-----|
| Display | text-6xl | 60px | 800 | Hero headlines |
...

## Spacing
Base unit: 4px (rem: 0.25rem)
...

## Radius
| Token | Value | Class |
...
```

---

## Generation Rules

- **OKLCH color format** — always generate colors in OKLCH, not hex. OKLCH provides perceptually uniform color manipulation and P3 wide-gamut support.
- **Contrast checking** — verify every foreground/background pair meets WCAG AA (4.5:1 for text, 3:1 for UI). If a generated pair fails, adjust lightness.
- **Dark mode** — dark mode tokens are NOT simply inverted light tokens. Dark backgrounds should be dark-neutral (low chroma), not pure black. Foreground text should be slightly off-white.
- **Color harmony** — secondary and accent derive from primary via hue rotation (±30°, ±60°, ±120°) or desaturation, not arbitrary picks.
- **Surface layering** — `background` < `card` < `popover` (each ~2-4% lighter in light mode, darker in dark mode) to create depth without borders.
