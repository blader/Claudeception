# Examples & Lifecycle Reference

← Back to `../SKILL.md`

## Complete Extraction Flow: Next.js Example

**Scenario**: While debugging a Next.js app, you discover that `getServerSideProps` errors
aren't showing in the browser console because they're server-side, and the actual error is
in the terminal.

**Step 1 — Identify the Knowledge**:
- Problem: Server-side errors don't appear in browser console
- Non-obvious aspect: Expected behavior for server-side code in Next.js
- Trigger: Generic error page with empty browser console

**Step 2 — Research Best Practices**:
Search: "Next.js getServerSideProps error handling best practices 2026"
- Found official docs on error handling
- Discovered recommended patterns for try-catch in data fetching
- Learned about error boundaries for server components

**Steps 3–5 — Structure and Save**:

```markdown
---
name: nextjs-server-side-error-debugging
description: |
  Use when: (1) Next.js page shows generic error but browser console is empty,
  (2) API routes return 500 with no details, (3) server-side code fails silently.
  Symptoms: getServerSideProps errors not visible, empty console with error page.
---

# Next.js Server-Side Error Debugging

## Problem
Server-side errors in Next.js don't appear in the browser console.

## Solution
1. Check the terminal where `npm run dev` is running — errors appear there
2. For production, check server logs (Vercel dashboard, CloudWatch, etc.)
3. Add try-catch with console.error in server-side functions for clarity
4. Use Next.js error handling: return `{ notFound: true }` or `{ redirect: {...} }`
   instead of throwing

## Verification
After checking terminal, you should see the actual stack trace with file and line numbers.

## References
- [Next.js Data Fetching: getServerSideProps](https://nextjs.org/docs/pages/building-your-application/data-fetching/get-server-side-props)
```

## Memory Consolidation Notes

When extracting skills, also consider:

1. **Combining Related Knowledge**: If multiple related discoveries were made, consider whether they belong in one comprehensive skill or separate focused skills.
2. **Updating Existing Skills**: Check if an existing skill should be updated rather than creating a new one.
3. **Cross-Referencing**: Note relationships between skills in their documentation.

## Skill Lifecycle

Skills should evolve:

1. **Creation**: Initial extraction with documented verification
2. **Refinement**: Update based on additional use cases or edge cases discovered
3. **Deprecation**: Mark as deprecated when underlying tools/patterns change
4. **Archival**: Remove or archive skills that are no longer relevant
