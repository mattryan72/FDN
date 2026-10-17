# Changelog

## [9.01] – in progress
### Baseline
- Imported FDN v8.04 (`src/`) as the starting point.

### Decisions
- Keep temporary docked freighter for trades; harden it (R-T1 / B15).
- Pending: B5 default dock surplus to DC, B9 reset scope, FL Station Manager exclusion.

### Docs
- Slimmed the local-AI prompt pack for the local model's context limits: new `docs/CORE_PROMPT.md` (short always-paste rules, about 1.2k tokens), `docs/MSCI_PRIMER.md` (moved out of the master prompt, pasted only when writing code), one task card per job in `docs/tasks/` (Phase 0 to 5), `tools/build_prompt.py` to build a paste-ready prompt with the instruction last, and `docs/CHECKING_ANSWERS.md`.
- The master prompt is now a reference for Matt, not something to paste. PHASE0 updated for the `phase0-setup` branch and `source_readable/`; phase plans point at their cards.
- Added Cline safety rules to `docs/CORE_PROMPT.md` (edit only the card's files, never touch XML/binary game files, one small find/replace per step, never push, commit only when asked, honest reports, keep `.gitattributes` line endings) and a "Using Cline" section to the README and `docs/CHECKING_ANSWERS.md` (commit or stash before each session).
- Recorded the P0-A findings (`notes/P0-A_findings.md`): settings [11] dock counter skips 6 calls and runs every 7th (the L071 comment is wrong); new minor bug B29 (dead `Debug.Sub` in Update.Ware, fix in Phase 2); allocation notes for is.dynamic [6] (size 10, only 0-2 set) and ware record [10] (never set); B1 and B2 confirmed.
- Recorded the P0-B findings (`notes/P0-B_findings.md`): B3, B7, B9 confirmed, B4 partly confirmed (pending test C1 T1); B3 locations extended (Supply.Factory L107, L129); B4 description corrected (Update.Ware 'add' also creates records; B2 makes the explicit 'create' calls no-ops); B7 fix narrowed to one line; B9 regex anchoring marked VERIFY with new test T8 in card P0-C1.
