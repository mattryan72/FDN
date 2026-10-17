# P4-03: plugin.LI.FDN.Setup: config entry, hotkey fallback, optional FL entries (B6)

- Phase: 4 (branch `phase4-compat`)
- Writes code: yes
- Estimated size: ~3,407 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-03_Setup_hotkey.md`
- Save the answer as: `notes/P4-03.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Setup.txt`

## Excerpts

### Compatibility notes (ANALYSIS 7)
- AP 3.3: native target (script engine 50 or more). FL 1.3: expected to work; FL patch scripts carry engine 60-74; install folder `addon2`. TC (about 44): out of scope.
- The FL Unofficial Patch 1.3.20 adds commands (e.g. `add script selection option`, `add sidebar custom entry`, `get dock storage wares`, `add object info menu`). Only use them behind a feature check.
- Always compare engine versions with >=, never ==.
- Community Plugin Configuration 1.61 is optional in v9; a hotkey is the fallback.

### Bug notes from the analysis (line numbers are Script Editor lines)
- B6 (high) Setup 36-38, 42-53. Hard dependency on `plugin.config.addscript` (Cycrow's Community Plugin Configuration). Without it FDN has no menu. Removal matches display text against the library's internal array, which is fragile. Fix direction: only call it if available; hotkey fallback comes in Phase 4.

## Key facts

- Phase 4 = compatibility and upgrade. Never break the save-game rules in CORE RULES.
- Never invent commands; FL patch commands need a citation or VERIFY.
- Use the engine numbers from NOTES_semantics.md if included; otherwise mark VERIFY.
- Keep text 101/102 and the script name string 'plugin.LI.FDN.Main.Menu'. Hotkey id goes in [21]; unregister on stop.

## Instruction

Phase 4, task P4-03. Rewrite plugin.LI.FDN.Setup: (a) Community Plugin Configuration entry unchanged; (b) hotkey fallback with `register hotkey` / `unregister hotkey` (VERIFY exact syntax); (c) if [24], the optional FL sidebar / script-selection entries.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
