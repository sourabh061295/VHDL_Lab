#!/usr/bin/python3

import os, sys
import subprocess
import argparse

parser = argparse.ArgumentParser(description='Simulate a vhdl testbench', usage='  ./simulate.py module [-s stoptime] [-p generic parameters] [-g]\nexample: ./simulate.py fulladder_tb -s 100ns')

parser.add_argument('t', nargs=1, metavar='testbench', help = 'entity name, e.g. fulladder_tb')
parser.add_argument('-s', nargs=1, metavar='stoptime' , help = 'with time unit, default=1000ns', default = ['1000ns'])
parser.add_argument('-g', action='store_true'         , help = 'start GTKWave Viewer')
parser.add_argument('-p', metavar = 'parameter=value', dest='param',  
                    help = 'Name and value of the generic parameter, e.g. -p N=4,M=5')
args = parser.parse_args()

top = args.t[0]
print(top)#
stoptime = args.s[0]

if args.param != None:
  pars = args.param.split(',')
  param=' '
  for p in args.param.split(','):
    param += ' -g' + p + ' '
else: 
  param = ' '

if os.path.exists("work"):
  os.system('rm -r work') 
os.system('mkdir work')   
os.system('ghdl -i -g -Wno-hide -O3 -fsynopsys --std=08 --workdir=work *.vhd')
os.system('ghdl -m -g -Wno-hide -O3 -fsynopsys --std=08 --workdir=work ' + top)

os.system('ghdl -r -g -Wno-hide -O3 -fsynopsys --std=08 --workdir=work ' + top + param + ' --wave=work/' + top + '.ghw' + ' --vcd=work/' + top + '.vcd' +' --stop-time=' + stoptime + ' --ieee-asserts=disable') 
if args.g == True:
  os.system('gtkwave work/' + top + '.ghw')
if top[-4:] != '.vhd':
  os.system('rm ' + top +' && ' + 'rm e~' + top + '.o') 


