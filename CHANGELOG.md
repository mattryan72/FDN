# Changelog

## [9.01] - Unreleased

### Baseline
- Imported FDN v8.04 (`src/`) as the starting point.

### Decisions
- Keep temporary docked freighter for trades; harden it (R-T1 / B15).
- B5, B9 and the FL Station Manager exclusion approved by Matt on 2026-10-17 (see Behaviour changes).

### Fixed
- [B1] Lock and settings index 12 collision (planned)
- [B2] 'create' null pointer (planned)
- [B3] DC/owner validation (planned)
- [B4] Null sell cap sells all stock (planned)
- [B5] Surplus default of -1 (planned; configurable default, approved, see below)
- [B6] Config-menu dependency (planned)
- [B7] Dynamic index 1 vs 2 (planned)
- [B8] Stacked _D updaters (planned)
- [B9] Reset regex scope (planned; registry-based reset, approved, see below)
- [B10] Sector.Array modes (planned)
- [B11] Duplicate Buy/Sell tasks (planned)
- [B12] No re-validation after waits (planned)
- [B13] Reverse array copy (planned)
- [B14] Wait in AL path (planned)
- [B15] Fragile temp-drone trades; drone kept and hardened per R-T1 (planned)
- [B16] Settings schema unversioned (planned)

### Changed
- None yet.

### Behaviour changes (need approval)
Approved by Matt on 2026-10-17:
- [B5] **Approved.** "Pass surplus to DC" becomes configurable: new global default in settings [28] (on / off / v8 compatible) for wares with no explicit choice; per-ware [7] is an override (1 on, 0 off, -1/null use the default). New Config menu row (texts 320-325). The v8 upgrade sets the default to "on" and turns v8's null ("switched off") into 0, so existing players see no change (migration approved by Matt on 2026-10-17). Fresh installs also default to "on", matching v8 (decided 2026-10-17).
- [B9] **Approved.** Reset clears FDN locals on every station FDN manages or has managed, using a new station registry in settings [29] (filled when a station joins the arrays or gets a ware record, pruned at Reset/Upgrade, seeded from [2]/[3]/[4] on upgrade). Reset pauses FDN first ([0] = FALSE), skips stations that no longer exist, and uses the anchored regex `'^FDN\.'` if test T8 passes, otherwise an exact-prefix loop.
- [FL] **Approved.** On Farnham's Legacy, stations run by Station Manager are dropped from the FDN network (removed from the factory/dock arrays; if it is the DC, FDN pauses), with a player message and a log line. Detection via `lib.LI.FDN.Is.FL.Managed` (FL only; exact command VERIFY, test T9 in card P0-C3), checked in Scan.

### Removed
- None yet.

### Compatibility
- Targets X3 Albion Prelude 3.3 and Farnham's Legacy 1.3, with or without Unofficial Patch 1.3.20; TC out of scope.

### Docs
- Slimmed the local-AI prompt pack for the local model's context limits: new `docs/CORE_PROMPT.md` (short always-paste rules, about 1.2k tokens), `docs/MSCI_PRIMER.md` (moved out of the master prompt, pasted only when writing code), one task card per job in `docs/tasks/` (Phase 0 to 5), `tools/build_prompt.py` to build a paste-ready prompt with the instruction last, and `docs/CHECKING_ANSWERS.md`.
- The master prompt is now a reference for Matt, not something to paste. PHASE0 updated for the `phase0-setup` branch and `source_readable/`; phase plans point at their cards.
- Added Cline safety rules to `docs/CORE_PROMPT.md` (edit only the card's files, never touch XML/binary game files, one small find/replace per step, never push, commit only when asked, honest reports, keep `.gitattributes` line endings) and a "Using Cline" section to the README and `docs/CHECKING_ANSWERS.md` (commit or stash before each session).
- Recorded the P0-A findings (`notes/P0-A_findings.md`): settings [11] dock counter skips 6 calls and runs every 7th (the L071 comment is wrong); new minor bug B29 (dead `Debug.Sub` in Update.Ware, fix in Phase 2); allocation notes for is.dynamic [6] (size 10, only 0-2 set) and ware record [10] (never set); B1 and B2 confirmed.
- Recorded the P0-B findings (`notes/P0-B_findings.md`): B3, B7, B9 confirmed, B4 partly confirmed (pending test C1 T1); B3 locations extended (Supply.Factory L107, L129); B4 description corrected (Update.Ware 'add' also creates records; B2 makes the explicit 'create' calls no-ops); B7 fix narrowed to one line; B9 regex anchoring marked VERIFY with new test T8 in card P0-C1.
- Recorded Matt's approved decisions (2026-10-17): B5 configurable surplus default (settings [28], texts 320-325), B9 registry-based Reset (settings [29], `lib.LI.FDN.Reg.Add`), FL Station Manager exclusion (`lib.LI.FDN.Is.FL.Managed`, texts 330-332, REFERENCE §H, test T9). Updated REFERENCE, ANALYSIS, MASTER §7, PHASE0-4 and the cards; new cards P0-C3, P2-05b, P4-04b; P4-06 rewritten.
- B5 upgrade migration ([7] null -> 0) approved by Matt on 2026-10-17; fresh-install default [28] = 1 (on) decided.
