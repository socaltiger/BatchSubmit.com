data example;
  input group $ outcome $ count @@;
  datalines;
placebo yes 2 placebo no 18 active yes 7 active no 13
;
run;

proc freq order=data; weight count;
  tables group*outcome / riskdiff(CL=(WALD MN)) measures;
* MN = Miettinen and Nurminen inverted score test;
run;