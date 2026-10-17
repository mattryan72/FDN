# P1-04: Update.Ware: build the record name before 'create' (B2)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~4,880 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-04_Update.Ware_B2.md`
- Save the answer as: `notes/P1-04.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Update.Ware.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B2 (high) Update.Ware 33-35 (+ Add.Ware.Sub 125-140); callers Main.Menu 475, Supply.Dock 100. `action='create'` jumps to Add.Ware.Sub before `$pointer` is assigned (only set at line 46), so the record is written under a null name. Result: Add Ware never creates settings, and Supply.Dock's create-then-read returns null. Fix direction: build `$pointer` before any gosub.
- B5 (medium/high, needs Matt's decision) Update.Ware 136; Wares.Summary 257; Supply.Dock 84-91. Default [7] = -1 counts as TRUE, so 'pass surplus to DC' is ON for every new ware; with maintain level null the whole stock of every non-DC dock is pulled into the DC. Recommended: default OFF (null) and migrate -1 to null in the upgrade, only if Matt approves.

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

## Instruction

Phase 1, task P1-04. Fix plugin.LI.FDN.Update.Ware:
(1) B2: build `$pointer` before the `create` gosub (around line 33).
(2) Return the amount actually added or removed on every path.
(3) B5: Matt has NOT yet approved changing the default. Keep `[7] = -1` for new records and add a `* TODO v9.01 B5` comment.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
