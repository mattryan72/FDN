# Changelog

## [9.01] - Unreleased

### Baseline
- Imported FDN v8.04 (`src/`) as the starting point.

### Decisions
- Keep temporary docked freighter for trades; harden it (R-T1 / B15).
- B5, B9 and the FL Station Manager exclusion approved by Matt on 2026-10-17 (see Behaviour changes).

### Fixed
- [B18] Main.Menu: safe ware edits (record get-or-create) - done in P1-05a.
- [B19] Main.Menu: Add Ware null-check when the player cancels the ware prompt - done in P1-05a.
- [B26] Main.Menu Remove.Ware.Sub: re-check stock == 0 (physical + virtual) before deleting and confirm with the player first (text id=300), so a ware can no longer be wiped silently or after supply lands between the click and the delete. On FL, Remove Ware now also clears the dock's tradeable list (new `plugin.LI.FDN.FL.Remove.Tradeable`, called only when script engine version >= 60).
- [B20] Move.Ware: null-check a cancelled destination prompt before any -> is of class / get free amount call; on cancel it exits silently with one debug line (`$debug` local copy, no array element in the condition) - done in P1-13a.
- [B21] Menu.Ware.Details: use $value -> get sector (shows the station's own sector instead of always showing the DC's); remove the dead sprintf at old L052 whose result was immediately overwritten - done in P1-13b.
- [B22] Menu.Factory.Details: read text 4001 directly instead of sprintf on a string with no %s (worked by accident) - done in P1-13c.
- [B23] Config.Menu: use the `menu` argument passed in from Main.Menu (Config.View.Sub) instead of creating a new menu array, which discarded Main.Menu's build and its heading text 102 - done in P1-13d.
- [B17] Sort.Wares: wares whose maintype is not one of the 9 listed groups (laser/shield/missile/energy/natural/bio/food/mineral/tech+equip) are now collected into an "Other" group and appended last in `$main.ware.Array` — v8 silently dropped them from every menu. Group key = text id=301 (callers do `read text id=$main.type`; id 300 is already B26's confirm-remove). The group is only added when it has at least one ware, so no empty heading appears - done in P1-13e.
- [B1] Supply.Start: real run-lock on settings [12] (stores `playing time`, stale after 120 s, set on the array not a local copy); while locked only the factory pass is skipped. Supply.Factory.Check releases [12] on every exit (no array, empty array, end of loop); the direction toggle that v8 kept in [12] moved to [13].
- [B2] Update.Ware: record name built before 'create'; 'create' only writes a missing record.
- [B3] Supply.Start: DC validated every tick (exists / owner race == Player / Dock class 2007); on failure clears settings [2], writes a logbook entry for the player and pauses. Supply.Factory.Check: a factory must exist and be owned by the player (`get owner race` == Player); missing, sold, captured or given-away stations are removed from the stored array [3]. Other B3 sites (Supply.Factory, Dock.Check) are their own cards. Supply.Factory: DC validated once per task; products are only taken from the factory when the DC is valid, and only the amount Update.Ware reports as added (null falls back to v8 until P1-04); resource remove and buy are skipped while the DC is invalid; a missing DC ware record skips only that ware's buy.
- [B3] Supply.Dock.Check: early return when settings [2] is null (Supply.Start owns DC validation); docks that do not exist or are not player-owned are removed from the stored array [4], with debug reason lines ' Clean from Dock Array - does not exist / not player owned'.
- [B30] Update.Ware: record re-read after it is created; non-Dock 'remove' no longer returns null (virtual stock defaults to 0).
- [B4] Supply.Dock: sell cap used only when the ware record exists and [5] is an integer >= 0; otherwise that ware is skipped.
- [B4][B12][B15] Sell.Ware: return without selling when the ware record is missing, sell-at price is not an int, or the sell cap is not an int >= 0; dock and DC re-checked after each wait; trade drone only used if create ship worked, named 'FDN Trade Drone' and tagged FDN.Trade.Drone, null sell treated as 0, destructed behind an exists check.
- [B4][B12][B15] Buy.Ware: return without buying when the ware record is missing or the buy-at price is not an int; factory and DC re-checked before the search loop and after each wait (Check.Alive.Sub); trade drone only used if create ship worked, named 'FDN Trade Drone' and tagged FDN.Trade.Drone, buy clamped to the drone's max cargo for the ware, null buy treated as 0, destructed behind an exists check.
- [B5] Surplus default of -1 (planned; configurable default, approved, see below)
- [B6] plugin.LI.FDN.Setup: guard the `plugin.config.addscript` call behind a check for the CPC registry global (`plugin.config`); log a debug line when CPC is absent. Stop branch unchanged (comment only). Hotkey fallback in Phase 4 - done in P1-12.
- [B7] Dynamic index 1 vs 2 (planned)
- [B8] Main.Menu: _D updaters (DC.Details_D, Dock.Details_D) are now STARTed only when entering view 1 or 5, not on every redraw; a token in settings [20] is incremented per start so an older updater exits via its own loop check. A one-time bump at menu open kills stale updaters from previous sessions.
- [B7] Menu.Dock.Details_D: read the dock dynamic flag from `al.Settings[6][2]` (was `[6][1]`, the retired dock-list toggle Config never sets), so Dock Details rows actually go dynamic when "Dock Details" is enabled in Configuration - done in P1-10a.
- [B8] Menu.Dock.Details_D: remember `$al.Settings[20]` at start and re-read `al.LI.FDN.event` each pass, exiting when FDN is off, when `[5]` is no longer 5, or when the token has changed (new updater). The update sub now runs INSIDE the while loop (it sat after the closing `end`, so it never ran on later passes), and the per-ware pointer in Update.Menu.Global.Sub uses textid=5000 to match the Write sub and the reader (was 5001, a global nobody read) - done in P1-10a.
- [B8] Menu.DC.Details_D: remember `$al.Settings[20]` at start and re-read `al.LI.FDN.event` each pass, exiting when the event global is gone or when the token has changed (new updater); Write.Menu.Global.Sub now runs inside `if $dc` before the dynamic gate instead of unconditionally at top level (B8c - it previously wrote garbage globals against a null DC). The update sub was confirmed already inside the loop, and both pointer textids (5001 credits / 5000 per-ware) were confirmed matching the reader `Menu.DC.Details` - no change needed there - done in P1-10b.
- [B24] Main.Menu: removed dead `if $menu.view == 3` branch from the Escape chain (unreachable after L082) and dead view 4–7 branches from `Menu.View.Header.Sub` (only called for views 1–3).
- [B9] Reset: registry-based reset done in P1-11. The script pauses FDN first ([0] = FALSE plus one short wait so a running supply task stops at its next tick), builds a deduped station list from the registry [29] with the DC and both arrays as fallback, skips stations that no longer exist, and clears their local variables with the anchored regex `'^FDN\.'` (test T8 confirmed: foreign FDN* names survive). It then empties [3]/[4]/[29], clears [2] and working slots [12]-[20]; [7] debug, [14] schema stamp and [28] surplus default are left alone. No player logbook line by design; debug lines only (skip destroyed station / cleared FDN locals).
- [B10] Sector.Array modes (planned)
- [B11] Supply.Factory: Buy.Ware is STARTed at most once per 120 s per factory (factory FDN.Settings [3] = playing time of the last start, stale after 120 s). Sell side (Supply.Dock) planned.
- [B12] Supply.Dock: after each wait in the ware loops the task stops if the dock or DC no longer exists or is not player owned.
- [B31] Supply.Factory (Supply.Resource.Sub): when a factory already holds more than 3 cycles of a resource in cargo, $required goes negative; clamp it to 0 straight after the $max clamp so the "requires" debug line never shows a negative amount (no remove or buy was ever attempted - the existing > 0 gate stayed as is).
- [B13] Supply.Factory.Check: no more `reverse array` (it returned a copy, so removals missed the stored array on reversed passes). The script walks the stored array [3] in place and alternates direction each call via settings [13]: forwards from 0, bound = shrinking size, index only advances when nothing was removed; backwards from size-1, always steps down.
- [B14] al.LI.FDN.event: the timer handler now STARTs `plugin.LI.FDN.Supply.Start` instead of calling it synchronously, so the AL event stays wait-free (Supply.Start keeps its own [12] run-lock).
- [B15] Fragile temp-drone trades; drone kept and hardened per R-T1 (planned)
- [B16] al.LI.FDN.event: calls new `plugin.LI.FDN.Upgrade` on init/reinit, after Setup (Setup resets the log); Upgrade stamps schema version [14]=901 and seeds the B9 registry [29] from DC + factories + docks when null. Phase 4 completes the migration.

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
- P2-04 card fix: the pasted source range now points at `docs/excerpts/v8_Supply.Factory.Check_D4.txt` (v8.04 reference lines 058-085, CRLF) instead of a line range in `source_readable/`; duplicate note updated to cite v8 065-084 and the other three D4 sites with their line ranges.
