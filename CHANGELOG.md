# Changelog

## [9.01] - Unreleased

### Baseline
- Imported FDN v8.04 (`src/`) as the starting point.

### Decisions
- Keep temporary docked freighter for trades; harden it (R-T1 / B15).
- B5, B9 and the FL Station Manager exclusion approved by Matt on 2026-10-17 (see Behaviour changes).

### Fixed
- [B1] Supply.Start: real run-lock on settings [12] (stores `playing time`, stale after 120 s, set on the array not a local copy); while locked only the factory pass is skipped. Supply.Factory.Check releases [12] on every exit (no array, empty array, end of loop); the direction toggle that v8 kept in [12] moved to [13].
- [B2] Update.Ware: record name built before 'create'; 'create' only writes a missing record.
- [B3] Supply.Start: DC validated every tick (exists / owner race == Player / Dock class 2007); on failure clears settings [2], writes a logbook entry for the player and pauses. Supply.Factory.Check: a factory must exist and be owned by the player (`get owner race` == Player); missing, sold, captured or given-away stations are removed from the stored array [3]. Other B3 sites (Supply.Factory, Dock.Check) are their own cards. Supply.Factory: DC validated once per task; products are only taken from the factory when the DC is valid, and only the amount Update.Ware reports as added (null falls back to v8 until P1-04); resource remove and buy are skipped while the DC is invalid; a missing DC ware record skips only that ware's buy.
- [B3] Supply.Dock.Check: early return when settings [2] is null (Supply.Start owns DC validation); docks that do not exist or are not player-owned are removed from the stored array [4], with debug reason lines ' Clean from Dock Array - does not exist / not player owned'.
- [B30] Update.Ware: record re-read after it is created; non-Dock 'remove' no longer returns null (virtual stock defaults to 0).
- [B4] Supply.Dock: sell cap used only when the ware record exists and [5] is an integer >= 0; otherwise that ware is skipped.
- [B4][B12][B15] Sell.Ware: return without selling when the ware record is missing, sell-at price is not an int, or the sell cap is not an int >= 0; dock and DC re-checked after each wait; trade drone only used if create ship worked, named 'FDN Trade Drone' and tagged FDN.Trade.Drone, null sell treated as 0, destructed behind an exists check.
- [B5] Surplus default of -1 (planned; configurable default, approved, see below)
- [B6] Config-menu dependency (planned)
- [B7] Dynamic index 1 vs 2 (planned)
- [B8] Stacked _D updaters (planned)
- [B9] Reset regex scope (planned; registry-based reset, approved, see below). Update.Ware adds each station that gets a new ware record to registry [29] (P1-04).
- [B10] Sector.Array modes (planned)
- [B11] Supply.Factory: Buy.Ware is STARTed at most once per 120 s per factory (factory FDN.Settings [3] = playing time of the last start, stale after 120 s). Sell side (Supply.Dock) planned.
- [B12] Supply.Dock: after each wait in the ware loops the task stops if the dock or DC no longer exists or is not player owned.
- [B13] Supply.Factory.Check: no more `reverse array` (it returned a copy, so removals missed the stored array on reversed passes). The script walks the stored array [3] in place and alternates direction each call via settings [13]: forwards from 0, bound = shrinking size, index only advances when nothing was removed; backwards from size-1, always steps down.
- [B14] Wait in AL path (planned)
- [B15] Fragile temp-drone trades; drone kept and hardened per R-T1 (planned)
- [B16] Settings schema unversioned (planned)

### Changed
- [P1] Supply.Start: `Sector.Array` refresh now throttled to at most every 300 s via timestamp settings `[16]`; a null `[16]` means never-scanned so the first tick still runs it. Throttle uses a `$do.scan` flag and never blocks supply - when throttled, the existing arrays are reused for this cycle (no wait added).
- [P7] Supply.Factory.Check: settings-variable name (text 4001) read once before the loop instead of once per factory.
- [P8] Supply.Dock: the dock supply loop waits 0.5-1 s every 10 wares (the DC sell loop already waits per ware).
- [P1-05] Supply.Dock: debug log lines (debug on only) for each dock pass, supply from the DC (requested and added), surplus to the DC, sell cap and early stop after a wait.
- [P1-05a] Main Menu: new Docks view (view 3, plugin.LI.FDN.Menu.AP.Dock.List; TC: plugin.LI.FDN.Menu.Dock.List) lists every tracked player dock except the DC and opens Dock Details; "Switch to" cycles DC -> Stations -> Docks; back from Dock Details returns to the Docks list. Ware settings and Add ware now create a missing ware record (settings were silently lost before).

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
