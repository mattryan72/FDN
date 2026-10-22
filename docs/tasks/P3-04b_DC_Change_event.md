# P3-04b: Write plugin.LI.FDN.DC.Change (DC change as one event)

- Phase: 3 (branch `phase3-menus`, after P3-04; needs the Phase 2 libs)
- Writes code: yes
- Estimated size: ~4,417 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P3-04b_DC_Change_event.md`
- Save the answer as: `notes/P3-04b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- source_readable/plugin.LI.FDN.Main.Menu.txt lines 175-183
- source_readable/plugin.LI.FDN.Update.Ware.txt lines 029-058, 125-148

## Excerpts

### Why (scheduled by Matt 2026-10-17; docs/DESIGN_v9_direction.md item 1)
- v8 `add.dc`/`change.dc` (Main.Menu L175-183) only overwrite `[2]`. FL log 2: the first pass after a change (01:30:02) logged `Buy null`. The new DC had no ware records, and Update.Ware L051-057 does not re-read the record it just created (B30), so the take returned null and may have removed DC stock.
- The old DC keeps DC-only fields ([1] remote, [3] can-buy), and its stock is stranded unless surplus is on. Nothing is logged.

### Steps (all wait-free, in this order)
1. Pause: `lib.LI.FDN.Lock(null, <supply-run key from P2-05/P2-08>, 'try', timeout)`. If FALSE, return 'busy' and change nothing.
2. Validate: `Is.Valid(new, need.dock=TRUE)`; refuse if new == old; on FL (`[23]` == 3) refuse if `Is.FL.Managed(new)`. On refusal, release the lock and return the reason.
3. Ensure records on the new DC with `Ware.Rec(new, ware, create=TRUE)` for every ware in: the products and resources of each factory in `[3]` (VERIFY the product/resource array commands; `get product ware` is used in v8 Supply.Factory L035), the tradeable wares of each dock in `[4]`, and each ware with a record on the old DC.
4. Carry over DC policy (Q1.1, default: copy): [1], [3], [4], [5], [6] from the old DC's record when the new record still has defaults.
5. Old DC, if it still exists and is valid: it stays in `[4]` as a dock; clear [1] and [3] in its records; leave [2] unset; set [7] = 1 (surplus on, Q1.2).
6. `[2]` = new; `Reg.Add(new)`; save the settings with `set global variable`.
7. Log via `lib.LI.FDN.Log` (text, caller): `$s.name = = get script name`, then `= [THIS] -> call script lib.LI.FDN.Log : text='DC changed: <old> -> <new>; records created <n>, copied <n>' caller=$s.name`, and a player message (new text in 300-399; propose the XML line).
8. Release the lock; return 'ok'.

### Library contracts (REFERENCE D)
- `lib.LI.FDN.Lock` | obj (or null = global), key (String), action ('try'/'release'), timeout s | TRUE if acquired/released
- `lib.LI.FDN.Is.Valid` | obj, need.dock (Boolean) | TRUE if it exists, owner race == Player (and is a Dock if asked)
- `lib.LI.FDN.Ware.Rec` | station, ware, create (Boolean) | record array (created with v9 defaults if create) or null
- `lib.LI.FDN.Reg.Add` | station | null; appends to registry [29]
- `lib.LI.FDN.Log` | text (String), caller (String) | writes only if [7]; callers do `$s.name = = get script name` and pass it
- `lib.LI.FDN.Is.FL.Managed` | station | FALSE unless FL and run by Station Manager (P4-06; a FALSE placeholder before Phase 4)

## Key facts

- Wait-free: no `wait`, no START. Every exit path releases the lock (single `Exit:` label).
- VERIFY: an MSCI script with no waits is not interrupted by other scripts (that is why holding the lock is enough).
- Menu.Command `set.dc` (P3-04) confirms with the player, then calls this script and shows the result ('busy' → "Supply pass running, try again in a few seconds").
- Source text only, never XML (except the proposed text line). Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.

## Instruction

Phase 3, task P3-04b. Write plugin.LI.FDN.DC.Change(old, new) implementing the 8 steps above, returning 'ok', 'busy' or a refusal reason string. Also give the 3-5 changed lines for P3-04's set.dc handler that call it.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
