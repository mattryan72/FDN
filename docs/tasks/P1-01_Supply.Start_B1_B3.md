# P1-01: Supply.Start: real run-lock (B1), DC check (B3), slower scan (P1)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~4,793 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-01_Supply.Start_B1_B3.md`
- Save the answer as: `notes/P1-01.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Supply.Start.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B1 (critical, confirmed in P0-A) Supply.Start 55-57; Supply.Factory.Check 35-40, 153. `$is.running = [TRUE]` sets a local copy and never writes `al.Settings[12]`, so the guard never engages and overlapping Factory.Check runs pile up when one run takes longer than 25 s. Factory.Check also uses [12] as its reverse-order toggle and clears it at the end. Fix direction: [12] = run-lock (store `playing time`, stale after N s), [13] = reverse toggle; set the lock with `$al.Settings[12] = ...`; release on every exit.
- B3 (critical, confirmed in P0-B) Supply.Start 46; Supply.Factory 67-72, 107, 129; Supply.Factory.Check 63; Supply.Dock.Check 39/47; Main.Menu 51. Only `if $dc` / `-> exists` are checked (Supply.Start L046 is just `if $dc`). (a) Destroyed DC: Supply.Factory L067 calls Update.Ware 'add' on the DC, but Update.Ware only handles stock if the station `is of class Dock` (L043), so it does nothing and returns 0; L071-072 then remove the product from the factory anyway, so wares vanish. L107 ('remove' from the DC) and L129 (reads the DC record) also use $dc unchecked. (b) No ownership check anywhere: the only `owner` in the code is `owner=Player` on the drone `create ship`. Sold or captured stations stay managed. Fix direction: validate the DC once per tick (exists, owner race == Player, is of class Dock); on failure pause and notify; remove from the factory only what Update.Ware reports as added; owner check in both Check loops.

### Global `al.LI.FDN.event` settings array (v8.04 meanings, from REFERENCE A / ANALYSIS 1.3)
| Idx | v8.04 meaning | Written by (per analysis) |
|---|---|---|
| 0 | plugin enabled | al.LI.FDN.event |
| 1 | text page ID 9910 (also the log file number: log09910.txt) | al.LI.FDN.event |
| 2 | DC (Dock object) | Main.Menu add.dc / change.dc |
| 3 | factory array | al.LI.FDN.event, Sector.Array, Reset |
| 4 | dock array (includes the DC) | al.LI.FDN.event, Sector.Array, Reset |
| 5 | open menu view (1 DC, 2 stations, 4 factory, 5 dock, 6 ware, 7 config) | Main.Menu |
| 6 | is.dynamic array: [0] DC view, [1] dock list (UI removed), [2] dock view; allocated size 10, only [0]-[2] set | al.LI.FDN.event, Main.Menu |
| 7 | debug on/off | Main.Menu |
| 8 | exclude array (all player stations) | Sector.Array |
| 9 | auto-manage new factories | Main.Menu |
| 10 | unused in v8 (used in v7.2) | none |
| 11 | dock-check counter: incremented while < 6 (call returns early), reset to 0 at 6 and docks supplied, so docks run every 7th call | Supply.Start |
| 12 | used twice: "factory supply running" flag (Supply.Start) AND reverse-order toggle (Supply.Factory.Check) | both (bug B1) |
| 13-29 | free in v8 | none |

### New indices used in this task
- [12] factory-check lock (`playing time`, null = free). [13] reverse toggle (moved off [12], used by Supply.Factory.Check). [16] scan timestamp.

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.
- Supply.Factory.Check releases [12] at the end of its run (separate task P1-02); here you only set it and handle the stale case.

## Instruction

Phase 1, task P1-01. Fix plugin.LI.FDN.Supply.Start:
(1) B1: set `$al.Settings[12] = playing time` instead of the local flag, treat it as stale after 120 s, and make sure it is not left set by an early return in this script.
(2) B3: validate the DC each tick (exists, `get owner race` == Player, is of class Dock). If invalid: set [2] = null, send the player one message, and return.
(3) P1 quick fix: only START Sector.Array when `playing time - $al.Settings[16] >= 300`, then store the time in [16].
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
