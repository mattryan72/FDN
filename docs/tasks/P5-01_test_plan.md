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
install, fresh game, upgrade from 8.04, DC change, DC destroyed, factory sold/captured, 50+ factories (SETA 2 h), buy/sell with low money, trade drone (foe/destroyed/full partner, XRM type fallback, no tagged drone after save/reload), virtual <-> physical, move ware to ship, master reset, uninstall (AL stop -> config entry removed, hotkey unregistered, no running tasks). Games: AP 3.3, AP + Plugin Configuration, FL 1.3, FL + Unofficial Patch 1.3.20; each fresh and from the v8.04 save.

## Key facts

- Phase 5 = testing and packaging. Plain language for players; Matt is the author (Logain Abler, Logain Industries).
- Do not invent features: only what CHANGELOG.md says.

## Instruction

Phase 5, task P5-01. Your only task is to write ONE new file, `notes/P5-01.md` (Markdown, LF line endings, plain ASCII, no emoji). Do not edit any other file. Use only your normal read-file and write-file tools; no `python -c`, PowerShell or other shell commands on repo files.

Read these first (read only): `CHANGELOG.md` (the list of what v9.01 does; if a line looks garbled, skip it), every `notes/P2-*.md`, `notes/P3-*.md` and `notes/P4-*.md`, and `docs/FDN_v9_PHASE4.md` (the test matrix paragraph). Do not invent features or log lines. Expected log lines may only be copied from those notes (they quote real log09910.txt lines from earlier in-game tests). When a step has no known log line, write "VERIFY: check the log for <what to look for>" instead of making one up.

Build the checklist like this:
1. A short "Assumptions" and "Questions for Matt" section at the top (3 to 6 bullets each, or "none").
2. A "Games and saves" table: AP 3.3; AP with Community Plugin Configuration 1.61; FL 1.3; FL with Unofficial Patch 1.3.20; each as a fresh game and from the v8.04 save (8 combinations, with a column for "done / date").
3. The main checklist as a Markdown table with columns: No., Area, Steps (numbered, plain language, short), Expected (including log09910.txt lines), Pass/Fail. One row per item from the Must-cover list above (install, fresh game, upgrade from 8.04, DC change, DC destroyed, factory sold or captured, 50+ factories with SETA for 2 hours, buy/sell with low money, trade drone (foe, destroyed, full partner, XRM type fallback, no tagged drone after save/reload), virtual to physical, move ware to ship, master reset, uninstall (AL stop, config entry removed, hotkey unregistered, no running tasks)). Add rows for: hotkey and Config menu entry, FL Station Manager drop (put a factory, a dock and the DC under Station Manager), Surplus to DC modes (On, Off, v8 compatible, per-ware default), menu navigation and Escape at every level, no ReadText errors.
4. A section "Carry-over checks from earlier phases": collect every item listed under a "Not seen", "Not tested" or "Open follow-up" heading or line in the notes P2 to P4 and list each as a checklist item with the note it came from (file name). Do not skip any; one line each.
5. Keep the whole file under about 350 lines.

After saving, re-read the file and report only: the line count, the number of rows in the main table, and the number of carry-over items. Say "Questions for Matt" items if any.