# P0-A: Check the saved-data dictionary against the code (review only)

Task card: `prompts/P0-A_data_dictionary.txt`. No code was written or changed for this task — review of three scripts only.

Files reviewed (as pasted in the task prompt; verified identical to `source_readable/`):
- `al.LI.FDN.event`
- `plugin.LI.FDN.Update.Ware`
- `plugin.LI.FDN.Supply.Start`

## Assumptions
- "CONFIRMED" = the index is read or written in one of these three scripts with a value matching the table's meaning; "NOT IN THESE SCRIPTS" = not touched here, but set/read elsewhere per the analysis (the other script is named); "WRONG" = the code contradicts the stated meaning.
- Only the three pasted files were used. The `Supply.Factory.Check` reverse-toggle lines quoted for index 12 come from the P0-B task-card excerpt in the same prompt, not read directly from `source_readable/plugin.LI.FDN.Supply.Factory.Check.txt`.

## Questions for Matt
- For indices only touched outside these three scripts (3, 4, 5, 6, 7, 8), should I mark them "NOT IN THESE SCRIPTS" and stop, or do you want a follow-up pass that opens those other files? Per the task rules I stopped at naming them.

## Part 1 — Settings array `al.LI.FDN.event`, indices 0–13

### [0] plugin enabled — CONFIRMED (all three scripts)
Table says written by `al.LI.FDN.event`.
- Set FALSE on init: L009 `$al.Settings[0] = [FALSE]`
- Set TRUE on start: L036 `$al.Settings[0] = [TRUE]`
- Set FALSE on stop: L040 `$al.Settings[0] = [FALSE]`
- Read as the enable gate (timer): L044 `if $al.Settings[0]`; also returned at L048.
- Note: the other two scripts fetch the array but never read `[0]`.

### [1] text page ID 9910 / log number — CONFIRMED
Table says written by `al.LI.FDN.event`.
- Set: L010 `$al.Settings[1] = $PageID` (with `$PageID = 9910` at L004)
- Read in all three scripts as the page/log ID: `Update.Ware` L022, `Supply.Start` L026.

### [2] DC (Dock object) — NOT IN THESE SCRIPTS
Never set or read here. Written by `Main.Menu add.dc / change.dc`; only *read* in `Supply.Start`:
- Read: L028 `$dc = $al.Settings[2]`, used at L046 `if $dc`.

### [3] factory array — NOT IN THESE SCRIPTS
Never set or read here. Written by `Sector.Array` / `Reset`; only *read* in `Supply.Start`:
- Read: L029 `$factory.array = $al.Settings[3]`, used at L049 `if $factory.array`.

### [4] dock array (includes DC) — NOT IN THESE SCRIPTS
Never set or read here. Written by `Sector.Array` / `Reset`; only *read* in `Supply.Start`:
- Read: L030 `$dock.array = $al.Settings[4]`, used at L079 `if $dock.array`.

### [5] open menu view bitmask (1 DC … 7 config) — NOT IN THESE SCRIPTS
Never set or read here. Written by `Main.Menu`.

### [6] is.dynamic array `[0]/[1]/[2]` — CONFIRMED (default-creation part only)
Table says written by `al.LI.FDN.event`, `Main.Menu`; here only `al.LI.FDN.event`:
- Allocated and defaulted: L017 `$is.dymanic = = array alloc: size=10` (note: 10, not 3 — indices 3–9 are left uninitialised/null), L018 `[0] = [TRUE]`, L019 `[1] = [TRUE]`, L020 `[2] = [TRUE]`, then stored at L021 `$al.Settings[6] = $is.dymanic`.
- No script here reads the individual flags.

### [7] debug on/off — CONFIRMED as read; NOT set in these scripts
Table says written by `Main.Menu` (correct — not set here). Read to gate debug logging:
- `Supply.Start` L040, L060, L081 (`if $al.Settings[7]`).
- `Update.Ware`: **not read** as a flag. It only derives `$DebugID = 0 + $PageID` (L023) and has a `Debug.Sub:` label (L152), but there is **no `gosub Debug.Sub:` call anywhere in the file** — so its debug logging is dead code here.

### [8] exclude array (all player stations) — NOT IN THESE SCRIPTS
Never set or read here. Written by `Sector.Array`.

### [9] auto-manage new factories — NOT IN THESE SCRIPTS
Never set or read here. Written by `Main.Menu`.

### [10] unused in v8 (used in v7.2) — CONFIRMED (unused)
No reference to `[10]` anywhere in the three scripts.

### [11] dock-check tick counter, Supply.Start — CONFIRMED
Read, incremented, stored and reset:
- Read L031 `$call.count.dock = $al.Settings[11]`; comparison L072 `if $call.count.dock < 6`; increment L073; write-back L074 `$al.Settings[11] = $call.count.dock`; reset L077 `$al.Settings[11] = 0`.
- Note: the comment at L071 says "skips the dock supply until call **3** times" but the code tests `< 6`, so it actually skips for 6 calls then fires (counter ranges 0–5, reset to 0). The table's "0..6" is slightly off — observed values are 0–5 before reset.

