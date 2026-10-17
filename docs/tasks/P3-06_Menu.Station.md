# P3-06: Write plugin.LI.FDN.Menu.Station (DC and dock in one view)

- Phase: 3 (branch `phase3-menus`)
- Writes code: yes
- Estimated size: ~6,848 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P3-06_Menu.Station.md`
- Save the answer as: `notes/P3-06.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Menu.AP.DC.Details.txt`
- `source_readable/plugin.LI.FDN.Menu.AP.Dock.Details.txt`

## Excerpts

### Menu target design (PHASE3)
- Main.Menu = controller only: view stack (array of [view, obj, ware]), header, footer, open menu, pass the return value to plugin.LI.FDN.Menu.Command, which returns the new stack. 'back' / -1 pops the stack.
- Views: Menu.Station (DC or dock), Menu.Stations (sectors from cache [15] -> factories [3] + docks [4]), Menu.Factory.Details, Menu.Ware.Details, Config.Menu.
- All rows come from lib.LI.FDN.Menu.Row/Toggle/ObjLine/WareRow; column offsets stored once.
- One refresh task Menu.Refresh; exits when [5] or token [20] changes.
- Wording: "Distribution Centre", "Stations", "Docks", "Factories"; ON/OFF from 148/149; colours via 9000-9007. AP/FL native groupings only.

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Menu.Row` | args: menu, label, value, retval (null = info line) | null | D5
- `lib.LI.FDN.Menu.ObjLine` | args: menu, object | null; 'Name [ID]' + sector | D6, Format.Name
- `lib.LI.FDN.Menu.WareRow` | args: station, ware, is.dc | formatted row array with retval ['open.ware', station, ware] | Wares.Summary, D8

### Duplicate / performance notes (ANALYSIS 3 and 5)
- D7 AP vs TC and DC vs Dock menu twins (70-81% identical) -> one Menu.Station, one Menu.Stations, one Menu.Refresh; delete TC twins.

## Key facts

- Phase 3 = unified menus. Keep the script name plugin.LI.FDN.Main.Menu (saves store it).
- Menu builders never wait. Rows only via the Menu.* libraries once they exist.
- Never invent commands; menu commands used in the pasted scripts are safe, others need VERIFY.

## Instruction

Phase 3, task P3-06. Write plugin.LI.FDN.Menu.Station(menu, station, is.dc): info line, credits, wares grouped via Sort.Wares + Menu.WareRow, add ware, config link. One view for both DC and dock.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
