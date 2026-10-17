# P0-B-B2: B2: does action='create' write the record under a null name?

- Phase: 0 (branch `phase0-setup`)
- Writes code: no
- Estimated size: ~3,934 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-B-B2_create_null_pointer.md`
- Save the answer as: `notes/P0-B-B2.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/plugin.LI.FDN.Update.Ware.txt`
- source_readable/plugin.LI.FDN.Main.Menu.txt lines 467-478
- source_readable/plugin.LI.FDN.Supply.Dock.txt lines 095-105

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B2 (high) Update.Ware 33-35 (+ Add.Ware.Sub 125-140); callers Main.Menu 475, Supply.Dock 100. `action='create'` jumps to Add.Ware.Sub before `$pointer` is assigned (only set at line 46), so the record is written under a null name. Result: Add Ware never creates settings, and Supply.Dock's create-then-read returns null. Fix direction: build `$pointer` before any gosub.

## Key facts

- This is a review only. Do not write or change any code.
- Quote code exactly, with its 3-digit line number from the pasted file. If you cannot find a line, say "not found" rather than guessing.
- Use only the pasted files. If you need another script, name it and stop.
- Claim: in Update.Ware, `action='create'` reaches Add.Ware.Sub (125-140) before `$pointer` is set at line 46.
- Main.Menu lines 467-478 (Add.Ware.Sub) and Supply.Dock lines 095-105 are the two callers that use action='create'. Only those lines of those two scripts are included.

## Instruction

Phase 0, task B, bug B2. Review only, no code.
1. Find the code the bug note points to and quote it exactly with line numbers.
2. Say CONFIRMED, PARTLY or REJECTED, and explain in 2-4 plain sentences why, using only the quoted lines.
3. If the line numbers in the bug note are off, give the correct ones.
4. Say what in-game test (if any) would settle it, in one or two steps.
Start with "Assumptions" and "Questions for Matt" (short).
