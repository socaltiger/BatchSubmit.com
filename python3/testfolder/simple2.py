cwd = os.getcwd()

print(cwd)

baconFile = open('bacon.txt', 'w')
baconFile.write('Hello world!\n')
baconFile.close()