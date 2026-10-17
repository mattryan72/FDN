# P1-09b: Main.Menu: safe ware edits (B18, B19), confirm Remove Ware (B26)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~5,287 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-09b_Main.Menu_B18_B19_B26.md`
- Save the answer as: `notes/P1-09b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- source_readable/plugin.LI.FDN.Main.Menu.txt lines 105-192, 336-412, 466-512

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B18 (low) Main.Menu 338-407. If the ware record is null, edits are applied to a null array and lost. Fix: get-or-create the record.
- B19 (low) Main.Menu 467-478. Add Ware: if the user cancels, `$ware` is null and the code carries on. Also affected by B2. Fix: null check.
- B26 (low) Main.Menu 507-511. Remove Ware deletes the record (and any virtual stock) without confirmation; the command path does not re-check stock == 0. Fix: re-check stock == 0 and confirm.
- B2 (high, confirmed in P0-A) Update.Ware 33-35 (+ Add.Ware.Sub 125-140); callers Main.Menu 475, Supply.Dock 100. `action='create'` jumps to Add.Ware.Sub before `$pointer` is assigned (only set at line 46), so the record is written under a null name. Result: Add Ware never creates settings, and Supply.Dock's create-then-read returns null. Fix direction: build `$pointer` before any gosub.

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

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.
- You only have some line ranges of this script (marked in the FILE block). Do NOT output the whole script. For each change output `Replace lines NNN-NNN with:` and the new lines, or `Insert after line NNN:`. Keep line numbers from the pasted file.
- Update.Ware action='create' works after task P1-04 (B2 fixed).

## Instruction

Phase 1, task P1-09b. Fix plugin.LI.FDN.Main.Menu (only the pasted ranges): B18 in Ware.User.Input.Sub get-or-create the ware record before editing (if it is null, create it via Update.Ware action='create'). B19 in Add.Ware.Sub return if the user cancels ($ware null). B26 in Remove.Ware.Sub re-check stock == 0 and ask for confirmation (reuse the confirm pattern from master.reset). Use the replace-block output described in the key facts.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
