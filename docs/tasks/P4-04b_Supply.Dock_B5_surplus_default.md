# P4-04b: Supply.Dock: effective surplus flag with global default (B5, approved)

- Phase: 4 (branch `phase4-compat`)
- Writes code: yes
- Estimated size: ~5,289 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-04b_Supply.Dock_B5_surplus_default.md`
- Save the answer as: `notes/P4-04b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Supply.Dock.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B5 (approved by Matt 2026-10-17: make it configurable) Update.Ware 136; Wares.Summary 257; Supply.Dock 84-91. v8: default [7] = -1 counts as TRUE, so 'pass surplus to DC' is ON for every new ware; null only appears when the player switches it off. v9: global default [28] (1 on, 0 off, 2 v8 compatible) for records whose [7] is -1/null; per-ware [7] 1 = on, 0 = off, -1/null = use default. New records keep -1. v8 upgrade (migration approved by Matt 2026-10-17) sets [28] = 1 and migrates [7] null -> 0, so existing saves behave as before. Config menu row texts 320-325.

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

### Settings used
- [28] default surplus: 1 on, 0 off, 2 v8 compatible.

## Key facts

- Phase 4 = compatibility and upgrade. Never break the save-game rules in CORE RULES.
- Never invent commands; FL patch commands need a citation or VERIFY.
- Use the engine numbers from NOTES_semantics.md if included; otherwise mark VERIFY.
- Only change how Supply.Dock decides 'pass surplus to DC'. Nothing else.
- Test null with `is datatyp[...] == DATATYPE_NULL` before comparing with 0 (test T1 shows whether null == 0).

- House style (Matt's rules, always): a discarded call result is written ` = [THIS] -> call script ...` (leading space-equals), never `$null =`. No AND, OR, && or || at all (nest `if` blocks instead). No `!=` (use `if not $a == $b`). No array element inside a condition (copy it to a local first). No `->` or calls inside a condition. `null == null` is FALSE, so test with `is datatyp[ $x ] == DATATYPE_NULL`. Block balance: `if` lines (not counting `else if`) plus `while` lines must equal `end` lines.
- Edit rules for this task: use only your normal file edit tool, one small find/replace at a time. Do NOT use `python -c`, PowerShell or any shell command to read, check or edit the source file (that wiped a file on 2026-10-27). Keep CRLF. If the file looks damaged, stop and tell Matt; do not retry in a loop.
- Lines 205-206 (`$surplus.flag = $ware.settings[7]` and `if $surplus.flag`) are the only decision point. The `if not $surplus.flag` block near line 237 and every log line stay unchanged.
## Instruction

Phase 4, task P4-04b. Edit only `source_readable/plugin.LI.FDN.Supply.Dock.txt`. Change how Supply.Dock decides "pass surplus to DC" so it uses an effective flag. Put the rule in ONE new sub `Surplus.Effective.Sub:` placed after `Sell.Ware.Sub` (same style as `Sell.Ware.Sub`: label, one-space indent, `endsub`, a blank line before it, shared variables).

The sub reads `$ware.settings[7]` and `$al.Settings[28]` and sets `$surplus.flag` to [TRUE] or [FALSE]. Copy each array element to a local first.

Rule table (raw = record [7], mode = settings [28]; a null or non-INT mode counts as 1, and any INT mode other than 0 or 2 counts as 1):
- raw is an INT equal to 1: on, whatever the mode.
- raw is an INT equal to 0: off, whatever the mode.
- raw is DATATYPE_NULL: on only if mode is 1; off if mode is 0 or 2 (v8: null meant the player switched it off).
- raw is any other INT (normally -1): on if mode is 1 or 2; off if mode is 0.

Steps:
1. In the main script replace the two lines `$surplus.flag = $ware.settings[7]` / `if $surplus.flag` with a comment tagged `v9.01 B5`, `gosub Surplus.Effective.Sub:` and the unchanged `if $surplus.flag`. Nothing else in the main body changes.
2. Add the sub. Use nested `if` blocks and booleans; no AND/OR. Test null with `is datatyp[ $x ] == DATATYPE_NULL` before comparing the value with 0 or 1.
3. Header: change `(v4, engine 50)` to `(v5, engine 50)`, `Version: 4.0` to `Version: 5.0`, `Date:` to 28/10/2026, `Tested:` to `Tested: not tested`. Add a block "v9.01 Phase 4 changes (P4-04b) - B5" after the P2-14 block, in the same layout, listing the rule table in two or three lines. Keep every other line of the header.
4. Do not touch Update.Ware, Wares.Summary or any other script. Do not change [7] itself.

After saving, re-read the full saved file and report the changed lines verbatim (old and new, with line numbers) and the new block-balance counts (if / while / end).
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES. Give test steps for a test script that checks the rule table for every combination of raw (1, 0, null, -1) and mode (1, 0, 2, null) = 16 cases, expecting: on for raw 1 in all modes; off for raw 0 in all modes; raw null on only for mode 1 and null; raw -1 on for mode 1, 2 and null, off for mode 0. Matt's helper writes that test; you only describe it.