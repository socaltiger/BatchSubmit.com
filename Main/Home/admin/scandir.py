from os import scandir

# detect the current working directory
path = os.getcwd()

# read the entries
with scandir(path) as listOfEntries:  
    for entry in listOfEntries:
        # print all entries that are files
        if entry.is_file():
            print(entry.name)