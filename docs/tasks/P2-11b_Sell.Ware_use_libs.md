# P2-11b: Sell.Ware on the shared libraries

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~4,537 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-11b_Sell.Ware_use_libs.md`
- Save the answer as: `notes/P2-11b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Sell.Ware.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Cfg.Get` | args: none | returns the settings array or null if FDN is not initialised | replaces the D1 header
- `lib.LI.FDN.Log` | args: text (String), obj (Value, optional) | returns null; writes to log file [1] only if [7] (debug) is on | replaces 9 copies of Debug.Sub (D2)
- `lib.LI.FDN.Is.Valid` | args: obj, need.dock (Boolean) | TRUE if obj exists, owner race == Player, and is a Dock if asked | B3, B12
- `lib.LI.FDN.Ware.Rec` | args: station, ware, create (Boolean) | record array (created with v9 defaults if create) or null; create=FALSE never writes | D3, B2, B18
- `lib.LI.FDN.Lock` | args: obj (or null = global), key (String), action ('try'/'release'), timeout s | TRUE if acquired/released; stores `playing time`; stale after timeout | B1, B11
- `lib.LI.FDN.Sectors` | args: mode (1 factories, 2 docks, 3 trade = all + adv. sats) | sector array from cache [15], never scans | replaces Sector.Array readers
- `lib.LI.FDN.Trade` | args: mode ('buy'/'sell'), partner (NPC station), ware, amount, home (player station whose account pays/receives), dest (optional, buy only) | units traded (0 on any failure, never null/negative). Wait-free. | D9, B15

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

Phase 2, task P2-11b. Switch Sell.Ware to Sectors and lib.LI.FDN.Trade (home = dock) with the same lock and counter rules as Buy.Ware.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
