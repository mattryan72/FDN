# P0-B-B3: B3: missing DC / owner checks

- Phase: 0 (branch `phase0-setup`)
- Writes code: no
- Estimated size: ~8,011 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-B-B3_dc_owner_checks.md`
- Save the answer as: `notes/P0-B-B3.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/plugin.LI.FDN.Supply.Start.txt`
- `source_readable/plugin.LI.FDN.Supply.Factory.txt`
- `source_readable/plugin.LI.FDN.Supply.Factory.Check.txt`
- `source_readable/plugin.LI.FDN.Supply.Dock.Check.txt`
- source_readable/plugin.LI.FDN.Main.Menu.txt lines 038-069

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B3 (critical, confirmed in P0-B) Supply.Start 46; Supply.Factory 67-72, 107, 129; Supply.Factory.Check 63; Supply.Dock.Check 39/47; Main.Menu 51. Only `if $dc` / `-> exists` are checked (Supply.Start L046 is just `if $dc`). (a) Destroyed DC: Supply.Factory L067 calls Update.Ware 'add' on the DC, but Update.Ware only handles stock if the station `is of class Dock` (L043), so it does nothing and returns 0; L071-072 then remove the product from the factory anyway, so wares vanish. L107 ('remove' from the DC) and L129 (reads the DC record) also use $dc unchecked. (b) No ownership check anywhere: the only `owner` in the code is `owner=Player` on the drone `create ship`. Sold or captured stations stay managed. Fix direction: validate the DC once per tick (exists, owner race == Player, is of class Dock); on failure pause and notify; remove from the factory only what Update.Ware reports as added; owner check in both Check loops.

## Key facts

- This is a review only. Do not write or change any code.
- Quote code exactly, with its 3-digit line number from the pasted file. If you cannot find a line, say "not found" rather than guessing.
- Use only the pasted files. If you need another script, name it and stop.
- Claim (a): if the DC is destroyed, Supply.Factory 67-72 still removes product from the factory, so wares vanish.
- Claim (b): no `get owner race` check anywhere, so sold or captured stations stay managed.
- Check every place the DC, a factory or a dock is used: is there an `exists` check, an owner check, a class check?

## Instruction

Phase 0, task B, bug B3. Review only, no code.
1. Find the code the bug note points to and quote it exactly with line numbers.
2. Say CONFIRMED, PARTLY or REJECTED, and explain in 2-4 plain sentences why, using only the quoted lines.
3. If the line numbers in the bug note are off, give the correct ones.
4. Say what in-game test (if any) would settle it, in one or two steps.
Start with "Assumptions" and "Questions for Matt" (short).
