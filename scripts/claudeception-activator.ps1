#!/usr/bin/env pwsh

# claudeception-activator.ps1
# Native Windows/PowerShell activator hook for Claudeception.
# Equivalent to scripts/claudeception-activator.sh for non-Unix environments.
#
# Hook type: UserPromptSubmit
# Purpose: Outputs a reminder for Claude to evaluate whether the current task
#          produced extractable knowledge worth saving as a reusable skill.
#
# Installation:
#   1. Copy this script to $env:USERPROFILE\.claude\hooks\
#   2. Add to $env:USERPROFILE\.claude\settings.json (see README for details)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Output @"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧠 MANDATORY SKILL EVALUATION REQUIRED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CRITICAL: After completing this user request, you MUST evaluate whether
it produced extractable knowledge using the claudeception skill.

EVALUATION PROTOCOL (NON-NEGOTIABLE):

1. COMPLETE the user's request first
2. EVALUATE: Ask yourself:
   - Did this require non-obvious investigation or debugging?
   - Was the solution something that would help in future similar situations?
   - Did I discover something not immediately obvious from documentation?

3. IF YES to any question above:
   ACTIVATE: Use Skill(claudeception) NOW to extract the knowledge

4. IF NO to all questions:
   SKIP: No skill extraction needed

This is NOT optional. Failing to evaluate means valuable knowledge is lost.
The claudeception skill will decide whether to actually create a new
skill based on its quality criteria.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
"@
