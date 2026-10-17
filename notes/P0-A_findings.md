# P0-A findings: saved-data dictionary check

- Date: 2026-10-17
- Source: the aibox local model's answer to task card P0-A (run in Cline), checked line by line against `source_readable/` by X Mod Bot. All points below are verified.
- Scripts checked: `al.LI.FDN.event`, `plugin.LI.FDN.Update.Ware`, `plugin.LI.FDN.Supply.Start`.

## Findings

1. **Settings [11], dock-check counter** (Supply.Start L031, L072-077). While the value is `< 6` it is incremented and the script returns early. At 6 it is reset to 0 and dock supply runs. So dock supply is skipped for 6 calls and runs on every 7th call (about 175 s at the 25 s timer). The L071 comment "until call 3 times" does not match the code. REFERENCE §A and ANALYSIS §1.3 updated.
2. **New minor bug B29**: Update.Ware has a `Debug.Sub:` label at L152, but nothing in the file calls `gosub Debug.Sub:`, so it is dead code. Update.Ware never reads settings [7] (debug), so it never logs. Severity low; fix in Phase 2 (card P2-12a) when logging moves to `lib.LI.FDN.Log`.
3. **is.dynamic (settings [6])** is allocated with size=10 (al.LI.FDN.event L017), but only [0]-[2] are set (L018-020). [3]-[9] are null. Noted in REFERENCE §A.
4. **Ware record** is allocated with size=12 (Update.Ware L128). Add.Ware.Sub sets [0]-[9] and [11] (L129-139) but never [10]; it is null only because the alloc leaves it null. Noted in REFERENCE §B (v9 should set it explicitly).
5. **Confirmed bugs**
   - **B1**: Supply.Start L055-057 sets only the local `$is.running` and then saves the array unchanged, so [12] is never set. Supply.Factory.Check L035-039 and L153 also write [12] (reverse toggle).
   - **B2**: Update.Ware L033-035: `action='create'` runs Add.Ware.Sub before `$pointer` is built at L046.

## Effect on the plan

- Cards P0-B-B1 and P0-B-B2 are optional now (both bugs confirmed).
- Phase 1 cards P1-01, P1-02 and P1-04 stand as written.
