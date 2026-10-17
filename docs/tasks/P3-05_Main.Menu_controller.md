# P3-05: Rewrite plugin.LI.FDN.Main.Menu as the controller

- Phase: 3 (branch `phase3-menus`)
- Writes code: yes
- Estimated size: ~4,760 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P3-05_Main.Menu_controller.md`
- Save the answer as: `notes/P3-05.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- source_readable/plugin.LI.FDN.Main.Menu.txt lines 001-110, 409-465, 538-585

## Excerpts

### Menu target design (PHASE3)
- Main.Menu = controller only: view stack (array of [view, obj, ware]), header, footer, open menu, pass the return value to plugin.LI.FDN.Menu.Command, which returns the new stack. 'back' / -1 pops the stack.
- Views: Menu.Station (DC or dock), Menu.Stations (sectors from cache [15] -> factories [3] + docks [4]), Menu.Factory.Details, Menu.Ware.Details, Config.Menu.
- All rows come from lib.LI.FDN.Menu.Row/Toggle/ObjLine/WareRow; column offsets stored once.
- One refresh task Menu.Refresh; exits when [5] or token [20] changes.
- Wording: "Distribution Centre", "Stations", "Docks", "Factories"; ON/OFF from 148/149; colours via 9000-9007. AP/FL native groupings only.

## Key facts

- Phase 3 = unified menus. Keep the script name plugin.LI.FDN.Main.Menu (saves store it).
- Menu builders never wait. Rows only via the Menu.* libraries once they exist.
- Never invent commands; menu commands used in the pasted scripts are safe, others need VERIFY.

## Instruction

Phase 3, task P3-05. Rewrite plugin.LI.FDN.Main.Menu as the controller only (view stack, header, footer, open menu, hand off to Menu.Command). Output the full new script.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
