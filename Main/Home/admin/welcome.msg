Welcome to BatchSubmit.com!

A few things to notice:

1) question: What is a .par file for?

answer: A parameter file (.par) enables user to execute 
the underlying scripts without seeing the dreadful code, 
it stores the parameter values to avoid repeat entry as
well. In addition, it can schedule repeated tasks.

2) question: In SAS, how do I define libname for current 
directory?

answer: For example, if the current dirctory is 
/Main/Users/guest, then: 
libname mylib '.';

3) question: In R, how do I read from/write to files 
in the current directory?

answer: For example, if the current dirctory is 
/Main/Users/guest, then: 
autos_data <- read.table("autos.dat", header=T, sep="\t")
or
png(filename="autos2.png", height=295, width=300, bg="white")

============================================================
