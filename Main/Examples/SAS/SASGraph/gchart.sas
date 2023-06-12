option gstyle;

ods listing style=statistical;

filename sasgraph 'gchart.png';
goptions gsfname=sasgraph dev=png xpixels=500 ypixels=400;

proc gchart data=sashelp.cars;
   vbar Make;
      where MPG_Highway >= 37;
   run;
quit;