#!/usr/bin/python3

import os, sys
import subprocess
import argparse

parser = argparse.ArgumentParser(description = 'Synthesize a vhdl top module', 
                                 usage       = 'synthesize.py (b|s) module [-l library] [-p generic parameters] [-d] [-s]',
                                 formatter_class=argparse.RawTextHelpFormatter)
                 
parser.add_argument('type', metavar = 'action (b or s)', choices = ['b', 's', 't'], 
                    help = ('''b = Generate a block diagram only\ns = Logic Synthesis only\nt = Synthesis & Technology mapping'''))
parser.add_argument('top', metavar = 'module', type = str, 
                    help = 'top entity')                   
parser.add_argument('-l', metavar = 'library', dest='library', default = 'cmosa',
                    help = 'library for technology mapping, e.g. (350nm, 180nm, 130nm, 45nm)')
parser.add_argument('-p', metavar = 'parameter=value', dest='param',  
                    help = 'Name and value of the generic parameter, e.g. -p N=4,M=6')
parser.add_argument('-d', action='store_true', dest='dffmap',  
                    help = 'Mapping the D-FFs')    
parser.add_argument('-s', action='store_true', dest='show',  
                    help = 'show circuit')                                      
args= parser.parse_args() 

top = args.top

if os.path.exists("work"):
  os.system('rm -r work') 
os.system('mkdir work')  
memfiles = [_ for _ in os.listdir('.') if _.endswith('.mem')] 
print('copy ' + str(memfiles) + '-> work')
if len(memfiles) != 0:
  for i in memfiles:
    os.system('cp ' + i + ' work/') 
    
os.system('ghdl -i -g -Wno-hide -O3 -fsynopsys --std=08 --workdir=work *.vhd')
os.system('ghdl -m -g -Wno-hide -O3 -fsynopsys --std=08 --workdir=work ' + top)

#print(args.library)

if args.param != None: 
  pars = args.param.split(',')
  param=''
  for p in args.param.split(','):
    param += '-g' + p + ' '
else: 
  param = ''

labpath = '~/lab/' 

ghdl     = '\"ghdl --std=08 -fsynopsys ' + param + top + '; '
jsonfile = top + '.json '
json     = 'write_json ' + jsonfile + '; '
svgfile  = top + '.svg'
verilog  = 'write_verilog ' + top + '.v\" > work/synth.ys'
opt      = 'opt; stat; '
techmap  = 'techmap; opt; ' 
libpath  = labpath + 'lib/'
print(labpath,libpath)
if args.type == 't':
  library = libpath + args.library + '.lib; '
  stat    = 'stat -liberty ' + library
elif args.type == 'b':  
  library = libpath + 'cmosa.lib; '
  stat    = 'stat; '
elif args.type == 's':
  library = ' ' #libpath + 'cmos.lib; ' 
  stat    = 'stat; ' 

readlib  = 'read_liberty -lib ' + library
print('Library: ' + library)
if args.dffmap == True:
  dffmap = 'dfflibmap -liberty ' + library 
else:
  dffmap = '' 

if args.show == True:
  show = 'show; ' + library 
else:
  show = ''  
 

abc      = 'abc -liberty ' + library
synth    = 'synth; flatten; ' #'synth -top ' + top + '; flatten; '

if args.type == 'b':
  print ('Generating Blockdiagram: work/' + top + '.svg')
  cmd = 'echo ' + ghdl + 'proc; clean; techmap -map ' + labpath + 'script/pmux2mux.v; opt; fsm; opt; ' + stat + show + json + verilog
elif args.type == 's':  
  print ('Synthesizing: work/' + top + '.v')
  cmd = 'echo ' + ghdl + synth + stat + show + json + verilog
elif args.type == 't':  
  print ('Synthesizing & Technology Mapping: work/' + top + '.v')
  cmd = 'echo ' + ghdl + readlib + synth + techmap + dffmap + abc + opt + show + json + stat + verilog  
print(cmd)  
os.system(cmd)
os.system('cd work && yosys -m ghdl synth.ys')
os.system('cd work && extract.py ' + top)
os.system('cd work && netlistsvg ' + jsonfile + ' -o ' + svgfile + ' --skin ' + labpath + 'script/lab.svg')
os.system('rm e~' + top + '.o')
if top[-4:] != '.vhd':
  os.system('rm ' + top)  