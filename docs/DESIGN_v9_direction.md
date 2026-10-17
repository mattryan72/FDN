# FDN v9: design direction (approved by Matt 2026-10-17)

Status: **item 1 is SCHEDULED for v9.01** (card `docs/tasks/P3-04b_DC_Change_event.md`). Items 2-8 are **proposals**, not scheduled. Decided within them (Matt, 2026-10-17): item 2's model (closest DC serves; DCs form a peer-to-peer backbone; reserve floor) and item 3's route-based cost (Q3.6). Each has open questions for Matt; no code until they are answered and a phase is chosen.

Evidence base: FL 1.3 + UP 1.3.20 tests and supply logs 1-2 (`notes/NOTES_semantics.md`).

## Critical assessment of FDN v8.04

**Strengths**
- Simple mental model: one DC, factories push products in and pull resources out, docks are topped up from the DC.
- Works on TC, AP and FL with no FL-specific code (supply logs 1 and 2: products → DC → factories, DC → dock confirmed).
- One central 25 s timer and wait-free transfers: cheap per tick, no ships to lose, no pathing.
- Real trade for shortages (temporary docked drone), so buying and selling use the native economy.

**Weaknesses**
- **Instant, free transfer undercuts the economy.** Wares teleport across the galaxy at no cost. There is no reason to build freighters or position stations sensibly, and the DC acts as a global warehouse.
- **Low visibility.** The dock pass writes nothing. "Buy N" is logged before the can-buy check, so it reads like a purchase. A DC change is invisible. Players cannot tell why something is not supplied (log 2: 22 minutes of stalled solar plants with no explanation in-game). Partly addressed by P2-14.
- **Fragile positional arrays.** Settings are a 30-slot global array and 12-slot ware records addressed by bare numbers. Meanings drift (B5 `-1` counts as TRUE; B7 [6][1] vs [6][2]). A record that does not exist yet yields null in arithmetic (B2, B30, B4).
- **Menu sprawl.** Separate AP/TC copies of each view, dynamic updater scripts and global row caches (FDND.*). Settings sit 3-4 levels deep: Matt lost the menu entry and mixed up DC and dock ware menus. The ware-details sector line is wrong (B21).
- **Crude timing.** Resources only arrive in the last 45 s of a cycle or after a stall. Docks are checked every ~175 s regardless of demand. Long cycles (SPP XL 239 s) still stall if the DC is short at that moment.
- **No geography.** One DC serves the whole universe, so distance never matters (addressed by item 2: station range plus backbone).
- **Single point of failure.** One DC for the whole network. Changing it orphans settings (B30) and leaves the old DC's stock stranded unless surplus is on.

## 1. DC change as a proper event (SCHEDULED, v9.01)

**Problem.** v8 `add.dc`/`change.dc` just overwrite `[2]`. The new DC has no ware records, so the first take returns null (B30, log 2 at 01:30:02, possible ware loss). The old DC keeps DC-only settings ([1] remote, [3] can-buy) that mean nothing on a dock. Nothing is logged.

**Design.** A new wait-free script `plugin.LI.FDN.DC.Change` (args `old`, `new`), called by Menu.Command `set.dc` after validation and confirmation:
1. **Pause:** take the global supply-run lock (the B1 lock from P2-05/P2-08). If a pass holds it, return `busy`; the menu shows "Supply pass running, try again in a few seconds" and changes nothing. The script has no waits, so no pass can interleave once it holds the lock (VERIFY: MSCI scripts without waits are not pre-empted).
2. **Validate** `new` with `lib.LI.FDN.Is.Valid(new, need.dock=TRUE)`, refuse if it equals `old`, and on FL refuse if `lib.LI.FDN.Is.FL.Managed(new)` (REFERENCE §H).
3. **Ensure records on the new DC** for every network ware: products and resources of every factory in `[3]`, tradeable wares of every dock in `[4]`, and every ware with a record on the old DC. Use `lib.LI.FDN.Ware.Rec(new, ware, create=TRUE)`. This fixes B30 for DC changes; P1-04/P2-12a fix it generally.
4. **Carry over DC policy** (open question Q1.1): copy [1] remote, [3] can-buy, [4] buy-at, [5] sell cap and [6] sell-at from the old DC's records where the new DC's record is still default.
5. **Give the old DC normal dock settings:** if it still exists and is valid, keep it in `[4]` as a dock. Clear its DC-only fields ([1], [3]) and leave [2] maintain unset, so it is not refilled. Set [7] surplus = 1 (on), so its stock drains into the new DC over the next dock passes (Q1.2). Virtual stock [0] stays on the old dock and drains the same way.
6. Set `[2]` = new, `lib.LI.FDN.Reg.Add(new)`, save the settings.
7. **Log:** `DC changed: <old> -> <new>; records created <n>, copied <n>` (P2-14 format, debug [7]). Show a player message (new text in 300-399).
8. **Resume:** release the lock. The next tick runs normally.

