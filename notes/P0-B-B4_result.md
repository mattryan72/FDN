# P0-B-B4: B4 missing record → sell all stock? — REVIEW ONLY (no code written)

**Assumptions:**
- The two pasted `source_readable` excerpts (`plugin.LI.FDN.Supply.Dock.txt`, `plugin.LI.FDN.Sell.Ware.txt`) are canonical; line numbers quoted are their 3-digit Script Editor lines.
- "The record" = the station local `FDN.Ware.<ware>` (text id 4000), index 5 = sell cap, per the bug note.
- Whether MSCI evaluates `null >= 0` as TRUE is treated as **unknown** — Phase 0 C test 1 settles it; nothing here assumes an answer.

**Questions for Matt:** none — the review answers everything from the two pasted files; only the engine-behaviour question remains and it is already queued under Phase 0 C.

---

## 1) The code the bug note points to, quoted exactly

`plugin.LI.FDN.Supply.Dock.txt`, `Sell.Ware.Sub` (note's "146-156"; actual sub spans L145–L158):

```
070     $pointer = = sprintf: pageid=$PageID textid=4000, $ware, null, null, null, null
...
146   $pointer = = sprintf: pageid=$PageID textid=4000, $ware, null, null, null, null
147   $ware.settings = $dock  ->  get local variable: name=$pointer
148   $sell = $ware.settings[5]
149   if $sell >= 0
150    $virtual.stock = $ware.settings[0]
151    $physical.stock = $dock  ->  get amount of ware $ware in cargo bay
152    $stock = $virtual.stock + $physical.stock
153    if $stock > $sell
154     $amount = $stock - $sell
155     START  = null -> call script plugin.LI.FDN.Sell.Ware : dock=$dock  ware=$ware  amount=$amount
156    end
157   end
158   endsub
```

`plugin.LI.FDN.Sell.Ware.txt`, lines 44–49 (as cited by the note):

```
044   $ware.settings = $dock  ->  get local variable: name=$pointer
045   $virtual.stock = $ware.settings[0]
046   $physical.stock = $dock  ->  get amount of ware $ware in cargo bay
047   $stock = $virtual.stock + $physical.stock
048   $sell = $ware.settings[5]
049   $amount = $stock - $sell
```

Note: the sub also fetches `$sell` and re-derives stock at Supply.Dock L146–L152; Sell.Ware 35–37 (its own first fetch, before the while loop) is part of the same exposure but the note's range 44–49 covers where the amount is actually computed.

---

## 2) Verdict: **PARTLY** — with one unverified engine-behaviour step that decides whether it fires at all.

- The chain *as described* does hold in code: a missing record gives `$ware.settings = null` (L147 / L036, L044), so `$sell = $ware.settings[5]` is null (Supply.Dock L148; Sell.Ware L048). If `null >= 0` is TRUE in MSCI, then Supply.Dock L149–L157 passes and calls Sell.Ware with `$amount = $stock - null` (Sell.Ware L049), i.e. the whole stock — which then loops over every sector at L040–L043 and sells until no buyer is found.
- However, the note's own premise ("null acts as 0") is unverified; if `null >= 0` is FALSE in MSCI, the guard at Supply.Dock L149 rejects it and nothing is sold — so the *dangerous* path depends entirely on that single engine behaviour, which Phase 0 C test 1 will settle. I therefore cannot call this CONFIRMED from pasted sources alone.
- One inaccuracy in the note: "Records are only created when a menu shows the ware" is not supported by the code you gave me — Supply.Dock L098–L102 explicitly *creates* a missing DC record (`action='create'`). The Dock-side record (the one Sell.Ware.Sub reads) has no equivalent create in this file, so a dock that holds wares but never had its menu opened is the plausible exposure. I am not asserting the "menu only" claim is false; it's just not verifiable from these two files.

---

## 3) Line numbers — correct as written

- Supply.Dock `Sell.Ware.Sub`: note says 146–156; actual sub is **L145 (`Sell.Ware.Sub:`) through L158 (`endsub`)** — the cited range is the meaningful body, so it's off by one line at each end only.
- Sell.Ware: note says **44–49** — exactly right; that block recomputes stock/amount inside the sector loop (L040 `while $s > 0` … L125 `end`).

---

## 4) In-game test to settle it (two steps, no code change yet)

1. **Force a missing dock record.** Pick one DC-owned dock that has physical stock of a ware whose trade class is not ST, and ensure the *dock's* local `FDN.Ware.<ware>` does not exist — easiest: after setting up the network, use MSCI in-game (`al.LI.FDN.event` debug / or just never open the Supply menu for that dock) so only the DC record exists. Enable `$al.Settings[7]` (debug log).
2. **Let one `al.LI.FDN.event` tick run** and read the log file: if you see `'Sold …'` lines from Sell.Ware (Sell.Ware L103, via Debug.Sub) for that ware with no cap set, then `null >= 0` was TRUE and B4 fires as written. If nothing sells but debug shows supply movement only, the guard at Supply.Dock L149 rejected null — meaning the fix direction ("skip when record is null; DATATYPE_INT check") is still the right hardening even though this specific path never sold stock on its own.

Either outcome tells you exactly what Phase 0 C test 1 should expect from MSCI's `null >= 0` evaluation, which is the only remaining unknown for B4.

---

**Summary:** B4 is **PARTLY** — the code chain (missing record → `$sell = null` → guard at Supply.Dock L149 → full-stock sell via Sell.Ware L048–L049) exists exactly as described, but whether it ever fires hinges on `null >= 0` evaluation in MSCI, which is unknown and scheduled for Phase 0 C test 1. Line numbers in the bug note are correct (Sell.Ware.Sub body 146–156; Sell.Ware 44–49). Not tested — review only, no code changed.