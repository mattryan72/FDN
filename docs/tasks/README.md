# Task cards for the local AI

One card = one short chat session with your local AI. Each card lists exactly what to paste, carries the few facts it needs, and ends with the instruction.

## How to use a card

0. You need Python 3 once: install it from python.org (tick "Add python.exe to PATH") or run `winget install Python.Python.3.12` in PowerShell.
1. Open a terminal in the repo folder (`C:\Users\mattr\Documents\X3Mods\FDN_v9.01`).
2. Build the prompt: `python tools/build_prompt.py docs/tasks/<card>.md`
3. Open the file it names in `prompts\` (for example in VS Code), select all, copy, and paste it into a **new** chat. One card per chat.
4. Save the answer in `notes\<card id>.md`, then check it with `docs/CHECKING_ANSWERS.md` before you use it.
5. Do the cards in order within a phase. Phase 1 cards need the Phase 0 results in `notes/NOTES_semantics.md` (the builder adds that file automatically once it exists).

**Running a card in Cline instead:** commit or stash first, start a new Cline task, and paste the built prompt from `prompts\` as the task (or attach it with `@prompts/<card>.txt`). Ask for a plan first; Cline follows the edit rules in CORE_PROMPT. See "Using Cline" in `docs/CHECKING_ANSWERS.md`.

`python tools/build_prompt.py --all` builds every card and prints a size table (this also regenerates everything in the untracked `prompts/` folder). Add `--stamp` to refresh the "Estimated size" line in each card after the scripts change.

Sizes are estimates (characters / 3.5). Every card is well under 16k tokens; the builder warns above 16k and refuses above 32k (override with `--force`).

If a card is out of date (for example a script grew a lot in Phase 1), edit the card itself: the `## Paste` list takes repo paths, optionally with `lines 100-180, 300-350` (Script Editor line numbers) to send only part of a big script.

## Which card fixes which bug

| Bug | Card |
|---|---|
| B1 | confirmed in P0-A; P0-B-B1 (optional), P1-01, P1-02 |
| B2 | confirmed in P0-A; P0-B-B2 (optional), P1-04 |
| B3 | confirmed in P0-B; P1-01, P1-02, P1-03, P1-06 |
| B4 | partly confirmed in P0-B; downgraded after C1 T1 (`null >= 0` is FALSE); P1-05, P1-07a |
| B5 | approved 2026-10-17 (configurable default [28]); P1-04 (keeps -1 = use default), P3-04, P3-08b, P3-08c (menus), P4-04 (upgrade), P4-04b (engine) |
| B6 | P1-12, P4-03 |
| B7 | confirmed in P0-B (one-line fix); P1-10a |
| B8 | P1-09a, P1-10a, P1-10b, P3-09 |
| B9 | confirmed in P0-B, scope approved 2026-10-17 (registry [29]); P0-C1 T8 (regex test), P1-04 + P1-08 (registry), P1-11 (Reset), P2-05b, P2-06 |
| B10 | P2-06 (split into Scan + Sectors) |
| B11 | P1-03, P2-11a/b |
| B12 | P1-05, P1-07a/b |
| B13 | confirmed by P0-C1 T2 (`reverse array` returns a copy); P1-02 |
| B14 | P1-08 |
| B15 | P0-C2 (tests), P1-07a/b, P2-07a, P2-07b |
| B16 | P1-08, P4-04 |
| B17-B26 | P1-09b, P1-13a-e (B25: P2-06; B24: P1-09a) |
| B29 | P2-12a (dead Debug.Sub in Update.Ware, found in P0-A) |
| B30 | suspected from FL log 2 (2026-10-17): Update.Ware L051-057 does not reload the record after creating it, so the first remove from a record-less DC ware returns null; P1-04, P2-12a, P3-04b (DC change) |
| Debug logging (dock pass, buy/sell, DC change) | requested by Matt 2026-10-17; P2-14, P3-04 (DC change line) |
| FL Station Manager | approved 2026-10-17; P0-C3 (test T9), P2-06 (Scan drop), P4-06 (detection) |

