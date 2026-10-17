# FDN v9.01: Reference Card (paste with every phase prompt)

## A. Global `al.LI.FDN.event` (array, size 30)
| Idx | v8.04 meaning (keep) | v9.01 |
|---|---|---|
| 0 | enabled | same |
| 1 | page ID 9910 | same (also the log file number) |
| 2 | DC (Dock) | same; validated every tick |
| 3 | factory array | same; only valid player factories |
| 4 | dock array (incl. DC) | same |
| 5 | open menu view | same, plus `[20]` token |
| 6 | is.dynamic array: [0] DC view, [2] dock view ([1] obsolete). Allocated with size=10 (al.LI.FDN.event L017) but only [0]–[2] are set (L018–020); [3]–[9] stay null (P0-A) | use [0] and [2] only |
| 7 | debug | same |
| 8 | exclude array (all player stations) | same, refreshed by Scan |
| 9 | auto-manage new factories | same |
| 10 | unused | reserved |
| 11 | dock-check tick counter (Supply.Start L031, L072–077): while `< 6` it is incremented and the call returns early; at 6 it is reset to 0 and dock supply runs. So dock supply is skipped for 6 calls and runs on every 7th (~175 s at 25 s). The L071 comment "until call 3 times" is wrong (P0-A) | same |
| 12 | (v8: broken running flag) | **factory-check lock**: `playing time` when started, null when free; stale after `[22]`×4 s |
| 13 | (v8: reverse toggle, collided with 12) | **factory cursor / reverse toggle** |
| 14 | — | **schema version** (901) |
| 15 | — | **sector cache** (array of sectors with player factories/docks/adv. sats) |
| 16 | — | **scan timestamp** (`playing time`) |
| 17 | — | **scan interval s** (default 300) |
| 18 | — | **active trade tasks** (counter, max `[19]`; reset to 0 by the init sweep) |
| 19 | — | **max trade tasks** (default 4) |
| 20 | — | **menu refresh token** (incremented per menu open; refresh task exits if it changes) |
| 21 | — | **hotkey ID** (from `register hotkey`) |
| 22 | — | **factories per tick budget** (default 40) |
| 23 | — | **game**: 1 TC, 2 AP, 3 FL (from `lib.LI.FDN.Game`) |
| 24 | — | **FL patch features available** flag |
| 25 | — | **trade-drone type list** (array of ship types tried in order; default: Argon Mercury Super Freighter XL) |
| 26 | — | **resolved trade-drone type** (cache of the last type that passed the checks; cleared on init/reinit) |
| 27 | — | **max drone loads per Trade call** (default 5) |
| 28 | — | **default surplus→DC** (B5, approved 2026-10-17): used when a ware record's [7] is −1/null. 1 = on, 0 = off, 2 = v8 compatible (per-ware −1 or 1 = on, null or 0 = off). Fresh install: 1 (on, matches v8; decided 2026-10-17). v8 upgrade: 1, after migrating v8 records' [7] null → 0 (see §B; approved by Matt 2026-10-17) |
| 29 | — | **station registry** (B9, approved 2026-10-17): array of every station FDN has ever touched (DC, factory, dock, or given an `FDN.Ware.*` record). Appended via `lib.LI.FDN.Reg.Add`; pruned of dead stations at Reset/Upgrade; seeded from [2], [3], [4] on upgrade; emptied after a Reset |

