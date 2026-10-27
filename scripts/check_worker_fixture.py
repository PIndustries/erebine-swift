#!/usr/bin/env python3
"""Check local metadata for the opt-in CPU worker smoke fixture. No network/weights."""
import argparse,json
from pathlib import Path
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('directory',type=Path)
parser.add_argument('--tool-parser',choices=['llama3_json','none'],default='llama3_json')
parser.add_argument('--context-tokens',type=int,default=256)
args=parser.parse_args()
try:
 config=json.loads((args.directory/'config.json').read_text())
 tokenizer=json.loads((args.directory/'tokenizer.json').read_text())
 vocab=tokenizer.get('model',{}).get('vocab',{})
 tokens=set(vocab) if isinstance(vocab,dict) else set()
 tokens.update(item['content'] for item in tokenizer.get('added_tokens',[]) if 'content' in item)
 required=['<|python_tag|>'] if args.tool_parser=='llama3_json' else []
 missing=[token for token in required if token not in tokens]
 max_context=config.get('max_position_embeddings',0)
 valid_context=0<args.context_tokens<=max_context
 result={'metadata_valid':True,'tool_parser':args.tool_parser,'missing_required_tokens':missing,'context_valid':valid_context,'head_dim':config.get('head_dim'),'architecture':config.get('architectures'),'passed':not missing and valid_context}
except (OSError,ValueError,TypeError,KeyError):
 result={'metadata_valid':False,'passed':False}
print(json.dumps(result))
raise SystemExit(0 if result['passed'] else 1)
