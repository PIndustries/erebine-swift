#!/usr/bin/env python3
"""Opt-in native SDK smoke test via SSH; account secrets remain on the SSH host."""
import argparse,os,pathlib,random,shlex,socket,subprocess,sys
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--ssh-host',required=True)
p.add_argument('--opencode-config',required=True,help='Remote path containing the Erebine provider configuration')
p.add_argument('--model',required=True,help='Model ID from that direct routing base')
p.add_argument('--embedding-model')
p.add_argument('--rerank-model')
p.add_argument('--transcription-model')
p.add_argument('--mcp-only',action='store_true',help='Only discover MCP tools; do not generate model output')
p.add_argument('--sudo',action='store_true',help='Read remote configuration with non-interactive sudo')
args=p.parse_args();root=pathlib.Path(__file__).resolve().parent.parent
if args.ssh_host.startswith('-'):p.error('SSH host cannot start with a dash')
with socket.socket() as s:
 s.bind(('127.0.0.1',0));local_port=s.getsockname()[1]
remote_port=random.SystemRandom().randint(35000,60000)
source=(root/'scripts/live_proxy.py').read_text()
remote=(['sudo','-n'] if args.sudo else [])+['python3','-u','-c',source,'--config',args.opencode_config,'--model',args.model,'--port',str(remote_port)]
for flag in ['embedding_model','rerank_model','transcription_model']:
 value=getattr(args,flag)
 if value:remote+=['--'+flag.replace('_','-'),value]
command=['ssh','-o','BatchMode=yes','-o','ExitOnForwardFailure=yes','-L',f'127.0.0.1:{local_port}:127.0.0.1:{remote_port}',args.ssh_host,shlex.join(remote)]
ssh=subprocess.Popen(command,stdin=subprocess.PIPE,stdout=subprocess.PIPE,text=True)
try:
 if ssh.stdout.readline().strip()!='VALIDATION_PROXY_READY':raise SystemExit('Remote validation proxy did not start')
 env=os.environ.copy();env['EREBINE_VALIDATION_ORIGIN']=f'http://127.0.0.1:{local_port}'
 if args.mcp_only:env['EREBINE_VALIDATION_MCP_ONLY']='1'
 else:env.pop('EREBINE_VALIDATION_MCP_ONLY',None)
 native=['cargo','run','--example','live_smoke'] if (root/'Cargo.toml').exists() else ['swift','run','ErebineLiveSmoke']
 result=subprocess.run(native,cwd=root,env=env)
 sys.exit(result.returncode)
finally:
 ssh.stdin.close()
 try:ssh.wait(timeout=15)
 except subprocess.TimeoutExpired:ssh.terminate();ssh.wait(timeout=5)
