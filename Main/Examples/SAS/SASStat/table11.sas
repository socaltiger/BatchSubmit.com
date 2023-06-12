data aids;
  input race $ azt $ y n @@;
  datalines;
White Yes 14 107 White No 32 113 Black Yes 11 63 Black No 12 55
;
run;

proc genmod; class race azt;
  model y/n = azt race / dist=bin type3 lrci residuals obstats;
run;

proc logistic; class race azt / param=reference;
  model y/n = azt race / aggregate scale=none clparm=both clodds=both;
  output out=predict p=pi_hat lower=lower upper=upper;
run;

proc print data=predict;
run;

proc logistic; class race azt (ref=first) / param=ref;
  model y/n = azt / aggregate=(azt race) scale=none;
run;