## B. Station locals
* `FDN.Ware.<ware>` (text 4000 via sprintf), size 12: [0] virtual stock, [1] DC remote reserve (>0 = share), [2] dock maintain level, [3] DC may buy, [4] buy-at price, [5] sell-above level (−1/null = off), [6] sell-at price, [7] surplus→DC override (B5, approved): 1 = on, 0 = off, −1 or null = use the global default `[28]`. New records keep the v8 create value −1 (= use default). **Always test for null with `is datatyp[...] == DATATYPE_NULL` before comparing with 0** (test T1 shows whether `null == 0`). The v8 upgrade migrates [7] null → 0 (approved by Matt 2026-10-17), because in v8 null only came from the player switching surplus OFF, [8] v9: last trade `playing time`, [9]–[11] free. Note (P0-A): the record is allocated with size=12 (Update.Ware L128); Add.Ware.Sub sets [0]–[9] and [11] (L129–139) but never [10], which is null only because the alloc leaves it null. v9 code should set it explicitly.
* `FDN.Settings` (text 4001) on factories, size 6: [0] manage product, [1] manage resources, [2] seen-once flag, [3] v9: busy-until time, [4]–[5] free.
* v9 `FDN.Trade.<ware>` (text 4101, on the home station): per station/ware trade guard (`playing time`, stale after 120 s), used through `lib.LI.FDN.Lock`.
* v9 `FDN.Trade.Drone` (text 4102, on the temporary drone): tag (value = `playing time`) so the init sweep can find orphaned drones.
* `FDN.Show.DC` (4004) / `FDN.Show.Dock` (4003): TC menu state, obsolete in v9 (Reset clears them).
* Temporary globals `FDND.*` (5000 `FDND.Ware.%s.%s`, 5001 `FDND.Credits.%s`): removed in v9 if Menu.Refresh builds rows directly; Cleanup still clears `FDND.*`.

## C. Text page 9910 ID ranges
* Existing: 8–19, 100–202, 1000–1003, 2000–2002, 4000–4005, 5000–5008, 9000–9007 (keep them all).
* New in v9: **300–399** UI strings (menus, messages, hotkey name); **4100–4199** new local/global names (4100 `FDN.Busy.%s`, 4101 `FDN.Trade.%s`, 4102 `FDN.Trade.Drone`; text 310 = drone name "FDN Trade Drone"; 320–325 B5 surplus default: 320 Config row label "Default: pass surplus to DC", 321 "On", 322 "Off", 323 "v8 compatible", 324 ware row "Default (%s)", 325 Config help line; 330–332 FL Station Manager: 330 player message "FDN: %s is run by Station Manager and was removed from the network", 331 "FDN paused: the Distribution Centre is run by Station Manager. Choose a new one.", 332 log text "SM drop %s"); **9100–9199** format strings (columns, colours). Fix typos in place (186, 132) and remove the empty page 17 and the stray `L`.

