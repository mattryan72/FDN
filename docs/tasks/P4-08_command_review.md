# P4-08: Command review: one v9 script against its v8 version

- Phase: 4 (branch `phase4-compat`)
- Writes code: no
- Estimated size: ~1,586 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-08_command_review.md`
- Save the answer as: `notes/P4-08.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- notes/review_v9.txt (optional)
- notes/review_v8.txt (optional)

## Excerpts

### How Matt prepares this card (once per script)
Copy the new v9 script to `notes/review_v9.txt`. Get the v8 version with `git show v8.04-baseline:source_readable/<name>.txt > notes/review_v8.txt` (in PowerShell add `| Out-File -Encoding utf8 notes/review_v8.txt` instead of `>` if the text looks garbled). New scripts with no v8 version: leave review_v8.txt empty.

## Key facts

- This is a review only. Do not write or change any code.
- Quote code exactly, with its 3-digit line number from the pasted file. If you cannot find a line, say "not found" rather than guessing.
- Use only the pasted files. If you need another script, name it and stop.

## Instruction

Phase 4, task P4-08. List every command in review_v9.txt that does not appear in review_v8.txt. For each: the line, a reference URL if you know one for certain, otherwise VERIFY with what Matt should check in the in-game editor.
Start with "Assumptions" and "Questions for Matt" (short).
