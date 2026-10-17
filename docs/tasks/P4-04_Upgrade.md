# P4-04: Write plugin.LI.FDN.Upgrade (v8.04 save -> v9.01)

- Phase: 4 (branch `phase4-compat`)
- Writes code: yes
- Estimated size: ~3,702 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-04_Upgrade.md`
- Save the answer as: `notes/P4-04.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/al.LI.FDN.event.txt`

## Excerpts

### Upgrade steps (MASTER 7)
`plugin.LI.FDN.Upgrade` is called from `al.LI.FDN.event` on `init`/`reinit`. If `al.Settings[14]` is lower than 901:
1. Resize the array to 30 if needed. Set `[12]` = null (lock), `[13]` = null (reverse toggle/cursor). Initialise the new indices 15–27 (REFERENCE).
2. Fix `[6]` (is.dynamic): make sure index 2 exists. Stop reading index 1.
3. Validate `[2]` (DC): exists, player-owned, dock. If invalid → null, and send the player a message (“FDN paused: choose a new Distribution Centre”).
4. Purge dead or non-player stations from `[3]` and `[4]`.
5. **Optional, only if Matt approves the B5 behaviour change:** sweep the ware records on the DC and the docks and set `[7] = -1` → null.
6. START `plugin.LI.FDN.Cleanup` (orphaned trade-drone sweep, REFERENCE §G). Do this on every init/reinit, not just upgrades.
7. Set `[14] = 901`, and log “FDN upgraded 8.04 → 9.01”.
Must be idempotent (safe to run twice) and must not use `wait`.

### New v9 settings indices (REFERENCE A)
- [12] factory-check lock: `playing time` when started, null when free; stale after a timeout.
- [13] factory cursor / reverse toggle (moved off [12]).
- [14] schema version (901).
- [15] sector cache, [16] scan timestamp (`playing time`), [17] scan interval s (default 300).
- [18] active trade tasks counter, [19] max trade tasks (default 4).
- [20] menu refresh token (incremented per menu open; refresh task exits if it changes).
- [21] hotkey ID, [22] factories per tick budget (default 40), [23] game 1 TC / 2 AP / 3 FL, [24] FL patch features flag.
- [25] trade-drone type list, [26] resolved drone type cache, [27] max drone loads per trade (default 5).

## Key facts

- Phase 4 = compatibility and upgrade. Never break the save-game rules in CORE RULES.
- Never invent commands; FL patch commands need a citation or VERIFY.
- Use the engine numbers from NOTES_semantics.md if included; otherwise mark VERIFY.
- Upgrade must be idempotent (safe to run twice) and must not wait. The optional B5 sweep stays behind a flag Matt sets.

## Instruction

Phase 4, task P4-04. Write plugin.LI.FDN.Upgrade implementing every step above.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
