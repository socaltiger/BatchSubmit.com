data glm;
  input snoring disease total @@;
  datalines;
0 24 1379 2 35 638 4 21 213 5 30 254
;
run;

proc genmod; model disease/total = snoring / dist=bin link=identity;
run;

proc genmod; model disease/total = snoring / dist=bin link=logit LRCI;
run;

proc genmod; model disease/total = snoring / dist=bin link=probit;
run;