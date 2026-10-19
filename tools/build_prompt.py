#!/usr/bin/env python3
"""Build one paste-ready prompt for the local AI from a task card.

Usage (run from the repo folder):
    python tools/build_prompt.py docs/tasks/P0-A_data_dictionary.md
    python tools/build_prompt.py docs/tasks/P0-A_data_dictionary.md --out prompts/P0-A.txt
    python tools/build_prompt.py --all            # build every card, print a size table
    python tools/build_prompt.py --all --stamp    # also update "Estimated size" in each card

The prompt is assembled in this order:
    1. docs/CORE_PROMPT.md (always)
    2. the card's "Excerpts" section (short bits of REFERENCE / ANALYSIS)
    3. every file listed under "Paste" (scripts can be cut to line ranges)
    4. the card's "Key facts" section
    5. the card's "Instruction" section (always last)

Token estimate = characters / 3.5. Above 16,000 it warns; above 32,000 it
refuses unless you add --force. Pure Python 3 standard library.
"""
import argparse
import os
import re
import sys

WARN_TOKENS = 16000
MAX_TOKENS = 32000
CHARS_PER_TOKEN = 3.5

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CORE = os.path.join("docs", "CORE_PROMPT.md")
TASKS = os.path.join("docs", "tasks")
SECTIONS = ("paste", "excerpts", "key facts", "instruction")


class CardError(Exception):
    pass


def read_text(rel_path):
    full = os.path.join(ROOT, rel_path)
    with open(full, "r", encoding="utf-8", errors="replace") as fh:
        text = fh.read()
    # Windows checkouts have CRLF; normalise so counts are the same everywhere.
    return text.replace("\r\n", "\n").replace("\r", "\n")


def estimate(text):
    return int(round(len(text) / CHARS_PER_TOKEN))


def parse_card(rel_path):
    text = read_text(rel_path)
    lines = text.split("\n")
    title = ""
    sections = {name: [] for name in SECTIONS}
    current = None
    for line in lines:
        if line.startswith("# ") and not title:
            title = line[2:].strip()
            continue
        if line.startswith("## "):
            name = line[3:].strip().lower()
            current = name if name in sections else None
            continue
        if current:
            sections[current].append(line)
    if not title:
        raise CardError("card has no '# Title' line")
    if not "\n".join(sections["instruction"]).strip():
        raise CardError("card has no '## Instruction' section")
    pastes = []
    for line in sections["paste"]:
        line = line.strip()
        if not line.startswith("- ") or line[2:].strip().startswith("("):
            continue  # not a list item, or a note like "(no extra files)"
        pastes.append(parse_paste_line(line[2:].strip()))
    return {
        "title": title,
        "pastes": pastes,
        "excerpts": "\n".join(sections["excerpts"]).strip(),
        "facts": "\n".join(sections["key facts"]).strip(),
        "instruction": "\n".join(sections["instruction"]).strip(),
    }


def parse_paste_line(item):
    """'path [lines 10-40, 90-120] [(optional)]' -> dict."""
    item = item.replace("`", "")
    optional = "(optional)" in item
    item = item.replace("(optional)", "").strip()
    ranges = []
    m = re.search(r"\blines?\s+([0-9,\-\s]+)$", item)
    if m:
        for part in m.group(1).split(","):
            part = part.strip()
            if not part:
                continue
            if "-" in part:
                a, b = part.split("-", 1)
                ranges.append((int(a), int(b)))
            else:
                ranges.append((int(part), int(part)))
        item = item[: m.start()].strip()
    path = item.split()[0] if item else ""
    if not path:
        raise CardError("empty Paste entry")
    return {"path": path, "ranges": ranges, "optional": optional}


def cut_lines(text, ranges, path):
    """Keep the unnumbered header plus Script Editor lines NNN in the ranges.

    Unnumbered lines after 001 (v9.01 additions) are kept when they sit between
    two numbered lines that are both kept, so a pasted range shows the real code.
    """
    def in_range(n):
        for i, (a, b) in enumerate(ranges):
            if a <= n <= b:
                return i
        return None

    out = []
    seen_numbered = False
    found = set()
    last_kept = None
    pending = []  # unnumbered lines since the last numbered line
    prev_kept = False
    prev_range = None
    for line in text.split("\n"):
        m = re.match(r"^(\d{3,4})\s", line)
        if not m:
            if not seen_numbered:
                out.append(line)  # header lines before 001
            else:
                pending.append(line)
            continue
        seen_numbered = True
        n = int(m.group(1))
        i = in_range(n)
        if i is not None:
            if prev_kept and i == prev_range:
                if n != last_kept + 1:
                    out.append("... (v8 lines %03d-%03d were deleted in v9.01) ..." % (last_kept + 1, n - 1))
                out.extend(pending)  # v9.01 lines inside the range
            elif last_kept is not None and n != last_kept + 1:
                out.append("... (lines %03d-%03d not included) ..." % (last_kept + 1, n - 1))
            elif last_kept is None and n > 1:
                out.append("... (lines 001-%03d not included) ..." % (n - 1))
            out.append(line)
            last_kept = n
            found.add(i)
        prev_kept = i is not None
        prev_range = i
        pending = []
    missing = [ranges[i] for i in range(len(ranges)) if i not in found]
    if missing:
        raise CardError("%s: line range(s) %s not found" % (path, missing))
    out.append("... (rest of script not included) ...")
    return "\n".join(out)