### [12] used twice: run flag AND reverse toggle (bug B1) — CONFIRMED as a dual use
In these scripts it acts only as the *run-flag*; the reverse-toggle half lives in `Supply.Factory.Check` (not one of the three files).
- Run-flag, read: L032 `$is.running = $al.Settings[12]`; gate at L055 `if not $is.running`.
- B1 detail worth flagging: Supply.Start sets the flag on a *local* variable, not the array — L056 `$is.running = [TRUE]` and the save at L057 persists whatever `[12]` already was. So in this script alone the lock is read but never actually written into the global (only the local copy changes). The other writer is `Supply.Factory.Check`, from the P0-B excerpt:
  - L035 `if not $al.Settings[12]` / L036 `$al.Settings[12] = 1` (reverse toggle)
  - L039 `$al.Settings[12] = null` (clear after reversing)
  - L153 `$al.Settings[12] = null` (the "clear is.running flag" comment — this one *does* write the array).
- Net: `[12]` is genuinely shared between two meanings, confirming B1. The "flag never engages" part of the analysis depends on `Supply.Factory.Check`, which was not opened directly (only its P0-B excerpt).

### [13] free in v8 — CONFIRMED (unused)
No reference to `[13]` anywhere in the three scripts.

## Part 2 — Ware record `FDN.Ware.<ware>`, indices 0–7

Record is built in `Update.Ware Add.Ware.Sub:` (L125) and read/written in the main body of `Update.Ware`. All below are from that one file.

### [0] virtual stock — CONFIRMED
Default L129 `$array[0] = 0`; read at L057 `$virtual.stock = $ware.array[0]`; written back at L073, L098 and reset to `0` at L110.

### [1] DC remote-access reserve (DC only; >0 = sharing on) — CONFIRMED as default only
Set once at L130 `$array[1] = null`. **No other script here reads or writes `[1]`** — the DC-only logic lives elsewhere (`Main.Menu`/supply), so its meaning is not verifiable from these three files.

### [2] dock maintain level — CONFIRMED as default only
L131 `$array[2] = null`; never read/written in any of these scripts (set by `Main.Menu`).

### [3] DC may buy this ware — CONFIRMED as default only; value matches table
L132 `$array[3] = [FALSE]` — the analysis lists the v8 default as "FALSE/null"; code uses `[FALSE]`, which is consistent. Not read/written elsewhere in these scripts (DC-buy logic is in the supply/menu scripts).

### [4] buy-at price — CONFIRMED as default only
L133 `$array[4] = $price` where `$price = get price of ware $ware` (L127). Matches "station price". Not read/written elsewhere here.

### [5] sell-above level (-1 = off) — CONFIRMED as default only
L134 `$array[5] = -1`. Matches "-1 = off". Not used elsewhere in these scripts (sell logic is in supply/menu).

### [6] sell-at price — CONFIRMED as default only
L135 `$array[6] = $price` (L127). Matches "station price". Not read/written elsewhere here.

### [7] pass surplus to DC (-1 counts as TRUE, bug B5) — CONFIRMED as default; the -1 value is present
L136 `$array[7] = -1`. This matches the table and is the value that underlies **B5** ("default `-1` counts as TRUE"). However, the *comparison* that makes `-1` count as TRUE (e.g. `if $ware.array[7] …`) happens in a supply/menu script, not these three — so I confirm the stored default but cannot show the B5 trigger from this code alone.

## Part 3 — Things these scripts touch that the tables do NOT cover

**Ware record:**
- **`$array[8]`, `$array[9]`, `$array[11]` are written in `Add.Ware.Sub` but `[10]` is skipped.** L137 `$array[8] = null`, L138 `$array[9] = null`, L139 `$array[11] = null`. The table says "8–11 unused in v8 (v9: [8] = last trade playing time)" — so `[8]/[9]/[11]` are correctly "unused" today, but the code never explicitly sets `[10]`; it relies on `array alloc` leaving it null. No functional meaning to flag; just a gap in explicit initialisation (L139 jumps from `[9]` to `[11]`).
- **The record is *written* under a potentially-null name when `$action == 'create'`.** L033–035 `if $action == 'create' → gosub Add.Ware.Sub:` runs before `$pointer = sprintf … textid=4000` (L046), so the record is stored at null. This is **B2**, and it affects the *record* itself, not a table index — worth calling out because Part 2's "defaults" only apply when the name resolves correctly.

**Settings array:**
- Nothing beyond indices 0–13 is read/written in these three scripts (no `[14]`–`[29]`). So no *additional* settings indices are used here — good, consistent with "new data goes in 12–29" once B1 is split.
- One behavioural note on the array as a whole: `al.LI.FDN.event` allocates it at **size=30** (L008) and every script re-saves via `set global variable … value=$al.Settings` (`Supply.Start` L057). That's consistent with the table; no uncovered index.

## Tally
- **CONFIRMED:** settings 0,1,6,7(read),10(unused),11,12(dual-use),13(unused) = 8 settings entries (indices 10/13 as unused); ware 0,1(default),2(default),3,4,5,6,7 = all 8.
- **WRONG:** none directly contradicted — but two near-misses to confirm: index 11's range is really 0–5 before reset (table says "0..6"), and the L071 comment ("until call 3 times") disagrees with the code (`< 6`). Neither changes meaning.
- **NOT IN THESE SCRIPTS:** settings 2,3,4,8,9 (written elsewhere); settings 5, plus the DC-only/compare logic for ware 1,2,3,4,5,6 and the B5 trigger for ware 7 (meaning not verifiable here).

**One-line summary: 16 entries CONFIRMED (all 8 ware indices + settings 0,1,6,7,10,11,12,13), 0 strictly WRONG (2 minor range/comment discrepancies on index 11), and the remaining settings entries 2,3,4,5,8,9 are NOT IN THESE SCRIPTS.**


