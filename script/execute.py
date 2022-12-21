#!/usr/bin/python3

import csv, os
import subprocess
import sys
import argparse

parser = argparse.ArgumentParser(description='Execute a RISC-V assembly program')
parser.add_argument('file', nargs=1, #type = string, #metavar='N', type=int, nargs='+',
                    help='execute RISC-V assembly file')
args     = parser.parse_args()
file = args.file[0]
rars = '../../tools/rars.jar ic smc mc CompactTextAtZero'
#rars = f'java -jar {path}'
out = subprocess.run([f'java -jar {rars} {file}.s'], universal_newlines=True, shell=True,
                                                                 stdout = subprocess.PIPE, 
                                                                 stderr = subprocess.PIPE) 
print(out.stdout)