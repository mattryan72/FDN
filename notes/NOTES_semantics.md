# NOTES_semantics: Phase 0 in-game test results

Game: X3 Farnham's Legacy 1.3 with the Unofficial Patch 1.3.20 (Matt's PC, Steam, `D:\Steam\steamapps\common\X3 Terran Conflict\addon2`).
Scripts: compiled test XMLs from `tests/xml/` (sources in `tests/xml/xs/`), saved at engine 50. Run by Matt on 2026-10-17. Output from `log09999.txt`.

Status: T1-T8 done. T9 done on both a normal station and a Station Manager station (2026-10-17). T9b 'off' sample done (consistent with the freshness rule); the T9b 'on' sample is pending. The first T5/T6/T9 run got a null argument; rerun 2026-10-17 ~16:37 BST with the argument picked from the prompt worked (the game folder still had the old 1-based `<arguments>` XMLs, so the index base did not matter).

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

### T9: Station Manager detection (P4-06), negative sample
- Station: Your Solar Power Plant XL alpha (Akeela's Beacon), **not** under Station Manager.
- `is task running 448` (Task.Stationmanage, from the compiler's FL constants) = **FALSE**. `get all running task ids` (FL-only) = 22, 1, 28: low custom task ids from other scripts, none in the 440-455 built-in range.
- Locals: `FDN.Settings` (FDN v8: this factory is in FDN's factory list, so v8's `is detectable == 0` factory rule passes on FL), plus `graph.data`, `graph.data.lastmoney`, `graph.data.warearray`, `graph.data.player.running`, `graph.data.player.station`, `money.transfer`, `transfered`. These belong to another mod or an FL feature, not FDN.
- **Regex safety:** none of those names contain `FD`, so v8 Reset's `'FDN*'` would not touch them, and v9's `'^FDN\.'` cannot. Cleanup's `'FDND.*'` works on globals only. Keep v9 strictly anchored to `^FDN\.` so other mods' locals stay safe.

### T9: Station Manager detection, positive sample (2026-10-17)
- Station: Your Solar Power Plant XL alpha (Argon Prime gamma), **under** Station Manager. 11 locals: `egosoft.price.time`, `egosoft.stationmgr.time`, `egosoft.stationmgr.blacklist`, plus the same 8 as the normal station (`graph.data.*`, `transfered`, `FDN.Settings`, `money.transfer`).
- `is task running 448` = FALSE (same as the normal station). Running tasks: 10, 22, 25, 1, 24, 28, 11 (normal station: 22, 1, 28), so 10, 11, 24 and 25 are new.
- **Detection candidate:** the station local `egosoft.stationmgr.time` (and/or `egosoft.stationmgr.blacklist`). **Task 448 as a number is rejected.** The extra task ids 10/11/24/25 are noted but not reliable alone (their numbers are not documented and may differ per game or patch).

### FL Station Manager scripts (read from the game files, 2026-10-17)
Source: the plain `.pck` scripts in `addon2\scripts` on Matt's PC (gzip XML with source text). FL's cat/dat were not opened.
- `!init.station.globalscriptmap`: the station command `COMMAND_STATION_MANAGER` (player stations) runs `!station.cmd.manage.pl`. Auto prices (`COMMAND_STATION_AUTOPRICE`) runs `!station.cmd.pricing.pl`.
- `!station.cmd.manage.pl` (engine 60): sets `egosoft.stationmgr.time` = `playing time`, then `start task [Task.StationMgr] with script plugin.stationmgr.run`. While the command runs it **rewrites `egosoft.stationmgr.time` every 1 s** and restarts `plugin.stationmgr.run` if it is no longer on the stack of `[Task.StationMgr]`.
- `plugin.stationmgr.run` (v16, Cycrow) creates `egosoft.stationmgr.blacklist` on first start. Every 6 s it reads `egosoft.stationmgr.time` and **quits if `playing time` minus that value is more than 10 s**. That is how SM notices it was switched off.
- **No script clears `egosoft.stationmgr.time` or `.blacklist`** (only `.wage` and `.unpaid` are set to null). So after SM is turned off, both locals most likely **stay on the station, with a time that stops updating**. "Local exists" alone would then give a false TRUE. Matt is retesting this.
- `[Task.StationMgr]` is FL constant 448 (text page 392002, FL only). The game resolves it to a task slot at runtime, so T9 passing the plain number 448 tested the wrong slot. T9's "task 448 = FALSE" says nothing about SM. Auto prices uses `[Task.StationPrice]` (449) and `egosoft.price.time` the same way (that is why the SM station also has `egosoft.price.time`).
- **Reliable detection (proposal, VERIFY with T9b):** TRUE when `$t = $station -> get local variable: name='egosoft.stationmgr.time'` is a number and `playing time - $t <= 10`. This is SM's own liveness rule, and it uses only standard commands, so the script also loads on AP. Optional FL-only confirmation: `$station -> is script plugin.stationmgr.run on stack of task=[Task.StationMgr]` (the check FL itself uses; constant 448 does not exist on AP).
- **T9b 'off' sample (2026-10-17, Matt confirmed SM was OFF):** `stationmgr.run on stack of Task.StationMgr = FALSE`, `task Task.StationMgr running = FALSE`, `playing time = 3448, egosoft.stationmgr.time = 3389`. The local **stays** after SM is switched off and is 59 s stale. This matches the source reading (never cleared, no longer refreshed), so the freshness rule gives FALSE and "local exists" alone would wrongly give TRUE. **Pending:** the 'on' sample (expect on-stack TRUE and a time within about 1 s of playing time). If SM is on but the time is stale or both checks are FALSE, the rule is wrong; fall back to the alternative below.
- **Source re-check (2026-10-17):** `.time` is written only by `!station.cmd.manage.pl`, on `[THIS]` = the **station**. `!init.station.globalscriptmap` maps `COMMAND_STATION_MANAGER` (FL command 100031, text page 392008) for class Station / race Player to that script, so it runs as the station's command script while the command is active. It refreshes `.time` every 1 s, and stops (leaving `.time` stale) when the command is replaced or `plugin.stationmgr.run` ends without the `sm.restart` flag. `plugin.stationmgr.run` itself only reads `.time`.
- **Alternative check, if the 'on' sample disagrees (not built yet):** `$station -> is script '!station.cmd.manage.pl' on stack of task=0`. It uses a standard command (id 1072, page 2003) with a plain script name, so it also loads on AP, where it simply returns FALSE. It assumes station command scripts run on task 0 (VERIFY). `get command` is a ship/wing command in the compiler data, and `COMMAND_STATION_MANAGER` is FL-only, so neither is used.
- **T9b** (`tests/xml/test.LI.FDN.T9b.xml`, new) logs the stack check, `is task running [Task.StationMgr]` with the constant, and `playing time` next to `egosoft.stationmgr.time`. Run it on the SM station with SM on, then again about 30 s after switching SM off.

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

- **T9b 'on' sample:** run T9b on the SM station with SM **on** (the 'off' sample is done).
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

### How v8.04 supply is started (Matt ran Supply.Start by hand, 2026-10-17)
- `plugin.LI.FDN.Supply.Start` is **one pass, not a loop**. It refreshes the station lists (Sector.Array), waits 1 s, then, if a DC is set, starts one `Supply.Factory.Check` pass (in the background). It also counts calls in `[11]`: only every 7th call starts one `Supply.Dock.Check` pass. It never starts a timer or another copy of itself.
- The repeat comes from the AL engine. `al.plugin.LI.FDN.register` runs at game load and registers `al.LI.FDN.event`. On `init`/`reinit` that script sets the plugin timer to 25 s. On every `timer` event it calls Supply.Start **only if `[0]` is TRUE**. `[0]` starts FALSE and is set TRUE only by the AL `start` event (cleared by `stop`). FL's own AL plugin (`al.plugin.x3fl` / `al.audiolfl.main`) uses the same pattern (state flag FALSE until `start`), so FL's AL engine is compatible.
- Running Supply.Start by hand skips the `[0]` check, which explains "it started when run manually": the timer path was off (`[0]` FALSE, i.e. FDN not switched on as an AL plugin) or the AL timer never fired. Whether a newly registered plugin gets `start` automatically or must be switched on by the player can't be seen in the scripts. Check it in game.
- Manual runs are harmless: each is a single pass, with no extra loop. A manual run can overlap a timer-started pass (B1: no real lock), which can supply twice in that moment but leaves nothing running. A hand run also advances the dock counter.
- Signs it is running by itself (Supply Debug ON): `log09910.txt` gets `<time>;plugin.LI.FDN.Supply.Start; Start Supply Called` about every 25 s with no hand runs. If you only see one line per hand run, the timer is not driving it.

### Why the FDN menu entry never appears on FL (2026-10-17)
- **No version check is involved.** The only game check anywhere in v8.04 is `lib.BW.isAP` (`script engine version >= 50`, TRUE on FL's 60). It is called only inside Main.Menu, after the menu is open, to pick the AP menu layouts. al.plugin.LI.FDN.register, al.LI.FDN.event and Setup check nothing but FDN's own `[0]` flag.
- **How the entry is made:** `al.LI.FDN.event` calls `plugin.LI.FDN.Setup` on the AL events `init`/`reinit`/`start`/`stop`. If `[0]` is TRUE, Setup calls `plugin.config.addscript` (Community Plugin Configuration, CPC) with section text 101 "Logain Industries Menus" and name text 102 "FDN Main Menu". There is no hotkey and no ship or station command.
- **What FL ships:** CPC is present in `addon2\scripts` (`init.community.config` v3, engine 62; `plugin.config.*`; text page 7000, "Plugin Configurations"). On **every game load**, `init.community.config` **wipes** the CPC registry (global `plugin.config`, comment "whipe all settings at begining"). It then opens the "Plugin Configurations" menu through a hotkey, `add script options`, a personal sidebar entry and a script global command. `plugin.config.addscript` (v5) stores the entry in `plugin.config[0]` and returns FALSE if that global does not exist yet.
- **Cause:** FDN registers only from AL events, not from a `setup.*` script that runs on every load after CPC's init. If the AL `init`/`reinit` event is handled before `init.community.config` runs (or, on a new game, before `plugin.config` exists), the entry is wiped or never stored, and nothing re-adds it until the next AL `start`. FDN's own removal code still reads the old CPC global `config.scripts`, which shows it was written for an older CPC that did not wipe. The exact AL vs `init.*` load order is not visible in scripts (VERIFY), but this is the only point in the path that can fail.
- **Fix (v8.04 test hotfix, built 2026-10-17):** `tests/xml/fix/setup.LI.FDN.config.xml` (source in `fix/xs/`). Setup scripts run on every load after `init.*`, and this one re-registers the menu when FDN is enabled. It is the same `plugin.config.addscript` call and texts (9910/101, 9910/102) as Setup, with all 7 CPC v5 arguments (name, author, script, display author, section, menu, is event). The same files are in the FDN_v8.04 repo under `tests\fix\`. Not installed; Matt copies the file to `addon2\scripts`. v9 already plans a hotkey fallback (P4-03) and should register from a `setup.*` script as well as on AL `start`.
## Design consideration: per-station tasks vs central timer (recorded 2026-10-17, plan unchanged)

Matt: earlier FDN versions ran a task (script) per station that called wares when needed. That hurt performance (possibly the way it was coded), so v8 moved to the current central AL timer (25 s tick; factory pass every tick, dock pass every 7th tick, about 175 s). For v9 this stays a design note, not a plan change:
- Central timer (v8, kept in v9): one loop, predictable cost, easy to pause; but latency up to one dock cycle, and a busy tick does all stations at once (v9 spreads load with `wait` every N stations in Scan and the supply loops).
- Per-station tasks: reacts per station, but N scripts each waiting/polling cost more, survive in saves, and are hard to stop or upgrade cleanly (Reset/Upgrade would have to find and kill every task).
- If latency becomes a complaint, prefer a shorter or adaptive central tick (or an event signal such as a factory product-complete signal, VERIFY) over per-station tasks.
