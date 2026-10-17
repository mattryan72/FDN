# P4-07: Clean up the text file 9910-L044.xml

- Phase: 4 (branch `phase4-compat`)
- Writes code: no
- Estimated size: ~3,177 tokens when built
- Build: `python tools/build_prompt.py docs/tasks/P4-07_text_file.md`
- Save the answer as: `notes/P4-07.md`

## Paste

CORE_PROMPT.md is always added first by the builder. Then, in this order:

- `source_readable/9910-L044.xml`

## Excerpts

### Known problems (ANALYSIS 1.4)
Empty `<page id="17">` (game object-name page), stray `L` after `<t id="135">`, typos 132 'Dock LDetails' and 186 'Confrim', mixed Center/Centre. New ranges: 300-399 UI, 4100-4199 names (4100 FDN.Busy.%s, 4101 FDN.Trade.%s, 4102 FDN.Trade.Drone), 9100-9199 formats; 310 = 'FDN Trade Drone'.

## Key facts

- This is the one file where you output XML: it is a text file, not a script.
- Keep every existing id.

## Instruction

Phase 4, task P4-07. Output the cleaned 9910-L044.xml with the fixes and new entries, then say how to make 9910-L049.xml (German copy).
Start with "Assumptions" and "Questions for Matt" (short).
