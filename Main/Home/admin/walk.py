from os import walk

for root, dirs, files in walk("."):  
   for name in files:
      print(name)