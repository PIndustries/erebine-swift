#!/usr/bin/env python3
"""Deterministic loopback-only fixture server. Never contacts Erebine."""
import argparse,json,socketserver,threading,time,base64,hashlib,struct
from http.server import BaseHTTPRequestHandler,ThreadingHTTPServer
class Handler(BaseHTTPRequestHandler):
 protocol_version='HTTP/1.1'
 def log_message(self,*args): pass
 def websocket(self):
  key=self.headers.get('Sec-WebSocket-Key','')
  accept=base64.b64encode(hashlib.sha1((key+'258EAFA5-E914-47DA-95CA-C5AB0DC85B11').encode()).digest()).decode()
  self.send_response(101);self.send_header('Upgrade','websocket');self.send_header('Connection','Upgrade');self.send_header('Sec-WebSocket-Accept',accept);self.send_header('X-Fixture-Authorization',self.headers.get('Authorization',''));self.end_headers()
  self.close_connection=True;self.connection.settimeout(10)
  def frame(op,payload):
   header=bytes([128|op,len(payload)]) if len(payload)<126 else bytes([128|op,126])+struct.pack('!H',len(payload))
   self.wfile.write(header+payload);self.wfile.flush()
  def event(obj):frame(1,json.dumps(obj).encode())
  try:
   while True:
    h=self.rfile.read(2)
    if len(h)!=2:break
    opcode=h[0]&15;length=h[1]&127
    if length==126:length=struct.unpack('!H',self.rfile.read(2))[0]
    elif length==127:length=struct.unpack('!Q',self.rfile.read(8))[0]
    mask=self.rfile.read(4) if h[1]&128 else None
    payload=self.rfile.read(length)
    if mask:payload=bytes(b^mask[i%4] for i,b in enumerate(payload))
    if opcode==8:frame(8,payload);break
    if opcode==9:frame(10,payload);continue
    if opcode==10:continue
    if opcode!=1:frame(opcode,payload);continue
    obj=json.loads(payload)
    if obj.get('type')=='session.update':event({'type':'session.updated','session':obj.get('session')})
    elif obj.get('type')=='input_audio_buffer.append':event({'type':'fixture.audio_received','bytes':len(base64.b64decode(obj['audio']))})
    elif obj.get('type')=='input_audio_buffer.commit':
     event({'type':'conversation.item.input_audio_transcription.delta','delta':'héllo '})
     event({'type':'conversation.item.input_audio_transcription.completed','transcript':'héllo 🌎'})
    else:event({'type':'fixture.echo','payload':obj})
  except (OSError,ValueError):pass
 def handle_request(self):
  n=int(self.headers.get('Content-Length','0'));body=self.rfile.read(n)
  if self.headers.get('Transfer-Encoding','').lower()=='chunked':
   body=b''
   while True:
    size=int(self.rfile.readline().split(b';')[0],16)
    if size==0:
     while self.rfile.readline().strip():pass
     break
    body+=self.rfile.read(size);self.rfile.read(2)
  path=self.path.split('?')[0]
  if path.endswith('/v1/realtime') and self.headers.get('Upgrade','').lower()=='websocket':self.websocket();return
  if body and self.headers.get('X-Fixture-Echo')!='1' and path.endswith(('/v1/chat/completions','/v1/responses','/v1/audio/speech')):
   obj=json.loads(body)
   if obj.get('stream') is True or obj.get('stream_format')=='sse':
    values=[{'fixture_request':obj,'fixture_path':self.path},
     {'id':'chat_fixture','choices':[{'index':0,'delta':{'role':'assistant','reasoning_content':'thinking'}}]},
     {'choices':[{'index':0,'delta':{'tool_calls':[{'index':0,'id':'call_fixture','type':'function','function':{'name':'echo','arguments':'{"a":'}}]}}]},
     {'choices':[{'index':0,'delta':{'tool_calls':[{'index':0,'function':{'arguments':'1}'}}]},'finish_reason':'tool_calls'}]},
     {'choices':[],'usage':{'total_tokens':5}}]
    data=b''.join(b'data: '+json.dumps(v).encode()+b'\n\n' for v in values)+b'data: [DONE]\n\n'
    self.send_response(200);self.send_header('Content-Type','text/event-stream');self.send_header('Content-Length',str(len(data)));self.end_headers();self.wfile.write(data);return
  if path.endswith('/v1/audio/speech') and self.headers.get('X-Fixture-Echo')!='1':
   data=b'RIFFfixtureWAVE';self.send_response(200);self.send_header('Content-Type','audio/wav');self.send_header('Content-Length',str(len(data)));self.end_headers();self.wfile.write(data);return
  if path.endswith('/v1/mcp'):
   if self.command=='DELETE':
    status,data,ct=204,b'','application/json'
   else:
    rpc=json.loads(body);method=rpc.get('method');rid=rpc.get('id')
    if method=='initialize':
     self.server.mcp_initialized=False
     result={'protocolVersion':'2025-06-18','capabilities':{'tools':{}}}
    else:
     if self.headers.get('Mcp-Session-Id')!='fixture-mcp' or self.headers.get('MCP-Protocol-Version')!='2025-06-18':self.send_error(400);return
     if method=='notifications/initialized':
      self.server.mcp_initialized=True
      self.send_response(202);self.send_header('Content-Length','0');self.end_headers();return
     if not getattr(self.server,'mcp_initialized',False):self.send_error(400);return
     result={'tools':[{'name':'fixture.echo','inputSchema':{'type':'object'}}]} if method=='tools/list' else {'content':[],'structuredContent':rpc.get('params',{}).get('arguments')}
    reply={'jsonrpc':'2.0','id':rid,'result':result}
    if method=='unknown':reply={'jsonrpc':'2.0','id':rid,'error':{'code':-32601,'message':'unknown method','x_vendor':True}}
    data=json.dumps(reply).encode();status=200;ct='application/json'
    if method=='initialize':data=b'event: message\ndata: '+data+b'\n\n';ct='text/event-stream'
   self.send_response(status);self.send_header('Content-Type',ct);self.send_header('Mcp-Session-Id','fixture-mcp');self.send_header('Content-Length',str(len(data)));self.end_headers();self.wfile.write(data);return
  if path=='/redirect':
   self.send_response(302);self.send_header('Location','/echo');self.send_header('Content-Length','0');self.end_headers();return
  if path=='/empty':status,data,ct=204,b'','application/json'
  elif path=='/binary':status,data,ct=200,bytes([0,255,10,128]),'application/octet-stream'
  elif path=='/error':status,data,ct=429,b'{"error":{"type":"future_vendor_error","message":"slow down","retry_after":3,"x_detail":true}}','application/json'
  elif path=='/stream':
   data=': heartbeat\r\nid: 42\r\nevent: x_reasoning\r\ndata: {"text":"héllo 🌎"}\r\n\r\nevent: response.completed\ndata: {"ok":true}\n\ndata: [DONE]\n\n'.encode()
   self.send_response(200);self.send_header('Content-Type','text/event-stream; charset=utf-8');self.send_header('X-Request-ID','fixture-stream');self.send_header('Content-Length',str(len(data)));self.end_headers()
   for b in data:
    try:self.wfile.write(bytes([b]));self.wfile.flush()
    except (BrokenPipeError,ConnectionResetError):break
   return
  else:
   status,data,ct=200,json.dumps({'method':self.command,'path':self.path,'headers':dict(self.headers),'body':body.decode('utf-8',errors='replace')}).encode(),'application/json'
  self.send_response(status);self.send_header('Content-Type',ct);self.send_header('X-Request-ID','fixture-request');self.send_header('Retry-After','3');self.send_header('Content-Length',str(len(data)));self.end_headers();self.wfile.write(data)
 do_GET=handle_request;do_POST=handle_request;do_PUT=handle_request;do_PATCH=handle_request;do_DELETE=handle_request
class FixtureServer(ThreadingHTTPServer):
 def server_bind(self):
  # HTTPServer calls getfqdn(), which may stall on CI macOS reverse DNS.
  # Loopback fixture identity is fixed and needs no hostname lookup.
  socketserver.TCPServer.server_bind(self)
  self.server_name='localhost'
  self.server_port=self.server_address[1]
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--port-file',required=True);args=p.parse_args()
 server=FixtureServer(('127.0.0.1',0),Handler)
 with open(args.port_file,'w') as f:f.write(str(server.server_port))
 server.serve_forever()
