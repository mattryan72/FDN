# M-03 test plan: test.LI.FDN.Hub

For the assistant writing and building `test.LI.FDN.Hub`. Follows the same pattern as
`test.LI.FDN.Upgrade`: each check writes a `TEST ...` line to 9910 (debug) and 9911
(test), final line `TEST Hub: n/m PASS`.

## Prerequisites
- A valid DC set in [2] (any player Dock).
- At least one factory or dock within range of the DC (for check 4).
- Settings array already grown to 40 (run Upgrade first, or a fresh install).

## Checks

### 1. Dc.Range: computed value
- Call `$r = [THIS] -> call script lib.LI.FDN.Dc.Range : dc=$dc`.
- Expected: R_base [32] (default 3) + subtype modifier for the DC's subtype.
  - If DC is an Equipment Dock (subtype 6): expect 3.
  - If DC is a Player HQ (subtype 62): expect 5.
  - Other dock subtype: expect 2 (3-1).
- Log: `TEST Hub 1a: Dc.Range computed = $r (expected <value>)`.

### 2. Dc.Range: override via FDN.DC.Cfg[0]
- Set `$dc -> set local variable: name='FDN.DC.Cfg' value=<array [5, -1, null, null]>`
  (use `create new array, arguments=5, -1, null, null`).
- Call Dc.Range again. Expect exactly 5.
- Restore: `$dc -> set local variable: name='FDN.DC.Cfg' value=null`.
- Log: `TEST Hub 2: Dc.Range override = $r (expected 5)`, then restore and re-check computed.

### 3. Dc.List: primary first, invalid dropped
- Read [30] before the call.
- Append a dead/null entry to [30]: `$al.Settings[30] = <copy with extra null>`.
- Call `$list = [THIS] -> call script lib.LI.FDN.Dc.List :`.
- Expected: size 1 (only the valid DC), element 0 == [2].
- Verify [30] was written back clean.
- Log: `TEST Hub 3: Dc.List size = $n (expected 1)`, `element[0] == primary`.

### 4. Route.Build with one DC: zero links
- Call `$links = [THIS] -> call script lib.LI.FDN.Route.Build :`.
- Expected: returns 0, [35] is an empty array.
- Log: `TEST Hub 4: Route.Build links = $links (expected 0)`.

### 5. Hub.Assign on a factory in range
- Pick a factory from [3]. Call `$home = [THIS] -> call script lib.LI.FDN.Hub.Assign : station=$fac`.
- Expected: returns the DC, FDN.Hub local written as [DC, jumps, stamp].
  - Verify `jumps` matches `= get jumps from sector $dc.sec to sector $fac.sec`.
  - Verify stamp is recent (within ~1 s of playing time).
- Log: `TEST Hub 5a: home = $home == DC`, `TEST Hub 5b: hub[1] = $jumps (expected <computed>)`.

### 6. Hub.Assign out-of-range with [31]=1, [32]=0, override 1
- Save current [31], [32]. Set [31]=1, [32]=0, FDN.DC.Cfg[0]=1 on the DC (range=1).
- Pick a factory more than 1 jump away. Call Hub.Assign.
- Expected: returns null, FDN.Hub = [null, -1, stamp].
- Log: `TEST Hub 6a: out-of-range home is null`, `hub[1] == -1`.

### 7. Same station with [31]=0 (range off)
- Set [31]=0 (keep override or remove it). Call Hub.Assign on the same far factory.
- Expected: returns the DC, FDN.Hub = [DC, jumps, stamp] (jumps > 1 but range ignored).
- Log: `TEST Hub 7: range-off home = $home == DC`.

### 8. Restore all changed settings and locals
- Restore [31], [32], FDN.DC.Cfg to their saved values.
- Re-run Dc.Range to confirm computed value is back.
- Log: `TEST Hub 8: restore OK, range = $r`.

## Final line
`TEST Hub: <passed>/<total> PASS` — write to both 9910 and 9911 via lib.LI.FDN.Log
with caller='test.LI.FDN.Hub'. If any check fails, log `TEST Hub FAIL: <check number>`
and continue with remaining checks (do not abort).

## Notes for the test author
- Use `[THIS] -> call script` for all synchronous calls.
- Save/restore every setting you change; the test must leave the save clean.
- The FDN.DC.Cfg local is an array of 4: [0]=range override, [1]=floor pct (unused here),
  [2]-[3] reserved. Pass `create new array, arguments=<val>, -1, null, null`.
- `get jumps from sector` returns the jump count between two sectors; same sector = 0.
  An unreachable sector may return null or negative — treat as no link (VERIFY item).
