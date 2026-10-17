# P2-07a: Write lib.LI.FDN.Trade (hardened trade drone, R-T1)

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~6,317 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-07a_lib_Trade.md`
- Save the answer as: `notes/P2-07a.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- source_readable/plugin.LI.FDN.Buy.Ware.txt lines 040-100
- source_readable/plugin.LI.FDN.Sell.Ware.txt lines 030-125

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Trade` | args: mode ('buy'/'sell'), partner (NPC station), ware, amount, home (player station whose account pays/receives), dest (optional, buy only) | units traded (0 on any failure, never null/negative). Wait-free. | D9, B15

### lib.LI.FDN.Trade spec (REFERENCE G)**Why it exists:** MSCI has no station-to-station trade command. A docked ship's `buy`/`sell` is the only way into the native economy (real price, homebase account, NPC stock, possibly trade rank/stats). The drone is created already docked and destroyed in the same wait-free block, so freight was never visible. Keeping it changes nothing the player sees.
**Invariants:** nothing waits between `create ship` and `destruct` (a drone can never end up in a save). One exit label: every path does `goto label Exit:`. Because the lib is wait-free, at most one drone exists at any moment. Log a reason code at every decision via `lib.LI.FDN.Log` (e.g. `TRADE skip foe`, `TRADE clamp money 120`, `TRADE spawn fail <type>`).
1. **Guards (before any spawn):** mode is 'buy'/'sell'; amount > 0; partner `exists`, owner race != Player, `$home -> get relation to object $partner` != Foe, `$partner -> get sector` non-null and in `lib.LI.FDN.Sectors(3)` (still in a trade sector); `lib.LI.FDN.Is.Valid($home)` (exists, Player-owned); dest (if given) valid too; `[18] <= [19]` (defensive; the caller owns the counter).
2. **Price sanity:** `$price = $partner -> get price of ware $ware` > 0 and between `get min price of ware $ware` and `get max price of ware $ware`. Buy: `$price <= rec[4]`. Sell: `$price >= rec[6]` (home record via `lib.LI.FDN.Ware.Rec(home, ware, FALSE)`).
3. **Clamp the amount (log each clamp; 0 → Exit):** buy: partner `get amount of ware $ware in cargo bay` (stock), dest `get free amount of ware $ware in cargo bay`, and money / `$price` from the account `buy` debits (`$home -> get money`; VERIFY in Phase 0 E whether it is the homebase or the player account, `get player money`). Sell: partner `get free amount of ware $ware in cargo bay` (demand/free space) and the home's physical + virtual stock.
4. **Drone type (resolved at runtime, so XRM/TShips mods can't break it):** try `[26]`, then each entry of `[25]`, then `get ship type array: maker race=<race> class=TS` for the core races (≤ 4 spawn attempts in total). Each attempt: `$drone = create ship: type=$t owner=Player addto=$partner x=null y=null z=null`. If the result is null or not `exists`, log it and try the next type. Immediately `set name to` (text 310), `set local variable: name=<4102> value=playing time`, `set homebase to $home`, and give it no command. Accept the type only if `$drone -> is docking allowed at $partner`, `-> can transport ware $ware` and `-> get max amount of ware $ware that can be stored in cargo bay` > 0. Otherwise destruct it and try the next type. Cache the winner in `[26]`. If none passes, log ERROR and return 0.
5. **Trade loop:** at most `[27]` loads, each ≤ the drone's max. Buy: `$n = $drone -> buy $chunk units of $ware`, then empty the drone (`= $drone -> add -$n units`, the v7.2 pattern) and `= $dest -> add $n units of $ware`. Sell: `= $drone -> add $chunk units`, `$n = $drone -> sell $chunk units`, then remove any leftover from the drone. A null/≤0 return ends the loop (logged, not an error). Sum the results in `$traded`.
6. **`Exit:`** `if $drone -> exists` → `$drone -> destruct: show no explosion=[TRUE]`, then `$drone = null` (repeat for a rejected candidate before trying the next). After that, only if `$traded > 0`: sell → `plugin.LI.FDN.Update.Ware` action='remove' amount=`$traded` station=home. If the returned amount < `$traded`, **reconcile**: take the difference from physical cargo, then virtual `[0]`, never below 0, and log `TRADE reconcile` with the virtual/physical values. Buy → delivery is already physical (step 5). Set `rec[8]` = playing time and return `$traded`. Home stock is never removed before a confirmed sale.
* **Side effects:** VERIFY (Phase 0 C6) whether `destruct: show no explosion` fires SIGNAL_KILLED (secondary or global-map handlers), changes the "ships lost" statistic, or shows a message. Mitigation: name and tag the drone *before* trading so cooperating mods can skip it, and never START a command on it. If Phase 0 shows a visible effect, look for a per-ship signal override in the command list (VERIFY), or document it as a known issue. The same applies to FL patch create hooks.


## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.
- Nothing may wait between `create ship` and `destruct`. One `Exit:` label; every path goes there and destructs the drone if it exists.
- Settings: [18] active trade tasks, [19] max, [25] drone type list, [26] resolved type cache, [27] max loads per call.
- Use the NOTES_semantics results (tests C5, C6, E) if included; otherwise mark those points VERIFY.

## Instruction

Phase 2, task P2-07a. Write lib.LI.FDN.Trade exactly to the spec above: guards, price checks, clamps, runtime drone type, null-checked create, trade loop, Exit with destruct, record update and reconcile, a log reason at every decision. Also give the text lines for ids 310, 4101 and 4102.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
