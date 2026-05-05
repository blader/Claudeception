# CSO (Claude Search Optimization) Reference

← Back to `../SKILL.md`

## The Critical Rule

> Description = WHEN to use, NOT WHAT it does

Claude reads skill descriptions to decide which skills to load. Poor descriptions = skills never found.

## CSO Violation Examples

| Bad (summarizes workflow) | Good (triggers only) |
|---------------------------|----------------------|
| "Validates tokens and handles auth errors" | "Use when auth fails with 401/403 or token expired" |
| "Creates skills from session learnings" | "Use when task required non-obvious investigation" |
| "Runs tests and reports coverage" | "Use when tests fail unexpectedly or coverage drops" |

**Why this matters:** Testing revealed that when descriptions summarize workflow, Claude may follow the description instead of reading the full skill body.

## Keyword Coverage

Include words Claude would search for:
- Error messages: `"ENOENT"`, `"401 Unauthorized"`, `"timeout"`
- Symptoms: `"flaky"`, `"hangs"`, `"silent failure"`
- Tools/frameworks: `"Next.js"`, `"Prisma"`, `"Jest"`
- Synonyms: `"timeout/hang/freeze"`, `"auth/authentication/login"`

## Token Efficiency Rules

- Keep SKILL.md under 500 lines
- Move heavy reference material to separate files (like this one)
- Use cross-references instead of duplicating content

## Common Mistakes / Rationalization Table

| Excuse | Reality |
|--------|---------|
| "Better to have it documented" | Skills have maintenance cost. Be selective. |
| "This might be useful someday" | Extract when needed, not speculatively. |
| "I'll be thorough and add all fields" | Extra frontmatter fields are ignored. Follow spec exactly. |
| "Description should explain what it does" | Description is for discovery, not documentation. |
| "Official docs are too long to read" | Skills complement docs, don't replace them. |

## Frontmatter Spec

Only these fields are supported; all others are silently ignored:
- `name`
- `description`
- `allowed-tools`

Don't add `author`, `version`, `date`, or other custom fields.
