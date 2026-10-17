# P0-B findings: bug checks for B3, B4, B7 and B9

- Date: 2026-10-17
- Source: the aibox local model's answers to task cards P0-B-B3, P0-B-B4, P0-B-B7 and P0-B-B9 (run in Cline), each checked against `source_readable/` by X Mod Bot. Matt's raw answers are in `notes/P0-B-*_result.md`.

| Bug | Verdict | Short version |
|---|---|---|
| B3 | Confirmed | A destroyed DC makes factory products vanish; no ownership checks anywhere. |
| B4 | Partly confirmed | Can sell all stock, but only if `null >= 0` is TRUE. Waits on test C1 T1. |
| B7 | Confirmed | One wrong index in Menu.Dock.Details_D. One-line fix. |
| B9 | Confirmed | Reset's regex is far too wide; no DC check, no pause, misses docks that left the array. |

## B3 (confirmed)
- Supply.Start L046 is only `if $dc`.
- Supply.Factory L067 adds the product to the DC via Update.Ware 'add', then L071-072 remove it from the factory no matter what. Update.Ware only handles stock when the station `is of class Dock` (L043), so for a destroyed DC the 'add' does nothing and returns 0, and the wares vanish.
- Supply.Factory L107 ('remove' from the DC) and L129 (reads the DC's ware record) also use `$dc` unchecked. Added to B3's locations.
- No station-management script checks ownership. The only `owner` in the code is the `owner=Player` argument of the drone `create ship` in Buy.Ware and Sell.Ware.

## B4 (partly confirmed, pending test C1 T1)
- Locations are right: Supply.Dock Sell.Ware.Sub L145-158 and Sell.Ware L044-049. Sell.Ware L036-037 is the same exposure.
- Correction to the old description: records are not only created by the menus. Update.Ware's 'add' path creates one (L052 `gosub Add.Ware.Sub`) when stock is added to a dock that has no record.
- The explicit `action='create'` calls (Supply.Dock L100, Main.Menu L475) do nothing because of B2, so the DC record that Supply.Dock L098-102 thinks it just created may still be missing. Fixing B2 closes that gap.

## B7 (confirmed, fix narrowed)
- Menu.Dock.Details_D L026 reads `$al.Settings[6][1]`; it should read `[6][2]`. That one line is the whole fix.
- Config.Menu L172 and Main.Menu's `dynamic.dock` handler (L261-266) already use `[2]`.
- `dynamic.dock.list` (Main.Menu L268-274) toggles `[1]`. It belongs to the removed dock-list UI (its Config row, L151-164, is commented out).
- **Rejected claim, do not act on it:** the model said the `dynamic.dock` and `dynamic.dock.list` handlers are swapped. They are not. Leave Main.Menu and Config.Menu alone for B7.

## B9 (confirmed)
- Reset L064 uses regex `'FDN*'`, which matches any name containing "FD" (other mods' locals too).
- L028-030: no null or exists check on the DC.
- Reset never pauses FDN (enable flag `[0]`), so supply tasks keep running during the reset.
- L043-048 only clear docks still in the dock array, so docks that have left it keep their `FDN.Ware.*` locals.
- VERIFY: does X3's regex support `^` and `\.`? (Cleanup L018 already uses `'FDND.*'`.) New test T8 in card P0-C1 checks this before the Phase 1 fix (card P1-11) uses `'^FDN\.'`.

## Effect on the plan
- Cards updated: P1-03 (extra B3 lines), P1-05 and P1-07a (B4 lines), P1-10a (B7 one line only), P1-11 (B9 regex depends on T8), P0-C1 (new T8).
- B4's Phase 1 guard is needed whatever T1 shows, because a null record should never mean "sell".
