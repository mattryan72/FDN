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
- `lib.LI.FDN.Log` | args: text (String), caller (String) | returns null; writes to log file [1] only if [7] (debug) is on | replaces 9 copies of Debug.Sub (D2); callers do `$s.name = = get script name` and pass it
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

Phase 2, task P2-12a. Switch Update.Ware to Cfg.Get, Ware.Rec and Log. Keep its four arguments (ware, amount, station, action) and its return values exactly: 'add' returns the amount actually added (physical + virtual), 'remove' returns the amount actually removed, 0 when amount is not > 0, null for 'create' or when FDN settings are missing. Callers depend on this: lib.LI.FDN.Trade (sell), Supply.Dock, Supply.Factory, Move.Ware and Main.Menu all call it, and Trade's sell reconcile trusts the 'remove' return. Rewrite the whole script as clean v9.01 source (the pasted file is v7 with patches and old line numbers; drop all of those, no source line numbers in comments).

Rules specific to this card:
1. DO NOT CHANGE THE ARITHMETIC. The dock 'add' split (physical first, rest to virtual [0]), the non-dock 'add' clamp to free space, and the 'remove' split (virtual first, then physical, floor at what exists) must keep exactly the same results. Only the record access, guards and logging change. Keep `$station -> is of class Dock 2007` for the virtual-stock decision.
2. HEADER: standard Cfg.Get header (return null if not $al.Settings). Delete $PageID, $DebugID, $script/$pointer sprintf (Ware.Rec owns the record name), Debug.Sub (B29, dead code) and all line-number comments. $s.name = = get script name; $debug.on = $al.Settings[7].
3. GUARDS (new, each logs when $debug.on and returns the safe value): ware not set; station not `is datatyp[ $station ] == DATATYPE_STATION` or does not exist (check the datatype BEFORE any -> call; return 0 for add/remove, null for create); action must be exactly 'create', 'add' or 'remove' (today anything that is not 'add' silently runs the remove branch - an unknown action must log and return 0 for non-create). Test action with single conditions, no OR.
4. RECORD: read with lib.LI.FDN.Ware.Rec station=$station ware=$ware create=[FALSE]. If null and a record is needed (the 'create' action, or any amount > 0 on a Dock), call Ware.Rec again with create=[TRUE] and use the returned record directly (this closes B30: no second re-read needed, and Ware.Rec create already registers the station via Reg.Add, so the old inline settings[29] registry code and Add.Ware.Sub's array build are deleted). 'create' on an existing record must write nothing.
5. SHOW-ON-DOCK TRICK: Add.Ware.Sub did, after creating a record, `if not physical.check > 0` then add 1 unit and add -1 unit of the ware so the ware shows on the dock. Ware.Rec does NOT do that. Keep it in a tiny sub (e.g. Show.Ware.Sub:, gosub, endsub placed after the final return) that runs only right after a record was newly created in this call (both for 'create' and for the Dock path).
6. LOG (lib.LI.FDN.Log, text built into $txt.log first, leading `= ` on the call, station and ware in every line): when a record is created; 'add' with amount, how much went physical and how much virtual; 'remove' with amount, how much came from virtual and from physical; each guard failure. Not in the arithmetic branches' hot path more than once per call.
7. One `return` per path is fine here (no locks or counters to release, so no Exit: label is needed), but every path must return the documented value. Block balance, no AND/OR/!=, no trailing comments, comments on their own line.
8. Header: `* Tested: not tested`, Version 8.0 (engine line v8), Date 26/10/2026, Returns values block as above, change block listing D1, D2 (one of nine), D3, B2/B9 (via Ware.Rec), B29, B30.
9. notes/P2-12a.md (ASCII, CRLF, editor tool, `$names` literal) plus one CHANGELOG line under `### Changed` placed AFTER the Sell.Ware line (do not move or delete any other CHANGELOG line, ASCII hyphens only).
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.