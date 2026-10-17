# P0-C1: Write tiny test scripts for MSCI behaviour (tests 1-4 and engine version)

- Phase: 0 (branch `phase0-setup`)
- Writes code: yes
- Estimated size: ~4,120 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-C1_semantics_tests.md`
- Save the answer as: `notes/P0-C1.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Supply.Start.txt`

## Excerpts

### Why these tests
Several fixes depend on engine behaviour nobody has checked: B4 (null compared with numbers), B13 (`reverse array`), the array-reference rule, and B3 (what a destroyed object variable returns). The engine version numbers are needed later for `lib.LI.FDN.Game` (FL patch scripts carry engine 60-74, AP is 50 or more, TC about 44).

## Key facts

- Supply.Start is pasted only as an example of real FDN syntax: `get global variable`, `write to log file`, `playing time`, `sprintf`. Copy command spellings from it.
- Each test script: 15 lines or fewer, no arguments, logs to log file 9999 (`write to log file 9999 append=[TRUE] value=$txt`), log lines start with the test number.
- Test script names: `test.LI.FDN.T1` ... `test.LI.FDN.T4`, `test.LI.FDN.T7`.
- Only use commands from the pasted script or the primer. Anything else: `VERIFY:`.

## Instruction

Phase 0, task C, part 1. Write five tiny MSCI test scripts:
T1: log the result of `null >= 0`, `null < 6` and `null == 0` (B4).
T2: make an array [1,2,3], run `reverse array` on it, and log both the original and the returned array, so we can see if it reverses in place or returns a copy (B13).
T3: `$a = get global variable` of a test global holding an array, set `$a[0]` to a new value without calling set global variable, re-read the global and log [0] (array reference rule).
T4: create a test object you can safely destroy (say which, and mark VERIFY if unsure), destruct it, then log what `if $obj` and `$obj -> exists` give (B3).
T7: log `script engine version` (for AP / FL detection).
For each: full source, the expected log lines, and one sentence on how Matt runs it (Script Editor, run on null). Keep each script short and plain.
