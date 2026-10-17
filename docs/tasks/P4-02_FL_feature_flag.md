# P4-02: Decide the FL patch feature flag [24]

- Phase: 4 (branch `phase4-compat`)
- Writes code: no
- Estimated size: ~1,793 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-02_FL_feature_flag.md`
- Save the answer as: `notes/P4-02.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- notes/NOTES_semantics.md (optional)

## Excerpts

### Compatibility notes (ANALYSIS 7)
- AP 3.3: native target (script engine 50 or more). FL 1.3: expected to work; FL patch scripts carry engine 60-74; install folder `addon2`. TC (about 44): out of scope.
- The FL Unofficial Patch 1.3.20 adds commands (e.g. `add script selection option`, `add sidebar custom entry`, `get dock storage wares`, `add object info menu`). Only use them behind a feature check.
- Always compare engine versions with >=, never ==.
- Community Plugin Configuration 1.61 is optional in v9; a hotkey is the fallback.

## Key facts

- Phase 4 = compatibility and upgrade. Never break the save-game rules in CORE RULES.
- Never invent commands; FL patch commands need a citation or VERIFY.
- Use the engine numbers from NOTES_semantics.md if included; otherwise mark VERIFY.

## Instruction

Phase 4, task P4-02. Propose a safe way to set [24] (FL Unofficial Patch available). If there is no safe test, say so and default it to FALSE. No code unless the test is certain.
Start with "Assumptions" and "Questions for Matt" (short).
