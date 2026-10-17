# P2-14: Decision logging for the dock pass, buy and sell (debug [7])

- Phase: 2 (branch `phase2-libs`, after P2-10b, P2-11a/b and P2-12a)
- Writes code: yes
- Estimated size: ~6,337 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-14_debug_logging.md`
- Save the answer as: `notes/P2-14.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Supply.Dock.txt`
- source_readable/plugin.LI.FDN.Supply.Factory.txt lines 081-137

(If P2-10b/P2-11a/b are done, paste the current v9 versions of Supply.Dock, Buy.Ware and Sell.Ware instead and drop the Supply.Factory excerpt if the card gets too big.)

## Excerpts

### Why (Matt, 2026-10-17, FL supply logs 1 and 2)
- v8.04 writes no debug lines in Supply.Dock.Check / Supply.Dock, so dock supply could only be inferred, from the DC running short of Energy Cells straight after a dock pass.
- "Buy N of ware X" (Supply.Factory L121-125) is written **before** the can-buy check (L131), so it reads like a purchase but is only a shortfall. Buy.Ware wrote nothing because it never started.
- A DC change is not visible in the log at all (the first pass after it showed `Buy null`, B30).
- Noise: `Remove 0  of <ware>` lines (2 per factory per pass). The log grew about 9 KB a minute with 6 factories.

### Library contract
- `lib.LI.FDN.Log` | args: text (String), obj (Value, optional) | returns null; writes to log file [1] only if [7] (debug) is on | keep the line format `time;script;text`

### Lines to add (all via lib.LI.FDN.Log, only when [7] is on; one line per decision, no new setting)
Dock pass (Supply.Dock.Check / Supply.Dock):
- Pass start/end: `Dock pass start: docks=<n>` and `Dock pass end: wares=<n> moved=<n> skipped=<n>`.
- Per dock/ware that has a record: `<dock> <ware>: maintain=<[2]> stock=<virtual>+<physical> dc.remote=<DC [1]> dc.stock=<virtual>+<physical> need=<n> moved=<n>`.
- Skip reasons, one per ware, with the same prefix:
  - `skip: dock is DC`
  - `skip: ST ware`
  - `skip: no record`
  - `skip: maintain not set`
  - `skip: stock >= maintain`
  - `skip: DC remote off (<= 0)`
  - `skip: DC stock <= remote level`
- Surplus: `surplus <n> passed to DC` or `surplus off`.
- Dock removed: `dock gone, removed from [4]`.

Buy/sell:
- Supply.Factory shortfall: replace `Buy N of ware ...` with `<factory> short <n> of <ware> at DC; buy allowed=<yes/no>`.
- Buy.Ware / Sell.Ware:
  - start: ware, amount, home
  - partner found or `no seller/buyer within <n> jumps`
  - price and price-sanity result
  - bought/sold amount and where it went
  - abort reason: lock busy, task cap [18]/[19], drone create failed, partner gone
- Remove the `Remove 0` noise: log the product pass only when the amount is > 0.

DC change: logged by the menu (P3-04 `set.dc`): `DC changed: <old> -> <new>`. Also, Supply.Start logs `DC: <dc>` once per Scan run, so every log shows which station is the DC.

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use only lib.LI.FDN.Log for output. No Debug.Sub, no new log file, no new setting: everything is under the existing "Supply Debug:" toggle [7].
- Logging must not change behaviour: no extra waits, no extra record creation (read records with `Ware.Rec` create=FALSE for logging).
- Keep lines short: object names via `$obj` (Log adds them), numbers as plain numbers.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.

## Instruction

Phase 2, task P2-14. Add the decision log lines listed above to Supply.Dock.Check, Supply.Dock, Supply.Factory (shortfall line, no `Remove 0` noise), Buy.Ware and Sell.Ware, using lib.LI.FDN.Log only. Each skip path logs exactly one reason. Do not change any supply decision. Give the diff per script.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
