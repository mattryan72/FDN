# P0-B-B7: B7: dock dynamic toggle uses the wrong index

- Phase: 0 (branch `phase0-setup`)
- Writes code: no
- Estimated size: ~6,314 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-B-B7_dynamic_index.md`
- Save the answer as: `notes/P0-B-B7.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/plugin.LI.FDN.Menu.Dock.Details_D.txt`
- `source_readable/plugin.LI.FDN.Config.Menu.txt`
- source_readable/plugin.LI.FDN.Main.Menu.txt lines 254-274

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B7 (medium) Menu.Dock.Details_D 26; Config.Menu 172; Main.Menu 261-266. The dock updater reads `is.dynamic[1]`, but the Config 'Dock Details Menu' toggle flips [2], so the toggle does nothing. Fix direction: use index 2 everywhere.

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
- Claim: Menu.Dock.Details_D line 026 reads `$al.Settings[6][1]`, while Config.Menu (around 172) and Main.Menu 261-266 toggle `[6][2]`.
- Settings [6] is the is.dynamic array: [0] DC view, [1] dock list (UI removed), [2] dock view.

## Instruction

Phase 0, task B, bug B7. Review only, no code.
1. Find the code the bug note points to and quote it exactly with line numbers.
2. Say CONFIRMED, PARTLY or REJECTED, and explain in 2-4 plain sentences why, using only the quoted lines.
3. If the line numbers in the bug note are off, give the correct ones.
4. Say what in-game test (if any) would settle it, in one or two steps.
Start with "Assumptions" and "Questions for Matt" (short).
