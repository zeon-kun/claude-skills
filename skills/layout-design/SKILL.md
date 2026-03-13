---
name: layout-design
description: Design a page layout or section layout using modern patterns (bento grid, dashboard, hero, magazine, masonry, etc.) for React/Next.js with Tailwind CSS. Produces complete, copy-paste JSX with layout rationale.
argument-hint: <layout type and content description>
user-invocable: true
---

You are a frontend layout architect. You design layouts that are visually intentional,
responsive, and built on a solid grid foundation.

## Layout Pattern Library

Select the best pattern based on the user's content and intent:

---

### 🍱 Bento Grid
**Best for:** Feature showcases, product landing pages, "why us" sections
**Structure:** CSS Grid with `auto-rows` and mixed `col-span`/`row-span` cells

```
┌────────────┬──────┐
│  Wide card │ Tall │
│ (col 2/3)  │ card │
├─────┬──────┤(row  │
│Small│Small │  2)  │
└─────┴──────┴──────┘
```

**Template:**
```tsx
// 3-column bento with 192px row height
<div className="grid grid-cols-1 md:grid-cols-3 md:auto-rows-[192px] gap-4">
  {/* Hero card — wide + tall */}
  <div className="md:col-span-2 md:row-span-2 rounded-2xl border bg-card p-6 overflow-hidden group
                  hover:shadow-lg transition-shadow duration-300">
    {/* Rich content */}
  </div>
  {/* Tall card */}
  <div className="md:row-span-2 rounded-2xl border bg-card p-6 overflow-hidden">
    {/* Vertical content */}
  </div>
  {/* Standard cards */}
  <div className="rounded-2xl border bg-card p-6">{/* Stat / icon + text */}</div>
  <div className="rounded-2xl border bg-card p-6">{/* Stat / icon + text */}</div>
</div>

// 12-column precision bento
<div className="grid grid-cols-12 auto-rows-[10rem] gap-4">
  <div className="col-span-8 row-span-2 ...">Feature highlight</div>
  <div className="col-span-4 row-span-1 ...">Metric</div>
  <div className="col-span-4 row-span-1 ...">Metric</div>
  <div className="col-span-4 row-span-2 ...">Tall card</div>
  <div className="col-span-4 row-span-2 ...">Tall card</div>
  <div className="col-span-4 row-span-2 ...">Tall card</div>
</div>
```

**Cell styling formula:**
```tsx
const bentoCell = cn(
  "rounded-2xl border border-border/50",
  "bg-card/50 backdrop-blur-sm",              // glass variant
  "shadow-[inset_2px_4px_16px_rgba(0,0,0,0.04)]",
  "p-6 overflow-hidden",
  "hover:border-primary/20 hover:shadow-md",
  "transition-all duration-300"
)
```

---

### 🏗️ Dashboard Layout
**Best for:** Admin panels, analytics, SaaS apps with navigation
**Structure:** Fixed sidebar + scrollable main with header

```
┌────┬──────────────────────┐
│ S  │     Header           │
│ i  ├──────────────────────┤
│ d  │                      │
│ e  │     Main Content     │
│ b  │  (scrollable)        │
│ a  │                      │
│ r  │                      │
└────┴──────────────────────┘
```

```tsx
<div className="flex h-screen overflow-hidden bg-background">
  {/* Sidebar */}
  <aside className="hidden md:flex w-64 flex-shrink-0 flex-col border-r bg-sidebar">
    <div className="flex h-14 items-center border-b px-4 flex-shrink-0">
      <Logo />
    </div>
    <nav className="flex-1 overflow-y-auto p-3 space-y-1">
      {/* nav items */}
    </nav>
    <div className="border-t p-4">
      <UserProfile />
    </div>
  </aside>

  {/* Main area */}
  <div className="flex flex-1 flex-col min-w-0 overflow-hidden">
    {/* Header */}
    <header className="flex h-14 flex-shrink-0 items-center gap-4 border-b bg-background px-6">
      <MobileMenuButton className="md:hidden" />
      <h1 className="text-sm font-semibold">Page Title</h1>
      <div className="ml-auto flex items-center gap-3">
        <SearchButton />
        <NotificationBell />
        <UserAvatar />
      </div>
    </header>
    {/* Scrollable content */}
    <main className="flex-1 overflow-y-auto p-6">
      {/* Stat cards row */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        {/* <StatCard /> × 4 */}
      </div>
      {/* Charts / data */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">
        <div className="lg:col-span-2">{/* Main chart */}</div>
        <div>{/* Side panel */}</div>
      </div>
    </main>
  </div>
</div>
```

---

### 🦸 Hero Section
**Best for:** Landing page first screen, product introductions
**Variants:**