Design proposals beyond v9.01 (hubs with range, energy cost, freighters, status screen, ...): `docs/DESIGN_v9_direction.md`. Only item 1 (DC change event, P3-04b) is scheduled.

## Phase 0: check the analysis, write test scripts

| Card | What | Code? | Tokens |
|---|---|---|---|
| [P0-A](P0-A_data_dictionary.md) | Check the saved-data dictionary against the code | no | 5,850 |
| [P0-B-B1](P0-B-B1_lock_collision.md) | B1: is the factory-run lock really broken? | no | 5,389 |
| [P0-B-B2](P0-B-B2_create_null_pointer.md) | B2: does action='create' write the record under a null name? | no | 4,123 |
| [P0-B-B3](P0-B-B3_dc_owner_checks.md) | B3: missing DC / owner checks | no | 8,011 |
| [P0-B-B4](P0-B-B4_null_sell_cap.md) | B4: can a missing record make FDN sell all stock? | no | 5,657 |
| [P0-B-B7](P0-B-B7_dynamic_index.md) | B7: dock dynamic toggle uses the wrong index | no | 6,583 |
| [P0-B-B9](P0-B-B9_reset_regex.md) | B9: master reset regex and scope | no | 2,712 |
| [P0-C1](P0-C1_semantics_tests.md) | Write tiny test scripts for MSCI behaviour (tests 1-4, engine version, regex) | yes | 4,234 |
| [P0-C2](P0-C2_drone_tests.md) | Write test scripts for the temporary trade drone (tests 5 and 6) | yes | 4,260 |
| [P0-C3](P0-C3_fl_station_manager_test.md) | FL only: test how to detect a station run by Station Manager (T9) | yes | 2,866 |
| [P0-D](P0-D_changelog_draft.md) | Draft the v9.01 CHANGELOG skeleton | no | 3,241 |

## Phase 1: bug fixes in place

| Card | What | Code? | Tokens |
|---|---|---|---|
| [P1-01](P1-01_Supply.Start_B1_B3.md) | Supply.Start: real run-lock (B1), DC check (B3), slower scan (P1) | yes | 4,793 |
| [P1-02](P1-02_Supply.Factory.Check_B1_B13.md) | Supply.Factory.Check: lock release (B1), no reverse array (B13), owner check (B3) | yes | 5,314 |
| [P1-03](P1-03_Supply.Factory_B3_B11.md) | Supply.Factory: no lost product (B3), no duplicate buys (B11) | yes | 5,115 |
| [P1-04](P1-04_Update.Ware_B2.md) | Update.Ware: build the record name before 'create' (B2) | yes | 5,137 |
| [P1-05](P1-05_Supply.Dock_B4_B12.md) | Supply.Dock: safe sell cap (B4), re-check after waits (B12) | yes | 5,353 |
| [P1-06](P1-06_Supply.Dock.Check_B3.md) | Supply.Dock.Check: drop dead or lost docks (B3) | yes | 3,949 |
| [P1-07a](P1-07a_Sell.Ware_B4_B12_B15.md) | Sell.Ware: guard records, re-check, safer drone (B4, B12, B15) | yes | 5,171 |
| [P1-07b](P1-07b_Buy.Ware_B12_B15.md) | Buy.Ware: re-check, clamp, safer drone (B12, B15) | yes | 5,010 |
| [P1-08](P1-08_al.event_B14_B16.md) | al.LI.FDN.event: START the scheduler (B14), schema version (B16) | yes | 3,557 |
| [P1-09a](P1-09a_Main.Menu_B8_B24.md) | Main.Menu: one updater per view (B8), remove dead view-3 code (B24) | yes | 4,943 |
| [P1-09b](P1-09b_Main.Menu_B18_B19_B26.md) | Main.Menu: safe ware edits (B18, B19), confirm Remove Ware (B26) | yes | 5,333 |
| [P1-10a](P1-10a_Dock.Details_D_B7_B8.md) | Menu.Dock.Details_D: read index 2 (B7), exit on new token (B8) | yes | 5,121 |
| [P1-10b](P1-10b_DC.Details_D_B8.md) | Menu.DC.Details_D: first-draw rows and token exit (B8) | yes | 5,067 |
| [P1-11](P1-11_Reset_B9.md) | Reset: registry walk, exact names, safe scope (B9, approved) | yes | 4,236 |
| [P1-12](P1-12_Setup_B6.md) | Setup: guard the Plugin Configuration call (B6) | yes | 3,445 |
| [P1-13a](P1-13a_Move.Ware_B20.md) | Move.Ware: small fix B20 | yes | 4,541 |
| [P1-13b](P1-13b_Menu.Ware.Details_B21.md) | Menu.Ware.Details: small fix B21 | yes | 6,037 |
| [P1-13c](P1-13c_Menu.Factory.Details_B22.md) | Menu.Factory.Details: small fix B22 | yes | 3,967 |
| [P1-13d](P1-13d_Config.Menu_B23.md) | Config.Menu: small fix B23 | yes | 4,823 |
| [P1-13e](P1-13e_Sort.Wares_B17.md) | Sort.Wares: small fix B17 | yes | 4,474 |

