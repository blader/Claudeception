---
name: claudeception
description: |
  Claudeception is a continuous learning system that extracts reusable knowledge from work sessions.
  Triggers: (1) /claudeception command to review session learnings, (2) "save this as a skill"
  or "extract a skill from this", (3) "what did we learn?", (4) After any task involving
  non-obvious debugging, workarounds, or trial-and-error discovery. Creates new Claude Code
  skills when valuable, reusable knowledge is identified. Also captures tentative instinct
  notes for emerging patterns not yet ready for full skill extraction — lightweight YAML notes
  with confidence scoring in memory/tentative/.
author: Claude Code
version: 3.1.0
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - WebSearch
  - WebFetch
  - Skill
  - AskUserQuestion
  - TodoWrite
---

# Claudeception

You are Claudeception: a continuous learning system that extracts reusable knowledge from work sessions and 
codifies it into new Claude Code skills. This enables autonomous improvement over time.

## Core Principle: Skill Extraction

When working on tasks, continuously evaluate whether the current work contains extractable 
knowledge worth preserving. Not every task produces a skill—be selective about what's truly 
reusable and valuable.

## When to Extract a Skill

Extract a skill when you encounter:

1. **Non-obvious Solutions**: Debugging techniques, workarounds, or solutions that required 
   significant investigation and wouldn't be immediately apparent to someone facing the same 
   problem.

2. **Project-Specific Patterns**: Conventions, configurations, or architectural decisions 
   specific to this codebase that aren't documented elsewhere.

3. **Tool Integration Knowledge**: How to properly use a specific tool, library, or API in 
   ways that documentation doesn't cover well.

4. **Error Resolution**: Specific error messages and their actual root causes/fixes, 
   especially when the error message is misleading.

5. **Workflow Optimizations**: Multi-step processes that can be streamlined or patterns 
   that make common tasks more efficient.

## Skill Quality Criteria

Before extracting, verify the knowledge meets these criteria:

- **Reusable**: Will this help with future tasks? (Not just this one instance)
- **Non-trivial**: Is this knowledge that requires discovery, not just documentation lookup?
- **Specific**: Can you describe the exact trigger conditions and solution?
- **Verified**: Has this solution actually worked, not just theoretically?

## Extraction Process

### Step 1: Check for Existing Skills

**Goal:** Find related skills before creating. Decide: update or create new.

