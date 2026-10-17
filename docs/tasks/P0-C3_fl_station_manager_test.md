# P0-C3: FL only: test how to detect a station run by Station Manager (T9)

- Phase: 0 (branch `phase0-setup`)
- Writes code: yes
- Estimated size: ~2,866 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-C3_fl_station_manager_test.md`
- Save the answer as: `notes/P0-C3.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`

## Excerpts

### Why this test
Matt decided (2026-10-17) that on Farnham's Legacy any station run by the native Station Manager is dropped from FDN. We do not know yet how a script can tell. Candidates: a local variable FL sets on the station, the station's current command, or a command from the FL Unofficial Patch 1.3.20 list (https://www.xpluginmanager.co.uk/addons/x3-farnhams-legacy-addons/x3fl-unoffical-patch/). This test finds out.

**Results (FL, 2026-10-17, NOTES_semantics T9):** the SM station has the extra locals `egosoft.stationmgr.time` and `egosoft.stationmgr.blacklist`; `is task running 448` is FALSE on both stations (448 is the FL constant `[Task.StationMgr]`, not a slot number). FL's scripts refresh `egosoft.stationmgr.time` every 1 s and never clear it, so the proposed rule is freshness (<= 10 s). **Confirmed by T9b:** SM on gave time 1 s old and both task checks TRUE; SM off gave 59 s stale and both FALSE. Card done.

## Key facts

- FL only. Matt puts one station under Station Manager and leaves a similar station without it.
- Log to file 9999; script 25 lines or fewer; name `test.LI.FDN.T9`; argument: the station to inspect.
- Every candidate command you use must be marked `VERIFY:` with where you got it from, unless it appears in the primer.
- Do not change anything on the station; read only.

## Instruction

Phase 0, task C3. Write test script T9 that logs, for the station passed as an argument: its name, `get local variables` names (whatever pattern lists them all), its current command if a command exists for that, and any Station Manager check you can cite from the FL Unofficial Patch list. Tell Matt to run it on both stations and compare the two logs. Say which difference would make a reliable detection.
