data table;
  input degree belief $ count @@;
  datalines;
1 1 9 1 2 8 1 3 27 1 4 8 1 5 47 1 6 236
2 1 23 2 2 39 2 3 88 2 4 49 2 5 179 2 6 706
3 1 28 3 2 48 3 3 89 3 4 19 3 5 104 3 6 293
;
run;

proc freq order=data; weight count;
  tables degree*belief / chisq expected measures cmh1;
run;

proc genmod order=data; class degree belief;
  model count = degree belief / dist=poi link=log residuals;
run;