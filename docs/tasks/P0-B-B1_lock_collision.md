# P0-B-B1: B1: is the factory-run lock really broken?

- Phase: 0 (branch `phase0-setup`)
- Writes code: no
- Estimated size: ~5,162 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-B-B1_lock_collision.md`
- Save the answer as: `notes/P0-B-B1.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/plugin.LI.FDN.Supply.Start.txt`
- `source_readable/plugin.LI.FDN.Supply.Factory.Check.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B1 (critical) Supply.Start 55-57; Supply.Factory.Check 35-40, 153. `$is.running = [TRUE]` sets a local copy and never writes `al.Settings[12]`, so the guard never engages and overlapping Factory.Check runs pile up when one run takes longer than 25 s. Factory.Check also uses [12] as its reverse-order toggle and clears it at the end. Fix direction: [12] = run-lock (store `playing time`, stale after N s), [13] = reverse toggle; set the lock with `$al.Settings[12] = ...`; release on every exit.

### Global `al.LI.FDN.event` settings array (v8.04 meanings, from REFERENCE A / ANALYSIS 1.3)
| Idx | v8.04 meaning | Written by (per analysis) |
|---|---|---|
| 0 | plugin enabled | al.LI.FDN.event |
| 1 | text page ID 9910 (also the log file number: log09910.txt) | al.LI.FDN.event |
| 2 | DC (Dock object) | Main.Menu add.dc / change.dc |
| 3 | factory array | al.LI.FDN.event, Sector.Array, Reset |
| 4 | dock array (includes the DC) | al.LI.FDN.event, Sector.Array, Reset |
| 5 | open menu view (1 DC, 2 stations, 4 factory, 5 dock, 6 ware, 7 config) | Main.Menu |
| 6 | is.dynamic array: [0] DC view, [1] dock list (UI removed), [2] dock view | al.LI.FDN.event, Main.Menu |
| 7 | debug on/off | Main.Menu |
| 8 | exclude array (all player stations) | Sector.Array |
| 9 | auto-manage new factories | Main.Menu |
| 10 | unused in v8 (used in v7.2) | none |
| 11 | dock-check tick counter (0..6) | Supply.Start |
| 12 | used twice: "factory supply running" flag (Supply.Start) AND reverse-order toggle (Supply.Factory.Check) | both (bug B1) |
| 13-29 | free in v8 | none |

## Key facts

- This is a review only. Do not write or change any code.
- Quote code exactly, with its 3-digit line number from the pasted file. If you cannot find a line, say "not found" rather than guessing.
- Use only the pasted files. If you need another script, name it and stop.
- Claim: Supply.Start 55-57 sets a local flag, not `$al.Settings[12]`; Supply.Factory.Check 35-40 and 153 use [12] as a reverse toggle and clear it.
- In MSCI an array from `get global variable` is a reference: `$al.Settings[12] = x` changes the global, but `$is.running = [TRUE]` changes only a local variable.

## Instruction

Phase 0, task B, bug B1. Review only, no code.
1. Find the code the bug note points to and quote it exactly with line numbers.
2. Say CONFIRMED, PARTLY or REJECTED, and explain in 2-4 plain sentences why, using only the quoted lines.
3. If the line numbers in the bug note are off, give the correct ones.
4. Say what in-game test (if any) would settle it, in one or two steps.
Start with "Assumptions" and "Questions for Matt" (short).
