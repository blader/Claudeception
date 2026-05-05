# Search & Versioning Reference

← Back to `../SKILL.md`

## Step 1: Check for Existing Skills

Before creating a new skill, search all skill directories:

```sh
SKILL_DIRS=(
  ".claude/skills"
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
)

# List all skills
rg --files -g 'SKILL.md' "${SKILL_DIRS[@]}" 2>/dev/null

# Search by keywords
rg -i "keyword1|keyword2" "${SKILL_DIRS[@]}" 2>/dev/null

# Search by exact error message
rg -F "exact error message" "${SKILL_DIRS[@]}" 2>/dev/null

# Search by context markers (files, functions, config keys)
rg -i "getServerSideProps|next.config.js|prisma.schema" "${SKILL_DIRS[@]}" 2>/dev/null
```

## Found vs. Action Matrix

| Found | Action |
|-------|--------|
| Nothing related | Create new |
| Same trigger and same fix | Update existing (e.g., `version: 1.0.0` → `1.1.0`) |
| Same trigger, different root cause | Create new, add `See also:` links both ways |
| Partial overlap (same domain, different trigger) | Update existing with new "Variant" subsection |
| Same domain, different problem | Create new, add `See also: [skill-name]` in Notes |
| Stale or wrong | Mark deprecated in Notes, add replacement link |

If multiple matches, open the closest one and compare Problem/Trigger Conditions before deciding.

## Versioning Scheme

- **patch** (`1.0.0` → `1.0.1`): typos, wording fixes
- **minor** (`1.0.0` → `1.1.0`): new scenario, added variant
- **major** (`1.0.0` → `2.0.0`): breaking changes, deprecation, complete rewrite
