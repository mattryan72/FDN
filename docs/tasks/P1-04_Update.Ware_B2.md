# P1-04: Update.Ware: build the record name before 'create' (B2)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~5,125 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-04_Update.Ware_B2.md`
- Save the answer as: `notes/P1-04.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Update.Ware.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B2 (high, confirmed in P0-A) Update.Ware 33-35 (+ Add.Ware.Sub 125-140); callers Main.Menu 475, Supply.Dock 100. `action='create'` jumps to Add.Ware.Sub before `$pointer` is assigned (only set at line 46), so the record is written under a null name. Result: Add Ware never creates settings, and Supply.Dock's create-then-read returns null. Fix direction: build `$pointer` before any gosub.
- B5 (approved by Matt 2026-10-17: make it configurable) Update.Ware 136; Wares.Summary 257; Supply.Dock 84-91. v8: default [7] = -1 counts as TRUE, so 'pass surplus to DC' is ON for every new ware; null only appears when the player switches it off. v9: global default [28] (1 on, 0 off, 2 v8 compatible) for records whose [7] is -1/null; per-ware [7] 1 = on, 0 = off, -1/null = use default. New records keep -1. v8 upgrade sets [28] = 1 and migrates [7] null -> 0, so existing saves behave as before. Config menu row texts 320-325.

### Ware record: station local `FDN.Ware.<ware>` (name from text 4000 via sprintf), array size 12
| Idx | Meaning | v8 default |
|---|---|---|
| 0 | virtual stock | 0 |
| 1 | DC remote-access reserve level (DC only; >0 = sharing on) | null |
| 2 | dock maintain level | null |
| 3 | DC may buy this ware | FALSE/null |
| 4 | buy-at price | station price |
| 5 | sell-above level (-1 = off) | -1 |
| 6 | sell-at price | station price |
| 7 | pass surplus to DC. v8: -1 default (counts as TRUE, B5), null = player switched it off. v9 (approved): 1 on, 0 off, -1/null = use global default [28]. Test null with DATATYPE_NULL before comparing with 0 | -1 |
| 8-11 | unused in v8 (v9: [8] = last trade `playing time`); [10] is never set, null only from `array alloc: size=12` | null |
Created by Update.Ware (Add.Ware.Sub) and Wares.Summary (Build.Ware.Array.Sub), duplicate code.

### Settings used
- [28] default surplus (B5), [29] station registry (B9): arrays from `get global variable` are references, so write `$al.Settings[29]` and save with set global variable.

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-04. Fix plugin.LI.FDN.Update.Ware:
(1) B2: build `$pointer` before the `create` gosub (around line 33).
(2) Return the amount actually added or removed on every path.
(3) B5 (approved): keep `[7] = -1` for new records; it now means 'use the global default [28]'. Add a comment saying so; do not change surplus behaviour here.
(4) B9 registry: when a record is created, append the station to `$al.Settings[29]` if it is not already in it (create the array if null; use `find ... in array`). Inline for now; lib.LI.FDN.Reg.Add replaces it in Phase 2.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
