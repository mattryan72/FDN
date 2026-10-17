# P0-B-B9: B9: master reset regex and scope

- Phase: 0 (branch `phase0-setup`)
- Writes code: no
- Estimated size: ~2,712 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-B-B9_reset_regex.md`
- Save the answer as: `notes/P0-B-B9.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/plugin.LI.FDN.Reset.txt`

## Excerpts

### Bug notes from the analysis (line numbers are Script Editor lines)
- B9 (confirmed in P0-B; scope approved by Matt 2026-10-17) Reset L064 regex `'FDN*'` matches any variable containing 'FD'. L028-030: no null/exists check on the DC. Reset never pauses FDN ([0]). L043-048 only clear docks still in the dock array. Approved fix: set [0] FALSE first; walk the registry [29] plus [2], [3], [4]; skip stations that don't exist; clear with `'^FDN\.'` (test T8 passed on FL 2026-10-17: one backslash, never two; `'^FDN[.]'` also works); then empty [3], [4], [29] and set [2] = null.

## Key facts

- This is a review only. Do not write or change any code.
- Quote code exactly, with its 3-digit line number from the pasted file. If you cannot find a line, say "not found" rather than guessing.
- Use only the pasted files. If you need another script, name it and stop.
- Claim: Reset lines 28-30 and 64 use regex `'FDN*'`, which matches any name containing 'FD'.
- Also check: null/exists checks on the DC and stations, whether running supply tasks are stopped, and which stations get cleared.

## Instruction

Phase 0, task B, bug B9. Review only, no code.
1. Find the code the bug note points to and quote it exactly with line numbers.
2. Say CONFIRMED, PARTLY or REJECTED, and explain in 2-4 plain sentences why, using only the quoted lines.
3. If the line numbers in the bug note are off, give the correct ones.
4. Say what in-game test (if any) would settle it, in one or two steps.
Start with "Assumptions" and "Questions for Matt" (short).
