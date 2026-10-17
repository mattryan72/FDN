# P2-05: Write lib.LI.FDN.Lock

- Phase: 2 (branch `phase2-libs`)
- Writes code: yes
- Estimated size: ~2,647 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P2-05_lib_Lock.md`
- Save the answer as: `notes/P2-05.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `docs/MSCI_PRIMER.md`

## Excerpts

### Library contracts (REFERENCE D; all synchronous, wait-free, return null on bad input)
- `lib.LI.FDN.Lock` | args: obj (or null = global), key (String), action ('try'/'release'), timeout s | TRUE if acquired/released; stores `playing time`; stale after timeout | B1, B11

### Names
- Object locks use local `FDN.Busy.<key>` (text 4100, `FDN.Busy.%s`); trade guards use `FDN.Trade.<ware>` (text 4101). Value = `playing time`. Global locks (obj = null) use a settings index given by the caller's key.

## Key facts

- Phase 2 = shared libraries. Libraries are synchronous and wait-free, return null on bad input, and never call START.
- Use the standard header (see excerpts) in every new script.
- Source text only, never XML. Never invent commands: use ones in the pasted scripts or mark `VERIFY:`.
- No scripts are pasted; this is a new helper.

## Instruction

Phase 2, task P2-05. Write lib.LI.FDN.Lock(obj, key, action, timeout). 'try' returns TRUE and stores playing time if the lock is free or older than timeout; 'release' clears it. No waits.
Start with "Assumptions" and "Questions for Matt" (short), then follow the answer format in CORE RULES.
