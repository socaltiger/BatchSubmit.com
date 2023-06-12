data sex;
  input premar extramar symm qi count @@;
  unif = premar*extramar;
  datalines;
1 1 1 1 144 1 2 2 5 2 1 3 3 5 0 1 4 4 5 0
2 1 2 5 33 2 2 5 2 4 2 3 6 5 2 2 4 7 5 0
3 1 3 5 84 3 2 6 5 14 3 3 8 3 6 3 4 9 5 1
4 1 4 5 126 4 2 7 5 29 4 3 9 5 25 4 4 10 4 5
;
run;

proc genmod; class symm;
  model count = symm / dist=poi link=log; * symmetry;
run;

proc genmod; class extramar premar symm;
  model count = symm extramar premar / dist=poi link=log; * QS;
run;

proc genmod; class symm;
  model count = symm extramar premar / dist=poi link=log; * ordinal QS;
run;

proc genmod; class extramar premar qi;
  model count = extramar premar qi / dist=poi link=log; * quasi indep;
run;

proc genmod; class extramar premar;
  model count = extramar premar qi unif / dist=poi link=log;
* quasi unif. assoc. ;
run;

data sex2;
  input score below above @@; trials = below + above;
  datalines;
1 33 2 1 14 2 1 25 1 2 84 0 2 29 0 3 126 0
;
run;

proc genmod data=sex2;
  model above/trials = / dist=bin link=logit noint; * symmetry;
run;

proc genmod data=sex2;
  model above/trials = score / dist=bin link=logit noint; * ordinal QS;
run;

proc genmod data=sex2;
  model above/trials = / dist=bin link=logit; * conditional symm;
run;