## Phase 2: shared libraries

| Card | What | Code? | Tokens |
|---|---|---|---|
| [P2-01](P2-01_lib_Cfg.Get_Log.md) | Write lib.LI.FDN.Cfg.Get and lib.LI.FDN.Log | yes | 4,076 |
| [P2-02](P2-02_lib_Is.Valid_Is.Factory.md) | Write lib.LI.FDN.Is.Valid and lib.LI.FDN.Is.Factory | yes | 4,363 |
| [P2-03](P2-03_lib_Ware.Rec.md) | Write lib.LI.FDN.Ware.Rec | yes | 4,060 |
| [P2-04](P2-04_lib_Fac.Cfg.md) | Write lib.LI.FDN.Fac.Cfg | yes | 3,451 |
| [P2-05](P2-05_lib_Lock.md) | Write lib.LI.FDN.Lock | yes | 2,831 |
| [P2-05b](P2-05b_lib_Reg.Add.md) | Write lib.LI.FDN.Reg.Add (B9 station registry) | yes | 2,883 |
| [P2-06](P2-06_Scan_and_Sectors.md) | Write plugin.LI.FDN.Scan and lib.LI.FDN.Sectors (B10) | yes | 4,827 |
| [P2-07a](P2-07a_lib_Trade.md) | Write lib.LI.FDN.Trade (hardened trade drone, R-T1) | yes | 6,317 |
| [P2-07b](P2-07b_Cleanup_orphan_sweep.md) | Orphan trade-drone sweep in plugin.LI.FDN.Cleanup | yes | 3,057 |
| [P2-08](P2-08_Supply.Start_use_libs.md) | Supply.Start on the shared libraries | yes | 4,153 |
| [P2-09a](P2-09a_Supply.Factory.Check_use_libs.md) | Supply.Factory.Check on the shared libraries | yes | 5,011 |
| [P2-09b](P2-09b_Supply.Factory_use_libs.md) | Supply.Factory on the shared libraries | yes | 4,619 |
| [P2-10a](P2-10a_Supply.Dock.Check_use_libs.md) | Supply.Dock.Check on the shared libraries | yes | 3,863 |
| [P2-10b](P2-10b_Supply.Dock_use_libs.md) | Supply.Dock on the shared libraries | yes | 5,076 |
| [P2-11a](P2-11a_Buy.Ware_use_libs.md) | Buy.Ware on the shared libraries | yes | 4,800 |
| [P2-11b](P2-11b_Sell.Ware_use_libs.md) | Sell.Ware on the shared libraries | yes | 4,720 |
| [P2-12a](P2-12a_Update.Ware_use_libs.md) | Update.Ware on the shared libraries | yes | 4,665 |
| [P2-12b](P2-12b_Move.Ware_use_libs.md) | Move.Ware on the shared libraries | yes | 4,712 |
| [P2-13](P2-13_wrappers_Sector.Array_Format.Name.md) | Turn Sector.Array and Format.Name into thin wrappers | yes | 3,454 |
| [P2-14](P2-14_debug_logging.md) | Decision logging for the dock pass, buy and sell (debug [7]) | yes | 6,337 |

## Phase 3: one menu framework

