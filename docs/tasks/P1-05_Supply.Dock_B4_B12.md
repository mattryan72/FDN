# P1-05: Supply.Dock: safe sell cap (B4), re-check after waits (B12)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~5,353 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-05_Supply.Dock_B4_B12.md`
- Save the answer as: `notes/P1-05.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Supply.Dock.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B4 (high, partly confirmed in P0-B; depends on test C1 T1) Supply.Dock 145-158 (Sell.Ware.Sub); Sell.Ware 44-49 (and 36-37, same exposure). If a ware has no record, `$sell = null`; if `null >= 0` is TRUE in MSCI, Sell.Ware computes amount = stock - null = stock and sells the whole stock. Records are also created by Update.Ware's 'add' path (L052 gosub Add.Ware.Sub) when stock is added to a dock with no record, but the explicit action='create' calls (Supply.Dock L100, Main.Menu L475) do nothing because of B2, so the DC record Supply.Dock L098-102 thinks it created can still be missing. Fix direction: skip when the record is null; sell cap active only if DATATYPE_INT and >= 0.
- B12 (medium) Supply.Dock 37-45, 56-137; Sell.Ware 41-124; Buy.Ware 49-111. Loops `wait` but never re-check that the dock, factory or DC still exists or is player-owned after the wait. Fix: re-validate after each wait.

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

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-05. Fix plugin.LI.FDN.Supply.Dock:
(1) B4: in Sell.Ware.Sub (L145-158), only sell when the record is not null and `$sell` is an INT (`is datatyp[ $sell ] == DATATYPE_INT`) and >= 0.
(2) B12: after each wait, re-check `$dock -> exists` and that the owner is Player; stop if not.
(3) P8: add a short wait every 10 wares.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
