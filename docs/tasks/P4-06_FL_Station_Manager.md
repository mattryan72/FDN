# P4-06: lib.LI.FDN.Is.FL.Managed: detect FL Station Manager (approved)

- Phase: 4 (branch `phase4-compat`)
- Writes code: yes
- Estimated size: ~3,135 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-06_FL_Station_Manager.md`
- Save the answer as: `notes/P4-06.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/lib.LI.FDN.Is.FL.Managed.txt` (the current stub, to be replaced)

## Excerpts

### Compatibility notes (ANALYSIS 7)
- AP 3.3: native target (script engine 50 or more). FL 1.3: expected to work; FL patch scripts carry engine 60-74; install folder `addon2`. TC (about 44): out of scope.
- The FL Unofficial Patch 1.3.20 adds commands (e.g. `add script selection option`, `add sidebar custom entry`, `get dock storage wares`, `add object info menu`). Only use them behind a feature check.
- Always compare engine versions with >=, never ==.
- Community Plugin Configuration 1.61 is optional in v9; a hotkey is the fallback.

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Is.FL.Managed` | args: station | TRUE only on FL ([23] == 3) when the station is run by Station Manager; always FALSE on AP. Detection (confirmed by T9b): `egosoft.stationmgr.time` is a number and `playing time` minus it is <= 10 | FL Station Manager decision
- `lib.LI.FDN.Game` | args: none | returns 1 TC / 2 AP / 3 FL from `script engine version` with >= thresholds (VERIFY values) | replaces lib.BW.isAP uses

### Decision (approved by Matt 2026-10-17, REFERENCE H)
Any station run by FL's Station Manager is dropped from FDN: removed from [3]/[4]; if it is the DC, FDN pauses. Player message (text 330/331) and a log line (332), once per drop. Scan already calls Is.FL.Managed at its exists/owner checks (Phase 2 stub returns FALSE).

## Key facts

