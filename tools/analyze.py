import json,re,sys,collections
src=sys.argv[1]
D=json.load(open(src+'/_all.json'))
names={d['name'] for d in D}
inv=[]
for d in D:
    L=[l for n,l in d['lines']]
    code=[l.strip() for l in L if l.strip() and not l.strip().startswith('*')]
    txt='\n'.join(L)
    calls=re.findall(r'call script ([\w\.]+)',txt)
    starts=[c for l in L for c in re.findall(r'START\s+.*call script ([\w\.]+)',l)]
    gget=sorted(set(re.findall(r"get global variable: name=([\$\w\.']+)",txt)))
    gset=sorted(set(re.findall(r"set global variable: name=([\$\w\.']+)",txt)))
    lvar=sorted(set(re.findall(r"local variable: name=([\$\w\.']+)",txt)))
    tids=sorted(set(int(x) for x in re.findall(r'(?:id|textid)=(\d+)',txt)),key=int)
    settings=sorted(set(int(x) for x in re.findall(r'\$al\.Settings\[(\d+)\]',txt)))
    waits=len(re.findall(r'= wait',txt))
    whiles=len(re.findall(r'^\s*while ',txt,re.M))
    labels=re.findall(r'^\s*([\w\.]+):\s*$',txt,re.M)
    menus=len(re.findall(r'open custom (?:info )?menu',txt))
    inv.append(dict(name=d['name'],desc=d['desc'],version=d['version'],args=[a.get('name') for a in d['args']],
      lines=len(L),code=len(code),calls=sorted(set(calls)),starts=sorted(set(starts)),gget=gget,gset=gset,lvar=lvar,tids=tids,
      settings=settings,waits=waits,whiles=whiles,subs=labels,menus=menus))
json.dump(inv,open(src+'/_inv.json','w'),indent=1)
for i in inv:
    print(f"{i['name']}: L{i['lines']}/C{i['code']} args={i['args']} calls={i['calls']} START={i['starts']} S={i['settings']} waits={i['waits']} whiles={i['whiles']} subs={i['subs']} lvar={i['lvar']} glob={i['gget']}/{i['gset']} tids={i['tids']}")
