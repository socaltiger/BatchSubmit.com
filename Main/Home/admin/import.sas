libname this '.';

proc import out=this.slr
    datafile = "slr.csv"
    dbms = csv replace;
    getnames=yes;
run;

proc contents data=this.slr;
run;

proc print data=this.slr; 
run;