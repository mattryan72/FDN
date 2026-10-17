# P2-02: Write lib.LI.FDN.Is.Valid and lib.LI.FDN.Is.Factory

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~4,363 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-02_lib_Is.Valid_Is.Factory.md`
- Save the answer as: `notes/P2-02.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Sector.Array.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Is.Valid` | args: obj, need.dock (Boolean) | TRUE if obj exists, owner race == Player, and is a Dock if asked | B3, B12
- `lib.LI.FDN.Is.Factory` | args: station | TRUE if managed factory (Factory, not Complex Hub, detectable rule; VERIFY intent of `is detectable == 0`) | D10

### Duplicate / performance notes (ANALYSIS 3 and 5)
- D10 'managed factory' test (Factory 2006, not Complex Hub, `is detectable == 0`) in Sector.Array twice and AP.Factory.List -> lib.LI.FDN.Is.Factory.

### v9 standard header (the only allowed copy of the settings fetch)
```
$al.Settings = [THIS] -> call script lib.LI.FDN.Cfg.Get :
if not $al.Settings
 return null
end
$PageID = $al.Settings[1]
```

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.
- Sector.Array lines 59-66 and 114-123 hold the current factory test (D10).

## Instruction

Phase 2, task P2-02. Write lib.LI.FDN.Is.Valid and lib.LI.FDN.Is.Factory. Keep the factory rule exactly as Sector.Array has it, and explain what `is detectable == 0` seems to be for (mark VERIFY).
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
