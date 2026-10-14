# Preferences

## Grilling (`/grill-me`, `grilling` skill)

Ask every question as a clickable multiple-choice question with the AskUserQuestion tool, not as a text list. For each question:

- Put your best recommendation first and add "(Recommended)" to its label.
- Give 2-4 concrete options. The user can still pick "Other" to type their own answer.
- Batch the round's frontier into one call (up to 4 questions per call; use more calls if the frontier is bigger).