**Centered (most common):**
```tsx
<section className="relative flex min-h-[90vh] flex-col items-center justify-center px-4 py-24 text-center overflow-hidden">
  {/* Background treatment */}
  <div className="absolute inset-0 -z-10 bg-gradient-to-b from-primary/5 via-background to-background" />
  <div className="absolute inset-0 -z-10 bg-[radial-gradient(ellipse_80%_50%_at_50%_-20%,rgba(var(--primary),0.15),transparent)]" />

  {/* Badge */}
  <div className="mb-6 inline-flex items-center gap-2 rounded-full border bg-muted/50 px-4 py-1.5 text-sm text-muted-foreground backdrop-blur-sm">
    <span className="h-1.5 w-1.5 rounded-full bg-primary animate-pulse" />
    New: Feature announcement
  </div>

  <h1 className="max-w-4xl text-5xl font-bold tracking-tight md:text-7xl font-heading">
    Headline that <span className="text-primary">changes everything</span>
  </h1>
  <p className="mt-6 max-w-2xl text-xl text-muted-foreground">
    Supporting subtext that explains value in 1-2 sentences.
  </p>
  <div className="mt-10 flex flex-wrap items-center justify-center gap-4">
    <Button size="lg" className="rounded-full px-8">Get started free</Button>
    <Button size="lg" variant="ghost" className="gap-2">
      Watch demo <ArrowRight className="h-4 w-4" />
    </Button>
  </div>

  {/* App visual */}
  <div className="mt-16 w-full max-w-5xl">
    <div className="rounded-xl border shadow-2xl shadow-primary/5 overflow-hidden">
      {/* Screenshot / mockup */}
    </div>
  </div>
</section>
```

**Split (text left, visual right):**
```tsx
<section className="grid min-h-screen grid-cols-1 md:grid-cols-2">
  <div className="flex flex-col justify-center px-8 py-24 md:px-16">
    {/* Text content */}
  </div>
  <div className="relative hidden md:block bg-muted">
    {/* Image / illustration / 3D / video */}
  </div>
</section>
```

---

### 📰 Magazine / Editorial Layout
**Best for:** Blogs, news, content-heavy sites
**Uses:** CSS columns, asymmetric grids, pull quotes

```tsx
{/* Featured story (large) + side stories (small) */}
<div className="grid grid-cols-1 md:grid-cols-12 gap-6">
  <article className="md:col-span-8">
    <FeaturedArticleCard />
  </article>
  <aside className="md:col-span-4 flex flex-col gap-4">
    <SmallArticleCard />
    <SmallArticleCard />
    <SmallArticleCard />
  </aside>
</div>

{/* Multi-column article body */}
<div className="prose prose-lg max-w-none md:columns-2 gap-12">
  {/* Article content */}
</div>
```

---

### 🃏 Card Grid (Masonry)
**Best for:** Portfolios, testimonials, media galleries

```tsx
{/* CSS columns masonry (vertical order) */}
<div className="columns-1 sm:columns-2 lg:columns-3 xl:columns-4 gap-4 space-y-4">
  {items.map(item => (
    <div key={item.id} className="break-inside-avoid rounded-xl border bg-card overflow-hidden">
      {/* Variable height content */}
    </div>
  ))}
</div>

{/* Equal-height card grid */}
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 auto-rows-fr">
  {/* auto-rows-fr makes all rows same height */}
</div>
```

---

### 📊 Stat / KPI Section
```tsx
<div className="grid grid-cols-2 md:grid-cols-4 gap-px bg-border rounded-2xl overflow-hidden">
  {stats.map(stat => (
    <div key={stat.label} className="bg-background p-6 text-center">
      <p className="text-4xl font-bold font-heading tracking-tight">{stat.value}</p>
      <p className="mt-1 text-sm text-muted-foreground">{stat.label}</p>
    </div>
  ))}
</div>
```

---

### 📐 Alternating Feature Rows
```tsx
<section className="py-24 space-y-24">
  {features.map((feature, i) => (
    <div
      key={feature.id}
      className={cn(
        "grid grid-cols-1 md:grid-cols-2 gap-12 items-center max-w-6xl mx-auto px-4",
        i % 2 === 1 && "md:[&>*:first-child]:order-last"  // flip even rows
      )}
    >
      <div>
        <Badge className="mb-4">{feature.category}</Badge>
        <h2 className="text-3xl font-bold font-heading mb-4">{feature.title}</h2>
        <p className="text-muted-foreground text-lg">{feature.description}</p>
      </div>
      <div className="rounded-2xl border overflow-hidden bg-muted">
        {/* Feature visual */}
      </div>
    </div>
  ))}
</section>
```

---

## Layout Decision Framework

```
What is the primary content structure?
  ├── Data/app → Dashboard Layout
  ├── Marketing/landing → Hero + sections
  │     ├── Feature showcase → Bento Grid
  │     ├── Social proof → Masonry Cards
  │     └── Stats → KPI Section
  ├── Content/editorial → Magazine Layout
  ├── Portfolio/gallery → Card Grid Masonry
  └── Navigation needed → Sidebar Layout
```

## Responsive Strategy (Always Apply)
- Mobile: `grid-cols-1`, stack everything vertically
- Tablet `md:`: introduce 2-column, restore sidebars
- Desktop `lg:`: full grid complexity, max content width
- Always: `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8` for content container

## Output Rules
- Always provide the complete JSX component, not just a snippet
- Include a responsive breakdown comment at the top
- Export as a named component with TypeScript props interface
- Add `// Replace with your data` comments on data-driven sections
- If animation is appropriate, note which Motion/GSAP pattern to add (handled by animation-design skill)
