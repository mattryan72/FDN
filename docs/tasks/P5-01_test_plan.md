# P5-01: Write the v9.01 test checklist

- Phase: 5 (branch `phase5-release`)
- Writes code: no
- Estimated size: ~1,564 tokens when built
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

Phase 5, task P5-01. Write the test checklist as a Markdown table: item, steps, expected log lines (log09910.txt), pass/fail column.
Start with "Assumptions" and "Questions for Matt" (short).
