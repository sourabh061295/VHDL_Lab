#!/usr/bin/python3
import json, sys

if len(sys.argv) < 2:
  sys.exit(0)
filename = sys.argv[1]
with open(filename + '.json','r') as file:
    data_in = json.loads(file.read()) 
file.close()    
data_out = {}
data_out['modules'] = {}
top_module = data_in['modules'][filename]
data_out['modules'][filename] = top_module 
with open(filename + '.json', 'w') as file:
    json.dump(data_out, file)