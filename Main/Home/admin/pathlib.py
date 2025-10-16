from pathlib import Path

# define the path
currentDirectory = pathlib.Path('.')

for currentFile in currentDirectory.iterdir():  
    print(currentFile)