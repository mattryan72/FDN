#!/usr/bin/env python3
"""Read-only checker for FDN MSCI readable source.

Usage (from the repo folder):
    python tools/check_source.py                      # all source_readable/*.txt
    python tools/check_source.py source_readable/lib.LI.FDN.Cfg.Get.txt

Checks: BOM, non-ASCII, CRLF, XTESTMARK, banned MSCI forms, block balance
(if + while == end), return inside a gosub sub. It never changes a file.
Calls inside conditions need a manual check. Exit code 1 if any FAIL.
"""
import glob, re, sys

def check(path):
    out = []
    raw = open(path, 'rb').read()
    if raw.startswith(b'\xef\xbb\xbf'):
        out.append('FAIL BOM present')
    try:
        raw.decode('ascii')
    except UnicodeDecodeError:
        out.append('FAIL non-ASCII characters')
    lf_only = raw.count(b'\n') - raw.count(b'\r\n')
    if lf_only:
        out.append('FAIL %d line(s) without CRLF' % lf_only)
    text = raw.decode('ascii', 'replace')
    lines = text.replace('\r\n', '\n').split('\n')
    ifs = whiles = ends = 0
    in_sub = False
    targets = set(re.findall(r'^\s*gosub\s+([\w.]+:)', text, re.M))
    for n, line in enumerate(lines, 1):
        s = line.strip()
        if 'XTESTMARK' in line:
            out.append('FAIL %d: XTESTMARK left in file' % n)
        if not s or s.startswith('*'):
            continue
        code = re.sub(r"'[^']*'", "''", s)  # ignore quoted strings
        if re.search(r'&&|\|\|', code):
            out.append('FAIL %d: && or || : %s' % (n, s))
        if '!=' in code:
            out.append('FAIL %d: != : %s' % (n, s))
        if re.search(r'\bAND\b|\bOR\b', code):
            out.append('WARN %d: AND/OR (check it is not a command word): %s' % (n, s))
        if re.search(r'\$[\w.]+\s*(\+\+|--)', code):
            out.append('FAIL %d: ++/-- (use inc/dec): %s' % (n, s))
        if re.match(r'\$null\s*=', code):
            out.append('FAIL %d: $null = : %s' % (n, s))
        if re.match(r'(break|continue)\b', code):
            out.append('FAIL %d: break/continue : %s' % (n, s))
        if re.match(r'(skip )?if\b', code, re.I) and not re.match(r'else', code, re.I) and re.match(r'if\b', code):
            ifs += 1
        elif re.match(r'while\b', code):
            whiles += 1
        elif re.match(r'end\s*$', code):
            ends += 1
        if re.match(r'[\w.]+:\s*$', code) and code.strip() in targets:
            in_sub = True
        elif re.match(r'endsub\b', code):
            in_sub = False
        elif in_sub and re.match(r'return\b', code):
            out.append('FAIL %d: return inside gosub sub : %s' % (n, s))
    bal = 'if=%d while=%d end=%d' % (ifs, whiles, ends)
    if ifs + whiles != ends:
        out.append('FAIL block balance: ' + bal)
    return bal, len(lines) - (1 if lines and lines[-1] == '' else 0), out

def main():
    files = sys.argv[1:] or sorted(glob.glob('source_readable/*.txt'))
    bad = 0
    for f in files:
        try:
            bal, nlines, out = check(f)
        except OSError as e:
            print('%s: cannot read (%s)' % (f, e)); bad += 1; continue
        fails = [o for o in out if o.startswith('FAIL')]
        status = 'FAIL' if fails else ('WARN' if out else 'OK')
        print('%s: %s  lines=%d  %s' % (f, status, nlines, bal))
        for o in out:
            print('    ' + o)
        bad += bool(fails)
    print('checked %d file(s), %d with FAIL' % (len(files), bad))
    print('Reminder: calls/array elements inside conditions are not checked.')
    return 1 if bad else 0

if __name__ == '__main__':
    sys.exit(main())