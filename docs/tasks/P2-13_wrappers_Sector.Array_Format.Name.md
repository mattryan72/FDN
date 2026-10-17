# P2-13: Turn Sector.Array and Format.Name into thin wrappers

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~3,454 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-13_wrappers_Sector.Array_Format.Name.md`
- Save the answer as: `notes/P2-13.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- source_readable/plugin.LI.FDN.Sector.Array.txt lines 001-020
- `source_readable/plugin.LI.FDN.Format.Name.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Sectors` | args: mode (1 factories, 2 docks, 3 trade = all + adv. sats) | sector array from cache [15], never scans | replaces Sector.Array readers
- `lib.LI.FDN.Menu.ObjLine` | args: menu, object | null; 'Name [ID]' + sector | D6, Format.Name

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.
- Keep both script names and arguments; old saves and old menus still call them.

## Instruction

Phase 2, task P2-13. Rewrite plugin.LI.FDN.Sector.Array as a thin wrapper that calls lib.LI.FDN.Sectors (and starts Scan if the cache is empty), and Format.Name as a thin wrapper that returns the same 'name [ID]' text. Two short scripts.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
