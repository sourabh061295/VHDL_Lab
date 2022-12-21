#!/usr/bin/python3

import sys,os
from matplotlib import pyplot as plt
import numpy as np

#results = {}
area    = np.zeros((2,4))
power   = np.zeros((2,4))
fmax    = np.zeros((2,4))

def parse(input_lines, entity, width, T):
    maxpath = False
    for line_i,line in enumerate(input_lines):
        if 'Chip area for module' in line:
          l = line.split(':')         
          area[entity][width]=round(float(l[1].strip()),2)
        if 'Combinational' in line:
          l = " ".join(line.split()).split()
          power[entity][width]=round(float(l[4])*1000000,2)
        if 'Path Type: max' in line:   
          maxpath = True
        if 'slack (MET)' in line and maxpath:
          l = line.strip().split(' ')
          fmax[entity][width]= round(1000/(T-float(l[0])),2)
      

def plot_result(n,entities):    

  x   = np.array(n) 
  fig, sub = plt.subplots(3, figsize=(15,15)) #, sharex=True)
  sub[0].set_title('Chip area')   
  sub[0].set_xticks(x)
  for i in range(np.shape(area)[0]):
    sub[0].plot(x, area[i],'o-',alpha=0.5)
  sub[0].legend(entities)
  sub[1].set_title('Maximum frequency')  
  sub[1].set_xticks(x)
  sub[1].set(ylabel='$[MHz]$')
  for i in range(np.shape(fmax)[0]):
    sub[1].plot(x, fmax[i],'o-',alpha=0.5) 
  sub[1].legend(entities)  
  sub[2].set_title('Power dissipation')  
  sub[2].set_xticks(x) 
  for i in range(np.shape(power)[0]):
    sub[2].plot(x, power[i],'o-',alpha=0.5)
  sub[2].set(xlabel='N')  
  sub[2].set(ylabel='$[mW]$')
  sub[2].legend(entities)
  plt.subplots_adjust(hspace=0.3)
  #plt.show()  
  plt.savefig('work/comparison.svg', bbox_inches='tight')

def print_result(n, entities): 
  strlen = 0
  for entity in entities:
    if len(entity) > strlen:
      strlen = len(entity)
  space = ' '*strlen   

  k = len(n)
  
  print('N' + space + ':', end='') 
  for i in n:
    print('%10d' % i,end='')   
  print() 
  print('\n %s' % 'Area'.center(10*k+strlen))
  for i,entity in enumerate(entities):  
    print('%*s : ' % (strlen, entity),end='')
    for j in range(len(n)):
      print('%10.2f' % area[i][j],end='')
    print() 
  print('\n %s' % 'Fmax [MHz]'.center(10*k+strlen))
  for i,entity in enumerate(entities):  
    print(f'%*s : ' % (strlen, entity),end='')
    for j in range(len(n)):
      print('%10.2f' % fmax[i][j],end='')
    print()   
  print('\n %s' % 'Power [mW]'.center(10*k+strlen))
  for i,entity in enumerate(entities):  
    print(f'%*s : ' % (strlen, entity),end='')
    for j in range(len(n)):
      print('%10.2f' % power[i][j],end='')  
    print()  

def usage():
    print ('Usage: '+sys.argv[0]+' <entity [entity ... ]>')
    sys.exit(1)

def printProgressBar (iteration, total, prefix = '', suffix = '', decimals = 1, length = 100, fill = '█', printEnd = "\r"):
    """
    Call in a loop to create terminal progress bar
    @params:
        iteration   - Required  : current iteration (Int)
        total       - Required  : total iterations (Int)
        prefix      - Optional  : prefix string (Str)
        suffix      - Optional  : suffix string (Str)
        decimals    - Optional  : positive number of decimals in percent complete (Int)
        length      - Optional  : character length of bar (Int)
        fill        - Optional  : bar fill character (Str)
        printEnd    - Optional  : end character (e.g. "\r", "\r\n") (Str)
    """
    percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration / float(total)))
    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    print(f'\r{prefix} |{bar}| {percent}% {suffix}', end = printEnd)
    # Print New Line on Complete
    if iteration == total: 
        print()    

def main(argv):
    if len(argv) < 1:
        usage()
    n = [8,16,32,64] 
    T = 10 #ns clock period

    l=len(argv[1:])*len(n)

    area.resize((len(argv[1:]),len(n)))   
    power.resize((len(argv[1:]),len(n)))   
    fmax.resize((len(argv[1:]),len(n))) 

    printProgressBar(0, l, prefix = 'Progress:', suffix = 'Complete', length = 50)

    #print(argv[1:])

    vhdlregfile = argv[0] + '.vhd'
    #print(vhdlregfile)

    for i, entity in enumerate(argv[1:]):

      vhdfile = open(vhdlregfile,'r')
      lines = vhdfile.readlines()
      vhdfile.close()
      vhdfile = open(vhdlregfile,'w')
      for line_i,line in enumerate(lines):
        if 'entity work' in line:
          lines[line_i] = '  analyze_inst: entity work.' + entity + '\n'
      vhdfile.writelines(lines)
      vhdfile.close()
   
      for j,width in enumerate(n):
        lines = os.popen(f'analyze.py {argv[0]} -p N={width}').read().split('\n') 
        parse(lines, i, j, T)
        printProgressBar((i*len(n))+(j+1), l, prefix = 'Progress:', suffix = 'Complete', length = 50)
    print()    

    print_result(n,argv[1:])
    plot_result(n,argv[1:])
if __name__ == '__main__':
    main(sys.argv[1:])