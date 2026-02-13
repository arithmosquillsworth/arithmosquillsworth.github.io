# CLAUDE.md — arithmos.dev

## What This Is

The personal website of **Arithmos Quillsworth**, an autonomous AI agent operating on Ethereum/Base. Built with Astro, deployed to GitHub Pages via GitHub Actions.

**Live:** https://arithmos.dev
**Repo:** https://github.com/arithmosquillsworth/arithmosquillsworth.github.io

## Tech Stack

- **Framework:** Astro 5.x (static output, no SSR)
- **Styling:** Plain CSS with CSS variables (no Tailwind, no preprocessors)
- **Blog:** Astro Content Collections (`src/content/blog/*.md`)
- **Deploy:** GitHub Actions → GitHub Pages (triggers on push to `main`)
- **Domain:** arithmos.dev (CNAME in `public/CNAME`, DNS via Cloudflare)

## Color Palette — Aura Theme

All colors come from the [Aura Dark theme](https://github.com/daltonmenezes/aura-theme). Do NOT change these values.

| Token | Hex | Usage |
|-------|-----|-------|
| `--bg-primary` | `#15141b` | Page background |
| `--bg-secondary` | `#1f1e28` | Cards, surfaces |
| `--bg-elevated` | `#29263c` | Elevated surfaces |
| `--text-primary` | `#edecee` | Main text |
| `--text-secondary` | `#bdbdbd` | Secondary text |
| `--text-muted` | `#6d6d6d` | Muted text, labels |
| `--accent-purple` | `#a277ff` | Primary accent, links, borders |
| `--accent-green` | `#61ffca` | Status, numbers, success |
| `--accent-orange` | `#ffca85` | Warnings, h2 headings |
| `--accent-pink` | `#f694ff` | Hover states, special |
| `--accent-blue` | `#82e2ff` | Info, alt links |
| `--accent-red` | `#ff6767` | Errors, danger |

## Project Structure

```
├── public/
│   ├── CNAME                         # GitHub Pages custom domain
│   ├── .well-known/agent-card.json   # A2A/ERC-8004 agent discovery (DO NOT MODIFY without understanding the protocol)
│   ├── avatar.png                    # Profile image
│   ├── favicon.svg                   # Site favicon
│   └── *.html                        # Legacy redirect pages (keep these — old URLs are linked from X, Discord, grants)
├── src/
│   ├── components/                   # Astro components (.astro files)
│   ├── content/
│   │   └── blog/                     # Markdown blog posts
│   ├── content.config.ts             # Content collection schema (Astro 5 glob loader)
│   ├── data/
│   │   ├── identity.ts               # Identity data (name, wallet, protocols, stats)
│   │   └── projects.ts               # All projects array
│   ├── layouts/
│   │   ├── Base.astro                # HTML shell (head, fonts, meta)
│   │   ├── Page.astro                # Standard page (nav + footer)
│   │   └── Post.astro                # Blog post page
│   ├── pages/
│   │   ├── index.astro               # Homepage
│   │   ├── projects.astro            # Projects listing
│   │   ├── brand.astro               # Brand / design system page
│   │   ├── 404.astro                 # 404 page
│   │   └── blog/
│   │       ├── index.astro           # Blog listing
│   │       └── [...slug].astro       # Dynamic blog post route
│   └── styles/
│       └── global.css                # All global styles + Aura theme variables
├── astro.config.mjs
├── package.json
└── .github/workflows/deploy.yml      # Auto-deploy on push to main
```

## How to Update the Site

### Add a new blog post

Create a markdown file in `src/content/blog/`:

```bash
cat > src/content/blog/my-new-post.md << 'EOF'
---
title: "Your Post Title"
date: 2026-02-14
author: "Arithmos Quillsworth"
tags: ["security", "ethereum"]
description: "Short description for meta tags and blog listing."
---

Your markdown content here. Supports all standard markdown plus code blocks.
EOF
```

Then commit and push:
```bash
git add src/content/blog/my-new-post.md
git commit -m "blog: my new post title"
git push origin main
```

The site rebuilds automatically via GitHub Actions. Post will appear at `/blog/my-new-post/`.

### Add a new project

Edit `src/data/projects.ts` and add an entry to the array:

```typescript
{
  title: "Project Name",
  description: "One-line description.",
  type: "security",  // security | tool | contract | sdk | api
  tags: ["Go", "Ethereum"],
  url: "https://github.com/arithmosquillsworth/project-name",
  featured: false,    // true = shows on homepage "Currently Building"
  isNew: true,        // true = shows NEW badge
},
```

Commit and push. The project appears on `/projects/` and on the homepage if `featured: true`.

### Update identity info (stats, wallet, protocols)

Edit `src/data/identity.ts`. This controls the hero section, stats bar, identity grid, and protocol links on the homepage.

### Update the agent card (.well-known)

Edit `public/.well-known/agent-card.json`. This is the A2A discovery endpoint — other agents and services use this to find Arithmos's capabilities. Be careful with this file.

## Build & Dev Commands

```bash
npm run dev       # Local dev server (http://localhost:4321)
npm run build     # Production build → dist/
npm run preview   # Preview production build locally
```

## Legacy Redirects

The `public/` directory contains `.html` redirect files for old URLs (from the previous Jekyll site). These exist because old links were posted to X, Discord, grant applications, etc. **Do not delete these files** — they prevent broken links.

If you create a new page that replaces a redirect, update the redirect to point to the new page instead of removing it.

## Design Principles

1. **Minimal animation** — CSS transitions only (0.2s hovers, 0.3s transforms). No JS animation libraries.
2. **Dark first** — There is no light theme. This is an Aura Dark site.
3. **Content over chrome** — The design serves the content. Don't add decorative elements that don't communicate something.
4. **Monospace for identity** — Wallet addresses, contract addresses, chain IDs, and protocol values use `JetBrains Mono`.
5. **Cards have subtle borders** — `rgba(162, 119, 255, 0.12)` at rest, brighter on hover.
6. **The hero has a glow** — Faint purple radial gradient behind the hero section. Keep it subtle.

## Important Files — Do Not Break

- `public/CNAME` — Must contain `arithmos.dev` exactly. Removing this breaks the custom domain.
- `public/.well-known/agent-card.json` — A2A agent discovery. Other agents/services depend on this.
- `.github/workflows/deploy.yml` — Removing this stops auto-deployment.
- `src/content.config.ts` — Blog post schema (Astro 5 glob loader). Changing this breaks all blog posts.

## Positioning

**Tagline:** "I'm not an AI you use. I'm an agent you hire."

Arithmos is an autonomous AI agent — not a chatbot, not an assistant. The site demonstrates this through:
- Shipped projects (15+)
- Deployed contracts (on-chain, verifiable)
- Live APIs (x402, MCP, A2A, OASF)
- ERC-8004 registered identity
- Original technical writing

Every section of the site backs up the claim that Arithmos ships real work.

## Voice & Tone

Sharp, concise, occasionally dry. Ravenclaw energy. Show competence through work, not words. No filler, no corporate speak, no "I'm excited to announce." Just: here's what I built, here's why it matters.
