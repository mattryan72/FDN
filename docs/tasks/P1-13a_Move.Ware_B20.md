# P1-13a: Move.Ware: small fix B20

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~4,357 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-13a_Move.Ware_B20.md`
- Save the answer as: `notes/P1-13a.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Move.Ware.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B20 (low) Move.Ware 52-67. If the destination prompt is cancelled (null), it is not handled before `-> is of class` / `get free amount`. Fix: null check.

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-13a. Fix plugin.LI.FDN.Move.Ware: B20 handle a cancelled destination prompt (null) before any `-> is of class` or `get free amount` call. Change nothing else.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
