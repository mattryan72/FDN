# P3-08a: Menu.Factory.Details on the menu libraries

- Phase: 3 (branch `phase3-menus`)
- Writes code: yes
- Estimated size: ~4,291 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P3-08a_Menu.Factory.Details_on_libs.md`
- Save the answer as: `notes/P3-08a.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Menu.Factory.Details.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Menu.Row` | args: menu, label, value, retval (null = info line) | null | D5
- `lib.LI.FDN.Menu.Toggle` | args: menu, label, bool, retval | null; uses ON/OFF texts 148/149 | D5
- `lib.LI.FDN.Menu.ObjLine` | args: menu, object | null; 'Name [ID]' + sector | D6, Format.Name
- `lib.LI.FDN.Ware.Rec` | args: station, ware, create (Boolean) | record array (created with v9 defaults if create) or null; create=FALSE never writes | D3, B2, B18
- `lib.LI.FDN.Fac.Cfg` | args: factory | settings array, get-or-create, applies auto-manage once | D4

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

## Instruction

Phase 3, task P3-08a. Rewrite plugin.LI.FDN.Menu.Factory.Details using the Menu.* libraries and the new command names. Keep what it shows; remove hand-built rows.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
