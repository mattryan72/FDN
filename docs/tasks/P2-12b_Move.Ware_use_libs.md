# P2-12b: Move.Ware on the shared libraries

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~4,712 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-12b_Move.Ware_use_libs.md`
- Save the answer as: `notes/P2-12b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Move.Ware.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Cfg.Get` | args: none | returns the settings array or null if FDN is not initialised | replaces the D1 header
- `lib.LI.FDN.Log` | args: text (String), caller (String) | returns null; writes to log file [1] only if [7] (debug) is on | replaces 9 copies of Debug.Sub (D2); callers do `$s.name = = get script name` and pass it
- `lib.LI.FDN.Ware.Rec` | args: station, ware, create (Boolean) | record array (created with v9 defaults if create) or null; create=FALSE never writes | D3, B2, B18
- `lib.LI.FDN.Is.Valid` | args: obj, need.dock (Boolean) | TRUE if obj exists, owner race == Player, and is a Dock if asked | B3, B12

### v9 standard header (the only allowed copy of the settings fetch)
```
$al.Settings = [THIS] -> call script lib.LI.FDN.Cfg.Get :
if not $al.Settings
 return null
end
$PageID = $al.Settings[1]
```

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.
- The libraries above already exist; call them with `[THIS] -> call script lib.LI.FDN.<name> : ...`.
- No Debug.Sub left; list which D/P/B IDs the script closes.

## Instruction

Phase 2, task P2-12b. Switch Move.Ware to Cfg.Get, Is.Valid, Ware.Rec and Log. Keep its two arguments (ware, source), all its user prompts and texts (page text ids 184, 178 for the prompts; 192, 193, 194 for the subtitles), and its behaviour: it always returns null. It is called by Main.Menu (`move.ware`, source = the station whose menu is open) and is interactive (get user input), so the player can wait a long time inside a prompt. Rewrite the whole script as clean v9.01 source (the pasted file is v2 with patches and old line numbers; drop all of those, no source line numbers in comments).

HOW TO WRITE IT (Cline stalled on a whole-file edit last card): do NOT edit source_readable/plugin.LI.FDN.Move.Ware.txt in place. Use the editor "create" command to make source_readable/plugin.LI.FDN.Move.Ware.new.txt in pieces of about 40 lines or fewer (create the first piece, then append each next piece with the editor insert command at the end of the file). After each piece tell me the line count and WAIT for my "next". Never repeat an identical editor call that failed: tell me the error and what you will change. Piece order: (1) header + guards, (2) source stock + destination prompt, (3) amount prompt + re-checks, (4) the move + logging + final return + Source.Stock.Sub. When the .new file is complete, give me the if/end counts and wait for "swap". Only then copy it over the real file, convert to CRLF, remove only the .new file you created.

Rules specific to this card:
1. HEADER: standard Cfg.Get header (return null if not $al.Settings); keep `$PageID = $al.Settings[1]` because read text and sprintf need it. Add `$s.name = = get script name` and `$debug.on = $al.Settings[7]` right after. Delete $script, $DebugID, $txt.debug and Debug.Sub. Build log text into $txt.log (not $txt, which is used for the prompt texts), call `= [THIS] -> call script lib.LI.FDN.Log : text=$txt.log caller=$s.name`, station first in the text, only inside `if $debug.on`.
2. SOURCE: validate with `lib.LI.FDN.Is.Valid obj=$source need.dock=[FALSE]` (returns TRUE, FALSE or null; test with plain `if not $src.valid`); on failure log and return null. Read the source record with `lib.LI.FDN.Ware.Rec station=$source ware=$ware create=[FALSE]` (never creates). A null record means virtual stock 0 (v2 read `$ware.array[0]` on a null array - that is the bug this closes). Virtual stock that is not > 0 counts as 0. Put the source stock calculation (virtual + `get amount of ware in cargo bay`, into $stock.avialable... fix the spelling to $stock.available) in a small sub `Source.Stock.Sub:` (gosub, endsub after the last return) because it runs twice: before the prompts and again after them.
3. DESTINATION: Is.Valid cannot be used here, it rejects ships (it needs a station) and the prompt allows `Var/Ship/Station owned by Player`. Keep the cancelled-prompt null exit (B20) before any `->` call. Then copy `->` results into locals before testing them: `$dest.is.dock = $destination -> is of class Dock 2007` and, for a non-Dock destination only, `$dest.free = $destination -> get free amount of ware $ware in cargo bay`; if that free amount is not > 0, show the existing subtitle 194 and return null (same as v2). Keep the same-station exit with subtitle 192.
4. AMOUNT: keep the amount prompt, the null (cancel) path with subtitle 193, the `not $amount > 0` exit, and the clamp to the available stock. After the amount prompt the player may have waited: call Is.Valid on $source again, re-check `$dest.exists = $destination -> exists`, gosub Source.Stock.Sub: again and clamp $amount to the fresh $stock.available (log and return null if either object is gone or stock is 0).
5. THE MOVE: v2 had two copies of the add-then-remove code (Dock and non-Dock). Merge into ONE path: `$amount.added = Update.Ware ware=$ware amount=$amount station=$destination action='add'`; if $amount.added is not > 0, log it and return null; clamp $amount to $amount.added if smaller; then `$amount.removed = Update.Ware ... station=$source action='remove'` and keep the result (v2 discarded it). Do not change what is added or removed. Log the requested amount, added and removed (station first). If $amount.removed is less than $amount.added the source changed in the last instant: log a clear 'Move mismatch' line, do not try to undo.
6. STYLE: no AND/OR/!=, no -> or call in conditions (copy to locals first), a discarded call needs a leading `= `, comments on their own line, nested ifs with a flag instead of AND, block balance recounted by command. No `continue`, no gosub inside a loop (there is no loop). One `return null` per path is fine here: there is no lock or counter, so no Exit: label is needed.
7. Header: `* Tested: not tested`, Version 3.0, engine line v3, Date 26/10/2026, Returns values 'N/A - always returns null', a change block listing the D/B IDs closed: D1, D2 (one of nine), D3, B3/B12 for the source check, B20 kept.
8. notes/P2-12b.md (editor tool, ASCII, CRLF, `$names` literal) and ONE CHANGELOG.md line under `### Changed` placed AFTER the Update.Ware (P2-12a) line, no blank line between list items, ASCII hyphens only, do not move or delete any other line.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.