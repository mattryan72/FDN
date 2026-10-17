# P1-13d: Config.Menu: small fix B23

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~4,823 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-13d_Config.Menu_B23.md`
- Save the answer as: `notes/P1-13d.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Config.Menu.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B23 (low) Config.Menu 28. Ignores the `menu` argument (creates its own). Fix: use the passed menu.

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-13d. Fix plugin.LI.FDN.Config.Menu: B23 use the `menu` argument that is passed in instead of creating a new menu (check Main.Menu passes one: it calls `Config.Menu : menu=$menu`). Change nothing else.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