**Open questions.** Q1.1 Copy DC policy, or start the new DC with defaults? Q1.2 Force surplus on for the old DC, or ask? Q1.3 When the old DC no longer exists (destroyed), just set the new DC and log?

## 2. Multiple DCs: station range plus a peer-to-peer backbone (proposal; model DECIDED by Matt 2026-10-17)

- **Station range (hard limit):** every DC serves only stations within `R` jumps. To extend coverage you must build another DC; there is no global reach any more.
  - `R_base` is configurable (example default 3 jumps).
  - The DC type modifies it: `R = R_base + R_type[DC]`. Example values: Player HQ +2, Trading Station +1, Equipment Dock 0, other docks −1, minimum 1. FL-specific station types: Q2.5.
  - Jumps are computed on Scan and cached per station (VERIFY the jumps command), never in the transfer loop.
- **Membership (DECIDED):** each factory and dock is served by the **closest DC** whose station range covers it (its home DC). Stored as a station local `FDN.Hub` (new text 41xx) plus a DC list in settings. Ties: Q2.1c.
- **Out of range = not served.** A station outside every DC's station range gets no products collected, no resources and no top-ups. The status screen (item 5) lists it as **out of range**, with the nearest DC and its distance, and Scan logs it once (P2-14 format). Its records and virtual stock stay untouched until it is in range again.
- **Backbone (DECIDED, replaces the earlier tree idea):** DCs form a **peer-to-peer network**.
  - Any two DCs within **backbone range** `R_bb` of each other are **linked** and can move stock between each other.
  - `R_bb` is longer than the station range: example `R_bb = 2 × R`, configurable. For a link between two DCs, use the smaller of the two `R_bb` values (proposal).
  - Stock may travel **multi-hop** through linked DCs. The route is the one with the fewest total jumps over links (precomputed on Scan into a small route table, since DC counts are small). The hop limit is Q2.6.
- **Shortage → pull via the backbone (DECIDED):** stations still deal only with their home DC. If the home DC cannot supply a ware (stock at or below its share level), it pulls the shortfall from **any DC reachable over the backbone** (this resolves Q2.1a).
  - Nearest by route first. Then it delivers to the station on the normal station leg.
  - Log `backbone: <ware> <n> <source> -> <home> (<hops> hops, <jumps> j)`. The status screen shows backbone pulls and failed pulls.
- **Reserve floor (DECIDED):** each DC keeps a per-ware **floor F** below which it will not give stock to other DCs (it is "not drained"). F is configurable; the default is Q2.7. A DC's own stations are still served down to its share level, as in v8.
- **Engine:** one DC per pass, round-robin (cursor like `[13]`), so per-tick cost stays bounded. Backbone pulls happen inside the home DC's pass, at most `[n]` pulls per pass (proposal).
- **Upgrade:** a v8 save has one DC, so there is no backbone and behaviour is identical. A "range off" setting keeps far stations served (Q2.4).
- **Decided / open questions:**
  - Q2.1 **Overlap: DECIDED.** The closest DC serves; on shortage it pulls via the backbone.
    - Q2.1a Fallback scope: **DECIDED.** Any DC linked over the backbone (directly or multi-hop) can help.
    - Q2.1b Pull before or after buying at market (proposal: backbone first, buy only if no linked DC has stock above its floor)?
    - Q2.1c Tie-break when two DCs are equally close (proposal: larger station range, then older DC)?
    - Q2.1d An optional manual override per station (pin to a DC), or never?
  - Q2.2 **Isolated DCs:** a DC with no backbone link serves only its own stations. Allow it silently, or warn on the status screen ("not linked")?
  - Q2.4 Upgraded v8 saves: start with range off (v8 behaviour) and let the player switch it on?
  - Q2.5 Range modifiers (station and backbone) for FL station types; should a DC type modify `R_bb` too?
  - Q2.6 **Multi-hop limit:** maximum hops per pull (proposal: 3), or unlimited within the route table?
  - Q2.7 **Reserve floor default:** the DC's own share level (v8 field [1]), a percentage of its current stock (example 25 %), or the larger of the two?
  - Q2.8 **Rebalance:** move stock between DCs only **on demand** (a pull on shortage), or also **proactively** (a slow background pass that evens out stock above floors toward DCs with shortages or no stock)? Proposal: on demand for v9; proactive later, as an option.

## 3. Energy transfer cost (Matt's idea, proposal)

