# M-05j-regroup: new plugin.LI.FDN.EC.Regroup - Energy Cells between DCs

- Phase: M (multi-DC, branch `phase4-compat`)
- Writes code: yes (ONE new file, nothing else)
- Build: `python tools/build_prompt.py docs/tasks/M-05j-regroup.md --out prompts/M-05j-EC.Regroup.txt`
- Save the answer as: `source_readable/plugin.LI.FDN.EC.Regroup.txt` (new file, CRLF, ASCII, no BOM)
- Part of M-05 (docs/tasks/M-05.md, Piece J). Supply.Start already STARTs this script (M-05j apply). Matt's assistant compiles, installs and tests (M 7, N 10).

## Paste

CORE_PROMPT.md is always added first by the builder. Nothing else is pasted; every call you need is copied below.

## Excerpts

### Exact call syntax (copied from installed scripts - use exactly these forms)
```
$al.Settings = [THIS] -> call script lib.LI.FDN.Cfg.Get :
$dc.list = [THIS] -> call script lib.LI.FDN.Dc.List :
$rec = [THIS] -> call script lib.LI.FDN.Ware.Rec : station=$dc ware=$ec.ware create=[FALSE]
$phys = $dc  ->  get amount of ware $ec.ware in cargo bay
$got = [THIS] -> call script lib.LI.FDN.Pull : home=$dc ware=$ec.ware need=$gap
$txt = = sprintf: pageid=$PageID textid=341, $total, null, null, null, null
write to player logbook $txt
= [THIS] -> call script lib.LI.FDN.Log : text=$txt.log caller=$s.name
set global variable: name='al.LI.FDN.event' value=$al.Settings
$now = = playing time
$s.name = = get script name
```
Set the ware once at the top: `$ec.ware = [SS_WARE_ENERGY]` (the form used in lib.LI.FDN.Pull).

### Contracts
- Dc.List -> array of valid DCs ([2] first), or null when settings are missing or smaller than 40.
- Ware.Rec create=[FALSE] -> record array or null. [0] = virtual stock, [2] = EC maintain level.
- Pull -> INT units that reached home (wait-free; it applies every source's protect, pays each backbone leg with the sender, counts deferred legs in [37]). Do NOT repeat any of that here.
- Text 341 (page [1]): `FDN: %s Energy Cells moved between Distribution Centres`.

## Key facts

Lessons from M-05d/e/f (each one was a real bug):
1. No `return` inside a sub; this script needs no subs at all.
2. Copy array elements to a local before any `if`/`while` (`$x = $rec[2]` then `if $x ...`).
3. No AND/OR/&&/||/!=, no break/continue, no `$i++` (use `inc $i =`), never `$null =`.
4. Every `if`/`while` has its own `end`; count them before you answer.
5. Do not invent helpers or arguments: only the calls above exist for this file.
6. Non-INT results count as 0 (`if not is datatyp[ $got ] == DATATYPE_INT` then `$got = 0`).
7. Header: ` * v9.01 D6 (M-05j): new - network Energy Cell regroup between DCs` and `* Tested: not tested`.

## Instruction

Write the complete new file `source_readable/plugin.LI.FDN.EC.Regroup.txt` (no arguments). Steps:
1. Cfg.Get; null, or `size of array` < 40 -> `return null` (no stamp).
2. `$cost.on = $al.Settings[33]`; not 1 -> `return null` (no stamp).
3. Dc.List; not an array, or size < 2 -> `return null` (no stamp; one DC does nothing).
4. `$now`; `$al.Settings[36] = $now`; store the global.
5. `$total = 0`; index loop over the list: Ware.Rec; no record -> skip. `$maintain = $rec[2]`, skip unless an INT > 0. `$virt = $rec[0]` (non-INT -> 0) + `$phys` = `$stock`. When `$stock < $maintain`: `$gap = $maintain - $stock`, Pull, non-INT -> 0, `$total = $total + $got`.
6. `$total > 0` -> `$PageID = $al.Settings[1]`, sprintf 341, logbook.
7. Debug ([7] copied to a local) on -> one Log line `'EC.Regroup: DCs=' + $dl.size + ' moved=' + $total`.
8. `return null`.
Use the editor tool only to create this one file. Do not change any other file. Answer with the file and a short list of the checks you did.
