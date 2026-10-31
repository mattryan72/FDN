# FDN v9.01 - Freight Distribution Network (Logain Industries)

> **IMPORTANT - FDN STARTS PAUSED.** After a first install or a Master Reset, FDN is paused. Setting a Distribution Centre does not start it. Open Gameplay > Artificial Life Settings (AL Plugins) and set Logain Industries: FDN v9.01 to Yes. While paused, the Config menu shows "FDN Enabled: OFF".

> **WARNING - fresh saves only.** Use v9.01 only on saves that have never had an older version of FDN installed. Saves that have had older FDN versions, including v8.04, are not guaranteed to work. Back up your saves first.

> **Tested on X3: Farnham's Legacy only.** Terran Conflict and Albion Prelude are untested (multi-DC, menus).

## What FDN does
FDN moves wares between your own stations. You choose one or more docks as Distribution Centres (DCs); FDN supplies your factories, collects their products into the DCs and can buy and sell with NPC stations. v9.01 is a rework of v8.04 by Logain Abler.

## What is new in v9.01
- Up to 16 Distribution Centres (DCs) linked as a DC Network, with a primary DC and a Distribution Centre Network page.
- Range rules: a dock can join only when it is linked to the primary DC; DCs that are not linked are marked.
- Network settings: range limit, base station range, DC Network range multiplier, reserve floor, and per-DC range and reserve floor overrides.
- Optional Energy Cell cost for transfers, with help between DCs, deferral warnings and a running cost page per DC.
- Trading Stations and Equipment Docks get the same range as DCs.
- Reworked menus: Menu Options footer on every page, Back / Esc navigation, consistent colours.
- Configurable Surplus to Distribution Centre default; Master Reset clears FDN data on every station.
- Farnham's Legacy: stations run by Station Manager are removed from the network; FDN entry in the Gameplay menu; hotkey fallback.
- Language files: English; German (machine translated, pending native review); English copies for French, Italian, Russian, Spanish, Polish and Czech.
- Many fixes and shared libraries; see CHANGELOG.md for the full list.
- Fresh saves only. FDN starts paused until you switch it on. Albion Prelude and Terran Conflict are untested.

## Requirements
- X3: Farnham's Legacy 1.3 (tested); Albion Prelude 3.3 and Terran Conflict listed but untested; FL Unofficial Patch 1.3.20 optional (adds a script options entry).
- Community Plugin Configuration: required for the .spk install (via X Plugin Manager); not needed for the manual zip install.
- X Plugin Manager for the .spk (use the latest version). The package is unsigned: Modified mode.

## Install
- **.spk:** install Logain Industries FDN v9.01 with X Plugin Manager (allow unsigned packages).
- **Loose zip:** copy `scripts\*.xml` to `addon2\scripts` and `t\9910-L0*.xml` to `addon2\t` (Albion Prelude: addon\scripts and addon\t; Terran Conflict: scripts and t in the game folder). Copy all 8 t\9910-L0*.xml files: English (L044), German (L049, machine translated, pending native review) and English copies for French, Italian, Russian, Spanish, Polish and Czech.
- Then: switch FDN on in Gameplay > Artificial Life Settings (AL Plugins), open FDN, choose your first DC in the FDN Config Menu.

## Hotkey
FDN registers a hotkey labelled "FDN" only while FDN is switched on. Bind a key under Controls > Interface (Extensions). Auto Manage Factories is On by default.

## Uninstall
Switch FDN off in Gameplay > Artificial Life Settings (AL Plugins) (removes its Config entry and hotkey), save, then remove the package or the FDN files. Manual (zip/copy) uninstall: leave lib.BW.isAP.xml in place (DrBullwinkle's script; other mods may use it). X Plugin Manager (.spk) uninstall removes lib.BW.isAP.xml too, as the package ships it; if another mod needs it, reinstall it from DrBullwinkle's own download. Virtual stock is lost.

## Known issues
- Tested on FL only; v8.04 saves not supported; German texts machine-translated, pending native review.
- Trading Stations still count as "other dock" for the Energy Cell cost factor.
- FDN buys only from stations that will trade with you. If your notoriety with a station's race is too low for a ware (the station shows the ware in red with "your notoriety is too low"), FDN skips that seller for 30 minutes game time and tries another one; the log shows `TRADE block seller` and `TRADE skip seller`. Raising your notoriety with that race fixes it.

## Compatibility
FL 1.3 (+ UP 1.3.20) tested; AP 3.3 / TC untested. XRM: unconfirmed, not tested. Litcube's Universe: not supported. Production Modules: not directly compatible; support is planned for a later release, date to be decided depending on interest. Text page and log id 9910.

## Credits
Logain Abler (Logain Industries). lib.BW.isAP by DrBullwinkle. X Plugin Manager and .spk tooling by Cycrow.

## Licence / Terms of use
Free to use, change and share as you see fit, as long as credit is given.

Reporting a problem: please attach log09910.txt (switch on Supply Debug under Debug Settings in the FDN Config Menu first).


The User Guide (FDN_v9.01_User_Guide.pdf) is included in the release zip.