## D. Library contracts (all synchronous, wait-free unless noted, return null on bad input)
| Script | Args | Returns | Replaces |
|---|---|---|---|
| `lib.LI.FDN.Cfg.Get` | — | settings array or null | D1 header |
| `lib.LI.FDN.Log` | text (String), obj (Value, optional) | null; writes only if `[7]` | D2 Debug.Sub ×9 |
| `lib.LI.FDN.Game` | — | 1 TC / 2 AP / 3 FL (`script engine version` thresholds: FL 1.3 + UP 1.3.20 = 60 (T7); provisional `>= 60` FL, `>= 50` AP, else TC; VERIFY the AP 3.3 value and FL without the patch) | lib.BW.isAP uses |
| `lib.LI.FDN.Is.Valid` | obj, need.dock (Boolean) | TRUE if it exists, owner race == Player (and is a Dock if asked) | B3, B12 |
| `lib.LI.FDN.Is.Factory` | station | TRUE if managed factory (Factory, not Complex Hub, detectable rule; VERIFY intent of `is detectable == 0`) | D10 |
| `lib.LI.FDN.Ware.Rec` | station, ware, create (Boolean) | record array (created with v9 defaults if `create`) or null | D3, B2, B18 |
| `lib.LI.FDN.Fac.Cfg` | factory | settings array (get-or-create, applies auto-manage once) | D4 |
| `lib.LI.FDN.Lock` | obj (or null = global), key (String), action ('try'/'release'), timeout s | TRUE if acquired/released | B1, B11 |
| `lib.LI.FDN.Sectors` | mode (1 factories, 2 docks, 3 trade = all + adv. sats) | sector array from cache `[15]` (no scanning) | Sector.Array readers |
| `lib.LI.FDN.Trade` | mode ('buy'/'sell'), partner (NPC station), ware, amount, home (player station whose account pays/receives), dest (optional, buy only: where bought wares go, default home) | units traded (0 on any failure, never null/negative). **Wait-free.** Spec: §G | D9, B15 |
| `lib.LI.FDN.Menu.Row` | menu, label, value, retval (null = info line) | null | D5 |
| `lib.LI.FDN.Menu.Toggle` | menu, label, bool, retval | null (uses ON/OFF texts 148/149) | D5 |
| `lib.LI.FDN.Menu.ObjLine` | menu, object | null ("Name [ID]" + sector) | D6, Format.Name |
| `lib.LI.FDN.Menu.WareRow` | station, ware, is.dc | formatted row array with retval `['open.ware', station, ware]` | Wares.Summary, D8 |
| `lib.LI.FDN.Reg.Add` | station | null; appends the station to registry `[29]` if not already there (creates the array if null) | B9 registry |
| `lib.LI.FDN.Is.FL.Managed` | station | TRUE only if `[23]` == 3 (FL, from `lib.LI.FDN.Game`) and the station is run by FL's Station Manager; always FALSE on AP. Detection (T9 + FL scripts, VERIFY with T9b): station local `egosoft.stationmgr.time` is a number and `playing time` minus it is <= 10 (FL's `!station.cmd.manage.pl` refreshes it every 1 s; `plugin.stationmgr.run` quits when it is > 10 s old). Existence alone is not enough: FL never clears it | FL Station Manager decision |

Standard header (the only allowed copy of D1):
```
$al.Settings = [THIS] -> call script lib.LI.FDN.Cfg.Get :
if not $al.Settings
 return null
end
$PageID = $al.Settings[1]
```

## E. Menu commands (v9 dispatcher `plugin.LI.FDN.Menu.Command`)
Return values are arrays `[cmd, obj, ware, extra]`, with strings only for global actions.
* Navigation: `open.dc`, `open.stations`, `open.dock`, `open.factory`, `open.ware`, `open.config`, `back`.
* Edit number (one handler): `remote.cap`→[1], `maintain.cap`→[2], `sell.cap`→[5]. Edit price (one handler): `buy.at`→[4], `sell.at`→[6].
* Surplus (B5): `surplus` cycles the ware's [7] Default (−1) → On (1) → Off (0) → Default; `surplus.default` cycles settings [28] On → Off → v8 compatible (Config menu row, texts 320–325).
* Toggle (one handler): `can.buy`→[3]; factory `product`→[0], `resource`→[1]; settings `debug`→[7], `auto`→[9], `dynamic.dc`→[6][0], `dynamic.dock`→[6][2].
* Stock: `move.ware`, `to.physical`, `to.virtual` (one handler), `add.ware`, `remove.ware` (re-check stock == 0).
* Global: `product.all.on/off`, `resource.all.on/off`, `set.dc` (merges add.dc/change.dc), `master.reset` (confirm).
* Removed: `switch.menu` (becomes a nav row), `show.factory`, `show.type.dc`, `show.type.dock` (TC only).