| Card | What | Code? | Tokens |
|---|---|---|---|
| [P3-01](P3-01_menu_design.md) | Menu design note and new text IDs | no | 9,143 |
| [P3-02](P3-02_lib_Menu_Row_Toggle_ObjLine.md) | Write Menu.Row, Menu.Toggle and Menu.ObjLine | yes | 6,125 |
| [P3-03](P3-03_lib_Menu_WareRow.md) | Write Menu.WareRow | yes | 5,794 |
| [P3-04](P3-04_Menu.Command.md) | Write the menu dispatcher plugin.LI.FDN.Menu.Command | yes | 7,353 |
| [P3-04b](P3-04b_DC_Change_event.md) | Write plugin.LI.FDN.DC.Change (DC change as one event; fixes B30 for DC changes) | yes | 4,417 |
| [P3-05](P3-05_Main.Menu_controller.md) | Rewrite plugin.LI.FDN.Main.Menu as the controller | yes | 4,760 |
| [P3-06](P3-06_Menu.Station.md) | Write plugin.LI.FDN.Menu.Station (DC and dock in one view) | yes | 7,032 |
| [P3-07](P3-07_Menu.Stations.md) | Write plugin.LI.FDN.Menu.Stations (stations list) | yes | 5,996 |
| [P3-08a](P3-08a_Menu.Factory.Details_on_libs.md) | Menu.Factory.Details on the menu libraries | yes | 4,291 |
| [P3-08b](P3-08b_Menu.Ware.Details_on_libs.md) | Menu.Ware.Details on the menu libraries | yes | 6,509 |
| [P3-08c](P3-08c_Config.Menu_on_libs.md) | Config.Menu on the menu libraries | yes | 5,332 |
| [P3-09](P3-09_Menu.Refresh.md) | Write plugin.LI.FDN.Menu.Refresh (single updater) | yes | 5,197 |
| [P3-10](P3-10_menu_stubs.md) | Stub the old menu scripts | yes | 2,774 |

## Phase 4: compatibility and upgrade

| Card | What | Code? | Tokens |
|---|---|---|---|
| [P4-01](P4-01_lib_Game.md) | Write lib.LI.FDN.Game | yes | 3,060 |
| [P4-02](P4-02_FL_feature_flag.md) | Decide the FL patch feature flag [24] | no | 1,793 |
| [P4-03](P4-03_Setup_hotkey.md) | plugin.LI.FDN.Setup: config entry, hotkey fallback, optional FL entries (B6) | yes | 3,591 |
| [P4-04](P4-04_Upgrade.md) | Write plugin.LI.FDN.Upgrade (v8.04 save -> v9.01) | yes | 4,006 |
| [P4-04b](P4-04b_Supply.Dock_B5_surplus_default.md) | Supply.Dock: effective surplus flag with global default (B5, approved) | yes | 5,289 |
| [P4-05](P4-05_al.event_final.md) | al.LI.FDN.event: v9.01 description and Upgrade call | yes | 3,249 |
| [P4-06](P4-06_FL_Station_Manager.md) | lib.LI.FDN.Is.FL.Managed: detect FL Station Manager (approved) | yes | 3,135 |
| [P4-07](P4-07_text_file.md) | Clean up the text file 9910-L044.xml | no | 3,361 |
| [P4-08](P4-08_command_review.md) | Command review: one v9 script against its v8 version | no | 1,770 |

## Phase 5: testing and packaging

| Card | What | Code? | Tokens |
|---|---|---|---|
| [P5-01](P5-01_test_plan.md) | Write the v9.01 test checklist | no | 1,747 |
| [P5-02](P5-02_version_bumps.md) | Version bump list | no | 1,652 |
| [P5-03](P5-03_readme.md) | Write the readme (forum BBCode and Markdown) | no | 3,233 |
| [P5-04](P5-04_spk_spec.md) | Plugin Manager package spec | no | 1,670 |
| [P5-05](P5-05_final_changelog.md) | Final CHANGELOG for v9.01 | no | 2,999 |
| [P5-06](P5-06_forum_post.md) | Forum post for the FDN thread | no | 2,988 |
