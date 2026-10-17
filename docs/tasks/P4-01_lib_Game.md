# P4-01: Write lib.LI.FDN.Game

- Phase: 4 (branch `phase4-compat`)
- Writes code: yes
- Estimated size: ~3,060 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-01_lib_Game.md`
- Save the answer as: `notes/P4-01.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)
- `source_readable/lib.BW.isAP.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Game` | args: none | returns 1 TC / 2 AP / 3 FL from `script engine version` with >= thresholds (FL 1.3 + UP 1.3.20 = 60 from test T7; provisional >= 60 FL, >= 50 AP, else TC; VERIFY the AP 3.3 value) | replaces lib.BW.isAP uses

### Compatibility notes (ANALYSIS 7)
- AP 3.3: native target (script engine 50 or more). FL 1.3: expected to work; FL patch scripts carry engine 60-74; install folder `addon2`. TC (about 44): out of scope.
- The FL Unofficial Patch 1.3.20 adds commands (e.g. `add script selection option`, `add sidebar custom entry`, `get dock storage wares`, `add object info menu`). Only use them behind a feature check.
- Always compare engine versions with >=, never ==.
- Community Plugin Configuration 1.61 is optional in v9; a hotkey is the fallback.

## Key facts

- Phase 4 = compatibility and upgrade. Never break the save-game rules in CORE RULES.
- Never invent commands; FL patch commands need a citation or VERIFY.
- Use the engine numbers from NOTES_semantics.md if included; otherwise mark VERIFY.
- Do not edit lib.BW.isAP; it is pasted only as an example.

## Instruction

Phase 4, task P4-01. Write lib.LI.FDN.Game returning 1/2/3 from `script engine version` with >= thresholds, and store the result in [23] (the caller does that; say where).
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
