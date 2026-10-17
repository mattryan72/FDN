# P1-13b: Menu.Ware.Details: small fix B21

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~5,853 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-13b_Menu.Ware.Details_B21.md`
- Save the answer as: `notes/P1-13b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Menu.Ware.Details.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B21 (low) Menu.Ware.Details 38, 52-53. Shows the DC's sector for any station; line 52 sprintf result is immediately overwritten. Fix: use `$value -> get sector`; delete the dead line.

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-13b. Fix plugin.LI.FDN.Menu.Ware.Details: B21 show the station's own sector (`$value -> get sector`) instead of the DC's, and delete the dead sprintf at line 52. Change nothing else.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
