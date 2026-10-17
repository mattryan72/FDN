# NOTES_semantics: Phase 0 in-game test results

Game: X3 Farnham's Legacy 1.3 with the Unofficial Patch 1.3.20 (Matt's PC, Steam, `D:\Steam\steamapps\common\X3 Terran Conflict\addon2`).
Scripts: compiled test XMLs from `tests/xml/` (sources in `tests/xml/xs/`), saved at engine 50. Run by Matt on 2026-10-17. Output from `log09999.txt`.

Status: T1-T8 done. T9 done for a station **not** under Station Manager; the positive sample (a Station Manager station) is still pending. The first T5/T6/T9 run got a null argument; rerun 2026-10-17 ~16:37 BST with the argument picked from the prompt worked (the game folder still had the old 1-based `<arguments>` XMLs, so the index base did not matter).

## Raw log

```
T1 null >= 0 -> FALSE
T1 null < 6 -> FALSE
T1 null == 0 -> FALSE
T2 before: 1/2/3
T2 returned: 3/2/1
T2 after: 1/2/3
T3 before [0]: 1
T3 after [0]: 42
T4 create ship returned Your Mercury Super Freighter XL
T4 before destruct: $obj -> exists = TRUE
T4 after destruct: if $obj = TRUE
T4 after destruct: $obj -> exists = FALSE
T5 station found: null
T5 abort: no station sells null
T6 abort: no station sells null
T7 script engine version = 60
T8 regex ^FDN(one backslash). -> 1
T8 regex ^FDN(two backslashes). -> 0
T8 regex ^FDN[.] -> 1
T8 regex FDN[.] -> 1
T8 regex FDN* -> 2
T8 after clear FDN* -> 0
T9 abort: pick a station as the argument
```

### Rerun log (T5, T6, T9 with arguments)

```
T5 station found: Solar Power Plant L gamma(Akeela's Beacon)
T5 create ship returned Your Mercury Super Freighter XL
T5 exists=TRUE name=Your Mercury Super Freighter XL maker=Argon
T5 docking allowed = TRUE
T5 can transport Energy Cells = TRUE
T5 max cargo Energy Cells = 11000
T5 bad type returned Your Mammoth
T6 drone docked at Wheat Farm M beta(Cloudbase North West), handler set
T6 SIGNAL_KILLED handler fired
T6 main script finished, check KillHandler line
T9 ---- station: Your Solar Power Plant XL alpha (Your Solar Power Plant XL alpha(Akeela's Beacon))
T9 local variables: 8
T9   local: graph.data.lastmoney
T9   local: graph.data.warearray
T9   local: graph.data.player.running
T9   local: transfered
T9   local: FDN.Settings
T9   local: graph.data
T9   local: money.transfer
T9   local: graph.data.player.station
T9 task 448 (Station Manager) running = FALSE
T9 running tasks: 3
T9   task: 22
T9   task: 1
T9   task: 28
```

## Results

### T1: comparisons with null (B4)
- `null >= 0`, `null < 6` and `null == 0` are all **FALSE**. MSCI does not treat null as 0 in comparisons. Any comparison with null fails.
- **Rule:** a positive guard (`if $x >= 0`) skips null safely. A negative guard does not: `if not $x >= 0`, `if $x < 0 ... skip`, or the `else` branch of a comparison will **take** null. Always check `is datatyp[ $x ] == DATATYPE_INT` (or `if $x` for objects) before such guards.
- Arithmetic with null (`$stock - null`) was not tested. Assume it may act as 0 (VERIFY if a fix depends on it).

### T2: `reverse array` (B13)
- It returns a **new, reversed array**. The original array is unchanged (still `1/2/3`).
- **B13 confirmed.** Supply.Factory.Check L038 `$factory.array = reverse array $factory.array` swaps the local to a copy. On reversed passes `remove element from array $factory.array` (L141) edits the copy, so `[3]` keeps dead factories. The P1-02 fix (walk by index, no reverse) stands.

### T3: arrays from `get global variable`
- The returned array is a **reference** to the stored array. `$b[0] = 42` changed what the next `get global variable` returned, without `set global variable`.
- **Rule:** `$a = $al.Settings[3]` (and any array read from a global or local variable) is shared. Editing it edits the stored settings at once. Copy explicitly (new array + copy loop) when a script must not change the stored data. `set global variable` is still the safe way to replace a whole value, but it is not needed after element edits.
- With T2: only `reverse array` (and other commands that build new arrays) create copies. Plain assignment never copies.

