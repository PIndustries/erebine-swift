#!/usr/bin/env python3
"""Regression checks for the opt-in live validators, using fake loopback HTTP only."""
import argparse,json,os,subprocess,tempfile,threading
from http.server import BaseHTTPRequestHandler,ThreadingHTTPServer
from pathlib import Path
parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--sdk',choices=['rust','swift'],required=True);args=parser.parse_args();root=Path(__file__).resolve().parent.parent
if args.sdk=='rust':
 subprocess.run(['cargo','build','--examples','--locked'],cwd=root,check=True)
 target=Path(json.loads(subprocess.check_output(['cargo','metadata','--format-version','1','--no-deps'],cwd=root,text=True))['target_directory']);folder=target/'debug/examples';worker=folder/('worker_inference_smoke'+('.exe' if os.name=='nt' else ''));manager=folder/('management_smoke'+('.exe' if os.name=='nt' else ''))
else:
 for product in ['ErebineWorkerInferenceSmoke','ErebineManagementSmoke']:subprocess.run(['swift','build','--product',product],cwd=root,check=True)
 folder=Path(subprocess.check_output(['swift','build','--show-bin-path'],cwd=root,text=True).strip());worker=folder/'ErebineWorkerInferenceSmoke';manager=folder/'ErebineManagementSmoke'
class Fixture(BaseHTTPRequestHandler):
 def log_message(self,*args):pass
 def send_json(self,value,status=200):
  data=json.dumps(value).encode();self.send_response(status);self.send_header('Content-Type','application/json');self.send_header('Content-Length',str(len(data)));self.end_headers();self.wfile.write(data)
 def stream(self,events):
  data=''.join('event: '+kind+'\ndata: '+json.dumps(value)+'\n\n' for kind,value in events).encode();self.send_response(200);self.send_header('Content-Type','text/event-stream');self.send_header('Content-Length',str(len(data)));self.end_headers();self.wfile.write(data)
 def response(self,rid='resp-parent',previous=None):
  return {'id':rid,'status':'completed','output':[{'id':'message-fixture','type':'message','role':'assistant','content':[{'type':'output_text','text':'ok'}],'status':'completed'}],'usage':{'input_tokens':1,'output_tokens':1,'total_tokens':2},'error':None,'previous_response_id':previous}
 def route(self):
  path=self.path.split('?')[0];body=json.loads(self.rfile.read(int(self.headers.get('Content-Length','0'))) or '{}');method=self.command;profile=self.server.profile
  if path=='/__management/config':return self.send_json({'project_id':'proj_fixture','prefix':'sdk-fixture','model_id':'model_fixture','endpoint_slug':'endpoint_fixture','endpoint_id':'endpoint_fixture'})
  if path.endswith('/v1/workspaces'):return self.send_json({'id':'workspace_fixture'},201)
  if path.endswith('/v1/chats'):return self.send_json({'id':'chat_fixture','workspace_id':'workspace_fixture'},201)
  if path.endswith('/v1/models'):return self.send_json({'data':[{'id':'model_fixture'}]})
  if path.endswith('/v1/settings/project'):return self.send_json({'tokens':0 if profile=='minimum-fails' else 2})
  if '/v1/chat/completions' in path:
   if method=='DELETE':return self.send_json({'deleted':True})
   if path.endswith('/messages'):return self.send_json({'data':[{'role':'user','content':'fixture'}]})
   empty=profile=='empty-chat' and not body.get('stream');content=None if empty else 'ok';tokens=0 if empty else 1
   if body.get('stream'):
    empty=profile=='empty-chat-stream';content='' if empty else 'ok';tokens=0 if empty else 1
    return self.stream([('message',{'id':'chatcmpl-fixture','choices':[{'index':0,'delta':{'content':content},'finish_reason':None}]}),('message',{'id':'chatcmpl-fixture','choices':[{'index':0,'delta':{},'finish_reason':'stop'}],'usage':{'completion_tokens':tokens}})])
   return self.send_json({'id':'chatcmpl-fixture','choices':[{'message':{'role':'assistant','content':content}}],'usage':{'completion_tokens':tokens}})
  if '/v1/responses' in path:
   tail=path.split('/v1/responses',1)[1]
   if tail.endswith('/cancel'):
    self.server.cancelled=True;return self.send_json({'id':'resp-background','status':'cancelled'})
   if tail.endswith('/input_items'):return self.send_json({'data':[{'role':'user','content':[{'type':'input_text','text':'fixture'}]}]})
   if method=='DELETE':
    rid=tail.lstrip('/');self.server.deleted.add(rid)
    if rid=='resp-background':return self.send_json({'error':{'code':'not_found'}},404)
    return self.send_json({'deleted':True})
   if method=='GET':
    if not tail:return self.send_json({'data':[self.response()]})
    rid=tail.lstrip('/')
    if rid in self.server.deleted:return self.send_json({'error':{'code':'not_found'}},404)
    if rid=='resp-background':return self.send_json({'id':rid,'status':'cancelled' if self.server.cancelled else 'queued'})
    return self.send_json(self.response(rid))
   if body.get('background'):return self.send_json({'id':'resp-background','status':'queued'})
   if body.get('stream'):
    start=('response.created',{'type':'response.created','response':{'status':'in_progress'}})
    if profile=='missing-terminal':return self.stream([start])
    result=self.response();kind='response.completed'
    if profile=='empty-response-stream':result['output']=[];result['usage']['output_tokens']=0
    if profile=='failed-response-stream':kind='response.failed';result['status']='failed';result['error']={'code':'fixture_error'}
    return self.stream([start,(kind,{'type':kind,'response':result})])
   return self.send_json(self.response('resp-child' if body.get('previous_response_id') else 'resp-parent',body.get('previous_response_id')))
  return self.send_json({'error':{'code':'fixture_route_missing'}},404)
 do_GET=do_POST=do_DELETE=do_PATCH=do_PUT=route
