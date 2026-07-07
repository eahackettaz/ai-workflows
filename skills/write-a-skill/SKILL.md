---
name: write-a-skill
description: Create new agent skills with proper frontmatter, progressive disclosure, and bundled resources. Use when the user wants to create, write, author, or restructure a Claude Code skill.
---

# Writing Skills

A skill is a folder containing a `SKILL.md`. Claude reads every skill's
`description` up front, then loads the full `SKILL.md` (and any files it links)
only when the skill fires. Design for that: a sharp trigger, a lean body, and
depth pushed into linked files.

## Process

1. **Gather requirements** — ask the user:
   - What task/domain does the skill cover, and what should trigger it?
   - Auto-invoked by Claude, or manual `/name` only?
   - Executable scripts, or instructions only?
   - Reference material to bundle?
2. **Draft** — SKILL.md (lean), plus reference files / scripts only if needed.
3. **Review with user** — does it cover the cases; anything missing; is the
   altitude of detail right?

## Structure

```
skill-name/
├── SKILL.md           # required — overview + navigation
├── REFERENCE.md       # optional — detail, loaded on demand
├── EXAMPLES.md        # optional — usage examples
└── scripts/           # optional — executed, not read into context
    └── helper.js
```

## Frontmatter

```yaml
---
name: skill-name              # lowercase, hyphens, ≤64 chars; matches the folder
description: What it does. Use when <specific triggers>.   # see below
# --- everything below is optional ---
disable-model-invocation: true   # never auto-fires; only runs via /skill-name
user-invocable: false            # hide from the / menu
argument-hint: "[issue-number]"  # autocomplete hint when the skill takes an arg
allowed-tools: Read, Grep, Bash  # granted without prompting while active
model: sonnet                    # model override for this skill
---
```

In practice only `name` + `description` are needed. Reach for the rest
deliberately:

- **`disable-model-invocation: true`** — for anything that must NOT fire on its
  own: destructive actions, session-management (`/handoff`), or persona/mode
  skills you only want on command. Caveat: this also removes the description
  from context, so Claude won't know the skill exists until you type `/name`.
- **`argument-hint`** — when the skill takes an argument.
- **`allowed-tools` / `model`** — when the skill has a fixed tool or model need.

## Description — the only thing that drives triggering

It is the sole text Claude sees when deciding whether to load the skill. Make it
earn the trigger.

- Third person. First sentence: what it does. Second: `Use when <concrete
  triggers>` — keywords, contexts, file types, phrases the user actually says.
- A few sentences max. Hard cap: the combined `description` (plus optional
  `when_to_use`) is truncated at **1,536 characters** in the skill listing, cut
  from the end — so put the key trigger first and stay well under it.
- No time-sensitive info.

**Good**: `Extract text and tables from PDFs, fill forms, merge documents. Use
when working with PDF files or when the user mentions PDFs, forms, or document
extraction.`

**Bad**: `Helps with documents.` — nothing distinguishes it from other document
skills; it won't fire reliably.

## Progressive disclosure

- Keep SKILL.md lean. The official ceiling is ~500 lines, but aim far lower
  (~100–200). Short bodies load fully and stay reliable.
- Split into a reference file when SKILL.md grows long, content splits into
  distinct domains, or advanced material is rarely needed.
- Link reference files with plain markdown so Claude knows what each contains and
  when to fetch it. Keep references one level deep.
- Bundle deterministic operations (validation, formatting) as **scripts** rather
  than prose — cheaper and more reliable than regenerating code. Reference
  bundled paths with the `${CLAUDE_SKILL_DIR}` variable — it resolves to the
  skill's own directory regardless of the working directory — rather than
  hardcoding a path.

## Where skills live

- **Personal** `~/.claude/skills/` — available in every project. Put
  stack-agnostic, cross-project skills here.
- **Project** `.claude/skills/` — checked into the repo, shared with the team,
  scoped to that codebase. Put project-specific procedure here.
- Personal overrides project on a name collision.

## Measure that it triggers

A skill that never fires is worse than no skill. For anything where reliable
triggering matters, don't just eyeball the description — **test it**: run realistic
prompts (and near-misses) in fresh sessions and confirm it fires when it should and
stays quiet when it shouldn't. Full method in [EVALS.md](EVALS.md).

## Review checklist

- [ ] `description` is third person and ends with concrete `Use when …` triggers
- [ ] Auto-invoke vs `/name`-only decided (set `disable-model-invocation` if manual)
- [ ] SKILL.md lean; depth pushed into linked reference files (one level deep)
- [ ] Bundled scripts referenced relative to the skill dir, not hardcoded paths
- [ ] No time-sensitive info; consistent terminology; concrete examples
- [ ] Correct home chosen: personal (cross-project) vs project (repo-specific)
- [ ] Triggering verified for trigger-sensitive skills (fires on real prompts, quiet on near-misses) — see [EVALS.md](EVALS.md)
