data example;
  input group $ outcome $ count @@;
  datalines;
placebo yes 2 placebo no 18 active yes 7 active no 13
;
run;

proc freq order=data; weight count;
  tables group*outcome ;
  exact or riskdiff ; * conservative Santner-Snell approach;
run;

proc freq order=data; weight count;
  tables group*outcome ;
  exact riskdiff(method=fmscore);
* exact unconditional inverting two one-sided score tests;
run;