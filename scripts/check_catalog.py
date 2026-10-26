#!/usr/bin/env python3
"""Validate the reviewed public contract inventory without credentials or network."""
import base64,hashlib,json,re
from pathlib import Path
root=Path(__file__).resolve().parent.parent
load=lambda name:json.loads((root/'api'/name).read_text())
ops=load('operations.json')['operations'];by_name={op['name']:op for op in ops}
assert len(by_name)==len(ops),'duplicate operation name'
shapes=set()
for op in ops:
 assert op['method'] in ['GET','POST','PUT','PATCH','DELETE','HEAD','OPTIONS']
 assert op['surface'] in ['router','dashboard']
 assert re.findall(r'\{([^}]+)\}',op['path'])==op['parameters'],op['name']
 assert len(op['parameters'])==len(set(op['parameters'])),op['name']
 assert op['sources'] and all(u.startswith(('https://erebine.ai/docs/','https://github.com/erebine/binaries/','https://modelcontextprotocol.io/')) for u in op['sources'])
 shape=(op['method'],re.sub(r'\{[^}]+\}','{}',op['path']))
 assert shape not in shapes,op['name']
 shapes.add(shape)
fixtures=load('cli-contracts.json')['requests']
for fixture in fixtures:
 op=by_name[fixture['operation']]
 assert set(fixture['parameters'])==set(op['parameters']),fixture['command']
 raw=base64.b64decode(fixture['body_base64'],validate=True)
 checksum=fixture.get('headers',{}).get('x-chunk-checksum')
 if checksum:assert hashlib.sha256(raw).hexdigest()==checksum,fixture['command']
 if fixture['body_json'] is not None:assert json.loads(raw)==fixture['body_json']
 assert all(k.lower() not in ['authorization','cookie','set-cookie','x-csrf-token'] for k in fixture.get('headers',{}))
refs=load('reference-audit.json')['references']
for ref in refs:
 assert ref['status'] in ['bound','workspace_endpoint_routing','excluded_asset']
 if ref['status']!='excluded_asset':assert ref['operation'] in by_name
for command in load('cli-command-audit.json')['commands']:
 assert command['status'] in ['captured','local_only','command_group']
 if command['status']=='captured':
  assert command['operations']
  assert all(name in by_name for name in command['operations'])
print(f'{len(ops)} bindings, {len(fixtures)} CLI request fixtures, {len(refs)} reviewed HTTP references: valid')

for path in (root/'api').glob('*.json'):
 text=path.read_text()
 assert not re.search(r'ere_mgmt_[A-Za-z0-9_-]{30,}',text),'credential-shaped value in public fixtures'
