# Phase 3: Unified menu framework

**AI sessions:** use the task cards `docs/tasks/P3-*` (one card per chat; see `docs/tasks/README.md`). This file is the plan for you; the cards are what the AI gets.
**Branch:** `phase3-menus`.

Design (agree this with Matt in answer 1 before writing code):
* `plugin.LI.FDN.Main.Menu` = controller only: a view stack (array of `[view, obj, ware]`), header, footer, open menu, hand the return value to `plugin.LI.FDN.Menu.Command`, which returns the new view stack. `back`/−1 pops the stack, so no hard-coded parents.
* Views: `Menu.Station` (DC or dock: info line, credits, grouped wares via `Sort.Wares` + `lib.LI.FDN.Menu.WareRow`, add ware, config link), `Menu.Stations` (sectors from the cache `[15]` → factories + docks from arrays `[3]`/`[4]`, global commands, stats lines 2000–2002), `Menu.Factory.Details`, `Menu.Ware.Details`, `Config.Menu`.
* All rows come from `lib.LI.FDN.Menu.Row/Toggle/ObjLine/WareRow`, with column offsets stored once (text 9100+ or constants in Row).
* One refresh task, `Menu.Refresh`: started on entering a dynamic view; exits when `[5]` or the token `[20]` changes, or when `is new script version available`. It rebuilds rows directly (no FDND globals) or keeps the FDND globals but with one writer.
* Wording: one term per concept ("Distribution Centre", "Stations", "Docks", "Factories"); ON/OFF from 148/149; colours via 9000–9007.

Steps (one answer each):
1. Design note + the new text IDs (300–399) as XML lines. Paste `Main.Menu.txt` and `Config.Menu.txt`.
2. `lib.LI.FDN.Menu.Row`, `Menu.Toggle`, `Menu.ObjLine` (paste `Menu.Ware.Details.txt` as the pattern).
3. `lib.LI.FDN.Menu.WareRow` (paste `Wares.Summary.txt`).
4. `plugin.LI.FDN.Menu.Command` (paste `Main.Menu.txt`): table-style dispatch per REFERENCE §E; one numeric-input handler, one price handler, one toggle handler; `set.dc` validates the dock (Is.Valid need.dock) and asks for confirmation; `master.reset` confirms.
5. `plugin.LI.FDN.Main.Menu` (controller rewrite).
6. `plugin.LI.FDN.Menu.Station` (paste `Menu.AP.DC.Details.txt` + `Menu.AP.Dock.Details.txt`).
7. `plugin.LI.FDN.Menu.Stations` (paste `Menu.AP.Factory.List.txt`).
8. `Menu.Factory.Details`, `Menu.Ware.Details`, `Config.Menu` on the libs (one answer each).
9. `plugin.LI.FDN.Menu.Refresh` (paste `Menu.DC.Details_D.txt`).
10. Stubs: `Menu.AP.DC.Details`, `Menu.DC.Details`, `Menu.AP.Dock.Details`, `Menu.Dock.Details`, `Menu.AP.Factory.List`, `Menu.Factory.List`, `Menu.DC.Details_D`, `Menu.Dock.Details_D`, `Wares.Summary` → `return null` with a v9 comment.

**Test:** every view opens from every route; Back always returns to the previous view; edits persist after closing and re-opening; menus open in under 1 s with 50 factories; no ReadText errors; old saves with a stale `[5]` behave.
**Done when:** no menu code outside the scripts above, no duplicated row code, and the TC twins are stubbed. Tag `v9-phase3`.
