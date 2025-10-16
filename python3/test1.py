Cross-platform:

import os 
import sys 

f = open(os.devnull, 'w') 
sys.stdout = f

On Windows:

f = open('nul', 'w') 
sys.stdout = f

On Linux:

f = open('/dev/null', 'w') 
sys.stdout = f