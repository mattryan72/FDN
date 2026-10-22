# P2-04 card fix (docs only, no B number)

Docs-only correction to the P2-04 task card (`lib.LI.FDN.Fac.Cfg`). No code change, so no bug ID.

## What changed
1. **New excerpt** `docs/excerpts/v8_Supply.Factory.Check_D4.txt` (CRLF per `.gitattributes`): v8.04 reference lines 058-085 of `plugin.LI.FDN.Supply.Factory.Check`, with a header noting it is not current source and that this block will be replaced by `lib.LI.FDN.Fac.Cfg` in P2-04 (text 4001 is read once before the loop in v9.01/v3 per P7).
2. **Card line 14** (`docs/tasks/P2-04_lib_Fac.Cfg.md`, kept LF): the paste entry now points at the excerpt file instead of `source_readable/plugin.LI.FDN.Supply.Factory.Check.txt lines 055-095`.
3. **Duplicate/perf note**: now cites "Supply.Factory.Check (v8 065-084, see excerpt; v3 has no prefixes)" and adds the other D4 sites with line ranges — Menu.AP.Factory.List 187-204, Menu.Factory.List 180-197, Menu.Factory.Details 8-14 (get-or-create only).
4. **Rebuilt prompt** via `python tools/build_prompt.py docs/tasks/P2-04_lib_Fac.Cfg.md --stamp`.

## Why
The card referenced a line range in the v3 source readable, but the D4 get-or-create/auto-manage block it describes is best shown from the stable v8.04 reference (v9.01/v3 has no line-number prefixes and reads text 4001 once before the loop). A dedicated, version-labelled excerpt keeps the paste deterministic and self-describing.
