#!/usr/bin/python3

import subprocess
import sys

rars = '../../tools/rars.jar'
out = subprocess.run([f'java -jar {rars}'], universal_newlines=True, shell=True,
                                                                 stdout = subprocess.PIPE, 
                                                                 stderr = subprocess.PIPE) 
print(out.stdout)