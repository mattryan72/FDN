# P2-05b: Write lib.LI.FDN.Reg.Add (B9 station registry)

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~2,883 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-05b_lib_Reg.Add.md`
- Save the answer as: `notes/P2-05b.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Reg.Add` | args: station | null; appends the station to registry [29] if not already there (creates the array if null) | B9 registry

### Registry (B9, approved by Matt 2026-10-17)
Settings [29] holds every station FDN has ever touched (DC, factory, dock, or given an FDN.Ware.* record), so Reset can clean stations that have since left the arrays. Pruning of dead stations happens in Reset and Upgrade, not here.

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.
- No scripts are pasted; this is a new helper.
- Settings arrays from get global variable are references; still call set global variable after changing [29] if the pasted examples do.

## Instruction

Phase 2, task P2-05b. Write lib.LI.FDN.Reg.Add(station): return null on a null station; create [29] if null; append the station only if `find` shows it is not already in the array. No waits.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
