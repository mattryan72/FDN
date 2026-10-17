# P1-03: Supply.Factory: no lost product (B3), no duplicate buys (B11)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~4,911 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-03_Supply.Factory_B3_B11.md`
- Save the answer as: `notes/P1-03.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Supply.Factory.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B3 (critical) Supply.Start 46; Supply.Factory 67-72; Supply.Factory.Check 63; Supply.Dock.Check 39/47; Main.Menu 51. Only `if $dc` / `-> exists` are checked. (a) If the DC is destroyed, Supply.Factory still removes factory product (71-72) after adding it to a non-existent DC, so wares vanish. (b) Sold, captured or given-away stations stay in the arrays and keep being supplied and drained. Fix direction: validate the DC once per tick (exists, owner race == Player, is of class Dock); on failure pause and notify; owner check in both Check loops.
- B11 (medium) Supply.Factory 128-133; Supply.Dock 155. Buy.Ware and Sell.Ware are STARTed every cycle with no per-station/ware lock, so the same shortfall can be bought several times. Fix: per-station busy marker, stale after a timeout.

### Factory settings: station local `FDN.Settings` (text 4001), array size 6
[0] manage product, [1] manage resources, [2] "already seen" flag (applies auto-manage once), [3] v9: busy-until time, [4]-[5] free.

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
| 8-11 | unused in v8 (v9: [8] = last trade `playing time`) | null |
Created by Update.Ware (Add.Ware.Sub) and Wares.Summary (Build.Ware.Array.Sub), duplicate code.

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.
- Update.Ware will return the amount it actually added after task P1-04. If you depend on that, say so.

## Instruction

Phase 1, task P1-03. Fix plugin.LI.FDN.Supply.Factory:
(1) B3: re-check the DC (exists, player-owned) before moving product. Remove from the factory only the amount Update.Ware reports as added.
(2) Null-check the ware record before reading [3].
(3) B11: skip starting Buy.Ware if the factory's `FDN.Settings[3]` (busy-until) is greater than `playing time`; when you do start it, set [3] = playing time + 120.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
