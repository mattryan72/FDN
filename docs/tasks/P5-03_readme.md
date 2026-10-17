# P5-03: Write the readme (forum BBCode and Markdown)

- Phase: 5 (branch `phase5-release`)
- Writes code: no
- Estimated size: ~2,321 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P5-03_readme.md`
- Save the answer as: `notes/P5-03.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `CHANGELOG.md`

## Excerpts

### Compatibility notes (ANALYSIS 7)
- AP 3.3: native target (script engine 50 or more). FL 1.3: expected to work; FL patch scripts carry engine 60-74; install folder `addon2`. TC (about 44): out of scope.
- The FL Unofficial Patch 1.3.20 adds commands (e.g. `add script selection option`, `add sidebar custom entry`, `get dock storage wares`, `add object info menu`). Only use them behind a feature check.
- Always compare engine versions with >=, never ==.
- Community Plugin Configuration 1.61 is optional in v9; a hotkey is the fallback.

### Requirements and credits
AP 3.3 or FL 1.3; optional Community Plugin Configuration 1.61; Plugin Manager 1.92. Litcube's Universe: unsupported. XRM: works, drone type resolved at runtime. Credits: Logain Abler; Bullwinkle (lib.BW.isAP). Text page and log id 9910.

## Key facts

- Phase 5 = testing and packaging. Plain language for players; Matt is the author (Logain Abler, Logain Industries).
- Do not invent features: only what CHANGELOG.md says.

## Instruction

Phase 5, task P5-03. Write the readme twice: BBCode for the Egosoft forum and Markdown for git. Sections: what FDN does, requirements, install / upgrade / uninstall, hotkey, known issues, compatibility, credits.
Start with "Assumptions" and "Questions for Matt" (short).
