# Placement Decision Reference

← Back to `../SKILL.md`

## Full 4-Destination Decision Tree

**Core principle:** Route each learning to the cheapest destination that preserves it.

**1. Is this a fact about the user, their feedback, project context, or external references?**
- **Yes** → Auto memory. See `~/.claude/CLAUDE.md` auto memory section for the four types (user / feedback / project / reference) and file format.
- **No** → Continue.

Examples of "yes" (use auto memory):
- "User prefers one bundled PR over many small ones for refactors" → **feedback**
- "User is a staff engineer focused on developer tooling" → **user**
- "Auth middleware rewrite is driven by legal/compliance, not tech-debt" → **project**
- "Pipeline bugs tracked in Linear project INGEST" → **reference**

Examples of "no" (not memory):
- "NewRelic requires camelCase for header exclusions" — technical gotcha, not a fact about the user/project → skill
- "Always use Logger not console.log in this repo" — derivable from code → skip or CLAUDE.md

**2. Would I figure this out eventually from docs or code?**
- **Yes** → CLAUDE.md instruction (reminder is enough) or skip.
- **No** → Continue to skill evaluation.

Examples of "yes" (use CLAUDE.md):
- Async API polling pattern (standard HTTP pattern)
- Don't test autouse fixtures explicitly (testing principle)

Examples of "no" (needs skill):
- NewRelic requires camelCase for header exclusions (non-obvious tool quirk)
- PyTorch 2.6 breaks WhisperX pickle loading (version-specific gotcha)
- Godot @onready runs before _ready() body (framework timing subtlety)

**3. Is this a simple instruction (1-3 lines)?**
- **Yes** → CLAUDE.md (global or project).
- **No** → Skill needed.

**4. Is this for your typical stack?**
- **Yes** (NestJS, TS, Python, Docker, GitLab) → Global skill (`~/.claude/skills/`).
- **No** (Godot, unusual framework) → Local skill (`.claude/skills/`).

## Placement Matrix

| Knowledge Type | Placement | Example |
|----------------|-----------|---------|
| Fact about the user | Auto memory (`user`) | "Deep Go expertise, new to React" |
| Workflow preference / correction | Auto memory (`feedback`) | "Prefers bundled PRs over split refactors" |
| Project goal, deadline, driver | Auto memory (`project`) | "Merge freeze 2026-03-05 for mobile release" |
| Where external info lives | Auto memory (`reference`) | "Pipeline bugs in Linear project INGEST" |
| Standard pattern reminder | Global CLAUDE.md | "Check for async API patterns" |
| Testing/coding principle | Global CLAUDE.md | "Don't test autouse fixtures" |
| Project-specific coding preference | Project CLAUDE.md | "Use Logger not console.log" |
| Non-obvious gotcha (typical stack) | Global skill | NewRelic camelCase |
| Non-obvious gotcha (unusual stack) | Local skill | Godot @onready timing |
| Version-specific fix | Global skill | PyTorch/WhisperX compatibility |

## Destination Comparison

| Aspect | Auto memory | CLAUDE.md | Skills |
|--------|-------------|-----------|--------|
| Context cost | Index always loaded; bodies on match | Always loaded | Loaded on semantic match |
| Best content | Who/why/where facts | Rules and reminders | Techniques, gotchas |
| Length | 3-10 lines per file | 1-3 lines | Full documentation |
| Decay | Facts go stale — verify on recall | Stable | Stable until tool changes |

## What NOT to Save as Memory

Auto memory is for facts that aren't derivable from the current project state. Don't save:
- Code patterns, conventions, file paths — readable from the repo.
- Git history or recent changes — `git log` is authoritative.
- Debugging fix recipes — those belong in a skill.
- Ephemeral task state — that's for plans/tasks, not memory.

If the user asks to "save this" and it's technical, route it to a skill or CLAUDE.md. If it's about who/why/where, route it to memory.

## CLAUDE.md vs Skill Tradeoff

Use CLAUDE.md when the reminder is short enough to fit in 1-3 lines and the knowledge is stable. Use a skill when the full solution requires steps, examples, or a decision tree that would bloat CLAUDE.md.

A session debrief commonly produces a mix: one skill, one CLAUDE.md line, two memory entries. Memory entries are cheap — don't skip a small feedback/project fact just because it isn't a full skill.
