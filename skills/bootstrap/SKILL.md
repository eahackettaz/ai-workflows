---
name: bootstrap
description: Bootstraps a project's constraint docs — a project-local CLAUDE.md, ADRs for load-bearing decisions, and (only when there's real domain language) a CONTEXT.md — through a grill-driven interview, so the generic skills can adapt to this repo. Works on both new/empty projects and existing codebases (analyzes the code first, then fills the gaps). Use when a repo has no CLAUDE.md yet, or when the user wants to set up, bootstrap, or establish project conventions, constraints, or domain docs.
---

# Bootstrap

Establish the per-project constraint docs the generic skills adapt to: a
project-local `CLAUDE.md`, ADRs for load-bearing decisions, and — only when the
project has real domain language — a `CONTEXT.md`. The generic skills (`tdd`,
`diagnose`, `prime`, `grill-with-docs`, `improve-codebase-architecture`) stay
stack-agnostic; this skill is what makes them fit a specific repo.

Complements the built-in `/init` (which only summarizes existing code into
CLAUDE.md): this skill is interview-driven, writes ADRs and CONTEXT.md too, and
handles greenfield.

## 1. Detect repo state

Before asking anything:

- Is there meaningful code, or is this greenfield (empty / scaffold only)?
- Do `CLAUDE.md`, `CONTEXT.md`, `CONTEXT-MAP.md`, or `docs/adr/` already exist?
- Is there a `README` worth reading for intent?

This branches the approach — and tells you what NOT to ask.

## 2. Brownfield — analyze first

If meaningful code exists, scan before interviewing so you never ask what the code
already answers. Use the Agent tool with `subagent_type=Explore` for breadth.
Draft observed facts:

- Languages, frameworks, and the **test framework** in use (feeds `tdd`).
- Build / test / lint / run commands (from `package.json`, `Makefile`,
  `pyproject.toml`, `Cargo.toml`, CI config).
- Conventions actually in use (formatting, structure, naming).
- Anything that looks like a deliberate, surprising decision → candidate ADR.

Reconcile with any existing docs. **Never clobber** — if `CLAUDE.md` exists, merge
into it and confirm changes; don't overwrite.

## 3. Interview for the rest

Grill one question at a time, each with your recommended answer — same discipline
as `/grill-with-docs`. Cover only the gaps analysis left open:

- **Stack & tooling** per relevant domain: languages, test frameworks, build
  system. (This is what `tdd/LANGUAGES.md` defers to.)
- **Conventions** specific to this repo that differ from the user's global defaults.
- **Domain language** — enough to decide whether a `CONTEXT.md` is warranted.
- **Load-bearing decisions** — architectural shape, tech lock-in, boundaries.
- **Constraints invisible in code** — target platforms, compliance, performance
  budgets, partner contracts.

If a question can be answered by reading the code, read it instead of asking.

## 4. Write — lazily, incrementally

Capture decisions as they crystallize, not in a batch at the end.

- **`./CLAUDE.md`** (project root) — stack, commands, conventions, constraints. This
  is the project-local memory Claude auto-loads. Keep it distinct from the user's
  global `~/.claude/CLAUDE.md`: global = universal prefs, project = this repo's
  specifics.
- **`docs/adr/000N-slug.md`** — one per load-bearing decision. Offer an ADR only
  when it's hard to reverse, surprising without context, and the result of a real
  trade-off. Format: [ADR-FORMAT.md](../grill-with-docs/ADR-FORMAT.md).
- **`CONTEXT.md`** — only if the project has real domain language worth pinning down
  (skip it for simple/CRUD/utility apps where the README suffices). Format:
  [CONTEXT-FORMAT.md](../grill-with-docs/CONTEXT-FORMAT.md).

Create each file only when you have something real to put in it.

## 5. Hand off

Summarize what you wrote and suggest the next step — usually `/prime` to confirm
the fresh orientation, or the work skill that fits the first task (`/tdd`,
`/grill-with-docs`, `/improve-codebase-architecture`).
