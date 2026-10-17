# P0-A: Check the saved-data dictionary against the code

- Phase: 0 (branch `phase0-setup`)
- Writes code: no
- Estimated size: ~5,850 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-A_data_dictionary.md`
- Save the answer as: `notes/P0-A.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/al.LI.FDN.event.txt`
- `source_readable/plugin.LI.FDN.Update.Ware.txt`
- `source_readable/plugin.LI.FDN.Supply.Start.txt`

## Excerpts

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
| 7 | pass surplus to DC. v8: -1 default (counts as TRUE, B5), null = player switched it off. v9 (approved): 1 on, 0 off, -1/null = use global default [28]. Test null with DATATYPE_NULL before comparing with 0 | -1 |
| 8-11 | unused in v8 (v9: [8] = last trade `playing time`); [10] is never set, null only from `array alloc: size=12` | null |
Created by Update.Ware (Add.Ware.Sub) and Wares.Summary (Build.Ware.Array.Sub), duplicate code.

## Key facts

- This is a review only. Do not write or change any code.
- Quote code exactly, with its 3-digit line number from the pasted file. If you cannot find a line, say "not found" rather than guessing.
- Use only the pasted files. If you need another script, name it and stop.
- The settings array is the global `al.LI.FDN.event`; scripts usually load it as `$al.Settings`.
- The ware record is the station local named by `sprintf: pageid=$PageID textid=4000, $ware` (`FDN.Ware.<ware>`), indices 0-7 matter.
- Analysis claim to test: index 12 is used for two different things (B1).
- The three scripts you have are al.LI.FDN.event, plugin.LI.FDN.Update.Ware and plugin.LI.FDN.Supply.Start. Other scripts also use these indices; if an entry is only set elsewhere, say "not in these scripts".

## Instruction

Phase 0, task A. Review only, no code.
1. For each settings index 0-13 in the table above, say CONFIRMED, WRONG or NOT IN THESE SCRIPTS, and quote the exact line(s) (with line number) where it is set or read.
2. Do the same for ware record indices 0-7.
3. List anything these three scripts read or write in `$al.Settings` or the ware record that the tables do not cover.
Start with "Assumptions" and "Questions for Matt" (short). End with a one-line summary: how many entries confirmed, wrong, not found.