Transfers cost Energy Cells (EC), paid by the **sending DC of each leg** from its own EC stock (Q3.7). If it has too few, the transfer is **deferred** (not partial) and logged: `transfer deferred: need <c> EC, <DC> has <e>`. **Cost follows the actual route (DECIDED, resolves Q3.6):** each backbone leg is charged at the backbone rate, and the final DC → station leg at the station rate. The cost is optional: a setting `0` = free v8-style, `1` = energy cost (Q3.1: default for new installs).

**Starting formula** (all integers, MSCI-friendly):

```
station leg:  cost_EC = ceil( U * vol * (B    + J    * jumps) * C[class] * V[tier] * H[DC] / 10^12 )
backbone leg: cost_EC = ceil( U * vol * (B_bb + J_bb * jumps) * C[class] * V[tier] * H[DC] / 10^12 )
route total   = sum of all backbone legs + the station leg (each leg rounded up on its own)
```
- `U` units moved; `vol` volume per unit (VERIFY the command to read it, e.g. `get volume of ware`). The cargo class comes from `get transport class of ware` (used in v8 Supply.Dock L061). The price comes from `get average price of ware` (v8 Main.Menu L387).
- `jumps` = jumps of that leg (DC → station, or DC → DC on a link) (VERIFY the jumps command; cache per station on Scan, never compute it in the transfer loop).
- `B`/`B_bb` = base cost per volume unit per leg (milli-EC); `J`/`J_bb` = extra per jump (milli-EC). The backbone is much cheaper per jump. `H[DC]` is the sending DC of the leg.
- `C`, `V`, `H` are multipliers stored as per-mille (1000 = ×1.0).
- **Integer overflow:** MSCI integers are 32-bit, so never multiply everything first. Divide by 1000 after each multiplier, rounding up at the end.

**Tunable constants (example values, not tuned):**
| Constant | Example |
|---|---|
| B base | 20 milli-EC per volume unit |
| J per jump (station leg) | 10 milli-EC per volume unit per jump |
| B_bb base (backbone leg) | 10 milli-EC per volume unit (Q3.8) |
| J_bb per jump (backbone leg) | J / 5 = 2 milli-EC per volume unit per jump |
| C class S / M / L / XL / ST | 1000 / 1500 / 2500 / 4000 / never moved (ST is skipped as in v8) |
| V value tier: avg price < 1,000 / < 10,000 / < 100,000 / higher | 1000 / 1500 / 2500 / 4000 |
| H sending DC: Player HQ / Trading Station / Equipment Dock / other dock | 800 / 900 / 1000 / 1200 (FL-specific station types: Q3.3) |

**Worked example** (example ware data, **not verified** from TWareT):
- 5,000 Energy Cells (vol 1, class S, tier 1) moved 3 jumps from a Player HQ hub:
  5000 × 1 × (20 + 30) = 250,000 milli-EC; × C 1.0, × V 1.0, × H 0.8 = 200,000 milli-EC = **200 EC** (4 % of the load).
- 20 units of a tech ware (example vol 10, class M, average price 50,000 → tier 3) moved 3 jumps from an Equipment Dock hub:
  20 × 10 × 50 = 10,000; × 1.5 × 2.5 × 1.0 = 37,500 milli-EC → **38 EC**. Item 4 would flag it before cost even applies.