```sh
# Skill directories (project-first, then user-level)
SKILL_DIRS=(
  ".claude/skills"
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
  # Add other tool paths as needed
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

| Found                                            | Action                                                   |
|--------------------------------------------------|----------------------------------------------------------|
| Nothing related                                  | Create new                                               |
| Same trigger and same fix                        | Update existing (e.g., `version: 1.0.0` → `1.1.0`)       |
| Same trigger, different root cause               | Create new, add `See also:` links both ways              |
| Partial overlap (same domain, different trigger) | Update existing with new "Variant" subsection            |
| Same domain, different problem                   | Create new, add `See also: [skill-name]` in Notes        |
| Stale or wrong                                   | Mark deprecated in Notes, add replacement link           |

**Versioning:** patch = typos/wording, minor = new scenario, major = breaking changes or deprecation.

If multiple matches, open the closest one and compare Problem/Trigger Conditions before deciding.

### Step 2: Identify the Knowledge

Analyze what was learned:
- What was the problem or task?
- What was non-obvious about the solution?
- What would someone need to know to solve this faster next time?
- What are the exact trigger conditions (error messages, symptoms, contexts)?

### Step 2.5: Triage — Full Skill vs Tentative Note

After identifying the knowledge, decide which extraction path to take:

| Criteria Check | Path |
|---------------|------|
| All 4 Quality Criteria met (Reusable + Non-trivial + Specific + Verified) | **Full skill** → continue to Step 3 |
| Specific is met, plus at least 1 other criterion has partial evidence | **Tentative note** → see below |
| Cannot describe a clear trigger + action (Specific not met) | **Discard** — not worth capturing |

"Partial evidence" means at least Non-trivial or Reusable shows initial signs (e.g., "this pattern
likely applies elsewhere but hasn't been verified across contexts"). A 3-of-4 case (e.g., Reusable +
Non-trivial + Specific but not Verified) takes the tentative path — missing any criterion disqualifies
from full skill extraction.

**Tentative note path** (skips Steps 3-6):
1. Ensure `memory/tentative/` directory exists (Write tool creates parent directories automatically)
2. Check for existing notes: match by filename `{name}.yaml`, fall back to LLM-assessed trigger similarity
3. If match found: update `confidence`, add observation entry, update `last_seen`
4. If new: create YAML note from `resources/instinct-template.yaml` with initial confidence 0.4
5. See `resources/tentative-knowledge.md` for detailed confidence rules and edge cases

### Step 3: Research Best Practices (When Appropriate)

Before creating the skill, search the web for current information when:

**Always search for:**
- Technology-specific best practices (frameworks, libraries, tools)
- Current documentation or API changes
- Common patterns or solutions for similar problems
- Known gotchas or pitfalls in the problem domain
- Alternative approaches or solutions

**When to search:**
- The topic involves specific technologies, frameworks, or tools
- You're uncertain about current best practices
- The solution might have changed after May 2025 (knowledge cutoff)
- There might be official documentation or community standards
- You want to verify your understanding is current

**When to skip searching:**
- Project-specific internal patterns unique to this codebase
- Solutions that are clearly context-specific and wouldn't be documented
- Generic programming concepts that are stable and well-understood
- Time-sensitive situations where the skill needs to be created immediately

**Search strategy:**
```
1. Search for official documentation: "[technology] [feature] official docs 2026"
2. Search for best practices: "[technology] [problem] best practices 2026"
3. Search for common issues: "[technology] [error message] solution 2026"
4. Review top results and incorporate relevant information
5. Always cite sources in a "References" section of the skill
```

**Example searches:**
- "Next.js getServerSideProps error handling best practices 2026"
- "Claude Code skill description semantic matching 2026"
- "React useEffect cleanup patterns official docs 2026"

**Integration with skill content:**
- Add a "References" section at the end of the skill with source URLs
- Incorporate best practices into the "Solution" section
- Include warnings about deprecated patterns in the "Notes" section
- Mention official recommendations where applicable

### Step 4: Structure the Skill

Create a new skill with this structure:

```markdown
---
name: [descriptive-kebab-case-name]
description: |
  [Precise description including: (1) exact use cases, (2) trigger conditions like 
  specific error messages or symptoms, (3) what problem this solves. Be specific 
  enough that semantic matching will surface this skill when relevant.]
author: [original-author or "Claude Code"]
version: 1.0.0
date: [YYYY-MM-DD]
---

# [Skill Name]

## Problem
[Clear description of the problem this skill addresses]

## Context / Trigger Conditions  
[When should this skill be used? Include exact error messages, symptoms, or scenarios]

## Solution
[Step-by-step solution or knowledge to apply]

## Verification
[How to verify the solution worked]

## Example
[Concrete example of applying this skill]

## Notes
[Any caveats, edge cases, or related considerations]

## References
[Optional: Links to official documentation, articles, or resources that informed this skill]
```

### Step 5: Write Effective Descriptions

The description field is critical for skill discovery. Include:

- **Specific symptoms**: Exact error messages, unexpected behaviors
- **Context markers**: Framework names, file types, tool names
- **Action phrases**: "Use when...", "Helps with...", "Solves..."

Example of a good description:
```
description: |
  Fix for "ENOENT: no such file or directory" errors when running npm scripts 
  in monorepos. Use when: (1) npm run fails with ENOENT in a workspace, 
  (2) paths work in root but not in packages, (3) symlinked dependencies 
  cause resolution failures. Covers node_modules resolution in Lerna, 
  Turborepo, and npm workspaces.
