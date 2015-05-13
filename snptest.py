from __future__ import division
import sys, getopt, math, numpy

def read_input(argv):
   genfile = ''
   samplefile = ''
   try:
      opts, args = getopt.getopt(argv,"hg:s:",["gfile=","sfile="])
   except getopt.GetoptError:
      print 'test.py -i <genfile> -o <samplefile>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'test.py -g <genfile> -s <samplefile>'
         sys.exit()
      elif opt in ("-g", "--gfile"):
         genfile = arg
      elif opt in ("-s", "--sfile"):
         samplefile = arg
   print 'Gen file is "', genfile
   print 'Sample file is "', samplefile
   return genfile, samplefile

if __name__ == "__main__":
   genfile, samplefile = read_input(sys.argv[1:])

def gen_range(start, end, step):
  while start <= end:
    yield start
    start += step

def read_input(genfile,samplefile, line_counter):
   snp_storage = list()
   with open(genfile, "r+") as gen, open(samplefile, "r+") as samp:
     for line in gen:
      line_counter = line_counter+1
      for group in gen_range(5,len(line),3): #python indexes starting at 0

          rs = "NA"
          x = group
          y = group + 1
          z = group + 2

          #generalized for imputed data
          one = line[x]
          two = line[y]
          three = line[z]

          if one > 0.9:
              rs = 0
          elif two > 0.9:
              rs = 1
          elif three > 0.9:
              rs = 2
          else:
              rs = "NA"
          snp_storage[line_counter-1]




      x1,x2,x3,x4,x5,x6 = line.split(' ')[:6]
      print x1,x2,x3,x4,x5,x6
      print line_counter

read_input(genfile,samplefile,0)

#for x in gen_range(6,30,3):
#  print(x)
