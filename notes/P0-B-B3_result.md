# P0-B-B3: B3 missing DC / owner checks — REVIEW ONLY (no code written)

**Assumptions:**
- The five excerpts pasted in the prompt are the complete scripts for review; `plugin.LI.FDN.Update.Ware` and `plugin.LI.FDN.Supply.Dock` were not given, so I cannot see how they handle a dead station. All findings below use only the quoted lines.
- Line numbers are the 3-digit Script Editor line numbers printed in each pasted file.

**Questions for Matt:**
1. Do you ever actually sell/give away stations to an NPC (or have one captured) while FDN is running? If not, part (b) stays theoretical but I still recommend the check because it's cheap.
2. When `plugin.LI.FDN.Update.Ware` can't find its station, does it return null/0 or something else? That decides whether "wares vanish" happens exactly as the bug note says (see below — one line from that script would settle it).

---

## 1) Quoted code at each spot the bug note points to

**Supply.Start L45-46** (the only DC check in the tick):
```
045   * check there is a DC the script will only continue if one is set
046   if $dc
```

**Supply.Factory L60-72** (`Add.Product.Sub` — moves product to DC, then removes it from the factory):
```
060  $product.amount = $factory  ->  get amount of ware $ware in cargo bay
...
067   = null -> call script plugin.LI.FDN.Update.Ware : ware=$ware  amount=$product.amount  station=$dc  action='add'
...
071  $remove = - $product.amount
072   = $factory  ->  add $remove units of $ware
```

**Supply.Factory L107-113, 129** (`Supply.Resource.Sub` — removes from DC, adds to factory):
```
107   $from.dc = null -> call script plugin.LI.FDN.Update.Ware : ware=$ware  amount=$required  station=$dc  action='remove'
...
113     = $factory  ->  add $required units of $ware
...
129    $ware.settings = $dc  ->  get local variable: name=$pointer
```

**Supply.Factory.Check L63, 140-141** (the only per-factory check):
```
063   if $factory  ->  exists
...
141    remove element from array $factory.array at index $s
```

**Supply.Dock.Check L39, 47, 54-56** (DC + per-dock checks):
```
039  if $dc  ->  exists
...
047   if $dock  ->  exists
...
055    * if factory does not exist remove from array
056    remove element from array $dock.array at index $s
```

**Main.Menu L51-53:**
```
051   if not $dc
052    $menu.view = 7
053    gosub Config.View.Sub:
```

---

## 2) Verdict

**(a) "DC destroyed → wares vanish": CONFIRMED (with one caveat).**
The only gate in the tick is `if $dc` at Supply.Start L46, which tests only whether the array slot is set — not whether the station still exists. So when the DC is destroyed, every factory with product management on still runs Supply.Factory flag=1: L067 calls Update.Ware to "add" into a dead `$dc`, and then L071-072 unconditionally subtracts the same amount from the *live* factory's cargo. If `plugin.LI.FDN.Update.Ware` fails silently on a non-existent station (the usual MSCI behaviour for a null object), nothing lands in the DC and the factory stock is gone — exactly as noted. The caveat: I was not given Update.Ware, so I can't rule out that it logs/fails differently; but L071-072 execute regardless of what L067 did. Note the bug note's "71-72" matches (it also cites 67-72 as the whole block — both are correct: 67 is the add-to-DC, 71-72 is the removal).

**(b) "No owner check anywhere → sold/captured stations stay managed": CONFIRMED.**
Across all five files there is exactly one `-> exists` per station (Factory.Check L063, Dock.Check L47) and DC checks at Supply.Start L46 / Dock.Check L39. There is no `get owner race` command anywhere in any of the pasted scripts, so a factory or dock sold to an NPC, captured, or given away keeps passing every check and stays in `$al.Settings[3]`/`$al.Settings[4]`, being drained (L071-072) and kept supplied (L113, L128 Buy.Ware). Same for the DC itself: if you sell it, Supply.Start L46 still passes and factories keep shipping product into a station no longer yours.

**Line-number check:** all numbers in the bug note are correct — Supply.Start 46; Supply.Factory 67-72 (and 71-72); Factory.Check 63; Dock.Check 39/47; Main.Menu 51. No corrections needed. One extra place worth adding to the list: **Supply.Factory L107 and L129**, which also act on `$dc` with no owner check (resource withdrawal / reading the DC's `FDN.Ware.<ware>` settings).

---

## 3) In-game test that would settle it

**Test for (a):**
1. Set up a DC + one product-managed factory, let it collect some product in its cargo bay; enable debug logging (setting index 7). Destroy the DC (e.g. sell-and-rebuy is easiest: actually just blow it up or sell it and don't reselect — selling also tests part b at once).
2. Wait ~25 s for the next `al.LI.FDN.event` tick, then open the factory's cargo. *Expected if confirmed:* product amount drops to zero (log shows "has N of X to pass to DC" / "Remove N ... from ..." with nothing landing anywhere), and no `FDN.Ware.<ware>` appears on any station.

**Test for (b):**
1. With a managed factory running, sell it to an NPC (or have one captured) and wait 2-3 ticks.
2. *Expected if confirmed:* the log keeps showing "Supply Factory called" / resource buys for that station every tick even though you no longer own it, and `al.LI.FDN.event[3]` still contains it — i.e. FDN is paying NPC stations to run on your wares (or buying resources into them).

---

**Summary:** both parts of B3 are **CONFIRMED** on the quoted lines; line numbers in the bug note are accurate. The missing pieces for a fix (next task) would be: one DC validation per tick at Supply.Start L46 (exists + owner race = player + class Dock, pause & notify on failure), and an `owner race` check next to the existing `-> exists` at Factory.Check L063 and Dock.Check L47 so non-player-owned stations get removed from their arrays. Not tested — review only, no code changed.
