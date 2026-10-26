# Remote-only ephemeral authentication proxy for scripts/validate_live.py.
import json,urllib.request,urllib.error,socketserver,argparse,sys,threading
from http.server import BaseHTTPRequestHandler,ThreadingHTTPServer
from urllib.parse import urlsplit
parser=argparse.ArgumentParser()
parser.add_argument('--config',required=True);parser.add_argument('--model',required=True);parser.add_argument('--port',required=True,type=int)
args=parser.parse_args()
cfg=json.load(open(args.config))['provider']['erebine']['options']
base=urlsplit(cfg['baseURL']);parts=base.path.strip('/').split('/');project,workspace=parts[:2]
if len(parts)!=4 or parts[2:]!=['_direct','v1']:raise SystemExit('Validation requires a workspace-scoped direct base URL')
class Handler(BaseHTTPRequestHandler):
 protocol_version='HTTP/1.1'
 def log_message(self,*args):pass
 def handle_api(self):
  if self.command=='GET' and self.path=='/__validation/config':
   raw=json.dumps({'project':project,'workspace':workspace,'model':args.model}).encode();status=200;headers={'Content-Type':'application/json'}
  else:
   allowed_get=self.command=='GET' and (self.path.startswith(base.path+'/models') or self.path==base.path+'/provider-manifest')
   mcp_path='/'+project+'/v1/mcp'
   is_mcp=self.path==mcp_path
   allowed_post=self.command in ['POST','DELETE'] and (self.path in [base.path+'/chat/completions',base.path+'/responses'] or is_mcp)
   if not (allowed_get or allowed_post):self.send_error(403);return
   body=self.rfile.read(int(self.headers.get('Content-Length','0'))) if self.command=='POST' else None
   if body and not is_mcp:
    obj=json.loads(body)
    if obj.get('model')!=args.model or obj.get('tools') or obj.get('store') is not False or max(obj.get('max_tokens',0),obj.get('max_output_tokens',0))>128:
     self.send_error(400);return
   if body and is_mcp and json.loads(body).get('method') not in ['initialize','notifications/initialized','tools/list','resources/list','prompts/list','ping']:
    self.send_error(403);return
   headers={k:v for k,v in self.headers.items() if k.lower() in ['content-type','accept','x-erebine-vendor-events','mcp-session-id','mcp-protocol-version']}
   headers['Authorization']='Bearer '+cfg['apiKey']
   try:r=urllib.request.urlopen(urllib.request.Request('https://api.erebine.ai'+self.path,data=body,headers=headers,method=self.command),timeout=90)
   except urllib.error.HTTPError as e:r=e
   status=r.status;headers=dict(r.headers)
   stream='text/event-stream' in r.headers.get('Content-Type','')
   if stream:
    self.send_response(status)
    for k,v in headers.items():
     if k.lower() in ['content-type','x-request-id','x-erebine-routed-model','mcp-session-id']:self.send_header(k,v)
    self.send_header('Connection','close');self.end_headers();self.close_connection=True
    try:
     while True:
      line=r.readline()
      if not line:break
      self.wfile.write(line);self.wfile.flush()
    except (BrokenPipeError,ConnectionResetError):pass
    finally:r.close()
    return
   raw=r.read();r.close()
  self.send_response(status)
  for k,v in headers.items():
   if k.lower() in ['content-type','x-request-id','x-erebine-routed-model','mcp-session-id']:self.send_header(k,v)
  self.send_header('Content-Length',str(len(raw)));self.end_headers();self.wfile.write(raw)
 do_GET=handle_api;do_POST=handle_api;do_DELETE=handle_api
class Server(ThreadingHTTPServer):
 def server_bind(self):
  socketserver.TCPServer.server_bind(self);self.server_name='localhost';self.server_port=self.server_address[1]
server=Server(('127.0.0.1',args.port),Handler)
print('VALIDATION_PROXY_READY',flush=True)
def watch_input():
 # Closing the SSH input stream always shuts down the temporary remote proxy.
 sys.stdin.buffer.read()
 server.shutdown()
threading.Thread(target=watch_input,daemon=True).start()
try:server.serve_forever()
finally:server.server_close()
