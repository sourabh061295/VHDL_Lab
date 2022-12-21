#!/usr/bin/python3

import csv, os
import subprocess
import sys
import argparse

def assemble_text(file):
  return 'dump .text HexText', f'{path}/hex/{file}_imem.hex'
 
def assemble_data(file):
  return 'dump .data HexText', f'{path}/hex/{file}_dmem.hex'

parser = argparse.ArgumentParser(description='Assemble a RISC-V assembly program')
parser.add_argument('file', nargs=1, help='assembly file')
parser.add_argument('memsize', nargs=1, help='assembly memsize')                    
parser.add_argument('--data', dest='section', action='store_const',
                    const = assemble_data, default=assemble_text,
                    help='assemble .data section (default: assemble .text section)')
args        = parser.parse_args()
pathfile    = args.file[0]
[path,file] = os.path.split(pathfile)
if path=='': path='.'

memsize     = int(args.memsize[0])
argument    = (args.section(file))
filename    = argument[1]
rars        = 'rars.jar'
pwd         = os.getcwd() 
if not os.path.exists(f'{path}/hex'):
    os.makedirs(f'{path}/hex')
print(f'{rars} a mc CompactTextAtZero  {argument[0]} {filename} {path}/{file}.s')    
out         = subprocess.run([f'{rars} a mc CompactTextAtZero  {argument[0]} {filename} {path}/{file}.s'], universal_newlines=True, shell=True,
                                                                 stdout = subprocess.PIPE, 
                                                                 stderr = subprocess.PIPE) 
print(out.stdout)
print(out.stderr)

# append with zeroes
lines = len(open(argument[1]).readlines())
with open(filename, 'a') as memfile:
  if (memsize-lines) < 0:
    print('Error: Memory too small!')
  else:  
    for i in range(memsize-lines):
      memfile.write('00000000\n')
  memfile.close()    

split = False
if split == True:
  # split memfile of words in 4 memfiles of bytes
  fname = filename[:-4]
  writer0 = open (fname + "0.hex",'w')
  writer1 = open (fname + "1.hex",'w')
  writer2 = open (fname + "2.hex",'w')
  writer3 = open (fname + "3.hex",'w')
  with open(filename, 'r') as reader:
    line = reader.readline()
    while line != '':  # The EOF char is an empty string
      writer0.write(line[0:2]+'\n')
      writer1.write(line[2:4]+'\n')
      writer2.write(line[4:6]+'\n')
      writer3.write(line[6:8]+'\n')
      line = reader.readline()

  reader.close()
  writer0.close()
  writer1.close()
  writer2.close()
  writer3.close()