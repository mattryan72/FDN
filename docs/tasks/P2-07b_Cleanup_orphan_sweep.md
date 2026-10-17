# P2-07b: Orphan trade-drone sweep in plugin.LI.FDN.Cleanup

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~2,874 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-07b_Cleanup_orphan_sweep.md`
- Save the answer as: `notes/P2-07b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Cleanup.txt`

## Excerpts

### Orphan sweep (REFERENCE G)
plugin.LI.FDN.Cleanup is STARTed on init/reinit (never inline in the AL event): `get ship array: of race Player class/type=TS`, destruct every ship whose `FDN.Trade.Drone` local is set (the tag is required; a name match alone is not enough). Log the count, reset [18] = 0 and [26] = null. Keep the existing FDND.* clearing.

## Key facts

- Cleanup is a task, so it may wait between ships.
- Never invent commands; mark VERIFY.

## Instruction

Phase 2, task P2-07b. Extend plugin.LI.FDN.Cleanup with the orphan drone sweep described above, keeping what it does today.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
