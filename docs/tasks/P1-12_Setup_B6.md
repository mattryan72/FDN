# P1-12: Setup: guard the Plugin Configuration call (B6)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~3,261 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-12_Setup_B6.md`
- Save the answer as: `notes/P1-12.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Setup.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B6 (high) Setup 36-38, 42-53. Hard dependency on `plugin.config.addscript` (Cycrow's Community Plugin Configuration). Without it FDN has no menu. Removal matches display text against the library's internal array, which is fragile. Fix direction: only call it if available; hotkey fallback comes in Phase 4.

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-12. Fix plugin.LI.FDN.Setup: B6 only call plugin.config.addscript if it is available. If you do not know a real MSCI command that checks whether a script exists, say so, mark VERIFY, and instead document the dependency in a comment; the hotkey fallback is Phase 4.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