- **Backbone fallback:** a Wheat Farm 2 jumps from its home DC A (Equipment Dock) needs 1,000 Energy Cells, but A has none above its share level. DC B (Player HQ) is linked to A at 4 jumps (backbone range 6) and has stock above its floor. Route B → A → farm:
  - backbone leg B → A (paid by B): 1000 × 1 × (10 + 2 × 4) = 18,000; × C 1.0 × V 1.0 × H 0.8 = 14,400 milli-EC → **15 EC**.
  - station leg A → farm (paid by A): 1000 × 1 × (20 + 10 × 2) = 40,000; × 1.0 × 1.0 × 1.0 = 40,000 milli-EC → **40 EC**.
  - **Total 55 EC**, against 40 EC if A had had stock. For comparison, a station-rate leg straight from B over the same 6 jumps would cost 1000 × (20 + 60) × 0.8 = **64 EC** (and B could not serve the farm directly anyway, since the farm is outside B's station range of 5).

**Open questions.** Q3.1 Default on or off for new installs; and for upgraded v8 saves (proposed: off)? Q3.2 Moving EC itself: pay from the shipment, from the hub, or exempt? Q3.3 FL station types and the HQ's efficiency values? Q3.4 Do factory product pushes (factory → hub) cost too, paid by the factory? Q3.5 Should cost be shown in the status screen per transfer or per cycle? Q3.6 **Fallback cost: DECIDED.** By actual route: backbone legs at the backbone rate, final leg at the station rate. Q3.7 Who pays a backbone leg: the sending DC (proposal), the receiving DC, or the home DC for the whole route? Q3.8 Should a backbone leg have its own base `B_bb`, or only the per-jump part (no base, so multi-hop is not penalised per hop)?

## 4. Freighter preference for high-value / complex wares (Matt's idea, proposal)

- **Threshold:** a ware is "freighter class" if its main type is laser, shield, missile or tech, or its average price ≥ `P_f` (example 20,000 Cr), or its cargo class is L/XL. The main type is read with `get maintype of ware`, as in v8 Sort.Wares.
- **Modes per ware or global (Q4.1):**
  - (a) steep energy multiplier (e.g. ×5 on top of item 3);
  - (b) **freighter only**: FDN refuses the instant transfer and logs/shows `freighter only`;
  - (c) later: FDN dispatches a real player freighter.
- **Feasibility of (c) in MSCI (to check before scheduling):**
  - Commanding a real ship to fly, dock and transfer (`buy ware`/`sell ware` while docked, or transfer between player stations): needs a sequence of fly-to and dock waits, i.e. a long-running ship task, unlike today's wait-free transfers.
  - Risk of loss (piracy, Xenon): what happens to wares in transit? FDN must not duplicate or lose them: debit on load, credit on unload.
  - Interference with the player's own commands and with FL Station Manager, CLS or Commercial Agent ships.
  - Save safety: a ship mid-task in a save must resume or abort cleanly on load.
- **Open questions:** Q4.1 Global or per-ware mode? Q4.2 Which freighters may FDN use: dedicated ones the player assigns to a hub? Q4.3 Is (b) enough for v9, with (c) as a later version?

## 5. Status screen per hub (top UX priority, proposal)

One read-only view per hub (DC), opened first:
- **Shortages:** ware, who needs it, how much, and why not supplied (DC below remote, buy off, no seller, deferred for energy, freighter only).
- **Stalls:** factories with check time == full time, and the missing resource.
- **Last cycle movements:** products in, resources out, dock top-ups, buys and sells (amounts, EC cost once item 3 exists).
- **Out of range:** stations outside every DC's station range (item 2), with the nearest DC and its distance in jumps. **Backbone:** links, isolated DCs, and backbone pulls (done and failed).
- **Exclusions:** FL Station Manager stations (§H), invalid stations dropped, and the time of the last DC change.
- **Data source:** a small ring buffer per hub written by the engine with the same decisions P2-14 logs, so the screen works with debug off.
- **Open questions:** Q5.1 How many entries per category (proposal: last 10)? Q5.2 Also as a player message summary every N minutes?

## 6. Simplified stock rules (proposal)

Per ware, on any FDN station:
- **Keep at least X** (dock: the level FDN tops up to; hub: the reserve it never shares).
- **Share above Y** (hub: stock above Y may go to stations; dock: stock above Y goes back to the hub as surplus).
- **Buy at market** and **Sell at market** as separate toggles with price limits.

Mapping to v8 fields for the upgrade:
- dock: X = [2] maintain; Y = [2] if [7] surplus on, else "never".
- hub: X = Y = [1] remote level.
- Buy: [3] can-buy + [4] buy-at. Sell: [5] sell-above + [6] sell-at.

**Open questions:** Q6.1 Allow X < Y on a dock (a band, with no traffic between X and Y)? Q6.2 One menu row per rule, or keep v8 row texts for familiarity?

## 7. Named records / single settings helper (proposal)

- All access through one library pair, `lib.LI.FDN.Get` / `lib.LI.FDN.Set (obj-or-null, field)`, where `field` is a text-ID constant (e.g. 41xx "maintain" → index 2). No bare indices outside the lib.
- Ware records gain a schema version in a fixed slot (ties into B16 "settings schema unversioned").
- **Cost:** one extra call per access. Hot loops may read the whole record once via `Ware.Rec` and use named local copies (Q7.1).
- **Open questions:** Q7.1 Is the per-access call cost acceptable in the factory loop (measure in the Phase 2 SETA run)? Q7.2 Extend the settings array beyond 30 slots for new features (hubs, energy) or move them into a second global?

## 8. Demand-driven timing (proposal)

- Keep the central 25 s timer as the heartbeat.
- **Factories:** supply resources at **cycle start** (remaining time ≈ full time, after the product push), not only in the last 45 s. Note the next check time per factory (`FDN.Settings` [3] busy-until) so it is skipped until then.
- **Docks:** a dock found short goes on a "hot list" checked every tick until satisfied. Others stay on the slow ~175 s pass.
- **Budget:** keep the factory budget `[22]` per tick and the round-robin cursor `[13]`.
- **Open questions:** Q8.1 Is cycle-start supply OK with the economy (factories hold 3 cycles of resources)? Q8.2 Hot-list size cap?
