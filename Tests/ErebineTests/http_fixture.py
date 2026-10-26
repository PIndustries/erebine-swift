#!/usr/bin/env python3
"""Deterministic loopback-only fixture server. Never contacts Erebine."""
import argparse,json,socketserver,threading,time
from http.server import BaseHTTPRequestHandler,ThreadingHTTPServer
class Handler(BaseHTTPRequestHandler):
 protocol_version='HTTP/1.1'
 def log_message(self,*args): pass
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
