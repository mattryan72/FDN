# P2-06: Write plugin.LI.FDN.Scan and lib.LI.FDN.Sectors (B10)

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~4,308 tokens when built
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

### Bug notes from the analysis (line numbers are Script Editor lines)
- B10 (medium) Sector.Array 7-10, 84; callers pass search=4 (Supply.Start 37, Menu.AP.Factory.List 15) or 3 (Buy/Sell). Documented modes 1/2/3 are ignored except 3. It both scans (changes [3]/[4]/[8]) and returns a list. Fix: split into plugin.LI.FDN.Scan and lib.LI.FDN.Sectors.
- B25 (low) Sector.Array 69-72 vs 125-128. Docks appended twice; `find in array` is O(n^2). Fix: single pass.

### Duplicate / performance notes (ANALYSIS 3 and 5)
- P1 full station scan every 25 s (Supply.Start -> Sector.Array) -> rate-limit with cache [15] and timestamp [16].

### Settings used
- [3] factories, [4] docks, [8] exclude array, [15] sector cache, [16] scan time, [17] scan interval (default 300).

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.
- Scan is a task (it may wait); Sectors is a library (no wait, never scans).

## Instruction

Phase 2, task P2-06. Write plugin.LI.FDN.Scan (one pass over player stations, no O(n^2) find-in-array, fills [3] [4] [8] [15], sets [16], waits every 50 stations) and lib.LI.FDN.Sectors(mode) which only reads [15]. Include advanced satellites for mode 3.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
