# P2-01: Write lib.LI.FDN.Cfg.Get and lib.LI.FDN.Log

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~5,184 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-01_lib_Cfg.Get_Log.md`
- Save the answer as: `notes/P2-01.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Supply.Start.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Cfg.Get` | args: none | returns the settings array or null if FDN is not initialised | replaces the D1 header
- `lib.LI.FDN.Log` | args: text (String), caller (String) | returns null; writes to log file [1] only if [7] (debug) is on | replaces 9 copies of Debug.Sub (D2)

### v9 standard header (the only allowed copy of the settings fetch)
```
$al.Settings = [THIS] -> call script lib.LI.FDN.Cfg.Get :
if not $al.Settings
 return null
end
$PageID = $al.Settings[1]
```

### Duplicate / performance notes (ANALYSIS 3 and 5)
- D1 settings fetch header copied in 26 of 31 scripts -> lib.LI.FDN.Cfg.Get + the 4-line standard header.
- D2 Debug.Sub copied 9 times (Buy.Ware, Move.Ware, Sell.Ware, Supply.Dock.Check, Supply.Dock, Supply.Factory.Check, Supply.Factory, Supply.Start, Update.Ware) -> lib.LI.FDN.Log.

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.
- Supply.Start is pasted as the pattern for the old header and Debug.Sub.

## Instruction

Phase 2, task P2-01. Write lib.LI.FDN.Cfg.Get and lib.LI.FDN.Log (two short scripts, one answer). Log must check [7] itself and keep the old log line format (time + script + text).
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
