# Phase 4: Compatibility (AP 3.3 + Farnham's Legacy) and the v8.04 → v9.01 upgrade

**AI sessions:** use the task cards `docs/tasks/P4-*` (one card per chat; see `docs/tasks/README.md`). This file is the plan for you; the cards are what the AI gets.
**Branch:** `phase4-compat`.

Steps (one answer each):
1. `lib.LI.FDN.Game`: return 1/2/3 from `script engine version` using Matt's logged numbers (T7: FL 1.3 + UP 1.3.20 returns 60; AP 3.3 still to log; TC ~44; provisional >= 60 FL, >= 50 AP). Use `>=` thresholds only. Store the result in `[23]`.
2. FL patch feature flag `[24]`: decide a safe detection (for example engine version ≥ the value logged with the patch installed). VERIFY with Matt; if there is no safe test, default to FALSE and leave the feature off.
3. `plugin.LI.FDN.Setup`: (a) Community Plugin Configuration entry (unchanged text 101/102 and the script name `'plugin.LI.FDN.Main.Menu'`); (b) **hotkey fallback** with `register hotkey <name> to call script plugin.LI.FDN.Main.Menu`, id stored in `[21]`, `unregister hotkey` on stop (VERIFY exact syntax against the MSCI command list or the in-game editor); (c) if `[24]`, optionally `add sidebar custom entry` / `add script selection option` (FL Unofficial Patch commands; check exact syntax in the patch list).
4. `plugin.LI.FDN.Upgrade`: implement MASTER §7 fully (idempotent, wait-free): `[28]` = 1 (also on fresh installs, decided 2026-10-17), B5 record migration (`[7]` null → 0, approved by Matt 2026-10-17), B9 registry seed and prune.
4b. **B5 engine (approved 2026-10-17):** `plugin.LI.FDN.Supply.Dock` uses the effective surplus flag: `[7]` 1 → on, 0 → off, −1/null → `[28]` (1 on, 0 off, 2 v8: −1 on, null off). Null-check with DATATYPE_NULL before comparing with 0.
5. `al.LI.FDN.event`: description text 100 → "FDN v9.01"; call Upgrade; nothing else blocking.
6. **FL Station Manager (approved by Matt 2026-10-17):** write `lib.LI.FDN.Is.FL.Managed` from the Phase 0 T9 result (FL only, `[23]` == 3; FALSE on AP), and finish the Scan drop: remove such stations from `[3]`/`[4]`, pause if it is the DC, warn once with text 330/331 and log text 332 (REFERENCE §H). If T9 found no reliable detection, keep the stub (FALSE) and list it as a known issue.
7. `t/9910-L044.xml`: fix typos (132 "Dock LDetails", 186 "Confrim"); remove the empty `<page id="17">` (game object-name page) and the stray `L` after `<t id="135">`; unify Centre; add the 300+, 4100+ and 9100+ entries; produce `9910-L049.xml` (copy of the English text, or German if Matt wants it) so FL German installs show text.
8. Review pass: list every command used in the v9 scripts that does **not** appear in v8.04 source; for each, give a reference URL or mark VERIFY.

**Test matrix:** AP 3.3 vanilla; AP + Community Plugin Configuration; FL 1.3 vanilla; FL + Unofficial Patch 1.3.20; each with (a) a fresh install and (b) loading the v8.04 baseline save. On FL, put one factory and one dock under Station Manager: both drop out of FDN with one message each; putting the DC under it pauses FDN. Expected: the menu is reachable (config entry or hotkey), the upgrade log line appears once, supply resumes, and there are no ReadText errors.
**Done when:** the matrix passes (TC is not required). Tag `v9-phase4`.