### T4: variable holding a destroyed object (B3)
- After `destruct`, `if $obj` is still **TRUE** (the variable is not cleared), but `$obj -> exists` is **FALSE**.
- **B3 confirmed in-game:** checks like Supply.Start L046 `if $dc` do not catch a destroyed DC. Always use `-> exists`, which the MSCI_PRIMER rule already says.
- `create ship` with `SS_SH_A_TS_5` (FDN's drone type) works on FL. It is named "Mercury Super Freighter XL".

### T5: docked trade drone checks (B15)
- `create ship` with `SS_SH_A_TS_5` at an NPC station (Solar Power Plant L gamma, Energy Cells) works on FL: `exists` TRUE, name "Your Mercury Super Freighter XL", maker Argon, `is docking allowed` TRUE, `can transport ware` TRUE, max cargo 11000 Energy Cells. The drone checks in REFERENCE §G step 4 all work on FL.
- **`create ship` with type = null did not fail:** it returned "Your Mammoth" (a player-owned Mammoth created at the station). So testing the return value does **not** catch a bad type. **Rule:** validate the ship type **before** `create ship` (non-null, and a TS type, e.g. it is in `get ship type array: maker race=... class=TS`, VERIFY the exact check), then still check the result (`exists`, docking allowed, can transport, max cargo > 0). Matt's note: the Mammoth is XL, so it would fail the docking check at most stations anyway; the lesson is to validate the type first.
- Side effect: T5 did not destroy the Mammoth (`$bad` was not destructed). A player-owned Mammoth is left at Solar Power Plant L gamma (Akeela's Beacon) in that game session/save.

### T6: does destructing the drone fire SIGNAL_KILLED (B15)
- **Yes.** A secondary SIGNAL_KILLED handler on the docked drone ran on `destruct: show no explosion=[TRUE]` (drone at Wheat Farm M beta, Cloudbase North West).
- **Rule:** any SIGNAL_KILLED handler (other mods, or the game) can see FDN's drones die. v9 drones must not carry handlers, and the trade lib must stay wait-free. Still to check by hand: on-screen message and the Statistics "ships lost" line before/after (not reported yet).

### T9: Station Manager detection (P4-06), negative sample only
- Station: Your Solar Power Plant XL alpha (Akeela's Beacon), **not** under Station Manager.
- `is task running 448` (Task.Stationmanage, from the compiler's FL constants) = **FALSE**. `get all running task ids` (FL-only) = 22, 1, 28: low custom task ids from other scripts, none in the 440-455 built-in range.
- Locals: `FDN.Settings` (FDN v8: this factory is in FDN's factory list, so v8's `is detectable == 0` factory rule passes on FL), plus `graph.data`, `graph.data.lastmoney`, `graph.data.warearray`, `graph.data.player.running`, `graph.data.player.station`, `money.transfer`, `transfered`. These belong to another mod or an FL feature, not FDN.
- **Regex safety:** none of those names contain `FD`, so v8 Reset's `'FDN*'` would not touch them, and v9's `'^FDN\.'` cannot. Cleanup's `'FDND.*'` works on globals only. Keep v9 strictly anchored to `^FDN\.` so other mods' locals stay safe.
- **Still pending:** run T9 on a station that **is** under Station Manager. Detection is reliable if task 448 turns TRUE there, or a new local/task id appears only there (also watch 449 Task.Stationpricing). Until then `lib.LI.FDN.Is.FL.Managed` stays a stub (FALSE).

### T7: script engine version (lib.LI.FDN.Game)
- FL 1.3 + Unofficial Patch 1.3.20 returns **60**.
- Scripts saved at engine 50 (FDN v8.04, these tests) load and run on FL.
- `lib.BW.isAP` (`>= 50`) is TRUE on FL, as expected.
- **Still needed:** the AP 3.3 value (run T7 on AP), and ideally FL **without** the patch. The patch notes say it "increased" the engine version, so vanilla FL may return less than 60.
- Provisional thresholds for `lib.LI.FDN.Game` (VERIFY with the AP number): `>= 60` gives FL (3); `>= 50` gives AP (2); otherwise TC (1). If vanilla FL turns out to report the same as AP, the version alone cannot tell AP from FL. Then add an FL-only check as well, for example whether a script command that only FL has gives a result.

### T8: regex in `get local variables: regular expression` (B9)
- **Anchors and escapes work.** `^FDN\.` typed with **one** backslash matched only `FDN.Test.A` (1). Two backslashes (`^FDN\\.`) matched nothing (0). MSCI strings are stored literally, with no escape processing.
- `^FDN[.]` (1) and `FDN[.]` (1) also work, without a backslash.
- v8's `FDN*` matched **2**: it also hit `XFDNY`. That confirms the B9 leak in-game.
- Setting a local variable to null **removes** it. After clearing, `FDN*` matched 0, so the Reset clear method works.
- **Use for B9:** `'^FDN\.'` with a single backslash, as the plan says. `'^FDN[.]'` is an equally good fallback if a tool might double the backslash. Never write `\\` in MSCI string literals. For dynamic-menu globals, `'^FDND\.'` is the anchored equivalent of Cleanup's `'FDND.*'`.

## Pending

- **T9 positive sample:** a station run by Station Manager (see T9 above).
- **T6 by hand:** on-screen message and Statistics "ships lost" before/after a drone destruct.
- **T7 on AP 3.3** (and FL without the patch, if easy).
- **T1 extra:** arithmetic with null (`$x + null`).

## FDN v8.04 on FL: "the DC supplies nothing" (analysis 2026-10-17)

Setup: FL 1.3 + UP 1.3.20, fresh FDN v8.04 install (all 31 scripts and `t/9910-L044.xml` in `addon2` are byte-identical to the repo; no `.pck` or other copy overrides an FDN script). Matt waited more than 3 minutes. `log09910.txt` held only the header `FDN Debug Log:` (written 16:25 BST by Setup), so Supply Debug was off or the timer never ran.

No FL- or engine-60-specific blocker was found in the code: `lib.BW.isAP` is TRUE (60 >= 50), so the AP menus are used; the factory rule `is detectable == 0` passes on FL (T9 station carries `FDN.Settings`); the drone works (T5). Likely causes, most likely first:
1. **B2 blocks every dock (fresh game).** "Add Ware" (Main.Menu L475) and Supply.Dock L100 call Update.Ware `'create'`, which writes the record under a null name, so no `FDN.Ware.<ware>` record exists. Then "Remote access past stock level:" and "Maintain stock at level:" cannot be stored (they stay ` - `), and Supply.Dock needs DC remote level `> 0` (L115) and dock maintain level `>` stock (L078-084). Records only appear when Update.Ware runs with an amount `> 0` on a Dock (a factory passing products to the DC, or the DC supplying a factory). Earlier saves probably still had records from older FDN versions, which hid B2.
2. **Factory resources not switched on.** Supply needs "Resources Managed" per factory. "Auto Manage Factories" only applies to factories seen for the first time **after** it is ON (flag `[2]` in `FDN.Settings`, set by Factory.Check or by opening the Stations view). Factories already seen stay off until "FDN Manage Resources" (global command) or the per-factory toggle is used.
3. **Factory trigger not met.** A resource top-up only runs when the production cycle looks stalled (`remaining == full cycle time`) or has < 45 s left (Supply.Factory.Check L105-136). The DC must hold the ware physically, or buying must be on for that ware at the DC (needs a record, see 1).
4. **AL timer not running.** Supply only runs when the AL plugin is enabled (`[0]`) and a DC is set (`[2]`). Seeing the FDN menu in the plugin config menu implies `[0]` was TRUE at the last load (Setup removes it otherwise).
5. **Cadence.** The factory pass runs every 25 s tick. The dock pass runs every 7th tick (about 175 s) plus 1-2 s per dock and 0.5-1 s per ware, so 3 minutes is borderline for docks.

Known bugs that do **not** stop supply entirely: B1 (no real lock, so runs can overlap), B3, B4, B13 (wrong amounts or ghost entries). The dock path writes no debug lines at all (Supply.Dock.Check and Supply.Dock never call Debug.Sub). Only Supply.Start, Supply.Factory(.Check), Buy.Ware and Sell.Ware log.

## Design consideration: per-station tasks vs central timer (recorded 2026-10-17, plan unchanged)

Matt: earlier FDN versions ran a task (script) per station that called wares when needed. That hurt performance (possibly the way it was coded), so v8 moved to the current central AL timer (25 s tick; factory pass every tick, dock pass every 7th tick, about 175 s). For v9 this stays a design note, not a plan change:
- Central timer (v8, kept in v9): one loop, predictable cost, easy to pause; but latency up to one dock cycle, and a busy tick does all stations at once (v9 spreads load with `wait` every N stations in Scan and the supply loops).
- Per-station tasks: reacts per station, but N scripts each waiting/polling cost more, survive in saves, and are hard to stop or upgrade cleanly (Reset/Upgrade would have to find and kill every task).
- If latency becomes a complaint, prefer a shorter or adaptive central tick (or an event signal such as a factory product-complete signal, VERIFY) over per-station tasks.
