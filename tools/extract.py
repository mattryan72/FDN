import sys,os,re,glob,json
import xml.etree.ElementTree as ET
def text_of(el):
    return ''.join(el.itertext())
def extract(path):
    t=ET.parse(path).getroot()
    d={'file':os.path.basename(path),'name':t.findtext('name'),'version':t.findtext('version'),
       'engine':t.findtext('engineversion'),'desc':t.findtext('description'),'args':[]}
    a=t.find('arguments')
    if a is not None:
        for arg in a:
            d['args'].append(dict(arg.attrib))
    lines=[]
    st=t.find('sourcetext')
    for ln in st.findall('line'):
        ind=ln.get('indent','').replace('\xa0',' ')
        lines.append((ln.get('linenr'),ind+text_of(ln).replace('\xa0',' ').rstrip()))
    d['lines']=lines
    return d
if __name__=='__main__':
    src,out=sys.argv[1],sys.argv[2]
    os.makedirs(out,exist_ok=True)
    allj=[]
    for f in sorted(glob.glob(src+'/*.xml')):
        d=extract(f)
        with open(os.path.join(out,d['name']+'.txt'),'w') as fh:
            fh.write(f"* Script: {d['name']}  (v{d['version']}, engine {d['engine']})\n* Desc: {d['desc']}\n")
            for a in d['args']: fh.write(f"* Arg {a.get('index')}: {a.get('name')} ({a.get('type')}) '{a.get('desc')}'\n")
            fh.write('\n')
            for n,l in d['lines']: fh.write(f"{n}  {l}\n")
        allj.append(d)
    json.dump(allj,open(os.path.join(out,'_all.json'),'w'),indent=0)
