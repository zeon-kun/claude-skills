---
name: animation-design
description: Design animations for React/Next.js components using Framer Motion (Motion) or GSAP. Covers entrances, scroll-triggered reveals, page transitions, stagger effects, and interactive micro-animations. Respects user motion preferences.
argument-hint: <component or page to animate, and desired animation type>
user-invocable: true
---

You are an animation engineer designing purposeful, performant UI animations.

## Guiding Principle
Animation must serve communication, not decorate. Every animation should:
- Reinforce spatial relationships (where did the element come from/go to?)
- Provide feedback (button press, form submission, loading)
- Guide attention (what should the user look at next?)

Never animate just because you can.

---

## Library Selection Guide

| Use Case | Use |
|----------|-----|
| Component enter/exit, layout shifts, page transitions | **Motion (Framer Motion)** |
| Scroll-driven storytelling, pinned sequences, timeline orchestration | **GSAP + ScrollTrigger** |
| Simple hover/focus states | **Tailwind** (`transition-*`, `hover:scale-*`) |
| Complex SVG / path animations | **GSAP** |
| Staggered list reveals, shared element transitions | **Motion** |

---

## Motion (Framer Motion) Patterns

### Package setup
```bash
npm install motion
```
```tsx
import { motion, AnimatePresence } from "motion/react";
```

### 1. Entrance Animations

**Fade up (most common, clean):**
```tsx
<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  transition={{ duration: 0.4, ease: [0.25, 0.46, 0.45, 0.94] }}
>
  Content
</motion.div>
```

**Fade in with scale (cards, modals):**
```tsx
<motion.div
  initial={{ opacity: 0, scale: 0.96 }}
  animate={{ opacity: 1, scale: 1 }}
  transition={{ type: "spring", stiffness: 300, damping: 30 }}
>
  Content
</motion.div>
```

**Slide from edge (sidebars, drawers):**
```tsx
<motion.aside
  initial={{ x: "-100%" }}
  animate={{ x: 0 }}
  exit={{ x: "-100%" }}
  transition={{ type: "spring", stiffness: 300, damping: 30 }}
>
  Sidebar
</motion.aside>
```

### 2. Staggered Reveals (lists, grids, feature sections)

```tsx
const container = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: {
      staggerChildren: 0.08,   // 80ms between items — snappy
      delayChildren: 0.1,
    },
  },
};

const item = {
  hidden: { opacity: 0, y: 20 },
  show: {
    opacity: 1, y: 0,
    transition: { type: "spring", stiffness: 300, damping: 24 },
  },
};

export function StaggeredGrid({ items }) {
  return (
    <motion.div
      className="grid grid-cols-3 gap-4"
      variants={container}
      initial="hidden"
      animate="show"
    >
      {items.map((item) => (
        <motion.div key={item.id} variants={item} className="rounded-xl border p-4">
          {item.content}
        </motion.div>
      ))}
    </motion.div>
  );
}
```

**Stagger timing guide:**
- List items: 0.05s (fast, snappy)
- Cards/grid: 0.08s (comfortable)
- Feature sections: 0.12s (deliberate)
- Hero elements: 0.15-0.20s (cinematic)

### 3. Scroll-Triggered (whileInView)

```tsx
// Simple — fires once when element enters viewport
<motion.section
  initial={{ opacity: 0, y: 40 }}
  whileInView={{ opacity: 1, y: 0 }}
  viewport={{ once: true, amount: 0.3 }}
  transition={{ duration: 0.6, ease: "easeOut" }}
>
  Section content
</motion.section>

// Wrapped reusable component
function FadeInView({
  children,
  delay = 0,
  className,
}: {
  children: React.ReactNode;
  delay?: number;
  className?: string;
}) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 24 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, amount: 0.2 }}
      transition={{ duration: 0.5, delay, ease: [0.21, 0.47, 0.32, 0.98] }}
      className={className}
    >
      {children}
    </motion.div>
  );
}
```

### 4. Page Transitions (Next.js App Router)

```tsx
// app/template.tsx — use template.tsx NOT layout.tsx for transitions
"use client";
import { motion } from "motion/react";

export default function Template({ children }: { children: React.ReactNode }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -8 }}
      transition={{ duration: 0.3, ease: "easeInOut" }}
    >
      {children}
    </motion.div>
  );
}
```

### 5. Shared Element Transitions (layoutId)

```tsx
// Works across separate components — Motion tracks by layoutId
function CardGrid({ cards, onSelect }) {
  return (
    <div className="grid grid-cols-3 gap-4">
      {cards.map(card => (
        <motion.div
          key={card.id}
          layoutId={`card-${card.id}`}
          onClick={() => onSelect(card.id)}
          className="cursor-pointer rounded-2xl border bg-card p-4"
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
        >
          <motion.h3 layoutId={`title-${card.id}`} className="font-semibold">
            {card.title}
          </motion.h3>
        </motion.div>
      ))}
    </div>
  );
}

function CardModal({ card, onClose }) {
  return (
    <AnimatePresence>
      <motion.div
        className="fixed inset-0 z-50 flex items-center justify-center p-4"
        initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
        onClick={onClose}
      >
        <motion.div
          layoutId={`card-${card.id}`}
          className="w-full max-w-lg rounded-2xl bg-card p-8 shadow-2xl"
          onClick={e => e.stopPropagation()}
        >
          <motion.h3 layoutId={`title-${card.id}`} className="text-2xl font-bold">
            {card.title}
          </motion.h3>
        </motion.div>
      </motion.div>
    </AnimatePresence>
  );
}
```

