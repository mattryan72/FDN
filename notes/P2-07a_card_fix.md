# P2-07a card fix: inline Phase 0 findings + helper contracts (docs only)

Docs-only correction to the P2-07a task card (`lib.LI.FDN.Trade`). No code change, so no bug ID. Written 10/23/2026, Cline session.

## What changed
`docs/tasks/P2-07a_lib_Trade.md`:
1. Removed `notes/NOTES_semantics.md (optional)` from the Paste list (~10,700 tokens of T9/FL notes pushed the built prompt to ~18,375 tokens / WARN).
2. Added five helper library contracts under "Library contracts" so the model knows what it can call without re-reading REFERENCE D: Cfg.Get, Log, Is.Valid, Sectors, Ware.Rec.
3. Added a short "Phase 0 test findings" subsection (T1 null comparisons, T4 destruct/exists, T5 docked drone + Mammoth guard, T6 SIGNAL_KILLED) so the trade-relevant test results are in-card without pasting the full notes file.

## Why
The prompt was at WARN level due to NOTES_semantics.md being too large for this card's needs (only 4 of ~12 test sections are trade-relevant). Inlining those four findings keeps the token count manageable while preserving the critical gotchas that directly affect `lib.LI.FDN.Trade` implementation. The helper contracts remove a round-trip dependency on REFERENCE D for args/signatures.

CHANGELOG: none (docs-only card fix, not yet committed).