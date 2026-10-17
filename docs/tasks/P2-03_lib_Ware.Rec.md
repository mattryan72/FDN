# P2-03: Write lib.LI.FDN.Ware.Rec

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~3,954 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-03_lib_Ware.Rec.md`
- Save the answer as: `notes/P2-03.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- source_readable/plugin.LI.FDN.Update.Ware.txt lines 120-150
- source_readable/plugin.LI.FDN.Wares.Summary.txt lines 240-270

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Ware.Rec` | args: station, ware, create (Boolean) | record array (created with v9 defaults if create) or null; create=FALSE never writes | D3, B2, B18

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
| 7 | pass surplus to DC | -1 (counts as TRUE, bug B5) |
| 8-11 | unused in v8 (v9: [8] = last trade `playing time`); [10] is never set, null only from `array alloc: size=12` | null |
Created by Update.Ware (Add.Ware.Sub) and Wares.Summary (Build.Ware.Array.Sub), duplicate code.

### Duplicate / performance notes (ANALYSIS 3 and 5)
- D3 ware record create (12-element default array) in Update.Ware 125-148 and Wares.Summary 247-268; record name sprintf'd in 13 places -> lib.LI.FDN.Ware.Rec.

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.
- Only the record-creation parts of Update.Ware and Wares.Summary are included.
- v9 default for [7] depends on Matt's B5 decision: use -1 unless the CHANGELOG says B5 was approved.

## Instruction

Phase 2, task P2-03. Write lib.LI.FDN.Ware.Rec(station, ware, create). create=FALSE must never write anything. Use the same defaults as the old create code, plus [8] = null.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
