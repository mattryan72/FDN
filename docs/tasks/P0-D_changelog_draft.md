# P0-D: Draft the v9.01 CHANGELOG skeleton

- Phase: 0 (branch `phase0-setup`)
- Writes code: no
- Estimated size: ~3,175 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P0-D_changelog_draft.md`
- Save the answer as: `notes/P0-D.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `CHANGELOG.md`

## Excerpts

### Bug IDs (REFERENCE F)
B1 lock/[12] collision; B2 'create' null pointer; B3 DC/owner validation; B4 null sell cap sells all; B5 surplus default -1; B6 config-menu dependency; B7 dynamic index 1 vs 2; B8 stacked _D updaters; B9 Reset regex; B10 Sector.Array modes; B11 duplicate Buy/Sell tasks; B12 no re-validation after waits; B13 reverse array copy; B14 wait in AL path; B15 fragile temp-drone trades (drone kept, hardened); B16 settings schema unversioned. B17-B28 are low-severity.

### Decisions so far
- R-T1: keep the temporary docked trade drone; harden it in lib.LI.FDN.Trade.
- Pending Matt's decision: B5 default dock surplus to DC, B9 reset scope, excluding FL Station Manager stations.

## Key facts

- Keep everything already in the pasted CHANGELOG.md.
- Plain Markdown, short lines, no code.
- Behaviour changes must sit under their own heading and be marked "needs Matt's approval".

## Instruction

Phase 0, task D. Rewrite CHANGELOG.md with a "## [9.01] - Unreleased" section and these headings: Fixed, Changed, Behaviour changes (need approval), Removed, Compatibility, Docs. Put each B1-B16 as a one-line placeholder under Fixed ("- [B1] ... (planned)"). Put B5, B9 and the FL Station Manager exclusion under Behaviour changes. Keep the existing Baseline and Decisions notes. Output the whole file.
