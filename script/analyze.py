#!/usr/bin/python3

import os, sys
import subprocess
import argparse

parser = argparse.ArgumentParser(description = 'Analyze a vhdl top entity', 
                                 usage       = './analyze.py module [-l library] [-c clock period] [-p generic parameters]',
                                 formatter_class = argparse.RawTextHelpFormatter)
                 
parser.add_argument('top', metavar = 'entity', type = str, 
                    help = 'Top entity')                   
parser.add_argument('-l', metavar = 'library', dest='library', default = '45nm_typ',
                    help = 'Library for technology mapping, e.g. (350nm, 180nm, 45nm)')
parser.add_argument('-p', metavar = 'parameter=value', dest='param',  
                    help = 'Name and value of the generic parameter, e.g. -p N=4,M=5')
parser.add_argument('-c', metavar = 'clockperiod', dest='period', default='10', 
                    help = 'Period of the clock in ns, e.g. 2')   
#parser.add_argument('-d', action='store_true', dest='dffmap',
#                    help = 'Mapping the D-FFs')                                      
args= parser.parse_args() 

top = args.top

if os.path.exists("work"):
  os.system('rm -r work') 
os.system('mkdir work')   

memfiles = [_ for _ in os.listdir('.') if _.endswith('.hex')] 
print('copy ' + str(memfiles) + '-> work')
if len(memfiles) != 0:
  for i in memfiles:
    os.system('cp ' + i + ' work/') 

os.system('ghdl -i -g -Wno-hide -O3 -fsynopsys --std=08 --workdir=work *.vhd')
os.system('ghdl -m -g -Wno-hide -O3 -fsynopsys --std=08 --workdir=work ' + top)

if args.param != None:
  pars = args.param.split(',')
  param=''
  for p in args.param.split(','):
    param += '-g' + p + ' '
else: 
  param = '' 

ghdl     = '\"ghdl -fsynopsys --std=08 ' + param + top + '; '
#jsonfile = top + '.json '
#json     = 'write_json ' + jsonfile + '; '
#svgfile  = top + '.svg'
verilog  = 'write_verilog ' + top + '.v\" > work/synth.ys'
opt      = ' ' #'opt; stat; '
techmap  = 'techmap; opt; ' 
libpath  = '~/lab/lib/' 
library  = libpath +args.library + '.lib; '
dffmap   = 'dfflibmap -liberty ' + library   
abc      = 'abc -liberty ' + library
synth    = 'synth -top ' + top + '; flatten; '
stat     = 'stat -liberty ' + library

cmd = 'echo ' + ghdl + synth + techmap + dffmap + abc + opt + stat + verilog
os.system(cmd)
os.system('cd work && yosys -m ghdl synth.ys')

cmd = 'echo ' + '\"read_liberty ' + library +'\n' + \
                'read_verilog ' + top + '.v\n' + \
                'link_design ' + top + '\n' + \
                'create_clock -name clk -period ' + args.period +' {clk}\n' + \
                'set_power_activity -global -activity 0.1\n' + \
                'report_checks -path_delay min_max\n' + \
                'report_power\n' + \
                'exit\"' + '> work/' + top + '.tcl'
os.system(cmd) 

os.system('cd work && sta ' + top + '.tcl') 
if top[-4:] != '.vhd':
  os.system('rm *.o')

