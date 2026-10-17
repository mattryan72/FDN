# P3-02: Write Menu.Row, Menu.Toggle and Menu.ObjLine

- Phase: 3 (branch `phase3-menus`)
- Writes code: yes
- Estimated size: ~5,941 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P3-02_lib_Menu_Row_Toggle_ObjLine.md`
- Save the answer as: `notes/P3-02.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Menu.Ware.Details.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Menu.Row` | args: menu, label, value, retval (null = info line) | null | D5
- `lib.LI.FDN.Menu.Toggle` | args: menu, label, bool, retval | null; uses ON/OFF texts 148/149 | D5
- `lib.LI.FDN.Menu.ObjLine` | args: menu, object | null; 'Name [ID]' + sector | D6, Format.Name

### Duplicate / performance notes (ANALYSIS 3 and 5)
- D5 4-column menu row / ON-OFF toggle row, about 28 copies (Config.Menu x8, Ware.Details x11, Factory.Details x3) -> Menu.Row and Menu.Toggle.
- D6 object header line (Format.Name + get sector), 6 copies -> Menu.ObjLine.

## Key facts

- Phase 3 = unified menus. Keep the script name plugin.LI.FDN.Main.Menu (saves store it).
- Menu builders never wait. Rows only via the Menu.* libraries once they exist.
- Never invent commands; menu commands used in the pasted scripts are safe, others need VERIFY.
- Ware.Details is pasted as the pattern for the hand-built rows (columns -470, -380, -290, -200).

## Instruction

Phase 3, task P3-02. Write lib.LI.FDN.Menu.Row, lib.LI.FDN.Menu.Toggle and lib.LI.FDN.Menu.ObjLine (one answer, three short scripts).
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
