# Phase 0: Inventory, tooling and baseline (Matt and the AI together)

**Branch:** `phase0-setup` (already created). The readable source is in `source_readable/`.
**AI sessions:** one task card per chat, built with `python tools/build_prompt.py docs/tasks/<card>.md`. The cards are listed in `docs/tasks/README.md`. Do not paste the master prompt, the whole reference or the whole analysis any more: the cards carry the parts they need.
**Goal:** be certain the analysis matches the code, the compile path works, and you have a baseline save and log before any change.

## Matt does (no AI needed)
1. ~~Set up git and the readable source.~~ **Done:** this repo already has v8.04 committed (tag `v8.04-baseline`), the `phase0-setup` branch, and `source_readable/`.
2. Install the tools:
   * **Python 3** for `tools/build_prompt.py` (python.org, tick "Add python.exe to PATH"; or in PowerShell `winget install Python.Python.3.12`).
   * **AP:** X-Studio 1.08 (xdownloads.co.uk, "X-Studio.v1.08.14.Feb.2014.rar"). Point it at the folder containing `X3AP.exe`.
   * **FL:** XScript Compiler 0.8 beta + VS Code extension (https://www.xpluginmanager.co.uk/xscript/).
   * Plugin Manager 1.92 (https://www.xpluginmanager.co.uk/download/x-plugin-manager-installer/). Optionally Community Plugin Configuration 1.61 for each game.
3. **Round-trip test (decides PIPELINE):**
   * XScript: `XScriptCompiler.exe --load_data default_data.dat --decompile plugin.LI.FDN.Setup.xml --out Setup.xs`, then `--compile Setup.xs --out Setup.new.xml`. Load the FL game with `Setup.new.xml` renamed to `plugin.LI.FDN.Setup.xml` and check that FDN still appears in the config menu. Then try the same compiled file in **AP**. If FL works, set `PIPELINE = XSCRIPT` for FL work. If AP rejects it, keep X-Studio for AP builds.
   * X-Studio: open `src/scripts/plugin.LI.FDN.Format.Name.xml`, add a comment line, save, and check that it loads in AP.
4. **Baseline save:** start a sandbox game (AP and/or FL) with cheats or a custom start, and give yourself 1 dock (DC), 1 second dock, 3 factories in 2 sectors, and money. Install FDN v8.04, set the DC, and turn on Supply Debug. Play 10 min with SETA. Keep `log09910.txt` and the save as **baseline** (copy the log into `tests/`).
5. **E. Trade-mechanism test (documents behaviour only, changes nothing):** on the baseline save, note your trade rank (Player profile: rank name and %), player money, the DC's account, and the Statistics screen trade/money lines. Run about 20 FDN trades (factory buys and dock sells, debug on, SETA), then note them all again. Record in `notes/NOTES_semantics.md`: did the rank or statistics change? Which account paid for buys (DC/homebase or player) and which received sales? Also run the T5/T6 test scripts from card P0-C2.
6. Run test script T7 (card P0-C1) in each game and note the `script engine version` numbers for AP/FL in `notes/NOTES_semantics.md`. They go into `lib.LI.FDN.Game` later.

## AI does (one card per chat, in this order)
| Card | What it does | Paste (the builder does this for you) |
|---|---|---|
| `P0-A_data_dictionary` | Checks the settings array and ware record tables against the code | `al.LI.FDN.event`, `Update.Ware`, `Supply.Start` |
| `P0-B-B1_lock_collision` | Confirms or rejects B1 | `Supply.Start`, `Supply.Factory.Check` |
| `P0-B-B2_create_null_pointer` | B2 | `Update.Ware` + two short line ranges |
| `P0-B-B3_dc_owner_checks` | B3 | `Supply.Start`, `Supply.Factory`, `Supply.Factory.Check`, `Supply.Dock.Check`, a Main.Menu range |
| `P0-B-B4_null_sell_cap` | B4 | `Supply.Dock`, `Sell.Ware` |
| `P0-B-B7_dynamic_index` | B7 | `Menu.Dock.Details_D`, `Config.Menu`, a Main.Menu range |
| `P0-B-B9_reset_regex` | B9 | `Reset` |
| `P0-C1_semantics_tests` | Tiny test scripts T1-T4, T7 and T8 (null compare, reverse array, array references, destroyed objects, engine version, regex `^` / `\.` support) | primer + `Supply.Start` as a syntax example |
| `P0-C2_drone_tests` | Test scripts T5-T6 for the trade drone (create ship checks, does destruct fire signals) | primer + the drone lines of `Buy.Ware` / `Sell.Ware` |
| `P0-D_changelog_draft` | Drafts the v9.01 CHANGELOG skeleton | `CHANGELOG.md` |

**Progress:** P0-A done 2026-10-17 (checked; see `notes/P0-A_findings.md`). It confirmed B1 and B2, so cards P0-B-B1 and P0-B-B2 are optional now; it also corrected the [11] range and found B29.

**Progress:** P0-B done 2026-10-17 for B3, B4, B7 and B9 (checked; see `notes/P0-B_findings.md`): B3, B7 and B9 confirmed; B4 partly confirmed and waits on test C1 T1 (`null >= 0`). The B7 fix is one line. C1 now also has T8 (does X3 regex support `^` and `\.`?) for the B9 fix.

You run the test scripts and record the log results in `notes/NOTES_semantics.md`. Check every answer with `docs/CHECKING_ANSWERS.md`.

**Done when:** PIPELINE is decided, the baseline save and log exist, `notes/NOTES_semantics.md` exists (including the E trade results and engine versions), and the bug list is confirmed. Commit and tag `v9-phase0`.
