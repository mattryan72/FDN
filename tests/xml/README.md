# FDN Phase 0 test scripts (ready-to-load XML)

Loadable X3 script files for tests T1-T9 and T9b, built from the XScript sources in `xs/`.
They replace typing the `tests/*.txt` listings into the in-game script editor.

## Install (Farnham's Legacy)

1. Close the game.
2. Copy every `*.xml` in this folder (not `xs/`) into the game's `addon2\scripts\` folder
   (Steam: `...\steamapps\common\x3 terran conflict\addon2\scripts\`).
3. Start the game and load your test save.

## Run

1. Open the script editor (pilot name `Thereshallbewings`, or the UP setting), then Shift+C, S.
2. Pick the script in the list, press `r`, then Enter for "run on: null".
3. Arguments: T5 and T6 then ask for a ware; T9 and T9b ask for a station. **Pick one from the
   selection** (for example Energy Cells, or the station). Pressing Enter or Esc on an empty
   prompt passes null, and the test only logs an abort line. The other tests take no arguments.
4. Results are written to `Documents\Egosoft\X3FL\log09999.txt`.

`plugin.LI.FDN.T6.KillHandler` is not run directly; T6 calls it. T9 is FL only: run it once on a
station under Station Manager and once on a similar station without it.

## Differences from the text listings in tests/*.txt

- T2/T3: array elements are read into temp variables first (MSCI expressions cannot index arrays).
- T4: the drone is created in the player's sector, not inside the player ship.
- T4/T5/T6: drone type is `SS_SH_A_TS_5`, the same type FDN v8 Buy.Ware/Sell.Ware use.
- T6: `add secondary signal` takes prio=100 and name='FDN.T6' (the command has four parameters).
- T8: the regex is tried with one backslash, two backslashes and `[.]`, because string escaping is unverified.
- T9: new script (P0-C3). It logs local variables, whether task slot 448 is running, and all running task ids.
  Note: it passes 448 as a plain number, but FL's scripts use the task constant `[Task.StationMgr]` (constant id 448),
  whose runtime slot number is probably different (the SM station gained tasks 10, 11, 24, 25), so T9's "task 448" line is not a valid Station Manager check.
- T9b: follow-up (P0-C3). Uses the constant `Tasks::StationManage` the way FL's `!station.cmd.manage.pl` does:
  `is script plugin.stationmgr.run on stack of task=[Task.StationMgr]`, `is task running [Task.StationMgr]`,
  and logs `playing time` next to the station's `egosoft.stationmgr.time`. Run it with SM on, then again some time after turning SM off.

## Rebuild (box only)

`/workspace/x3tools/build/build.sh` compiles with XScriptCompiler v0.8 under wine, then runs `fix.py`.
fix.py escapes `<`/`&`, fixes duplicated arguments and sets engineversion 50.
