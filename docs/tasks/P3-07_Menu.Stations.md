# P3-07: Write plugin.LI.FDN.Menu.Stations (stations list)

- Phase: 3 (branch `phase3-menus`)
- Writes code: yes
- Estimated size: ~5,813 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P3-07_Menu.Stations.md`
- Save the answer as: `notes/P3-07.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Menu.AP.Factory.List.txt`

## Excerpts

### Menu target design (PHASE3)
- Main.Menu = controller only: view stack (array of [view, obj, ware]), header, footer, open menu, pass the return value to plugin.LI.FDN.Menu.Command, which returns the new stack. 'back' / -1 pops the stack.
- Views: Menu.Station (DC or dock), Menu.Stations (sectors from cache [15] -> factories [3] + docks [4]), Menu.Factory.Details, Menu.Ware.Details, Config.Menu.
- All rows come from lib.LI.FDN.Menu.Row/Toggle/ObjLine/WareRow; column offsets stored once.
- One refresh task Menu.Refresh; exits when [5] or token [20] changes.
- Wording: "Distribution Centre", "Stations", "Docks", "Factories"; ON/OFF from 148/149; colours via 9000-9007. AP/FL native groupings only.

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Sectors` | args: mode (1 factories, 2 docks, 3 trade = all + adv. sats) | sector array from cache [15], never scans | replaces Sector.Array readers
- `lib.LI.FDN.Fac.Cfg` | args: factory | settings array, get-or-create, applies auto-manage once | D4
- `lib.LI.FDN.Menu.Row` | args: menu, label, value, retval (null = info line) | null | D5
- `lib.LI.FDN.Menu.Toggle` | args: menu, label, bool, retval | null; uses ON/OFF texts 148/149 | D5
- `lib.LI.FDN.Menu.ObjLine` | args: menu, object | null; 'Name [ID]' + sector | D6, Format.Name

### Duplicate / performance notes (ANALYSIS 3 and 5)
- P1 full station scan every 25 s (Supply.Start -> Sector.Array) -> rate-limit with cache [15] and timestamp [16].

## Key facts

- Phase 3 = unified menus. Keep the script name plugin.LI.FDN.Main.Menu (saves store it).
- Menu builders never wait. Rows only via the Menu.* libraries once they exist.
- Never invent commands; menu commands used in the pasted scripts are safe, others need VERIFY.
- Build from cached arrays [3]/[4] grouped by sector [15]; no full scan when the menu opens (P6).

## Instruction

Phase 3, task P3-07. Write plugin.LI.FDN.Menu.Stations: sectors -> factories + docks, the global product/resource commands, and the stats lines 2000-2002.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
