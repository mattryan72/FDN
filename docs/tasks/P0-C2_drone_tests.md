# P0-C2: Write test scripts for the temporary trade drone (tests 5 and 6)

- Phase: 0 (branch `phase0-setup`)
- Writes code: yes
- Estimated size: ~4,260 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-C2_drone_tests.md`
- Save the answer as: `notes/P0-C2.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- source_readable/plugin.LI.FDN.Buy.Ware.txt lines 059-090
- source_readable/plugin.LI.FDN.Sell.Ware.txt lines 068-104

## Excerpts

### Why FDN uses a temporary trade drone (decision R-T1: keep it, make it robust)
MSCI has no station-to-station trade command. FDN creates a player ship already docked at the NPC station, sets its homebase to the DC or dock, buys or sells, and destroys it straight away with nothing waiting in between. v9 keeps this but adds checks. Unknowns to test: does `create ship` return null for a bad type; do the docking/transport checks work on the new ship; does destroying it fire SIGNAL_KILLED, show a message or count as a ship lost.

## Key facts

- The pasted Buy.Ware and Sell.Ware lines show the real v8 drone code (`create ship: type=Argon Mercury Super Freighter XL owner=Player addto=...`, `set homebase to`, `buy`/`sell`, `destruct: show no explosion=[TRUE]`). Copy command spellings from there.
- Commands not in the pasted code (for example `is docking allowed at`, `can transport ware`, `get max amount of ware ... cargo bay`, `add secondary signal`, `get maker race`) must be marked `VERIFY:` unless you can cite a reference.
- Log to file 9999; scripts 25 lines or fewer; names `test.LI.FDN.T5`, `test.LI.FDN.T6` (+ a tiny signal-handler script for T6 if needed).
- Nothing may `wait` between create ship and destruct.

## Instruction

Phase 0, task C, part 2. Write two test scripts:
T5: find an NPC station that trades a known ware (say how, or take it as an argument). Create a ship at it with a valid TS type, log: the result, `-> exists`, docking allowed, can transport the ware, max cargo amount for the ware, its name and maker race. Destruct it. Then try again with an invalid or null type and log what `create ship` returns.
T6: create a docked TS the same way, add a secondary SIGNAL_KILLED handler that writes a log line, then `destruct: show no explosion=[TRUE]`. Log whether the handler ran. Tell Matt what to look at by hand: any on-screen message, and the Statistics "ships lost" line before and after.
For each: full source, expected log lines, how to run it, and what result would be bad news for the drone approach.