- Phase 4 = compatibility and upgrade. Never break the save-game rules in CORE RULES.
- Never invent commands; FL patch commands need a citation or VERIFY.
- Use the engine numbers from NOTES_semantics.md if included; otherwise mark VERIFY.
- T9 (2026-10-17): the SM station has the extra locals `egosoft.stationmgr.time`, `egosoft.stationmgr.blacklist` (and `egosoft.price.time` from auto prices); the normal station has none. `is task running 448` was FALSE on both: 448 is the FL constant `[Task.StationMgr]`, and passing it as a plain number checks the wrong slot. Extra task ids 10/11/24/25 on the SM station are not reliable alone.
- FL's `!station.cmd.manage.pl` rewrites `egosoft.stationmgr.time` = `playing time` every 1 s while SM runs; `plugin.stationmgr.run` stops when it is more than 10 s old. No FL script clears it, so use **freshness, not existence**: `$t = $station -> get local variable: name='egosoft.stationmgr.time'`; TRUE if `is datatyp[ $t ] == DATATYPE_INT` and `( playing time - $t ) <= 10`. **Confirmed 2026-10-17 (T9b):** SM on: time 3797 at playing time 3798, and both `[Task.StationMgr]` checks TRUE. SM off: 59 s stale, both FALSE. No VERIFY needed.
- The `[Task.StationMgr]` checks are valid on FL (T9b) but are FL-only constants. Do not use them in this lib, which must load on AP; mention them only as a manual test aid.
- Use the confirmed T9/T9b rule from NOTES_semantics.md. The Phase 2 placeholder (returns FALSE) exists only because `[23]` (lib.LI.FDN.Game) arrives in Phase 4. Replace it here.
- Must return FALSE on AP without running any FL-only command (check [23] == 3 first).
- House style (Matt's rules, always): a discarded call result is written ` = [THIS] -> call script ...`, never `$null =`. No AND, OR, && or || (nest `if` blocks). No `!=` (use `if not $a == $b`). No array element inside a condition (copy it to a local first). No `->` or calls inside a condition (assign first, then test the variable). `null == null` is FALSE, so test with `is datatyp[ $x ] == DATATYPE_NULL`. Block balance: `if` lines (not counting `else if`) plus `while` lines must equal `end` lines.
- Edit rules for this task: use only your normal file tools, no `python -c`, PowerShell or any shell command on the source file (a shell edit wiped a file on 2026-10-27). If something fails, stop and tell Matt exactly what failed; do not retry in a loop.
- Settings [23] is written by Setup.Keys from lib.LI.FDN.Game (1 TC, 2 AP, 3 FL). The settings array has 30 entries after P4-04; read it with `[THIS] -> call script lib.LI.FDN.Cfg.Get :` (it returns the shared array or null).
## Instruction

Phase 4, task P4-06. Edit only `source_readable/lib.LI.FDN.Is.FL.Managed.txt`. Replace the whole file with the version below, using your file write tool (overwrite the file in one go; Matt's assistant fixes the line endings afterwards). Copy the code exactly; the only text you may adapt is the header description lines if a line is wrong. The code block is final.

```
* Script: lib.LI.FDN.Is.FL.Managed  (v2, engine 50)
* Desc: FDNv9 - TRUE if a station is run by FL Station Manager and must be dropped from the network
* Arg 0: station (Value) 'station'
* Author: Logain Abler
* -----------------------------------------------------------------------------------
* Synchronous wait-free helper. Single owner of the approved FL Station Manager exclusion
* check (REFERENCE H, tests T9 and T9b, confirmed in game 2026-10-17). On Farnham's Legacy a
* station run by Station Manager is dropped from [3]/[4] and, if it is the DC, [2].
* Rule: FL only (settings [23] == 3) and the station local egosoft.stationmgr.time is a number
* that is no more than 10 s older than playing time. FL rewrites that local every second while
* Station Manager runs and nothing clears it, so freshness is used, not existence.
* No FL-only command is run on AP or TC: [23] is checked first.

* Arguments:
* - station (Value): Station to test against the FL Station Manager rule

* Returns values:
* - [TRUE]  only on FL, for a station whose egosoft.stationmgr.time local is <= 10 s old
* - [FALSE] on AP/TC, when the settings are missing or [23] is not 3, or the local is missing, not a number or stale
* - null for bad input (not a station, or it does not exist); Scan treats null as FALSE

* Version: 2.0
* Date: 28/10/2026
* Tested: not tested
* -----------------------------------------------------------------------------------

* v9.01 P4-06: real Station Manager detection (replaces the Phase 2 stub)
if not is datatyp[ $station ] == DATATYPE_STATION
 return null
end
$exists = $station  ->  exists
if not $exists
 return null
end
* FL only: settings [23] == 3. Copy the element to a local before any condition
$al.Settings = [THIS] -> call script lib.LI.FDN.Cfg.Get :
if not $al.Settings
 return [FALSE]
end
$n.settings = size of array $al.Settings
if $n.settings < 24
 return [FALSE]
end
$game = $al.Settings[23]
if not is datatyp[ $game ] == DATATYPE_INT
 return [FALSE]
end
if not $game == 3
 return [FALSE]
end
* Station Manager rewrites this local with playing time every second while it runs
$sm.time = $station  ->  get local variable: name='egosoft.stationmgr.time'
if not is datatyp[ $sm.time ] == DATATYPE_INT
 return [FALSE]
end
$now = = playing time
$age = $now - $sm.time
if $age > 10
 return [FALSE]
end
return [TRUE]
```

After saving, re-read the saved file and report: the total line count, the block-balance counts (if / while / end), and the exact lines you wrote for `$sm.time = ...` and `$now = ...`. Say "not tested". Do not touch any other file.
Start with "Assumptions" and "Questions for Matt" (short, or "none"), then keep the report short.