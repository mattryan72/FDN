# P1-06: Supply.Dock.Check: drop dead or lost docks (B3)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~3,839 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-06_Supply.Dock.Check_B3.md`
- Save the answer as: `notes/P1-06.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Supply.Dock.Check.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B3 (critical) Supply.Start 46; Supply.Factory 67-72; Supply.Factory.Check 63; Supply.Dock.Check 39/47; Main.Menu 51. Only `if $dc` / `-> exists` are checked. (a) If the DC is destroyed, Supply.Factory still removes factory product (71-72) after adding it to a non-existent DC, so wares vanish. (b) Sold, captured or given-away stations stay in the arrays and keep being supplied and drained. Fix direction: validate the DC once per tick (exists, owner race == Player, is of class Dock); on failure pause and notify; owner check in both Check loops.

### Settings used
- [1] page ID, [2] DC, [4] dock array (includes the DC), [7] debug.

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-06. Fix plugin.LI.FDN.Supply.Dock.Check: B3 owner check; remove docks that no longer exist or are not player-owned from [4]. Supply.Start has already validated the DC this tick (task P1-01): if [2] is null, return without doing anything.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
