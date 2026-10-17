# Checking the local AI's answers

Your local model is good, but on long input it can get a detail wrong and still sound sure of itself. A test showed this: on an 86k-token prompt it got a simple "find this one fact" question wrong. Spend a few minutes on these checks before you put any answer into the game.

## Every answer

1. **Spot-check line numbers.** Pick 3 quoted lines (more if the answer is a bug verdict). Open the same file in `source_readable/` in VS Code, press Ctrl+G, type the number, and check the line matches word for word. One wrong quote means you should treat the whole answer with suspicion.
2. **Check every command exists.** For each command in new code, search for it in `source_readable/` (Ctrl+Shift+F in VS Code), or check the reference the AI cited. If it is in neither, it is invented or needs testing: it must be marked `VERIFY:`. Test it with a tiny script in the in-game editor before relying on it.
3. **One script per answer.** If the AI rewrote two unrelated scripts, or "also tidied" something you did not ask for, throw away the extra part and ask again with the right card.
4. **Save-game rules.** Check that it did not rename `al.LI.FDN.event`, `al.plugin.LI.FDN.register` or `plugin.LI.FDN.Main.Menu`, did not change settings indices 0-11 or ware record indices 0-7, and did not touch `lib.BW.isAP`.
5. **No XML.** If the answer contains `<codearray>` or `<sourcetext>`, discard that part.

## When an answer depends on a buried detail

If a conclusion rests on one line deep inside a long script (for example "line 146 compares null with 0"), ask again in a **fresh, short chat**: paste only `docs/CORE_PROMPT.md`, the few lines around it, and the one question. If the two answers disagree, trust the source file, not either answer.

## Before you compile

- Read the "Assumptions" and "Questions for Matt" at the top. Answer the questions before using the code.
- Search the answer for `VERIFY:`. Each one is a small in-game test to do first, or a note for `notes/NOTES_semantics.md`.
- Compare the change list with the code: every listed change should be there, and nothing unlisted.
- Commit the answer in `notes/` and the edited `source_readable/` file together, so you can always see what changed and why.

## If it keeps going wrong

- Start a new chat. Old chat history makes the prompt longer and less reliable.
- Use a smaller card, or cut the script to a line range in the card's `## Paste` list.
- Ask for less in one go: one bug per answer is fine.
