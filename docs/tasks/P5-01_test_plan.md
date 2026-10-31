# P5-01: Write the v9.01 test checklist

- Phase: 5 (branch `phase5-release`)
- Writes code: no
- Estimated size: ~1,747 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P5-01_test_plan.md`
- Save the answer as: `notes/P5-01.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- (no extra files)

## Excerpts

### Must cover
install, fresh game, upgrade from 8.04, DC change, DC destroyed, factory sold/captured, 50+ factories (SETA 2 h), buy/sell with low money, trade drone (foe/destroyed/full partner, XRM type fallback, no tagged drone after save/reload), virtual <-> physical, move ware to ship, master reset, uninstall (AL stop -> config entry removed, hotkey unregistered, no running tasks). Games: AP 3.3, AP + Plugin Configuration, FL 1.3, FL + Unofficial Patch 1.3.20; each on a FRESH save (M-08 decision 7, Matt 30/10/2026: v9.01 requires fresh saves; v8.04 save upgrade is not guaranteed and not tested - keep at most one "v8.04 save, best effort, not supported" note row, no pass/fail).
Multi-DC (M-03 to M-08): first DC from Config (homes assigned at once), add / remove / make primary on the Distribution Centre Network page (only docks in backbone range of the primary are offered), red 'Not linked to primary' mark, range limit on/off and base range, per-DC range and floor overrides, backbone range multiplier 1-5, Energy Cell cost on/off with deferral warning and help between DCs, running cost page and its Reset, Buy / Buy at / Maintain / Pass Surplus rows on every DC, menu navigation (Back returns to the page you came from, no page twice in the history, Esc = Back, Close menu), FDN paused after first install and after a Master Reset ('FDN Enabled: OFF' row) until switched on in the Artificial Life settings.

### Settings array and v9.01 state (M-08, for steps and expected values)
- The settings array has 40 slots (not 30); Upgrade grows it and fills empty slots, never overwriting a player value.
| Slot | Meaning | Default / values |
|---|---|---|
| [30] | DC list (primary [2] first) | array; [2] when it is a valid DC, else empty |
| [31] | range limit on/off | 1 on / 0 off; fresh install 1 |
| [32] | base station range (jumps) | 3 (1-20) |
| [33] | Energy Cell transfer cost on/off | 1 on / 0 off; fresh install 1 |
| [34] | global reserve floor % | 25 (0-100) |
| [35] | route cache (backbone links [dcA, dcB, jumps]) | array, rebuilt by Route.Build |
| [36] | last network Energy Cell check time | 0 |
| [37] | deferred transfers this tick | 0 (Leg.Pay counts, Supply.Start resets) |
| [38] | backbone range multiplier | 2 (1-5); link when jumps <= multiplier x smaller DC range |
- Reset (v3.1) clears [2], [3], [4], [29], [30], [35], [12]-[20] except [14], [36]/[37] = 0 and every '^FDN\.' local on every player station; keeps [7], [14], [28], [31]-[34], [38]; FDN stays paused.
- DC range = per-DC override (FDN.DC.Cfg[0], 1-20) or [32] + type: Player HQ +2, Equipment Dock 0, other docks -1 (Trading Station subtype not yet known).
- Menu views: 1 DC view, 2 Stations, 3 Distribution Centre Network (text 353), 4 factory, 5 dock, 6 ware, 7 Config, 8 DC running cost.
- 9910 texts added in v9.01 M-06 to M-08: 353-369, 370-391, 392, 393-399 (393 'Not linked to primary', 394-397 network page, 398/399 backbone multiplier); a 'ReadText' on screen means the game text file is old.
- In-game test scripts (run from the script editor, each ends 'TEST <name>: done n/m PASS'): test.LI.FDN.Probe, test.LI.FDN.FL.Managed, test.LI.FDN.Hub, test.LI.FDN.Cost (26 one DC / 34 four DCs), test.LI.FDN.Menu.Cfg, test.LI.FDN.Slots (17, 16 with no DC), test.LI.FDN.Reset.Check (16, throwaway save after a Reset), test.LI.FDN.Dc.Reach (8).

## Key facts

- Phase 5 = testing and packaging. Plain language for players; Matt is the author (Logain Abler, Logain Industries).
- Do not invent features: only what CHANGELOG.md says.
- Updated by card M-08m (31/10/2026): fresh saves only, 40-slot settings array, multi-DC rows and the M-08 test scripts; see docs/tasks/M-08.md.

## Instruction

Phase 5, task P5-01. Your only task is to write ONE new file, `notes/P5-01.md` (Markdown, LF line endings, plain ASCII, no emoji). Do not edit any other file. Use only your normal read-file and write-file tools; no `python -c`, PowerShell or other shell commands on repo files.

Read these first (read only): `CHANGELOG.md` (the list of what v9.01 does; if a line looks garbled, skip it), every `notes/P2-*.md`, `notes/P3-*.md` and `notes/P4-*.md`, and `docs/FDN_v9_PHASE4.md` (the test matrix paragraph). Do not invent features or log lines. Expected log lines may only be copied from those notes (they quote real log09910.txt lines from earlier in-game tests). When a step has no known log line, write "VERIFY: check the log for <what to look for>" instead of making one up.

Build the checklist like this:
1. A short "Assumptions" and "Questions for Matt" section at the top (3 to 6 bullets each, or "none").
2. A "Games and saves" table: AP 3.3; AP with Community Plugin Configuration 1.61; FL 1.3; FL with Unofficial Patch 1.3.20; each as a FRESH game (4 rows, with a column for "done / date"), plus one note that v8.04 saves are not supported (no test row).
3. The main checklist as a Markdown table with columns: No., Area, Steps (numbered, plain language, short), Expected (including log09910.txt lines), Pass/Fail. One row per item from the Must-cover list above (install, fresh game, upgrade from 8.04 (mark "not supported, fresh saves required", no pass/fail), DC change, DC destroyed, factory sold or captured, 50+ factories with SETA for 2 hours, buy/sell with low money, trade drone (foe, destroyed, full partner, XRM type fallback, no tagged drone after save/reload), virtual to physical, move ware to ship, master reset, uninstall (AL stop, config entry removed, hotkey unregistered, no running tasks)). Add rows for: hotkey and Config menu entry, FL Station Manager drop (put a factory, a dock and the DC under Station Manager), Surplus to DC modes (On, Off, v8 compatible, per-ware default), menu navigation and Escape at every level, no ReadText errors, and one row per Multi-DC item above (use the settings table for expected values) plus one row per test script with its expected count.
4. A section "Carry-over checks from earlier phases": collect every item listed under a "Not seen", "Not tested" or "Open follow-up" heading or line in the notes P2 to P4 and list each as a checklist item with the note it came from (file name). Do not skip any; one line each.
5. Keep the whole file under about 350 lines.

After saving, re-read the file and report only: the line count, the number of rows in the main table, and the number of carry-over items. Say "Questions for Matt" items if any.