## F. Key known bugs (details in ANALYSIS §4)
B1 lock/[12] collision · B2 'create' null pointer · B3 DC/owner validation (wares vanish) · B4 null sell cap → sell all · B5 surplus default −1 · B6 config-menu dependency · B7 Dock_D reads [6][1] not [6][2] (one-line fix) · B8 stacked _D updaters · B9 Reset regex `FDN*` · B10 Sector.Array modes · B11 duplicate Buy/Sell tasks · B12 no re-validation after waits · B13 reverse array copy · B14 wait in AL path · B15 fragile temp-drone trades (drone **kept**, hardened in `lib.LI.FDN.Trade`, §G) · B16 settings schema unversioned. Approved behaviour changes (Matt, 2026-10-17): B5 configurable default `[28]`; B9 reset over registry `[29]`; FL Station Manager stations dropped (§H). Minor: B29 dead `Debug.Sub` in Update.Ware (fix in Phase 2 with `lib.LI.FDN.Log`). Verified: B1, B2 (P0-A); B3, B7, B9 (P0-B); B3, B9 and B13 in-game (tests C1 T4, T8, T2); B4 partly, downgraded to medium (T1: `null >= 0` is FALSE). See `notes/NOTES_semantics.md`.

## G. `lib.LI.FDN.Trade` spec (decision R-T1: KEEP the docked trade drone, make it robust)
**Why it exists:** MSCI has no station-to-station trade command. A docked ship's `buy`/`sell` is the only way into the native economy (real price, homebase account, NPC stock, possibly trade rank/stats). The drone is created already docked and destroyed in the same wait-free block, so freight was never visible. Keeping it changes nothing the player sees.
**Invariants:** nothing waits between `create ship` and `destruct` (a drone can never end up in a save). One exit label: every path does `goto label Exit:`. Because the lib is wait-free, at most one drone exists at any moment. Log a reason code at every decision via `lib.LI.FDN.Log` (e.g. `TRADE skip foe`, `TRADE clamp money 120`, `TRADE spawn fail <type>`).
1. **Guards (before any spawn):** mode is 'buy'/'sell'; amount > 0; partner `exists`, owner race != Player, `$home -> get relation to object $partner` != Foe, `$partner -> get sector` non-null and in `lib.LI.FDN.Sectors(3)` (still in a trade sector); `lib.LI.FDN.Is.Valid($home)` (exists, Player-owned); dest (if given) valid too; `[18] <= [19]` (defensive; the caller owns the counter).
2. **Price sanity:** `$price = $partner -> get price of ware $ware` > 0 and between `get min price of ware $ware` and `get max price of ware $ware`. Buy: `$price <= rec[4]`. Sell: `$price >= rec[6]` (home record via `lib.LI.FDN.Ware.Rec(home, ware, FALSE)`).
3. **Clamp the amount (log each clamp; 0 → Exit):** buy: partner `get amount of ware $ware in cargo bay` (stock), dest `get free amount of ware $ware in cargo bay`, and money / `$price` from the account `buy` debits (`$home -> get money`; VERIFY in Phase 0 E whether it is the homebase or the player account, `get player money`). Sell: partner `get free amount of ware $ware in cargo bay` (demand/free space) and the home's physical + virtual stock.
4. **Drone type (resolved at runtime, so XRM/TShips mods can't break it):** try `[26]`, then each entry of `[25]`, then `get ship type array: maker race=<race> class=TS` for the core races (≤ 4 spawn attempts in total). Before each attempt, skip a null type (test T5: `create ship` with type=null returned a player Mammoth, not null, so the result check alone does not catch a bad type; VERIFY a TS-class check on the type, e.g. membership of the `get ship type array` result). Each attempt: `$drone = create ship: type=$t owner=Player addto=$partner x=null y=null z=null`. If the result is null or not `exists`, log it and try the next type. Immediately `set name to` (text 310), `set local variable: name=<4102> value=playing time`, `set homebase to $home`, and give it no command. Accept the type only if `$drone -> is docking allowed at $partner`, `-> can transport ware $ware` and `-> get max amount of ware $ware that can be stored in cargo bay` > 0. Otherwise destruct it and try the next type. Cache the winner in `[26]`. If none passes, log ERROR and return 0.
5. **Trade loop:** at most `[27]` loads, each ≤ the drone's max. Buy: `$n = $drone -> buy $chunk units of $ware`, then empty the drone (`= $drone -> add -$n units`, the v7.2 pattern) and `= $dest -> add $n units of $ware`. Sell: `= $drone -> add $chunk units`, `$n = $drone -> sell $chunk units`, then remove any leftover from the drone. A null/≤0 return ends the loop (logged, not an error). Sum the results in `$traded`.
6. **`Exit:`** `if $drone -> exists` → `$drone -> destruct: show no explosion=[TRUE]`, then `$drone = null` (repeat for a rejected candidate before trying the next). After that, only if `$traded > 0`: sell → `plugin.LI.FDN.Update.Ware` action='remove' amount=`$traded` station=home. If the returned amount < `$traded`, **reconcile**: take the difference from physical cargo, then virtual `[0]`, never below 0, and log `TRADE reconcile` with the virtual/physical values. Buy → delivery is already physical (step 5). Set `rec[8]` = playing time and return `$traded`. Home stock is never removed before a confirmed sale.
* **Side effects:** VERIFY (Phase 0 C6) whether `destruct: show no explosion` fires SIGNAL_KILLED (secondary or global-map handlers), changes the "ships lost" statistic, or shows a message. Mitigation: name and tag the drone *before* trading so cooperating mods can skip it, and never START a command on it. If Phase 0 shows a visible effect, look for a per-ship signal override in the command list (VERIFY), or document it as a known issue. The same applies to FL patch create hooks.
* **Orphan sweep:** `plugin.LI.FDN.Cleanup`, STARTed on init/reinit (never inline in the AL event): `get ship array: of race Player class/type=TS`, destruct every ship whose `FDN.Trade.Drone` local is set (the tag is required; a matching name alone is not enough, since a player can rename a ship). Log the count, reset `[18]` = 0 and `[26]` = null.
* **Concurrency (task level):** Buy.Ware/Sell.Ware take `lib.LI.FDN.Lock(home, 'FDN.Trade.<ware>', 'try', 120)` and increment `[18]` only if `[18] < [19]`. They release the lock and decrement `[18]` on every exit (one exit label there too).
* **Future option (not now):** a "direct transfer" config mode (add/remove money and wares by hand) only if the Phase 0 E test shows that drone trades don't affect trade rank or stats.

## H. FL Station Manager exclusion (approved by Matt, 2026-10-17)
* Any station run by Farnham's Legacy's Station Manager is dropped from the FDN network: removed from `[3]` (factories) and `[4]` (docks). If it is the DC, set `[2]` = null and FDN pauses (as for an invalid DC).
* Detection: `lib.LI.FDN.Is.FL.Managed(station)`, used only when `[23]` == 3 (FL). Rule (VERIFY with T9b, NOTES_semantics T9): `$t = $station -> get local variable: name='egosoft.stationmgr.time'`; managed if `is datatyp[ $t ] == DATATYPE_INT` and `playing time - $t <= 10`. Only standard commands, so the lib still loads on AP. Rejected: `is task running 448` (448 is the FL constant `[Task.StationMgr]`; as a number it is the wrong slot), the extra task ids 10/11/24/25 (not reliable alone), and "`egosoft.stationmgr.time`/`.blacklist` exists" alone (FL never clears them, so they probably stay after SM is switched off). Optional FL-only confirmation: `is script plugin.stationmgr.run on stack of task=[Task.StationMgr]`.
* Where: `plugin.LI.FDN.Scan`, at the same points as the exists/owner checks (each station before it is added to `[3]`/`[4]`, and the DC). Until Scan exists (Phase 2), nothing changes.
* Warn once: Scan rebuilds the arrays each pass, so only message when a station that was in `[3]`/`[4]` (or was the DC) is dropped. Player message text 330 (station) or 331 (DC), plus a log line via `lib.LI.FDN.Log` (text 332). Skipped stations are not re-added while Station Manager runs them.
* The station's FDN locals are kept (not cleared), so it rejoins with its settings if the player stops Station Manager.