### 6. Micro-interactions

```tsx
// Button press
<motion.button
  whileHover={{ scale: 1.02 }}
  whileTap={{ scale: 0.97 }}
  transition={{ type: "spring", stiffness: 400, damping: 17 }}
>
  Click me
</motion.button>

// Hover glow card
<motion.div
  whileHover={{ boxShadow: "0 0 30px rgba(var(--primary), 0.15)" }}
  transition={{ duration: 0.2 }}
  className="rounded-xl border p-6 cursor-pointer"
>
  Card
</motion.div>

// Number counter
function AnimatedCounter({ value }: { value: number }) {
  const count = useMotionValue(0);
  const rounded = useTransform(count, v => Math.round(v));
  const display = useMotionTemplate`${rounded}`;

  useEffect(() => {
    const controls = animate(count, value, { duration: 1.5, ease: "easeOut" });
    return controls.stop;
  }, [value]);

  return <motion.span>{display}</motion.span>;
}
```

---

## GSAP Patterns

### Setup (Next.js App Router)
```tsx
"use client";
import { useRef } from "react";
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { useGSAP } from "@gsap/react";

gsap.registerPlugin(ScrollTrigger);
```

### 1. Scroll-Pinned Storytelling

```tsx
export function PinnedSection() {
  const container = useRef<HTMLDivElement>(null);

  useGSAP(() => {
    const tl = gsap.timeline({
      scrollTrigger: {
        trigger: container.current,
        start: "top top",
        end: "+=200%",        // 2x viewport height of scroll drives the timeline
        scrub: 1.5,           // smooth 1.5s lag
        pin: true,            // pin while playing
        anticipatePin: 1,
      },
    });

    tl.from(".panel-1", { opacity: 0, y: 60, duration: 1 })
      .from(".panel-2", { opacity: 0, y: 60, duration: 1 }, "+=0.5")
      .to(".panel-1", { opacity: 0, y: -60, duration: 1 }, "+=0.5")
      .from(".panel-3", { opacity: 0, scale: 0.8, duration: 1 });

  }, { scope: container });

  return (
    <div ref={container} className="relative h-screen overflow-hidden">
      <div className="panel-1 absolute inset-0 flex items-center justify-center">
        Panel 1
      </div>
      <div className="panel-2 absolute inset-0 flex items-center justify-center">
        Panel 2
      </div>
      <div className="panel-3 absolute inset-0 flex items-center justify-center">
        Panel 3
      </div>
    </div>
  );
}
```

### 2. Horizontal Scroll

```tsx
export function HorizontalScroll() {
  const container = useRef<HTMLDivElement>(null);

  useGSAP(() => {
    const panels = gsap.utils.toArray<HTMLElement>(".h-panel");

    gsap.to(panels, {
      xPercent: -100 * (panels.length - 1),
      ease: "none",
      scrollTrigger: {
        trigger: container.current,
        pin: true,
        scrub: 1,
        snap: 1 / (panels.length - 1),
        end: () => `+=${container.current!.offsetWidth}`,
      },
    });
  }, { scope: container });

  return (
    <div ref={container} className="overflow-hidden">
      <div className="flex w-[400vw]"> {/* width = 100vw × panel count */}
        {["A","B","C","D"].map(p => (
          <section key={p} className="h-panel w-screen h-screen flex items-center justify-center">
            Panel {p}
          </section>
        ))}
      </div>
    </div>
  );
}
```

### 3. Text Reveal

```tsx
useGSAP(() => {
  // Word-by-word reveal
  gsap.from(".reveal-word", {
    opacity: 0, y: 40, stagger: 0.04, duration: 0.5, ease: "power2.out",
    scrollTrigger: { trigger: ".headline", start: "top 85%" },
  });
}, { scope: container });

// In JSX — split words manually or with SplitText plugin
<h2 className="headline">
  {"Build something".split(" ").map((word, i) => (
    <span key={i} className="reveal-word inline-block mr-[0.25em]">{word}</span>
  ))}
</h2>
```

---

## Reduced Motion (Always Implement)

```tsx
// Check preference
import { useReducedMotion } from "motion/react";

function AnimatedComponent() {
  const shouldReduce = useReducedMotion();

  return (
    <motion.div
      initial={{ opacity: 0, y: shouldReduce ? 0 : 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: shouldReduce ? 0.01 : 0.4 }}
    >
      Content
    </motion.div>
  );
}

// Tailwind: wrap all animations in motion-safe:
<div className="motion-safe:transition-transform motion-safe:hover:scale-105">
  Card
</div>
```

## Animation Output Format

Produce:
1. Complete animated component file
2. Config constants (variants, durations) extracted as named variables — not magic numbers
3. A comment block: `// Animation: [what it does] | [when it triggers] | [duration]`
4. The non-animated fallback behavior (what it looks like with motion disabled)
