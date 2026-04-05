# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Claudeception is a **Claude Code skill** for continuous learning—it enables Claude Code to autonomously extract and preserve learned knowledge into reusable skills. It also captures emerging patterns as tentative YAML notes with confidence scoring, promoting them to full skills after repeated observations. It is not an application codebase but rather a skill definition with documentation and examples.

## Key Files

- `SKILL.md` — The main skill definition (YAML frontmatter + instructions). This is what Claude Code loads.
- `resources/skill-template.md` — Template for creating new skills
- `resources/instinct-template.yaml` — YAML template for tentative knowledge notes
- `resources/tentative-knowledge.md` — Detailed rules for confidence scoring, promotion, and expiry
- `examples/` — Sample extracted skills demonstrating proper format

## Skill File Format

Skills use YAML frontmatter followed by markdown:

```yaml
---
name: kebab-case-name
description: |
  Must be precise for semantic matching. Include:
  (1) exact use cases, (2) trigger conditions like error messages,
  (3) what problem this solves
author: Claude Code
version: 1.0.0
allowed-tools:
  - Read
  - Write
  - Bash
  - Grep
  - Glob
---
```

The description field is critical—it determines when the skill surfaces during semantic matching.

## Installation Paths

- **User-level**: `~/.claude/skills/[skill-name]/`
- **Project-level**: `.claude/skills/[skill-name]/`

## Quality Criteria for Skills

When modifying or creating skills, ensure:
- **Reusable**: Helps with future tasks, not just one instance
- **Non-trivial**: Requires discovery, not just documentation lookup
- **Specific**: Clear trigger conditions (exact error messages, symptoms)
- **Verified**: Solution has actually been tested and works

## Research Foundation

The approach is based on academic work on skill libraries (Voyager, CASCADE, SEAgent, Reflexion). See `resources/research-references.md` for details.
