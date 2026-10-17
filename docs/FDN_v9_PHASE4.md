# Phase 4: Compatibility (AP 3.3 + Farnham's Legacy) and the v8.04 → v9.01 upgrade

**Paste with:** MASTER_PROMPT, REFERENCE, ANALYSIS §6–§7 (compat matrix + FL gotchas), `NOTES_semantics.md` (engine version numbers from Phase 0), and the scripts named.
**Branch:** `v9/phase4-compat`.

Steps (one answer each):
1. `lib.LI.FDN.Game`: return 1/2/3 from `script engine version` using Matt's logged numbers (FL patch scripts are engine 60–74; AP ≥ 50; TC ~44). Use `>=` thresholds only. Store the result in `[23]`.
2. FL patch feature flag `[24]`: decide a safe detection (for example engine version ≥ the value logged with the patch installed). VERIFY with Matt; if there is no safe test, default to FALSE and leave the feature off.
3. `plugin.LI.FDN.Setup`: (a) Community Plugin Configuration entry (unchanged text 101/102 and the script name `'plugin.LI.FDN.Main.Menu'`); (b) **hotkey fallback** with `register hotkey <name> to call script plugin.LI.FDN.Main.Menu`, id stored in `[21]`, `unregister hotkey` on stop (VERIFY exact syntax against the MSCI command list or the in-game editor); (c) if `[24]`, optionally `add sidebar custom entry` / `add script selection option` (FL Unofficial Patch commands; check exact syntax in the patch list).
4. `plugin.LI.FDN.Upgrade`: implement MASTER §7 fully (idempotent, wait-free). Include the optional B5 sweep behind a flag Matt sets.
5. `al.LI.FDN.event`: description text 100 → "FDN v9.01"; call Upgrade; nothing else blocking.
6. Exclusions: skip stations whose current command is a station-manager / trade-distribution style command in FL, or let the player exclude a station via a factory/dock toggle (`FDN.Settings[4]` = excluded). Ask Matt which.
7. `t/9910-L044.xml`: fix typos (132 "Dock LDetails", 186 "Confrim"); remove the empty `<page id="17">` (game object-name page) and the stray `L` after `<t id="135">`; unify Centre; add the 300+, 4100+ and 9100+ entries; produce `9910-L049.xml` (copy of the English text, or German if Matt wants it) so FL German installs show text.
8. Review pass: list every command used in the v9 scripts that does **not** appear in v8.04 source; for each, give a reference URL or mark VERIFY.

**Test matrix:** AP 3.3 vanilla; AP + Community Plugin Configuration; FL 1.3 vanilla; FL + Unofficial Patch 1.3.20; each with (a) a fresh install and (b) loading the v8.04 baseline save. Expected: the menu is reachable (config entry or hotkey), the upgrade log line appears once, supply resumes, and there are no ReadText errors.
**Done when:** the matrix passes (TC is not required). Tag `v9-phase4`.
