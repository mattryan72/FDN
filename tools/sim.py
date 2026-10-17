import json,re,difflib,collections,itertools
D=json.load(open('src804/_all.json'))
def norm(l):
    s=l.strip()
    if not s or s.startswith('*'): return None
    s=re.sub(r'\s+',' ',s)
    return s
code={d['name']:[(n,norm(l)) for n,l in d['lines'] if norm(l)] for d in D}
# pairwise similarity
names=sorted(code)
res=[]
for a,b in itertools.combinations(names,2):
    A=[x[1] for x in code[a]];B=[x[1] for x in code[b]]
    r=difflib.SequenceMatcher(None,A,B,autojunk=False).ratio()
    if r>0.35: res.append((r,a,b))
for r,a,b in sorted(res,reverse=True): print(f"{r:.2f} {a} <-> {b}")
# shingles of 5 lines across scripts
K=5
sh=collections.defaultdict(set)
for nm,L in code.items():
    for i in range(len(L)-K+1):
        key=tuple(x[1] for x in L[i:i+K])
        sh[key].add((nm,L[i][0]))
print('\n== repeated 5-line blocks across >=3 scripts ==')
seen=collections.Counter()
for key,locs in sh.items():
    scr={l[0] for l in locs}
    if len(scr)>=3:
        seen[key[0][:60]]+=1
top=sorted(((len({l[0] for l in v}),k,v) for k,v in sh.items() if len({l[0] for l in v})>=3),reverse=True)
printed=set()
for n,k,v in top[:400]:
    if k[0] in printed: continue
    printed.add(k[0])
    print(n, '|', ' / '.join(k)[:150])
