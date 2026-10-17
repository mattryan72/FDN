# P4-04b: Supply.Dock: effective surplus flag with global default (B5, approved)

- Phase: 4 (branch `phase4-compat`)
- Writes code: yes
- Estimated size: ~5,277 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-04b_Supply.Dock_B5_surplus_default.md`
- Save the answer as: `notes/P4-04b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Supply.Dock.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
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
- [28] default surplus: 1 on, 0 off, 2 v8 compatible.

## Key facts

- Phase 4 = compatibility and upgrade. Never break the save-game rules in CORE RULES.
- Never invent commands; FL patch commands need a citation or VERIFY.
- Use the engine numbers from NOTES_semantics.md if included; otherwise mark VERIFY.
- Only change how Supply.Dock decides 'pass surplus to DC'. Nothing else.
- Test null with `is datatyp[...] == DATATYPE_NULL` before comparing with 0 (test T1 shows whether null == 0).

## Instruction

Phase 4, task P4-04b. Change plugin.LI.FDN.Supply.Dock so the surplus decision uses the effective flag: record [7] == 1 -> on; [7] == 0 (and not null) -> off; [7] -1 or null -> use [28]: 1 on, 0 off, 2 (v8 compatible) -> on if [7] is -1, off if [7] is null. If [28] itself is null, treat it as 1. Put the rule in one small sub.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
