# P1-10b: Menu.DC.Details_D: first-draw rows and token exit (B8)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~5,067 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-10b_DC.Details_D_B8.md`
- Save the answer as: `notes/P1-10b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Menu.DC.Details_D.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B8 (medium) Main.Menu 413, 446; DC.Details_D 33-44; Dock.Details_D. (a) A new _D updater task is STARTed on every menu redraw, so updaters stack up. (b) The view reads FDND.* globals right after START, before the updater may have written them (empty rows on first draw, verify). (c) DC_D runs Write.Menu.Global before its `if $dc` check. Fix direction: one refresh task with a token in [20]; build first draw synchronously.

### Settings used
- [2] DC, [5] open view (1 = DC view), [6] is.dynamic ([0] = DC view), [20] menu token (new).

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-10b. Fix plugin.LI.FDN.Menu.DC.Details_D: B8(c) move the `if $dc` check before Write.Menu.Global. B8 remember `$al.Settings[20]` at start and exit when it changes or when [5] is no longer 1. For B8(b) (empty rows on first draw) explain the options in 3-4 sentences; pick the smallest change.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
