# P1-11: Reset: exact regex and safe scope (B9)

- Phase: 1 (branch `phase1-bugfix`)
- Writes code: yes
- Estimated size: ~4,117 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P1-11_Reset_B9.md`
- Save the answer as: `notes/P1-11.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/plugin.LI.FDN.Reset.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B9 (medium, confirmed in P0-B) Reset L064 regex `'FDN*'` means 'FD followed by any number of N', so it matches any variable containing 'FD', including other mods' locals. L028-030: no null/exists check on the DC. Reset never pauses FDN (enable flag [0]). L043-048 only clear docks still in the dock array, so docks that left it keep their FDN.Ware.* locals. Fix direction: regex `'^FDN\.'` (VERIFY X3 regex supports ^ and \. : test C1 T8; Cleanup L018 uses 'FDND.*'), exists checks, set enabled FALSE first, sweep all player docks.

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

## Key facts

- Phase 1 = bug fixes in place: minimal diffs, same script name, same arguments, no new lib scripts (small inline subs are fine).
- Mark every change with a comment `* v9.01 B#`.
- Never edit XML; source text only. Never invent commands: use ones in the pasted script or mark `VERIFY:`.
- If NOTES_semantics.md was included, follow its test results; if not, mark those engine points `VERIFY:`.

## Instruction

Phase 1, task P1-11. Fix plugin.LI.FDN.Reset: B9 use regex `'^FDN\.'` only if test C1 T8 (in NOTES_semantics) showed `^` and `\.` work, otherwise use the pattern T8 proved and say so; add a null/exists check on the DC (L028-030) and every station; set `$al.Settings[0]` FALSE first and wait one tick (Reset is called from the menu, so a wait here is fine); sweep all player docks and factories, not just the arrays; clear settings [12] to [20]. The wider reset scope is a behaviour change: list it under 'Behaviour changes (need approval)' in the CHANGELOG entry.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
