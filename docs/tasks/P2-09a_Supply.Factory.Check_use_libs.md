# P2-09a: Supply.Factory.Check on the shared libraries

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~5,011 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-09a_Supply.Factory.Check_use_libs.md`
- Save the answer as: `notes/P2-09a.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Supply.Factory.Check.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Cfg.Get` | args: none | returns the settings array or null if FDN is not initialised | replaces the D1 header
- `lib.LI.FDN.Log` | args: text (String), caller (String) | returns null; writes to log file [1] only if [7] (debug) is on | replaces 9 copies of Debug.Sub (D2); callers do `$s.name = = get script name` and pass it
- `lib.LI.FDN.Is.Valid` | args: obj, need.dock (Boolean) | TRUE if obj exists, owner race == Player, and is a Dock if asked | B3, B12
- `lib.LI.FDN.Is.Factory` | args: station | TRUE if managed factory (Factory, not Complex Hub, detectable rule; VERIFY intent of `is detectable == 0`) | D10
- `lib.LI.FDN.Fac.Cfg` | args: factory | settings array, get-or-create, applies auto-manage once | D4
- `lib.LI.FDN.Lock` | args: obj (or null = global), key (String), action ('try'/'release'), timeout s | TRUE if acquired/released; stores `playing time`; stale after timeout | B1, B11

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
- The libraries above already exist; call them with `[THIS] -> call script lib.LI.FDN.<name> : ...`.
- No Debug.Sub left; list which D/P/B IDs the script closes.

## Instruction

Phase 2, task P2-09a. Switch Supply.Factory.Check to Fac.Cfg, Is.Valid, Is.Factory, Lock and Log. Call Supply.Factory (no START per factory).
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
