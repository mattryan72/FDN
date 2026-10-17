# P0-B-B4: B4: can a missing record make FDN sell all stock?

- Phase: 0 (branch `phase0-setup`)
- Writes code: no
- Estimated size: ~5,575 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-B-B4_null_sell_cap.md`
- Save the answer as: `notes/P0-B-B4.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/plugin.LI.FDN.Supply.Dock.txt`
- `source_readable/plugin.LI.FDN.Sell.Ware.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B4 (high, verify) Supply.Dock 146-156 (Sell.Ware.Sub); Sell.Ware 44-49. If a ware has no record, `$sell = null`, and `null >= 0` is probably TRUE in MSCI (null acts as 0). Sell.Ware then computes amount = stock - null = stock and sells the whole stock. Records are only created when a menu shows the ware. Fix direction: skip when the record is null; sell cap active only if DATATYPE_INT and >= 0.

## Key facts

- This is a review only. Do not write or change any code.
- Quote code exactly, with its 3-digit line number from the pasted file. If you cannot find a line, say "not found" rather than guessing.
- Use only the pasted files. If you need another script, name it and stop.
- Claim: in Supply.Dock Sell.Ware.Sub (146-156) and Sell.Ware 44-49, a missing record gives `$sell = null`, and if `null >= 0` is TRUE the whole stock is sold.
- Whether `null >= 0` is TRUE is not known yet; Phase 0 task C test 1 settles it. Treat it as unknown.

## Instruction

Phase 0, task B, bug B4. Review only, no code.
1. Find the code the bug note points to and quote it exactly with line numbers.
2. Say CONFIRMED, PARTLY or REJECTED, and explain in 2-4 plain sentences why, using only the quoted lines.
3. If the line numbers in the bug note are off, give the correct ones.
4. Say what in-game test (if any) would settle it, in one or two steps.
Start with "Assumptions" and "Questions for Matt" (short).
