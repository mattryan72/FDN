# FDN v9.01 – Freight Distribution Network (Logain Industries)

X3: Albion Prelude 3.3 / Farnham's Legacy rework of FDN v8.04 by Logain Abler.

## Layout
| Folder | What |
|---|---|
| `src/scripts/` | Compiled MSCI script XML – what ships in the game. Baseline = v8.04. Only change via X-Studio / XScript / in-game editor. |
| `src/t/` | Text page 9910 (`9910-L044.xml`, plus language copies later). |
| `source_readable/` | Readable source of every script – what the local AI reads and edits. Keep in sync with `src/`. |
| `docs/` | Analysis, master prompt, phase prompts (0–5), reference, recommendations. Start with `docs/FDN_v9_MASTER_PROMPT.md`. |
| `notes/` | Save the local AI's answers here, one file per step (e.g. `notes/phase1-B03.md`). |
| `tests/` | Test scripts, test save notes, log captures (`log09910.txt`). |
| `package/` | Plugin Manager `.spk` and release zip builds. |
| `reference/` | Readable v7.2 and the ship equipment patch, for comparison only. |
| `tools/` | Python helpers used to decode and analyse the scripts. |

## Workflow
1. One branch per phase: `phase0-setup`, `phase1-bugfix`, `phase2-libs`, `phase3-menus`, `phase4-compat`, `phase5-release`.
2. Local AI proposes changes against `source_readable/`. Apply them in the script editor, export to `src/scripts/`, re-export readable, commit both.
3. Record every change in `CHANGELOG.md`.

## Key decisions
- The docked trade drone is kept (it uses the game's native trade mechanics) and hardened via `lib.LI.FDN.Trade` – see `docs/FDN_v9_REFERENCE.md` §G.
- Save compatibility: keep `al.LI.FDN.event`, `al.plugin.LI.FDN.register`, `plugin.LI.FDN.Main.Menu`, settings 0–11, text page 9910.
