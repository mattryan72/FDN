# P1-10a: Menu.Dock.Details_D: read index 2 (B7), exit on new token (B8)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~5,121 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-10a_Dock.Details_D_B7_B8.md`
- Save the answer as: `notes/P1-10a.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Menu.Dock.Details_D.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B7 (medium, confirmed in P0-B) Menu.Dock.Details_D L026 reads `$al.Settings[6][1]` but must read `[6][2]`. Config.Menu L172 and Main.Menu's 'dynamic.dock' handler (L261-266) already use [2]. 'dynamic.dock.list' (Main.Menu L268-274) toggles [1] for the removed dock-list UI (its Config row L151-164 is commented out); the handlers are NOT swapped. Fix: one line in Menu.Dock.Details_D, nothing else.
- B8 (medium) Main.Menu 413, 446; DC.Details_D 33-44; Dock.Details_D. (a) A new _D updater task is STARTed on every menu redraw, so updaters stack up. (b) The view reads FDND.* globals right after START, before the updater may have written them (empty rows on first draw, verify). (c) DC_D runs Write.Menu.Global before its `if $dc` check. Fix direction: one refresh task with a token in [20]; build first draw synchronously.

### Settings used
- [5] open view (5 = dock view), [6] is.dynamic ([2] = dock view), [20] menu token (new, incremented by Main.Menu when it starts an updater).

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-10a. Fix plugin.LI.FDN.Menu.Dock.Details_D: B7 is a one-line fix: L026 must read `$al.Settings[6][2]`, not [6][1]. Do not change Config.Menu or Main.Menu for B7 (they already use [2]; dynamic.dock.list on [1] is old dock-list code, not a swapped handler). B8 remember `$al.Settings[20]` at start and exit the loop when it changes or when [5] is no longer 5.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
