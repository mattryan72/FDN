# Phase 2: Shared libraries and engine optimisation

**Paste with:** MASTER_PROMPT, REFERENCE (§D contracts), ANALYSIS §3 (D-clusters) + §5 (P-issues), and the scripts named in the step.
**Branch:** `v9/phase2-libs`. One lib per answer, then one consumer per answer.

### 2a. Write the libraries (paste no FDN scripts except the ones named)
1. `lib.LI.FDN.Cfg.Get` + `lib.LI.FDN.Log` (paste `Supply.Start.txt` as the D1/D2 pattern).
2. `lib.LI.FDN.Is.Valid` + `lib.LI.FDN.Is.Factory` (paste `Sector.Array.txt`).
3. `lib.LI.FDN.Ware.Rec` (paste `Update.Ware.txt` (Add.Ware.Sub) and `Wares.Summary.txt`). Defaults per REFERENCE §B; `create=FALSE` must never write.
4. `lib.LI.FDN.Fac.Cfg` (paste `Supply.Factory.Check.txt` (factory-settings init, cluster D4)).
5. `lib.LI.FDN.Lock`: object local `FDN.Busy.<key>` (text 4100) or the global key, storing `playing time`, with a timeout. No waits.
6. `plugin.LI.FDN.Scan` + `lib.LI.FDN.Sectors`: Scan does the single station pass (one loop, no O(n²) `find in array`; use a temporary "seen" local or sorted merge, and VERIFY the cost), fills `[3]`, `[4]`, `[8]`, `[15]` and sets `[16]`. Sectors only reads `[15]`. Include the advanced satellites for mode 3. Scan yields (`wait`) every 50 stations.
7. `lib.LI.FDN.Trade` (decision R-T1: **keep** the docked drone, hardened). Implement REFERENCE §G exactly: guards, price sanity, clamps, runtime type resolution, null-checked create, wait-free create→destruct with a single `Exit:` label, trade loop, record update and reconcile, log codes. Paste `Buy.Ware.txt`, `Sell.Ware.txt` and the Phase 0 C5/C6/E notes. Second answer: the orphan sweep in `plugin.LI.FDN.Cleanup` (STARTed on init/reinit; resets `[18]`, `[26]`). Add texts 310, 4101 and 4102.

### 2b. Switch the engine to the libraries
8. `plugin.LI.FDN.Supply.Start`: START `Scan` only when `[16]` is stale (`[17]` s). Run the factory pass via **call** (not START) inside one task with a budget of `[22]` factories per tick, using cursor `[13]` (**P4**).
9. `plugin.LI.FDN.Supply.Factory.Check` / `Supply.Factory`: use Fac.Cfg, Ware.Rec, Is.Valid, Lock, Log. Supply.Factory becomes a called routine (no START per factory).
10. `plugin.LI.FDN.Supply.Dock.Check` / `Supply.Dock`: same pattern. Sell is triggered through Lock and the trade-task cap `[18]`/`[19]`.
11. `plugin.LI.FDN.Buy.Ware` / `Sell.Ware`: use Sectors (from the cache) or a single `find station … max.jumps=N, startsector=<DC sector>` (**P3**). Use `lib.LI.FDN.Trade` (Buy.Ware: home = DC, dest = factory). Take the `FDN.Trade.<ware>` lock and increment `[18]` only below `[19]`. Release and decrement on every exit through one exit label.
12. `plugin.LI.FDN.Update.Ware`, `Move.Ware`: use Ware.Rec and Log.
13. Turn `plugin.LI.FDN.Sector.Array` and `plugin.LI.FDN.Format.Name` into thin wrappers (call the libs) for now; Phase 3 removes their callers.

**Checks per answer:** no Debug.Sub left in the script; the header is the 4-line standard; the script lists which D/P IDs it closes.
**Done when:** a 2-hour SETA run in the sandbox with 20+ factories shows a flat FDN task count (log a counter per tick: active trade tasks `[18]`, factories processed, scan runs), supply works as at baseline, and scans happen ≤ 1 per `[17]` s. Trade tests: a no-money DC, a foe or destroyed partner, a full partner and an invalid `[25]` type all return 0 with a logged reason. Saving and reloading mid-run leaves no `FDN.Trade.Drone` ship (the sweep logs 0). Sell stock reconciles with the trade log. Tag `v9-phase2`.
