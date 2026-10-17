# P4-06: lib.LI.FDN.Is.FL.Managed: detect FL Station Manager (approved)

- Phase: 4 (branch `phase4-compat`)
- Writes code: yes
- Estimated size: ~3,135 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-06_FL_Station_Manager.md`
- Save the answer as: `notes/P4-06.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)

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

## Instruction

Phase 4, task P4-06. Write lib.LI.FDN.Is.FL.Managed(station) from the T9 result: FALSE if [23] != 3 or the station is null or does not exist; otherwise TRUE only if the station local egosoft.stationmgr.time is a number no more than 10 seconds older than playing time. The detection is confirmed (NOTES_semantics T9b); do not mark it VERIFY.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
