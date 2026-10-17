# P4-06: lib.LI.FDN.Is.FL.Managed: detect FL Station Manager (approved)

- Phase: 4 (branch `phase4-compat`)
- Writes code: yes
- Estimated size: ~3,135 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-06_FL_Station_Manager.md`
- Save the answer as: `notes/P4-06.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- notes/NOTES_semantics.md (optional)

## Excerpts

### Compatibility notes (ANALYSIS 7)
- AP 3.3: native target (script engine 50 or more). FL 1.3: expected to work; FL patch scripts carry engine 60-74; install folder `addon2`. TC (about 44): out of scope.
- The FL Unofficial Patch 1.3.20 adds commands (e.g. `add script selection option`, `add sidebar custom entry`, `get dock storage wares`, `add object info menu`). Only use them behind a feature check.
- Always compare engine versions with >=, never ==.
- Community Plugin Configuration 1.61 is optional in v9; a hotkey is the fallback.

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Is.FL.Managed` | args: station | TRUE only on FL ([23] == 3) when the station is run by Station Manager; always FALSE on AP. Detection command is VERIFY (Phase 0 test T9) | FL Station Manager decision
- `lib.LI.FDN.Game` | args: none | returns 1 TC / 2 AP / 3 FL from `script engine version` with >= thresholds (VERIFY values) | replaces lib.BW.isAP uses

### Decision (approved by Matt 2026-10-17, REFERENCE H)
Any station run by FL's Station Manager is dropped from FDN: removed from [3]/[4]; if it is the DC, FDN pauses. Player message (text 330/331) and a log line (332), once per drop. Scan already calls Is.FL.Managed at its exists/owner checks (Phase 2 stub returns FALSE).

## Key facts

- Phase 4 = compatibility and upgrade. Never break the save-game rules in CORE RULES.
- Never invent commands; FL patch commands need a citation or VERIFY.
- Use the engine numbers from NOTES_semantics.md if included; otherwise mark VERIFY.
- T9 status (2026-10-17): only the negative sample is done (task 448 Task.Stationmanage FALSE on a normal station); the positive sample is pending, so the detection is not yet confirmed.
- Use the T9 result in NOTES_semantics.md for the detection. If T9 found nothing reliable, keep returning FALSE and say it is a known issue.
- Must return FALSE on AP without running any FL-only command (check [23] == 3 first).

## Instruction

Phase 4, task P4-06. Write lib.LI.FDN.Is.FL.Managed(station) from the T9 result: FALSE if [23] != 3 or the station is null; otherwise TRUE if the station is run by Station Manager. Mark the detection line VERIFY unless NOTES_semantics confirms it.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
