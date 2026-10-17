# P1-11: Reset: registry walk, exact names, safe scope (B9, approved)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~4,236 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-11_Reset_B9.md`
- Save the answer as: `notes/P1-11.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Reset.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B9 (confirmed in P0-B; scope approved by Matt 2026-10-17) Reset L064 regex `'FDN*'` matches any variable containing 'FD'. L028-030: no null/exists check on the DC. Reset never pauses FDN ([0]). L043-048 only clear docks still in the dock array. Approved fix: set [0] FALSE first; walk the registry [29] plus [2], [3], [4]; skip stations that don't exist; clear with `'^FDN\.'` (test T8 passed on FL 2026-10-17: one backslash, never two; `'^FDN[.]'` also works); then empty [3], [4], [29] and set [2] = null.

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

### New indices used
- [29] station registry: array of every station FDN has ever touched (DC, factory, dock, or given an FDN.Ware.* record). May be null on saves that have not run the Upgrade stub yet.

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-11. Fix plugin.LI.FDN.Reset as Matt approved on 2026-10-17:
(1) Set `$al.Settings[0]` FALSE first and wait one tick (Reset runs from the menu, so a wait is fine).
(2) Build the list of stations: the registry [29] (if it is an array), plus [2], [3] and [4], without duplicates.
(3) For each station: skip it if it is null or does not `exist`. Clear its FDN locals with regex `'^FDN\.'` (single backslash; test C1 T8 in NOTES_semantics showed `^` and `\.` work). Setting a local to null removes it (T8).
(4) Empty [3], [4] and [29], set [2] = null, clear [12] to [20].
List the wider scope under 'Behaviour changes (approved)' in the CHANGELOG entry.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
