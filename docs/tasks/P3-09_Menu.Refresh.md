# P3-09: Write plugin.LI.FDN.Menu.Refresh (single updater)

- Phase: 3 (branch `phase3-menus`)
- Writes code: yes
- Estimated size: ~5,013 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P3-09_Menu.Refresh.md`
- Save the answer as: `notes/P3-09.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Menu.DC.Details_D.txt`

## Excerpts

### Menu target design (PHASE3)
- Main.Menu = controller only: view stack (array of [view, obj, ware]), header, footer, open menu, pass the return value to plugin.LI.FDN.Menu.Command, which returns the new stack. 'back' / -1 pops the stack.
- Views: Menu.Station (DC or dock), Menu.Stations (sectors from cache [15] -> factories [3] + docks [4]), Menu.Factory.Details, Menu.Ware.Details, Config.Menu.
- All rows come from lib.LI.FDN.Menu.Row/Toggle/ObjLine/WareRow; column offsets stored once.
- One refresh task Menu.Refresh; exits when [5] or token [20] changes.
- Wording: "Distribution Centre", "Stations", "Docks", "Factories"; ON/OFF from 148/149; colours via 9000-9007. AP/FL native groupings only.

### Bug notes from the analysis (line numbers are Script Editor lines)
- B8 (medium) Main.Menu 413, 446; DC.Details_D 33-44; Dock.Details_D. (a) A new _D updater task is STARTed on every menu redraw, so updaters stack up. (b) The view reads FDND.* globals right after START, before the updater may have written them (empty rows on first draw, verify). (c) DC_D runs Write.Menu.Global before its `if $dc` check. Fix direction: one refresh task with a token in [20]; build first draw synchronously.

### Duplicate / performance notes (ANALYSIS 3 and 5)
- P5 stacked menu refresh loops -> one refresh task.

## Key facts

- Phase 3 = unified menus. Keep the script name plugin.LI.FDN.Main.Menu (saves store it).
- Menu builders never wait. Rows only via the Menu.* libraries once they exist.
- Never invent commands; menu commands used in the pasted scripts are safe, others need VERIFY.
- Menu.Refresh is a task (it waits); it must exit when [5] or [20] changes or `is new script version available`.

## Instruction

Phase 3, task P3-09. Write plugin.LI.FDN.Menu.Refresh to replace both *_D updaters.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
