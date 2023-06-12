data gss;
  input absingle abhlth abpoor count;
  sum = absingle + abhlth + abpoor;
  datalines;
1 1 1 466
1 1 0 39
1 0 1 3
1 0 0 1
0 1 1 71
0 1 0 423
0 0 1 3
0 0 0 147
;
run;

proc genmod data=gss; class sum;
  model count = sum / dist=poisson link=log; * symmetry;
run;

proc genmod data=gss; class sum;
  model count = sum absingle abhlth abpoor / dist=poisson link=log
  obstats; * quasi-symmetry;
run;