libname mylib '.';

data mylib.admit;
   set sasuser.admit;
   if ActLevel="HIGH";
run;

proc print data=mylib.admit;
run;