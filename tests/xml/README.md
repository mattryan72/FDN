# FDN Phase 0 test scripts (ready-to-load XML)

Loadable X3 script files for tests T1-T9, built from the XScript sources in `xs/`.
They replace typing the `tests/*.txt` listings into the in-game script editor.

## Install (Farnham's Legacy)

1. Close the game.
2. Copy every `*.xml` in this folder (not `xs/`) into the game's `addon2\scripts\` folder
   (Steam: `...\steamapps\common\x3 terran conflict\addon2\scripts\`).
3. Start the game and load your test save.

## Run

1. Open the script editor (pilot name `Thereshallbewings`, or the UP setting), then Shift+C, S.
2. Pick the script in the list, press `r`, then Enter for "run on: null".
3. Arguments: T5 and T6 then ask for a ware; T9 asks for a station. **Pick one from the
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
- T9: new script (P0-C3). It logs local variables, whether task 448 (Station Manager) is running, and all running task ids.

## Rebuild (box only)

`/workspace/x3tools/build/build.sh` compiles with XScriptCompiler v0.8 under wine, then runs `fix.py`.
fix.py escapes `<`/`&`, fixes duplicated arguments and sets engineversion 50.
