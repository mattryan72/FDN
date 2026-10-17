# P0-B-B9: B9 master reset regex and scope — REVIEW ONLY (no code written)

### Task P0-B-B9: B9 — Reset uses regex `'FDN*'` which matches any name containing 'FD' (review only)

**Assumptions:**
- The pasted `source_readable/plugin.LI.FDN.Reset.txt` is the complete script.
- Regex semantics are as the MSCI engine implements them (X3's regex has no anchors; an unanchored pattern matches any occurrence).

**Questions for Matt:**
- Do you want this answer to stay review-only, or should I draft a fix in a follow-up?
- Should Reset also stop running supply tasks (`plugin.LI.FDN.Supply.Start`) and sweep all player docks (per the fix direction), or is that a separate task card?

---

#### 1. Quoted code (exact lines)

This is the only place `FDN*` appears in the script, used once as the regex argument:
```
064   $array = $station  ->  get local variables: regular expression='FDN*'
```
(L028–030 are just `$station = $dc` / `gosub Clear.Local.Sub:`; the actual regex is at **L064**, so if the bug note points to "28-30, 64" that's roughly right but L064 is the only line containing the pattern.)

The sub then does:
```
065   $s = size of array $array
...
069   $station  ->  set local variable: name=$var value=null
```

#### 2. Verdict: **CONFIRMED**

- `FDN*` in regex means "F, D, and zero-or-more N" — i.e., it matches any variable whose name contains the substring "FD". So a station that has locals from another mod (e.g. anything containing `fd`) would also be matched and nulled by Reset. The fix direction's `^FDN\.` is correct in principle, but VERIFY: whether X3's regex engine supports `^` anchors and `\.` escape — I can't cite this from the given files, so test before shipping.

#### 3. Additional scope issues (all confirmed from the pasted lines)

- **No exists check on DC:** L028 `$station = $dc` runs unconditionally even when `$al.Settings[2]` is null; a `gosub Clear.Local.Sub:` with a null station will either error or do nothing — VERIFY which. Add an `if $station / if $dc exists` guard before the gosub at L030, and likewise inside the loops (L038, L047) since array entries could reference destroyed stations.
- **Running supply tasks not stopped:** this script never disables or stops any AL task; it only nulls locals and clears `al.Settings[2..4]` (L052–056). If `plugin.LI.FDN.Supply.Start` is still enabled when Reset runs, the next 25 s tick will act on a half-reset state. The fix direction says "set enabled FALSE first" — that requires touching another script (`al.LI.FDN.event` or wherever the task is managed), which I don't have pasted; name it and I'll review it.
- **Stale dock records:** L043–048 only loops `$dock.array`, so a dock removed from the array (sold/destroyed) keeps its `FDN.Ware.*` locals forever. "Sweep all player docks" would fix this but again needs code I don't have (a station-listing helper).

#### 4. In-game test to settle it

1. On a DC, manually set a local variable named e.g. `OtherMod.FDThing` = some value via the script editor; run `plugin.LI.FDN.Reset`; re-inspect locals — if `OtherMod.FDThing` is null, the regex leak is proven in-game (expected with current code).
2. For the DC-null case: delete the DC's local `$dc` reference (or set `al.Settings[2]`=null), run Reset, and watch for a script error or silent no-op — that settles whether an exists guard is needed.

*Not tested in game — this is source review only.*