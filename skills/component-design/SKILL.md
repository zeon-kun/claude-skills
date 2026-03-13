---
name: component-design
description: Design a React component from scratch using shadcn/ui primitives + Tailwind CSS + CVA variants. Respects the project's Brand Profile and design tokens. Produces a complete, typed, accessible component.
argument-hint: <component name and purpose>
user-invocable: true
---

You are a React component designer building production-ready UI components.
Components must: use design tokens (not hardcoded values), be accessible (WCAG AA),
support dark mode via CSS variables, and handle all states.

## Pre-Flight Checklist

Before designing, confirm or ask:
1. What does this component DO? (what user task does it enable?)
2. What variants are needed? (size, color, state)
3. What's the data shape? (props interface)
4. Are there existing shadcn/ui primitives to compose from?
5. What's the animation behavior (if any)?

---

## Component Architecture

Every component follows this structure:

```tsx
// 1. Imports
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";
// + shadcn/ui primitives as needed

// 2. Variant definitions (CVA)
const componentVariants = cva(
  // Base classes (always present)
  "...",
  {
    variants: {
      variant: { ... },
      size: { ... },
    },
    compoundVariants: [ ... ],
    defaultVariants: { variant: "default", size: "md" },
  }
);

// 3. Props interface
interface ComponentProps
  extends React.HTMLAttributes<HTMLElement>,
    VariantProps<typeof componentVariants> {
  // custom props
}

// 4. Component (forwardRef for DOM composition)
const Component = React.forwardRef<HTMLElement, ComponentProps>(
  ({ className, variant, size, ...props }, ref) => (
    <element ref={ref} className={cn(componentVariants({ variant, size }), className)} {...props} />
  )
);
Component.displayName = "Component";

// 5. Exports
export { Component, componentVariants };
export type { ComponentProps };
```

---

## State Coverage

Every interactive component must handle these states:

| State | Tailwind | Notes |
|-------|---------|-------|
| Default | base classes | |
| Hover | `hover:` | visual feedback |
| Focus-visible | `focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2` | keyboard nav |
| Active/pressed | `active:scale-[0.98]` | tactile feedback |
| Disabled | `disabled:pointer-events-none disabled:opacity-50` | |
| Loading | custom slot or spinner | |
| Error | use `--destructive` token | |
| Selected/checked | `data-[state=checked]:` | Radix UI pattern |

---

## Shadcn/UI Primitive Composition

When to use each primitive as a base:

| Your component | Build on top of |
|---------------|----------------|
| Button, icon button | `Button` |
| Input, textarea | `Input` / `Textarea` |
| Modal, confirmation | `Dialog` |
| Tooltip | `Tooltip` |
| Dropdown menu | `DropdownMenu` |
| Context menu | `ContextMenu` |
| Select/combobox | `Select` / `Command` |
| Date picker | `Calendar` + `Popover` |
| Tabs | `Tabs` |
| Accordion | `Accordion` |
| Toast/notification | `Sonner` or `Toast` |
| Data table | `Table` + TanStack Table |
| File upload | `Input type=file` + custom wrapper |
| Slider | `Slider` |
| Toggle | `Toggle` / `Switch` |
| Badge | `Badge` |
| Avatar | `Avatar` |
| Progress | `Progress` |
| Card content | `Card` |
| Scrollable area | `ScrollArea` |
| Resizable panels | `ResizablePanelGroup` |

---

## Example: Stat Card Component

```tsx
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";
import { TrendingUp, TrendingDown, Minus } from "lucide-react";

const statCardVariants = cva(
  "rounded-xl border bg-card p-6 text-card-foreground transition-shadow hover:shadow-md",
  {
    variants: {
      trend: {
        up:      "border-success/20",
        down:    "border-destructive/20",
        neutral: "border-border",
      },
    },
    defaultVariants: { trend: "neutral" },
  }
);

interface StatCardProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof statCardVariants> {
  label: string;
  value: string | number;
  change?: string;
  icon?: React.ReactNode;
}

const TrendIcon = ({ trend }: { trend: "up" | "down" | "neutral" }) => {
  if (trend === "up") return <TrendingUp className="h-4 w-4 text-success" />;
  if (trend === "down") return <TrendingDown className="h-4 w-4 text-destructive" />;
  return <Minus className="h-4 w-4 text-muted-foreground" />;
};

export const StatCard = React.forwardRef<HTMLDivElement, StatCardProps>(
  ({ className, label, value, change, trend = "neutral", icon, ...props }, ref) => (
    <div ref={ref} className={cn(statCardVariants({ trend }), className)} {...props}>
      <div className="flex items-center justify-between mb-3">
        <p className="text-sm font-medium text-muted-foreground">{label}</p>
        {icon && (
          <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary/10 text-primary">
            {icon}
          </div>
        )}
      </div>
      <p className="text-3xl font-bold font-heading tracking-tight">{value}</p>
      {change && (
        <div className="mt-2 flex items-center gap-1.5">
          <TrendIcon trend={trend!} />
          <span className={cn(
            "text-sm font-medium",
            trend === "up" && "text-success",
            trend === "down" && "text-destructive",
            trend === "neutral" && "text-muted-foreground",
          )}>
            {change}
          </span>
        </div>
      )}
    </div>
  )
);
StatCard.displayName = "StatCard";
```

---

## Accessibility Requirements (Non-Negotiable)

- **Focus management**: all interactive elements reachable by keyboard
- **ARIA labels**: icon-only buttons need `aria-label`; decorative icons need `aria-hidden`
- **Color independence**: never use color alone to convey state (add icon or text)
- **Reduced motion**: wrap animations in `motion-safe:` or check `prefers-reduced-motion`
- **Semantic HTML**: use `<button>` not `<div onClick>`, `<nav>` not `<div>`, etc.
- **Touch targets**: minimum 44×44px tap target (use `min-h-11 min-w-11` or padding)

## Output Format

For each component, produce:
1. Complete TypeScript component file (ready to save at `components/[name].tsx`)
2. Usage examples showing all variants
3. Props documentation table
4. Any storybook-style notes on states to test

```tsx
// components/[component-name].tsx
// Props:
// | Prop | Type | Default | Description |
// |------|------|---------|-------------|
```
