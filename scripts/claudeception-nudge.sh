#!/usr/bin/env bash
# Claudeception quiet nudge hook — one line, once per session.
#
# Installation:
#   Add a Stop hook to ~/.claude/settings.json pointing at this script.

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

STATE_FILE="/tmp/claudeception-nudged-${SESSION_ID}"

if [[ ! -f "$STATE_FILE" ]]; then
  touch "$STATE_FILE"
  echo "Reminder: if this session produced a non-obvious insight or workaround, consider running /claudeception to extract it as a skill or memory."
fi

exit 0
