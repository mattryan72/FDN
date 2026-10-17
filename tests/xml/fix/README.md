# Test-only fix: FDN menu missing from Plugin Configurations on FL

`setup.LI.FDN.config.xml` re-registers "FDN Main Menu" (section "Logain Industries Menus") with
Community Plugin Configuration on every game load. It is a test-only hotfix for FDN v8.04 on
X3 Farnham's Legacy 1.3 + Unofficial Patch 1.3.20. It is not part of the released mod.

## Why

FL's Community Plugin Configuration (`init.community.config` v3) clears its menu list on every
game load. FDN v8.04 adds its menu entry only from its AL plugin events (`plugin.LI.FDN.Setup`), so
the entry can be wiped and nothing re-adds it. Setup scripts run on every load after the `init.*`
scripts, so this one puts the entry back. It changes nothing else: same call, arguments and texts
(page 9910, ids 101/102) as `plugin.LI.FDN.Setup`, plus CPC's 7th argument "Is Event Script" = FALSE.
It does nothing unless the "Logain Industries: FDN" AL plugin is enabled.

## Install

1. Close the game.
2. Copy `setup.LI.FDN.config.xml` (not `xs/`) into the game's scripts folder:
   `D:\Steam\steamapps\common\X3 Terran Conflict\addon2\scripts\`
3. Start the game and load the save. The "Logain Industries: FDN" AL plugin must be enabled.
4. Open "Plugin Configurations", then "Logain Industries Menus", then "FDN Main Menu".

To remove it, delete the file from `addon2\scripts\`. The entry will then be missing again after
the next load.

## Source and build

`xs/setup.LI.FDN.config.xs`, compiled with XScriptCompiler v0.8 and post-processed by `fix.py`
(engineversion 50), the same as the test scripts. Round-trip decompiled to check.
