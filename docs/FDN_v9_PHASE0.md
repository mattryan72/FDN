# Phase 0: Inventory, tooling and baseline (Matt and the AI together)

**Paste with:** MASTER_PROMPT, REFERENCE, ANALYSIS §1–§3 (not the whole file), and the script(s) named in each step.
**Goal:** be certain the analysis matches the code, the compile path works, and you have a baseline save and log before any change.

## Matt does (no AI needed)
1. In your FDN working folder (make it a git repo if needed: `git init`, commit v8.04 as-is): `git checkout -b v9/phase0`. Copy `fdn_v9/source_readable/` into the repo as `src_readable/` and commit it ("readable source of v8.04").
2. Install the tools:
   * **AP:** X-Studio 1.08 (xdownloads.co.uk, "X-Studio.v1.08.14.Feb.2014.rar"). Point it at the folder containing `X3AP.exe`.
   * **FL:** XScript Compiler 0.8 beta + VS Code extension (https://www.xpluginmanager.co.uk/xscript/).
   * Plugin Manager 1.92 (https://www.xpluginmanager.co.uk/download/x-plugin-manager-installer/). Optionally Community Plugin Configuration 1.61 for each game.
3. **Round-trip test (decides PIPELINE):**
   * XScript: `XScriptCompiler.exe --load_data default_data.dat --decompile plugin.LI.FDN.Setup.xml --out Setup.xs`, then `--compile Setup.xs --out Setup.new.xml`. Load the FL game with `Setup.new.xml` renamed to `plugin.LI.FDN.Setup.xml` and check that FDN still appears in the config menu. Then try the same compiled file in **AP**. If FL works, set `PIPELINE = XSCRIPT` for FL work. If AP rejects it, keep X-Studio for AP builds.
   * X-Studio: open `plugin.LI.FDN.Format.Name.xml`, add a comment line, save, and check that it loads in AP.
4. **Baseline save:** start a sandbox game (AP and/or FL) with cheats or a custom start, and give yourself 1 dock (DC), 1 second dock, 3 factories in 2 sectors, and money. Install FDN v8.04, set the DC, and turn on Supply Debug. Play 10 min with SETA. Keep `log09910.txt` and the save as **baseline**.
5. **E. Trade-mechanism test (documents behaviour only, changes nothing):** on the baseline save, note your trade rank (Player profile: rank name and %), player money, the DC's account (`get money`), and the Statistics screen trade/money lines. Run N = 20 FDN trades (factory buys and dock sells, debug on, SETA), then note them all again. Record in `NOTES_semantics.md`: did the rank or statistics change? Which account paid for buys (DC/homebase or player) and which received sales? Also run the C5/C6 test scripts (written by the AI in step C).
6. In each game, run a 2-line test script that logs `script engine version` (write to log file 9999) and note the numbers for TC/AP/FL. They go into `lib.LI.FDN.Game` later.

## AI does (one prompt per item; paste the listed files)
A. **Verify the data dictionary** (REFERENCE §A/§B) against `al.LI.FDN.event.txt`, `plugin.LI.FDN.Update.Ware.txt` and `plugin.LI.FDN.Supply.Start.txt`. Report any mismatch.
B. **Verify the bug list:** for B1, B2, B3, B4, B7 and B9, quote the exact lines from the pasted scripts and confirm or reject each one. Files: `Supply.Start`, `Supply.Factory.Check`, `Update.Ware`, `Supply.Factory`, `Supply.Dock`, `Menu.Dock.Details_D`, `Reset`.
C. **Write 6 tiny MSCI test scripts** (≤15 lines each, page 9999 log) that settle the open semantics:
   1. `null >= 0` and `null < 6` (B4);
   2. does `reverse array` return a new array or reverse in place (B13);
   3. does `$a = get global variable` alias the stored array (write `$a[0]`, re-read the global);
   4. what `if $obj` / `$obj -> exists` return after `$obj -> destruct` (B3);
   5. `create ship` at an NPC station with a valid TS type and with an invalid/null type: does it return null? Log `-> is docking allowed at`, `-> can transport ware`, `get max amount of ware … cargo bay`, the drone's name and `get maker race` (also run under XRM if used) (B15);
   6. create a TS docked at an NPC station, `add secondary signal: signal=SIGNAL_KILLED, script=<log script>, prio=100, name='FDN.Test'`, then `destruct: show no explosion=[TRUE]`. Does the signal fire? Any player message, or a change to the "ships lost" statistic? (B15 side effects)
   Matt runs them and pastes the log back. Record the results in `NOTES_semantics.md`.
D. **Draft `CHANGELOG.md`** with a v9.01 "Unreleased" section and headings Fixed / Changed / Behaviour changes (need approval) / Removed / Compatibility.

**Done when:** PIPELINE is decided, the baseline save and log exist, the semantics notes exist (including the E trade results), and the bug list is confirmed. Commit and tag `v9-phase0`.
