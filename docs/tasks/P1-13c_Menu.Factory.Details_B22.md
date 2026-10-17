# P1-13c: Menu.Factory.Details: small fix B22

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~3,967 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-13c_Menu.Factory.Details_B22.md`
- Save the answer as: `notes/P1-13c.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Menu.Factory.Details.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B22 (low) Menu.Factory.Details 8. `sprintf textid=4001, $value` on a string with no `%s` works by accident. Fix: `read text`.

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-13c. Fix plugin.LI.FDN.Menu.Factory.Details: B22 replace `sprintf textid=4001, $value` with `read text: page=$PageID id=4001`. Change nothing else.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
