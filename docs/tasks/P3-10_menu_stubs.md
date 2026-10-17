# P3-10: Stub the old menu scripts

- Phase: 3 (branch `phase3-menus`)
- Writes code: yes
- Estimated size: ~2,591 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P3-10_menu_stubs.md`
- Save the answer as: `notes/P3-10.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`

## Excerpts

### Scripts to stub in v9.01
Menu.AP.DC.Details, Menu.DC.Details, Menu.AP.Dock.Details, Menu.Dock.Details, Menu.AP.Factory.List, Menu.Factory.List, Menu.DC.Details_D, Menu.Dock.Details_D, Wares.Summary (all `plugin.LI.FDN.` prefixed). Each keeps its name and arguments and becomes `return null` with a v9 comment, so old saves that call them do not error.

## Key facts

- Phase 3 = unified menus. Keep the script name plugin.LI.FDN.Main.Menu (saves store it).
- Menu builders never wait. Rows only via the Menu.* libraries once they exist.
- Never invent commands; menu commands used in the pasted scripts are safe, others need VERIFY.

## Instruction

Phase 3, task P3-10. Write the stub source for each script listed (header comment + `return null`), and say which arguments Matt must keep in the editor for each (he can read them from the old XML).
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
