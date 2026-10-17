# P1-13e: Sort.Wares: small fix B17

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~4,290 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-13e_Sort.Wares_B17.md`
- Save the answer as: `notes/P1-13e.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Sort.Wares.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B17 (low) Sort.Wares 49-73. Wares whose maintype is not in the 9 listed groups are silently dropped from menus. Fix: add an 'Other' group (new text 300).

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-13e. Fix plugin.LI.FDN.Sort.Wares: B17 add an 'Other' group for wares whose maintype is not in the listed groups. Its heading is new text id 300 (give the XML line). Change nothing else.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
