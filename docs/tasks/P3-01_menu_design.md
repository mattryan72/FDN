# P3-01: Menu design note and new text IDs

- Phase: 3 (branch `phase3-menus`)
- Writes code: no
- Estimated size: ~8,959 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P3-01_menu_design.md`
- Save the answer as: `notes/P3-01.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/plugin.LI.FDN.Main.Menu.txt`
- `source_readable/plugin.LI.FDN.Config.Menu.txt`

## Excerpts

### Menu target design (PHASE3)
- Main.Menu = controller only: view stack (array of [view, obj, ware]), header, footer, open menu, pass the return value to plugin.LI.FDN.Menu.Command, which returns the new stack. 'back' / -1 pops the stack.
- Views: Menu.Station (DC or dock), Menu.Stations (sectors from cache [15] -> factories [3] + docks [4]), Menu.Factory.Details, Menu.Ware.Details, Config.Menu.
- All rows come from lib.LI.FDN.Menu.Row/Toggle/ObjLine/WareRow; column offsets stored once.
- One refresh task Menu.Refresh; exits when [5] or token [20] changes.
- Wording: "Distribution Centre", "Stations", "Docks", "Factories"; ON/OFF from 148/149; colours via 9000-9007. AP/FL native groupings only.

### Menu commands (REFERENCE E)
Return values are arrays [cmd, obj, ware, extra]; strings only for global actions.
- Navigation: open.dc, open.stations, open.dock, open.factory, open.ware, open.config, back.
- Edit number (one handler): remote.cap->[1], maintain.cap->[2], sell.cap->[5]. Edit price (one handler): buy.at->[4], sell.at->[6].
- Toggle (one handler): can.buy->[3], surplus->[7]; factory product->[0], resource->[1]; settings debug->[7], auto->[9], dynamic.dc->[6][0], dynamic.dock->[6][2].
- Stock: move.ware, to.physical, to.virtual (one handler), add.ware, remove.ware (re-check stock == 0).
- Global: product.all.on/off, resource.all.on/off, set.dc (merges add.dc/change.dc), master.reset (confirm).
- Removed: switch.menu (becomes a nav row), show.factory, show.type.dc, show.type.dock (TC only).

## Key facts

- Phase 3 = unified menus. Keep the script name plugin.LI.FDN.Main.Menu (saves store it).
- Menu builders never wait. Rows only via the Menu.* libraries once they exist.
- Never invent commands; menu commands used in the pasted scripts are safe, others need VERIFY.
- No code in this answer except the new text XML lines.

## Instruction

Phase 3, task P3-01. Write a short design note for Matt to approve: the view stack, which script builds each view, how Back works, and the full list of new text IDs 300-399 as XML lines `<t id="3xx">...</t>`. Point out anything in the pasted scripts that does not fit the design.
Start with "Assumptions" and "Questions for Matt" (short).