def build(card_path):
    card = parse_card(card_path)
    notes = []
    parts = []
    parts.append("===== CORE RULES (read first) =====\n" + read_text(CORE).strip())
    parts.append("===== TASK: %s =====" % card["title"])
    if card["excerpts"]:
        parts.append("===== BACKGROUND (excerpts from the FDN docs) =====\n" + card["excerpts"])
    for p in card["pastes"]:
        full = os.path.join(ROOT, p["path"])
        if not os.path.isfile(full):
            if p["optional"]:
                notes.append("note: optional file not found, skipped: %s" % p["path"])
                continue
            raise CardError("file not found: %s" % p["path"])
        body = read_text(p["path"]).strip("\n")
        label = p["path"]
        if p["ranges"]:
            body = cut_lines(body, p["ranges"], p["path"])
            label += " (only lines %s)" % ", ".join("%03d-%03d" % r for r in p["ranges"])
        parts.append("===== FILE: %s =====\n%s\n===== END FILE: %s =====" % (label, body, p["path"]))
    if card["facts"]:
        parts.append("===== KEY FACTS (repeated here so you do not have to search) =====\n" + card["facts"])
    parts.append("===== YOUR TASK (do exactly this) =====\n" + card["instruction"])
    text = "\n\n".join(parts) + "\n"
    return card, text, notes


def stamp(card_path, tokens):
    full = os.path.join(ROOT, card_path)
    text = read_text(card_path)
    new_line = "- Estimated size: ~{:,} tokens when built".format(tokens)
    text2, n = re.subn(r"^- Estimated size:.*$", new_line, text, count=1, flags=re.M)
    if n and text2 != text:
        with open(full, "w", encoding="utf-8", newline="\n") as fh:
            fh.write(text2)


def rel(path):
    full = os.path.abspath(path)
    try:
        return os.path.relpath(full, ROOT)
    except ValueError:  # Windows: different drive letter
        return full


def default_out(card_path):
    stem = os.path.splitext(os.path.basename(card_path))[0]
    return os.path.join("prompts", stem + ".txt")


def do_one(card_path, out_path, force, do_stamp, quiet=False):
    card, text, notes = build(card_path)
    tokens = estimate(text)
    status = "ok"
    if tokens > MAX_TOKENS and not force:
        status = "REFUSED"
    elif tokens > WARN_TOKENS:
        status = "WARN"
    if status != "REFUSED":
        out_full = os.path.join(ROOT, out_path)
        os.makedirs(os.path.dirname(out_full), exist_ok=True)
        with open(out_full, "w", encoding="utf-8") as fh:
            fh.write(text)
    if do_stamp:
        stamp(card_path, tokens)
    if not quiet:
        for n in notes:
            print(n)
        print("Card:   %s" % card["title"])
        print("Tokens: ~{:,} (estimate = characters / 3.5)".format(tokens))
        if status == "REFUSED":
            print("REFUSED: over {:,} tokens. Split the card, or add --force.".format(MAX_TOKENS))
        else:
            if status == "WARN":
                print("WARNING: over {:,} tokens. The local model is less reliable this long;"
                      " consider splitting this card.".format(WARN_TOKENS))
            print("Wrote:  %s  (open it, select all, paste into the AI chat)" % out_path)
    return status, tokens, notes


def main():
    ap = argparse.ArgumentParser(description="Build a paste-ready local-AI prompt from a task card.")
    ap.add_argument("card", nargs="?", help="docs/tasks/<card>.md")
    ap.add_argument("--out", help="output file (default prompts/<card>.txt)")
    ap.add_argument("--force", action="store_true", help="build even if over 32k tokens")
    ap.add_argument("--all", action="store_true", help="build every card in docs/tasks")
    ap.add_argument("--stamp", action="store_true", help="write the token estimate into the card")
    args = ap.parse_args()

    if args.all:
        cards = sorted(f for f in os.listdir(os.path.join(ROOT, TASKS))
                       if f.endswith(".md") and f.lower() != "readme.md")
        worst = 0
        for f in cards:
            cp = os.path.join(TASKS, f)
            try:
                status, tokens, notes = do_one(cp, default_out(cp), args.force, args.stamp, quiet=True)
            except CardError as e:
                print("%-45s ERROR  %s" % (f, e))
                worst = max(worst, 2)
                continue
            extra = ("  (" + "; ".join(n.replace("note: ", "") for n in notes) + ")") if notes else ""
            print("%-45s %7s  %s%s" % (f, "{:,}".format(tokens), status, extra))
            if status == "WARN":
                worst = max(worst, 1)
            if status == "REFUSED":
                worst = max(worst, 2)
        return worst

    if not args.card:
        ap.print_help()
        return 2
    card_path = rel(args.card)
    out_path = rel(args.out) if args.out else default_out(card_path)
    try:
        status, _, _ = do_one(card_path, out_path, args.force, args.stamp)
    except CardError as e:
        print("ERROR: %s" % e)
        return 2
    return 2 if status == "REFUSED" else 0


if __name__ == "__main__":
    sys.exit(main())
