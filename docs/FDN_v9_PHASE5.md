# Phase 5: Testing, versioning and packaging

**Paste with:** MASTER_PROMPT, REFERENCE, `CHANGELOG.md`, and the list of v9 script names with their `<version>` values.
**Branch:** `v9/phase5-release` → merge to `main`, tag `v9.01`.

AI tasks (one answer each):
1. **Test plan** as a checklist: install, fresh game, upgrade from 8.04, DC change, DC destroyed, factory sold/captured, 50+ factories performance (SETA 2 h), buy/sell with low money, trade drone (foe/destroyed/full partner, XRM type fallback, no tagged drone left after save/reload), virtual ↔ physical, move ware to ship, master reset, uninstall (AL stop → config entry removed, hotkey unregistered, no running tasks). Each item: steps, expected log lines (page 9910 log), pass/fail column.
2. **Version bump list**: every script's `<version>` → 901 (or +1), descriptions prefixed "FDN v9.01 –". Text 100 updated. Confirm the stubs are included.
3. **Readme** (BBCode for the Egosoft forum and Markdown for git): what FDN does, requirements (AP 3.3 or FL 1.3; optional Community Plugin Configuration 1.61; Plugin Manager 1.92), install/upgrade/uninstall, hotkey, known issues, the LU/XRM notes from ANALYSIS §7, credits (Logain Abler, Bullwinkle `lib.BW.isAP`), and text page / log IDs (9910).
4. **Plugin Manager package spec**: `.spk` metadata (name "Logain Industries FDN", author Logain Abler, version 9.01, games AP + FL, files scripts/*.xml and t/9910-L0xx.xml, uninstall script = AL stop). List the steps in Plugin Manager 1.92's package creator; Matt builds it.
5. **Final CHANGELOG** for v9.01, grouped Fixed (B#), Performance (P#), Refactor (D#), Menus, Compatibility, Behaviour changes, Removed/Stubbed, Known issues.
6. **Forum post refresh** draft for the existing FDN thread on the Egosoft forum: short intro, what's new in 9.01, download links placeholder.

**Done when:** the checklist passes on AP and FL, the package installs and uninstalls cleanly via Plugin Manager, git is tagged `v9.01`, and the zip + .spk are archived in the repo `releases/`.
