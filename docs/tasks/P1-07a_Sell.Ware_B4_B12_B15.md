# P1-07a: Sell.Ware: guard records, re-check, safer drone (B4, B12, B15)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~5,018 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-07a_Sell.Ware_B4_B12_B15.md`
- Save the answer as: `notes/P1-07a.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Sell.Ware.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B4 (high, verify) Supply.Dock 146-156 (Sell.Ware.Sub); Sell.Ware 44-49. If a ware has no record, `$sell = null`, and `null >= 0` is probably TRUE in MSCI (null acts as 0). Sell.Ware then computes amount = stock - null = stock and sells the whole stock. Records are only created when a menu shows the ware. Fix direction: skip when the record is null; sell cap active only if DATATYPE_INT and >= 0.
- B12 (medium) Supply.Dock 37-45, 56-137; Sell.Ware 41-124; Buy.Ware 49-111. Loops `wait` but never re-check that the dock, factory or DC still exists or is player-owned after the wait. Fix: re-validate after each wait.
- B15 (medium) Sell.Ware 74-98; Buy.Ware 74-80. The temporary 'Argon Mercury Super Freighter XL' trade drone is fragile: no check that `create ship` worked; ship type compiled as a type index (differs under XRM); no docking/transport/price/money/stock checks; Buy.Ware does not clamp to cargo; destruct may fire SIGNAL_KILLED (verify); overlapping tasks. Matt's decision R-T1: KEEP the drone, make it robust.

### Phase 1 drone rules (minimal; Phase 2 replaces this with lib.LI.FDN.Trade)
- Keep the drone (decision R-T1). After `create ship`, skip the trade if `$drone` is null or not `-> exists` (log it).
- Name it "FDN Trade Drone" and set local `FDN.Trade.Drone` = playing time on it before trading (text IDs 310 and 4102 come later; plain strings are fine for now with a TODO).
- Nothing waits between create ship and destruct. Treat a null buy/sell return as 0.
- Destruct on every path, behind `if $drone -> exists`.
- Use the cached sector list `$al.Settings[15]` if it is an array, instead of calling Sector.Array (P2).

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

Phase 1, task P1-07a. Fix plugin.LI.FDN.Sell.Ware: B4 guard against a null record or null sell cap (return without selling). B12 re-validate the dock and DC every loop after waits. B15 minimal drone hardening as in the drone rules above. Only remove from the dock what was actually sold.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
