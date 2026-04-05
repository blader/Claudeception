# Tentative Knowledge — Detailed Rules

Reference document for the Claudeception Tentative Knowledge Layer.
SKILL.md contains summaries; this file has the complete rules and edge cases.

## Confidence Arithmetic

### Initial Assignment

- **Single observation, unverified**: 0.4
- **Single observation + user verbal confirmation in same session**: 0.4 + 0.30 = 0.70
  (but promotion still blocked — see Promotion Protocol below)

### Adjustment Events

| Event | Delta | Example |
|-------|-------|---------|
| Re-observed in same context | +0.15 | Same project, same problem domain, same tool |
| Observed in different context | +0.20 | Different project OR different problem domain |
| User explicit confirmation | +0.30 | User says "yes that's a real pattern" |
| Counter-example observed | −0.20 | Pattern fails or contradicts in a new scenario |

### Clamping

After every adjustment: `confidence = clamp(confidence + delta, 0.1, 0.95)`

**Simultaneous events in one session**: Apply deltas sequentially in observation order,
clamping after each. Example: observe in new context (+0.20) then user confirms (+0.30):
0.4 → 0.60 → 0.90. When all deltas are positive (or all negative), order does not affect
the final result. However, if a counter-example (−0.20) is mixed with positive deltas in
the same session, order CAN matter due to floor-clamping — apply counter-example deltas
last to avoid premature floor-clamping that inflates the result.

### Context Differentiation

- **Same context**: same project (by working directory) + same problem domain + same tool
- **Different context**: different project OR different problem domain
- Ambiguous cases: use LLM judgment; when uncertain, treat as same context (+0.15, conservative)

## Promotion Protocol

### Eligibility

Both conditions must be met:
1. `confidence >= 0.7`
2. `observations.length >= 2`, from **>= 2 distinct sessions or dates**

**Critical rule**: User explicit confirmation (+0.30) adjusts confidence only.
It does **NOT** add an entry to the `observations` list. This prevents a single-observation
note from being promoted via confirmation alone (the "fast-track loophole").

### Promotion Steps (during Retrospective Mode)

1. Scan `memory/tentative/*.yaml` for eligible notes
2. Display each candidate: name, trigger, action, confidence, observation count
3. Ask user: "This pattern has been observed N times (confidence C). Promote to full skill?"
4. **If confirmed**: run Extraction Process Steps 3-6, pre-filling from the note:
   - `trigger` → Context / Trigger Conditions section
   - `action` → Solution section (starting point)
   - `observations` → Example section (pick most illustrative)
   - `tags` → description keywords
5. **If declined**: keep as tentative; append current date to `promotion_declined` list in the YAML file
6. After successful promotion: delete the YAML file

### Promotion Declined Twice

If the same note's `promotion_declined` list contains >= 2 entries from distinct sessions,
stop suggesting it automatically during Retrospective Mode scans. The note remains in
`memory/tentative/` and can still be manually promoted if the user explicitly requests it
(e.g., "promote [note-name] to skill"), which bypasses the auto-skip filter.

### Stale-but-Promotable Precedence

If a note simultaneously meets promotion thresholds AND 90-day stale criteria,
**promotion takes precedence**. Rationale: the note has enough evidence to be useful;
staleness just means the pattern hasn't recurred recently, not that it's invalid.

## Expiry Rules

| Condition | Action | Rationale |
|-----------|--------|-----------|
| 90 days since `last_seen`, no new observation | Mark stale; prompt user for cleanup | Knowledge may be outdated |
| 180 days since `last_seen` | Auto-delete the YAML file | Definitely stale; reduce clutter |
| `confidence < 0.3` AND 60 days since `last_seen` | Early delete | Low confidence + idle = noise |

"Days since last_seen" is calculated from `last_seen` field in the YAML, not from file modification time.

## Deduplication Strategy

Tentative notes use `{name}.yaml` as filename (e.g., `memory/tentative/git-rebase-conflict-resolution.yaml`).

**Matching priority when creating a new note**:
1. **Filename exact match**: if `memory/tentative/{name}.yaml` already exists, update it
2. **Trigger semantic similarity**: read existing YAML files, compare trigger descriptions
   using LLM judgment (not a programmatic similarity metric). If a semantically similar
   note exists, update that note instead of creating a duplicate
3. **No match**: create new file

## Edge Cases

- **Note contradicts existing skill**: Add counter-example to the note; do NOT modify the skill.
  Flag for review during next Retrospective Mode.
- **Two notes should merge**: During Retrospective, if two notes have overlapping triggers,
  merge into one: combine observations lists, average confidences, keep the more descriptive trigger.
- **Namespace collision**: If two different patterns naturally produce the same kebab-case name,
  append a numeric suffix (e.g., `pattern-name-2.yaml`).

## Future: Cross-Project Aggregation

**Not yet implemented.** Planned feature: when the same pattern appears in `memory/tentative/`
across 2+ distinct projects with average confidence >= 0.8, suggest global promotion to a
user-level skill (installed in `~/.claude/skills/`). Design details pending future development.
