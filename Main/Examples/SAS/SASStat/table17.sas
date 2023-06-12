data drugs;
  input a c m count @@;
  datalines;
1 1 1 911 1 1 2 538 1 2 1 44 1 2 2 456
2 1 1 3 2 1 2 43 2 2 1 2 2 2 2 279
;
run;

proc genmod; class a c m;
  model count = a c m a*m a*c c*m / dist=poi link=log lrci type3 obstats;
run;