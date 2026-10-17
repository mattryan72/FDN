# P3-03: Write Menu.WareRow

- Phase: 3 (branch `phase3-menus`)
- Writes code: yes
- Estimated size: ~5,794 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P3-03_lib_Menu_WareRow.md`
- Save the answer as: `notes/P3-03.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Wares.Summary.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Menu.WareRow` | args: station, ware, is.dc | formatted row array with retval ['open.ware', station, ware] | Wares.Summary, D8
- `lib.LI.FDN.Ware.Rec` | args: station, ware, create (Boolean) | record array (created with v9 defaults if create) or null; create=FALSE never writes | D3, B2, B18

### Duplicate / performance notes (ANALYSIS 3 and 5)
- D8 Wares.Summary DC.Summary.Sub vs Dock.Summary.Sub (~70%) -> one row builder.

## Key facts

- Phase 3 = unified menus. Keep the script name plugin.LI.FDN.Main.Menu (saves store it).
- Menu builders never wait. Rows only via the Menu.* libraries once they exist.
- Never invent commands; menu commands used in the pasted scripts are safe, others need VERIFY.

## Instruction

Phase 3, task P3-03. Write lib.LI.FDN.Menu.WareRow(station, ware, is.dc) as one row builder covering both the DC and dock columns from Wares.Summary.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
