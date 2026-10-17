# P0-B-B4: B4: can a missing record make FDN sell all stock?

- Phase: 0 (branch `phase0-setup`)
- Writes code: no
- Estimated size: ~5,657 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-B-B4_null_sell_cap.md`
- Save the answer as: `notes/P0-B-B4.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/plugin.LI.FDN.Supply.Dock.txt`
- `source_readable/plugin.LI.FDN.Sell.Ware.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B4 (high, partly confirmed in P0-B; depends on test C1 T1) Supply.Dock 145-158 (Sell.Ware.Sub); Sell.Ware 44-49 (and 36-37, same exposure). If a ware has no record, `$sell = null`; if `null >= 0` is TRUE in MSCI, Sell.Ware computes amount = stock - null = stock and sells the whole stock. Records are also created by Update.Ware's 'add' path (L052 gosub Add.Ware.Sub) when stock is added to a dock with no record, but the explicit action='create' calls (Supply.Dock L100, Main.Menu L475) do nothing because of B2, so the DC record Supply.Dock L098-102 thinks it created can still be missing. Fix direction: skip when the record is null; sell cap active only if DATATYPE_INT and >= 0.

## Key facts

- This is a review only. Do not write or change any code.
- Quote code exactly, with its 3-digit line number from the pasted file. If you cannot find a line, say "not found" rather than guessing.
- Use only the pasted files. If you need another script, name it and stop.
- Claim: in Supply.Dock Sell.Ware.Sub (146-156) and Sell.Ware 44-49, a missing record gives `$sell = null`, and if `null >= 0` is TRUE the whole stock is sold.
- Settled after this review: test C1 T1 (2026-10-17, FL) showed `null >= 0` is FALSE (see notes/NOTES_semantics.md).

## Instruction

Phase 0, task B, bug B4. Review only, no code.
1. Find the code the bug note points to and quote it exactly with line numbers.
2. Say CONFIRMED, PARTLY or REJECTED, and explain in 2-4 plain sentences why, using only the quoted lines.
3. If the line numbers in the bug note are off, give the correct ones.
4. Say what in-game test (if any) would settle it, in one or two steps.
Start with "Assumptions" and "Questions for Matt" (short).