profiles={'valid':None,'empty-chat':'real CPU chat completion','empty-chat-stream':'real CPU chat SSE and native assembly','empty-response-stream':'real CPU Responses SSE terminal snapshot and usage','failed-response-stream':'real CPU Responses SSE terminal snapshot and usage','missing-terminal':'real CPU Responses SSE terminal snapshot and usage'}
server=ThreadingHTTPServer(('127.0.0.1',0),Fixture);threading.Thread(target=server.serve_forever,daemon=True).start();env={**os.environ,'EREBINE_MANAGEMENT_PROXY':'http://127.0.0.1:'+str(server.server_port),'EREBINE_WORKER_INFERENCE_MODE':'all'}
try:
 for profile,failed_name in profiles.items():
  server.profile=profile;server.deleted=set();server.cancelled=False
  run=subprocess.run([str(worker)],cwd=root,env=env,capture_output=True,text=True,timeout=45);report=json.loads(run.stdout)
  if failed_name is None:assert run.returncode==0 and report['completed'],(profile,report)
  else:
   assert run.returncode!=0 and not report['completed'],(profile,report)
   assert any(x['name']==failed_name and x['result']=='response_contract_failed' for x in report['checks']),(profile,report)
 with tempfile.TemporaryDirectory() as directory:
  path=Path(directory)/'scenario.json';path.write_text(json.dumps({'steps':[{'name':'positive output tokens','operation':'get_project_id_v1_settings_project','parameters':{'project_id':'${project_id}'},'min_numbers':{'/tokens':1}}]}));env['EREBINE_MANAGEMENT_SCENARIOS']=str(path)
  for profile,expected in [('minimum-passes',0),('minimum-fails',1)]:
   server.profile=profile;run=subprocess.run([str(manager)],cwd=root,env=env,capture_output=True,text=True,timeout=30);report=json.loads(run.stdout);assert (run.returncode!=0)==bool(expected),(profile,report)
 print(json.dumps({'sdk':args.sdk,'worker_profiles':len(profiles),'minimum_assertion_profiles':2,'passed':True}))
finally:server.shutdown();server.server_close()
