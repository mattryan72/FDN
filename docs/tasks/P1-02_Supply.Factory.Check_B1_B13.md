# P1-02: Supply.Factory.Check: lock release (B1), no reverse array (B13), owner check (B3)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~5,204 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-02_Supply.Factory.Check_B1_B13.md`
- Save the answer as: `notes/P1-02.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Supply.Factory.Check.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B1 (critical, confirmed in P0-A) Supply.Start 55-57; Supply.Factory.Check 35-40, 153. `$is.running = [TRUE]` sets a local copy and never writes `al.Settings[12]`, so the guard never engages and overlapping Factory.Check runs pile up when one run takes longer than 25 s. Factory.Check also uses [12] as its reverse-order toggle and clears it at the end. Fix direction: [12] = run-lock (store `playing time`, stale after N s), [13] = reverse toggle; set the lock with `$al.Settings[12] = ...`; release on every exit.
- B13 (medium, verify) Supply.Factory.Check 38. `reverse array` may return a new array; if so, removals on reversed passes go to the copy and the stored array is never purged. Fix: iterate by index direction instead of reversing.
- B3 (critical) Supply.Start 46; Supply.Factory 67-72; Supply.Factory.Check 63; Supply.Dock.Check 39/47; Main.Menu 51. Only `if $dc` / `-> exists` are checked. (a) If the DC is destroyed, Supply.Factory still removes factory product (71-72) after adding it to a non-existent DC, so wares vanish. (b) Sold, captured or given-away stations stay in the arrays and keep being supplied and drained. Fix direction: validate the DC once per tick (exists, owner race == Player, is of class Dock); on failure pause and notify; owner check in both Check loops.

### Settings used
- [3] factory array, [7] debug, [9] auto-manage, [12] lock set by Supply.Start (`playing time`), [13] reverse toggle (new).

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-02. Fix plugin.LI.FDN.Supply.Factory.Check:
(1) B1: move the reverse-order toggle from [12] to [13]. Release the lock `$al.Settings[12] = null` at the end AND on every early return.
(2) B13: walk the factory array forwards or backwards by index instead of calling `reverse array`, and remove dead factories from the stored array only.
(3) B3: drop factories that no longer exist or are not player-owned.
(4) P7: read text 4001 once before the loop, not inside it.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
