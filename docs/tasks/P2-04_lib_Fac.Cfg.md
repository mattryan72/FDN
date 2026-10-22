# P2-04: Write lib.LI.FDN.Fac.Cfg

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~3,760 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-04_lib_Fac.Cfg.md`
- Save the answer as: `notes/P2-04.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `docs/excerpts/v8_Supply.Factory.Check_D4.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Fac.Cfg` | args: factory, auto.manage (1 = apply [9] on first sight via [2], null/0 = get-or-create only) | settings array, get-or-create | D4

### Factory settings: station local `FDN.Settings` (text 4001), array size 6
[0] manage product, [1] manage resources, [2] "already seen" flag (applies auto-manage once), [3] v9: busy-until time, [4]-[5] free.

### Duplicate / performance notes (ANALYSIS 3 and 5)
- D4 factory settings get-or-create + auto-manage first-seen in Supply.Factory.Check (v8 065-084, see excerpt; v3 has no prefixes), Menu.AP.Factory.List 187-204, Menu.Factory.List 180-197, Menu.Factory.Details 8-14 (get-or-create only) -> lib.LI.FDN.Fac.Cfg.

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.

## Instruction

Phase 2, task P2-04. Write lib.LI.FDN.Fac.Cfg(factory): get-or-create FDN.Settings and apply auto-manage ([9]) only the first time the factory is seen ([2]).
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
