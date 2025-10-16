from distutils.dir_util import copy_tree

# copy subdirectory example
fromDirectory = "python"
toDirectory = "python4"

copy_tree(fromDirectory, toDirectory)