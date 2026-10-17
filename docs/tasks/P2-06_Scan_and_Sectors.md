# P2-06: Write plugin.LI.FDN.Scan and lib.LI.FDN.Sectors (B10)

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~4,827 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-06_Scan_and_Sectors.md`
- Save the answer as: `notes/P2-06.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/plugin.LI.FDN.Sector.Array.txt`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Sectors` | args: mode (1 factories, 2 docks, 3 trade = all + adv. sats) | sector array from cache [15], never scans | replaces Sector.Array readers
- `lib.LI.FDN.Is.Factory` | args: station | TRUE if managed factory (Factory, not Complex Hub, detectable rule; VERIFY intent of `is detectable == 0`) | D10
- `lib.LI.FDN.Is.Valid` | args: obj, need.dock (Boolean) | TRUE if obj exists, owner race == Player, and is a Dock if asked | B3, B12
- `lib.LI.FDN.Reg.Add` | args: station | null; appends the station to registry [29] if not already there (creates the array if null) | B9 registry
- `lib.LI.FDN.Is.FL.Managed` | args: station | TRUE only on FL ([23] == 3) when the station is run by Station Manager; always FALSE on AP. Phase 2 stub returns FALSE; Phase 4 rule: `egosoft.stationmgr.time` is fresh (<= 10 s old, VERIFY with T9b) | FL Station Manager decision

### Bug notes from the analysis (line numbers are Script Editor lines)
- B10 (medium) Sector.Array 7-10, 84; callers pass search=4 (Supply.Start 37, Menu.AP.Factory.List 15) or 3 (Buy/Sell). Documented modes 1/2/3 are ignored except 3. It both scans (changes [3]/[4]/[8]) and returns a list. Fix: split into plugin.LI.FDN.Scan and lib.LI.FDN.Sectors.
- B25 (low) Sector.Array 69-72 vs 125-128. Docks appended twice; `find in array` is O(n^2). Fix: single pass.

### Duplicate / performance notes (ANALYSIS 3 and 5)
- P1 full station scan every 25 s (Supply.Start -> Sector.Array) -> rate-limit with cache [15] and timestamp [16].

### Settings used
- [3] factories, [4] docks, [8] exclude array, [15] sector cache, [16] scan time, [17] scan interval (default 300), [23] game (3 = FL), [29] registry.

### FL Station Manager (approved by Matt 2026-10-17, REFERENCE H)
On FL, a station run by Station Manager is dropped: not added to [3]/[4]; if it is the DC, set [2] = null (FDN pauses). Warn only when a station that WAS in [3]/[4] (or was the DC) is dropped: player message text 330 (station, %s = name) or 331 (DC), and a log line via lib.LI.FDN.Log (text 332). Keep its FDN locals.

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.
- Scan is a task (it may wait); Sectors is a library (no wait, never scans).

## Instruction

Phase 2, task P2-06. Write plugin.LI.FDN.Scan (one pass over player stations, no O(n^2) find-in-array, fills [3] [4] [8] [15], sets [16], waits every 50 stations; every station added to [3]/[4] goes through lib.LI.FDN.Reg.Add; at the same point as the exists/owner checks, call lib.LI.FDN.Is.FL.Managed and drop/warn as described; also write Is.FL.Managed as a stub that returns FALSE until test T9 gives the detection) and lib.LI.FDN.Sectors(mode) which only reads [15]. Include advanced satellites for mode 3.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
