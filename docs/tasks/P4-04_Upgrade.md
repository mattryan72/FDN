# P4-04: Write plugin.LI.FDN.Upgrade (v8.04 save -> v9.01)

- Phase: 4 (branch `phase4-compat`)
- Writes code: yes
- Estimated size: ~3,965 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-04_Upgrade.md`
- Save the answer as: `notes/P4-04.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`
- `source_readable/al.LI.FDN.event.txt`

## Excerpts

### Upgrade steps (MASTER 7)
`plugin.LI.FDN.Upgrade` is called from `al.LI.FDN.event` on `init`/`reinit`. If `al.Settings[14]` is lower than 901:
1. Resize the array to 30 if needed. Set `[12]` = null (lock), `[13]` = null (reverse toggle/cursor). Initialise the new indices 15–29 (REFERENCE): `[28]` = 1 (surplus default on, B5), `[29]` = registry seeded from `[2]`, `[3]`, `[4]` (B9).
2. Fix `[6]` (is.dynamic): make sure index 2 exists. Stop reading index 1.
3. Validate `[2]` (DC): exists, player-owned, dock. If invalid → null, and send the player a message (“FDN paused: choose a new Distribution Centre”).
4. Purge dead or non-player stations from `[3]` and `[4]`.
5. **B5 (approved 2026-10-17):** migrate the v8 ware records on the stations in `[29]`: `[7]` null → 0 (explicit off; in v8 null only came from the player switching it off). Leave −1 (now "use default" = on via `[28]` = 1) and 1 alone. If this is too much work for one wait-free script, START a one-off migration task and set a flag so it runs once. Also prune dead stations from `[29]`.
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
- [28] default surplus->DC (B5, approved): 1 on, 0 off, 2 v8 compatible; used when a record's [7] is -1/null. v8 upgrade sets 1.
- [29] station registry (B9, approved): array of every station FDN has ever touched; appended via lib.LI.FDN.Reg.Add; pruned at Reset/Upgrade; seeded from [2], [3], [4] on upgrade.

## Key facts

- Phase 4 = compatibility and upgrade. Never break the save-game rules in CORE RULES.
- Never invent commands; FL patch commands need a citation or VERIFY.
- Use the engine numbers from NOTES_semantics.md if included; otherwise mark VERIFY.
- Upgrade must be idempotent (safe to run twice) and must not wait. B5 and B9 were approved by Matt on 2026-10-17: [28] = 1, migrate records' [7] null -> 0, seed and prune registry [29].
- In v8, a record's [7] = null only happened when the player switched surplus off, so null -> 0 keeps their choice; -1 stays (= use default, which is on).
- Test null with DATATYPE_NULL, not `== 0`.

## Instruction

Phase 4, task P4-04. Write plugin.LI.FDN.Upgrade implementing every step above.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
