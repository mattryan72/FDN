# P1-09a: Main.Menu: one updater per view (B8), remove dead view-3 code (B24)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~4,943 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-09a_Main.Menu_B8_B24.md`
- Save the answer as: `notes/P1-09a.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- source_readable/plugin.LI.FDN.Main.Menu.txt lines 001-110, 409-465, 538-585

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B8 (medium) Main.Menu 413, 446; DC.Details_D 33-44; Dock.Details_D. (a) A new _D updater task is STARTed on every menu redraw, so updaters stack up. (b) The view reads FDND.* globals right after START, before the updater may have written them (empty rows on first draw, verify). (c) DC_D runs Write.Menu.Global before its `if $dc` check. Fix direction: one refresh task with a token in [20]; build first draw synchronously.
- B24 (low) Main.Menu 47, 92, 540-560. Dead view-3 branches and unreachable header branches. Fix: delete.

### Menu views
1 DC, 2 stations, 4 factory, 5 dock, 6 ware, 7 config (3 was removed). Settings [5] = open view, [20] = menu refresh token (new).

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.
- You only have some line ranges of this script (marked in the FILE block). Do NOT output the whole script. For each change output `Replace lines NNN-NNN with:` and the new lines, or `Insert after line NNN:`. Keep line numbers from the pasted file.

## Instruction

Phase 1, task P1-09a. Fix plugin.LI.FDN.Main.Menu (only the pasted ranges): B8 START the *_D updater only when ENTERING view 1 or 5, not on every redraw; increment `$al.Settings[20]` (menu token) each time you start one so old updaters can exit. B24 delete the dead view-3 branches and unreachable header branches. Use the replace-block output described in the key facts.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
