# P2-11b: Sell.Ware on the shared libraries

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~4,720 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-11b_Sell.Ware_use_libs.md`
- Save the answer as: `notes/P2-11b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Sell.Ware.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Cfg.Get` | args: none | returns the settings array or null if FDN is not initialised | replaces the D1 header
- `lib.LI.FDN.Log` | args: text (String), caller (String) | returns null; writes to log file [1] only if [7] (debug) is on | replaces 9 copies of Debug.Sub (D2); callers do `$s.name = = get script name` and pass it
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

Phase 2, task P2-11b. Switch Sell.Ware to Sectors (mode 3 cache) and lib.LI.FDN.Trade (mode 'sell', home = dock), with the Buy.Ware v3 exit and counter pattern. Rewrite the whole script as clean v9.01 source (the pasted file is v8 with patches and old line numbers; drop all of those, drop $PageID/$DebugID/Debug.Sub/Check.Alive.Sub, no source line numbers in comments).

Rules specific to this card (they differ from Buy.Ware in ONE way - read the lock rule):
1. LOCK: Supply.Dock (P2-10b, committed) has ALREADY taken Lock obj=$dock key='FDN.Trade.'+$ware (try, 120 s) before it STARTs this script, and does not release it. So Sell.Ware must NOT take that lock (a second try would fail on its own caller's lock and nothing would ever sell). Sell.Ware only RELEASES it at Exit: lib.LI.FDN.Lock obj=$dock key=$trade.key action='release' timeout=null. Release whenever $dock is a station (is datatyp[ $dock ] == DATATYPE_STATION); Lock returns null for a non-existent obj, so that is safe. Build $trade.key = 'FDN.Trade.' + $ware before any guard that can goto Exit:, and only release when $ware is not null.
2. COUNTER: this script owns [18]. After the guards and before the sector loop: read [18]/[19] from $al.Settings, cap check exactly as Buy.Ware v3 (nested INT checks, [19] > 0, not [18] < [19] -> log 'Sell skipped - trade task cap reached (a/b)' and goto Exit:), then `if not is datatyp[ $trade.active ] == DATATYPE_INT` set $trade.active = 0 (null [18] in saves where Cleanup has not run; null + 1 is not safe), then $al.Settings[18] = $trade.active + 1, set global variable name='al.LI.FDN.event', $counter.inc = [TRUE]. Exit: decrements exactly as Buy.Ware v3 (re-read via Cfg.Get, INT check, floor at 0, save).
3. EXIT: one Exit: label, every guard does `goto label Exit:`, one `return null` at the end. Initialise $counter.inc = [FALSE] before the first guard (also before the Cfg.Get check).
4. GUARDS (each logs when $debug.on, includes the dock in the log text): Cfg.Get; Is.Valid dock need.dock=[TRUE]; Is.Valid DC ([2]) need.dock=[TRUE]; Ware.Rec station=$dock ware=$ware create=[FALSE] (null = skip); [5] sell cap must be an INT >= 0 (-1 = selling off); [6] sell-at price must be an INT.
5. LOOP: Sectors mode=3 (null/empty = log and Exit:). Same v8 loop: while $s > 0, `dec $s =`, find station: resource $ware with best price: min.price=$sell.at (the [6] value), amount=null, max.jumps=0, startsector=$sector, trader=null, exclude array=$exclude.array. Each pass: re-read the record with Ware.Rec (create=[FALSE]), recompute $amount = (rec[0] + physical stock in the dock cargo bay) - [5]; the $amount argument from Supply.Dock is only a hint and is overwritten each pass. No amount > 0 means stop: set $s = 0 and $more = [FALSE]. If a station is found: ONE lib.LI.FDN.Trade call: mode='sell' partner=$sell.Station ware=$ware amount=$amount home=$dock (dest omitted). Non-INT result = 0. Log 'Sold N of <ware> at <station>' when > 0.
6. NO Update.Ware call and NO manual stock removal and NO drone code: lib.LI.FDN.Trade in sell mode already removes the sold units from the dock stock (Update.Ware 'remove' plus a reconcile) and stamps rec[8]. Calling Update.Ware 'remove' here would remove the stock twice.
7. WAIT: keep the 500-1000 ms wait between passes, but only `if $more`, and after it re-validate dock and DC with Is.Valid, each failure logging 'Sell stopped - dock no longer valid' / 'DC no longer valid' and doing goto label Exit:. No continue, no extra dec; use $skip flags / $more for control, no AND/OR/!=.
8. After the loop, if $amount > 0 and the loop ended without selling it, log 'No buyer found for remaining N of <ware>'.
9. Header: `* Tested: not tested`, Version 3.0, Date 26/10/2026, change block listing the D/P/B ids closed (D1, D2, B4, B12, B15, B2/B18 trade ownership). Update argument/description header lines (the old one says it is called by Supply.Factory and buys; it is called by Supply.Dock and sells).
10. notes/P2-11b.md (ASCII, CRLF, editor tool, `$names` literal) plus one CHANGELOG line. In the notes add the follow-ups: Supply.Dock's comments that say Sell.Ware 'owns' the lock go stale (Supply.Dock takes it, Sell.Ware releases it) - comment-only fix on a later card; Supply.Dock's Sell.Ware.Sub may be left as is.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.