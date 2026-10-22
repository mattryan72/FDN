# P2-01 card fix: lib.LI.FDN.Log arg obj -> caller (docs only)

Saved per the P2-01 task flow. Written 22/10/2026, Cline session. Docs-only - no source file touched, no B number (this is a documentation sync after the in-game test result recorded in `notes/P2-01.md`).

### What changed
The P2-01 test (`04:16:31;lib.LI.FDN.Log;caller name test`) proved `get script name` inside a called lib returns the lib's own name, so `lib.LI.FDN.Log` was changed to Arg 1 = `caller` (String). Every card and REFERENCE row that still described the old `obj (Value, optional)` arg now reads `args: text (String), caller (String)`, with callers doing `$s.name = = get script name` and passing it.

Files (line endings kept per `.gitattributes`; all these are .md):
- `docs/tasks/P2-08_Supply.Start_use_libs.md` L20 - contract line only, no call example in the card
- `docs/tasks/P2-09a_Supply.Factory.Check_use_libs.md` L20 - same
- `docs/tasks/P2-09b_Supply.Factory_use_libs.md` L20 - same
- `docs/tasks/P2-10a_Supply.Dock.Check_use_libs.md` L20 - same
- `docs/tasks/P2-10b_Supply.Dock_use_libs.md` L20 - same
- `docs/tasks/P2-11a_Buy.Ware_use_libs.md` L20 - same
- `docs/tasks/P2-11b_Sell.Ware_use_libs.md` L20 - same
- `docs/tasks/P2-12a_Update.Ware_use_libs.md` L20 - same (card's B39 note already says "add lib.LI.FDN.Log calls"; no call example)
- `docs/tasks/P2-12b_Move.Ware_use_libs.md` L20 - same
- `docs/tasks/P2-14_debug_logging.md` L28 - contract line; also the Key fact "object names via `$obj` (Log adds them)" was wrong under the new arg and now says station names go inside `text` (`$obj -> get name` into the string) since Log has no object arg
- `docs/tasks/P3-04b_DC_Change_event.md` L38 contract line + L30 call example, which is now: `$s.name = = get script name`, then `= [THIS] -> call script lib.LI.FDN.Log : text='DC changed: <old> -> <new>; records created <n>, copied <n>' caller=$s.name`
- `docs/FDN_v9_REFERENCE.md` L53 - D table row updated and notes the P2-01 test result

CHANGELOG: one line under "### Docs", no B tag.

Prompts rebuilt with full Python path (`C:\Users\mattr\AppData\Local\Programs\Python\Python312\python.exe tools/build_prompt.py ...`) for all 11 changed cards; 10 wrote `prompts/*.txt` successfully.

Questions for Matt: none - the change is mechanical and matches the tested contract.

Test steps:
1. Rebuild any card prompt you plan to use next (already done for all 11 above) and check its "Library contracts" section shows `args: text (String), caller (String)` before pasting it into a session.
2. **P2-14 will NOT build** - pre-existing, not caused by this fix: `tools/build_prompt.py docs/tasks/P2-14_debug_logging.md` fails with "source_readable/plugin.LI.FDN.Supply.Factory.txt: line range(s) [(81, 137)] not found". The card's paste list needs a real range or an excerpt file (see the P2-04 pattern of `docs/excerpts/v8_Supply.Factory.Check_D4.txt`) before that card can run.

VERIFY tags: none - no code written; every edit is a documentation string, and the caller convention matches the committed source `source_readable/lib.LI.FDN.Log.txt`.