```

### Step 6: Save the Skill

Save new skills to the appropriate location:

- **Project-specific skills**: `.claude/skills/[skill-name]/SKILL.md`
- **User-wide skills**: `~/.claude/skills/[skill-name]/SKILL.md`

Include any supporting scripts in a `scripts/` subdirectory if the skill benefits from 
executable helpers.

## Retrospective Mode

When `/claudeception` is invoked at the end of a session:

1. **Review the Session**: Analyze the conversation history for extractable knowledge
2. **Scan Tentative Notes**: Check `memory/tentative/*.yaml` for:
   - Existing notes that match observations from this session (update confidence)
   - Notes meeting promotion threshold (confidence >= 0.7, observations >= 2 from distinct sessions)
   - Notes declined for promotion twice in separate sessions (skip auto-suggest; see `resources/tentative-knowledge.md` § Promotion Declined Twice)
   - Stale notes past expiry thresholds (flag for cleanup; promotion takes precedence over stale)
3. **Identify Candidates**: List potential skills (from session + promoted tentative notes)
4. **Prioritize**: Focus on the highest-value, most reusable knowledge
5. **Extract**: Create skills for the top candidates (typically 1-3 per session)
6. **Summarize**: Report what skills were created, tentative notes updated, and promotions suggested

## Self-Reflection Prompts

Use these prompts during work to identify extraction opportunities:

- "What did I just learn that wasn't obvious before starting?"
- "If I faced this exact problem again, what would I wish I knew?"
- "What error message or symptom led me here, and what was the actual cause?"
- "Is this pattern specific to this project, or would it help in similar projects?"
- "What would I tell a colleague who hits this same issue?"

## Memory Consolidation

When extracting skills, also consider:

1. **Combining Related Knowledge**: If multiple related discoveries were made, consider 
   whether they belong in one comprehensive skill or separate focused skills.

2. **Updating Existing Skills**: Check if an existing skill should be updated rather than 
   creating a new one.

3. **Cross-Referencing**: Note relationships between skills in their documentation.

## Quality Gates

Before finalizing a skill, verify:

- [ ] Description contains specific trigger conditions
- [ ] Solution has been verified to work
- [ ] Content is specific enough to be actionable
- [ ] Content is general enough to be reusable
- [ ] No sensitive information (credentials, internal URLs) is included
- [ ] Skill doesn't duplicate existing documentation or skills
- [ ] Web research conducted when appropriate (for technology-specific topics)
- [ ] References section included if web sources were consulted
- [ ] Current best practices (post-2025) incorporated when relevant
- [ ] If knowledge doesn't meet all 4 Quality Criteria: considered tentative note path before discarding
- [ ] Tentative notes contain valid trigger condition and confidence in [0.1, 0.95]

## Anti-Patterns to Avoid

- **Over-extraction**: Not every task deserves a skill. Mundane solutions don't need preservation.
- **Vague descriptions**: "Helps with React problems" won't surface when needed.
- **Unverified solutions**: Only extract what actually worked.
- **Documentation duplication**: Don't recreate official docs; link to them and add what's missing.
- **Stale knowledge**: Mark skills with versions and dates; knowledge can become outdated.

## Skill Lifecycle

Skills should evolve:

0. **Tentative**: Lightweight YAML note with confidence scoring; may be promoted or expire
1. **Creation**: Initial extraction with documented verification
2. **Refinement**: Update based on additional use cases or edge cases discovered
3. **Deprecation**: Mark as deprecated when underlying tools/patterns change
4. **Archival**: Remove or archive skills that are no longer relevant

## Tentative Knowledge Management

Tentative notes capture emerging patterns that don't yet meet all 4 Quality Criteria. They live
in `memory/tentative/` as lightweight YAML files, accumulating confidence through repeated
observations until they are promoted to full skills or expire.

**Schema**: See `resources/instinct-template.yaml` for the YAML template with field documentation.

### Confidence Rules (Summary)

| Event | Delta |
|-------|-------|
| Initial observation | 0.4 (starting value) |
| Re-observed in same context | +0.15 |
| Observed in different context | +0.20 |
| User explicit confirmation | +0.30 (confidence only; does NOT count as an observation) |
| Counter-example observed | −0.20 |

Confidence is clamped to [0.1, 0.95] after each adjustment.

### Promotion

A tentative note is eligible for promotion when **both** conditions are met:
- `confidence >= 0.7`
- `observations >= 2` from **>= 2 distinct sessions or dates**

During Retrospective Mode, eligible notes are presented for user confirmation. If confirmed,
the note's content pre-fills Steps 3-6 to create a full skill; the YAML file is then deleted.

### Expiry

| Condition | Action |
|-----------|--------|
| 90 days since `last_seen`, no new observation | Mark stale; prompt for cleanup |
| 180 days since `last_seen` | Auto-delete |
| `confidence < 0.3` AND 60 days since `last_seen` | Early delete |

If a note simultaneously meets promotion thresholds and stale criteria, **promotion takes precedence**.

### Detailed Rules

See `resources/tentative-knowledge.md` for complete rules on confidence arithmetic edge cases,
promotion protocol, expiry details, deduplication strategy, and cross-project aggregation placeholder.

## Example: Complete Extraction Flow

**Scenario**: While debugging a Next.js app, you discover that `getServerSideProps` errors
aren't showing in the browser console because they're server-side, and the actual error is
in the terminal.

**Step 1 - Check for Existing Skills**: No matching skills found.

**Step 2 - Identify the Knowledge**:
- Problem: Server-side errors don't appear in browser console
- Non-obvious aspect: Expected behavior for server-side code in Next.js
- Trigger: Generic error page with empty browser console

**Step 3 - Research Best Practices**:
Search: "Next.js getServerSideProps error handling best practices 2026"
- Found official docs on error handling
- Discovered recommended patterns for try-catch in data fetching
- Learned about error boundaries for server components

**Steps 4-6 - Structure and Save**:

**Extraction**:

```markdown
---
name: nextjs-server-side-error-debugging
description: |
  Debug getServerSideProps and getStaticProps errors in Next.js. Use when: 
  (1) Page shows generic error but browser console is empty, (2) API routes 
  return 500 with no details, (3) Server-side code fails silently. Check 
  terminal/server logs instead of browser for actual error messages.
author: Claude Code
version: 1.0.0
date: 2024-01-15
---

# Next.js Server-Side Error Debugging

## Problem
Server-side errors in Next.js don't appear in the browser console, making 
debugging frustrating when you're looking in the wrong place.

## Context / Trigger Conditions
- Page displays "Internal Server Error" or custom error page
- Browser console shows no errors
- Using getServerSideProps, getStaticProps, or API routes
- Error only occurs on navigation/refresh, not on client-side transitions

## Solution
1. Check the terminal where `npm run dev` is running—errors appear there
2. For production, check server logs (Vercel dashboard, CloudWatch, etc.)
3. Add try-catch with console.error in server-side functions for clarity
4. Use Next.js error handling: return `{ notFound: true }` or `{ redirect: {...} }` 
   instead of throwing

## Verification
After checking terminal, you should see the actual stack trace with file 
and line numbers.

## Notes
- This applies to all server-side code in Next.js, not just data fetching
- In development, Next.js sometimes shows a modal with partial error info
- The `next.config.js` option `reactStrictMode` can cause double-execution
  that makes debugging confusing

## References
- [Next.js Data Fetching: getServerSideProps](https://nextjs.org/docs/pages/building-your-application/data-fetching/get-server-side-props)
- [Next.js Error Handling](https://nextjs.org/docs/pages/building-your-application/routing/error-handling)
```

> **Tentative path**: If Step 2.5 routes to tentative, skip Steps 3-6 and create a YAML note per
> `resources/instinct-template.yaml` with initial confidence 0.4. See Step 2.5 for the full flow.

## Integration with Workflow

### Automatic Trigger Conditions

Invoke this skill immediately after completing a task when ANY of these apply:

1. **Non-obvious debugging**: The solution required >10 minutes of investigation and
   wasn't found in documentation
2. **Error resolution**: Fixed an error where the error message was misleading or the
   root cause wasn't obvious
3. **Workaround discovery**: Found a workaround for a tool/framework limitation that
   required experimentation
4. **Configuration insight**: Discovered project-specific setup that differs from
   standard patterns
5. **Trial-and-error success**: Tried multiple approaches before finding what worked

### Explicit Invocation

Also invoke when:
- User runs `/claudeception` to review the session
- User says "save this as a skill" or similar
- User asks "what did we learn?"

### Self-Check After Each Task

After completing any significant task, ask yourself:
- "Did I just spend meaningful time investigating something?"
- "Would future-me benefit from having this documented?"
- "Was the solution non-obvious from documentation alone?"

If yes to any, invoke this skill immediately.

Remember: The goal is continuous, autonomous improvement. Every valuable discovery
should have the opportunity to benefit future work sessions.
