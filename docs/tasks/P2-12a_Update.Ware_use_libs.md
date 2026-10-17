# P2-12a: Update.Ware on the shared libraries

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~4,665 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-12a_Update.Ware_use_libs.md`
- Save the answer as: `notes/P2-12a.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Update.Ware.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Cfg.Get` | args: none | returns the settings array or null if FDN is not initialised | replaces the D1 header
- `lib.LI.FDN.Log` | args: text (String), obj (Value, optional) | returns null; writes to log file [1] only if [7] (debug) is on | replaces 9 copies of Debug.Sub (D2)
- `lib.LI.FDN.Ware.Rec` | args: station, ware, create (Boolean) | record array (created with v9 defaults if create) or null; create=FALSE never writes | D3, B2, B18

### Bug notes
- B30 (suspected, FL log 2, 2026-10-17) Update.Ware 051-057: after `gosub Add.Ware.Sub:` the new record is not re-read, so `$ware.array`/`$virtual.stock` stay null. The first remove from a DC ware with no record returned null (`Buy null` lines at 01:30:02), and L112 may still remove DC physical stock. Fix: re-read the record (or use the record Ware.Rec returns) before using it.

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

Phase 2, task P2-12a. Switch Update.Ware to Ware.Rec and Log. Keep its arguments and return the real amount moved. B29: delete the dead Debug.Sub (L151-157, never called) and add lib.LI.FDN.Log calls at the add/remove/create decisions.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
