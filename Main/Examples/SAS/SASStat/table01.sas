data veg;
  input response $ count;
  datalines;
no 25
yes 0
run;

proc freq data=veg; weight count;
  tables response / binomial(ac wilson exact jeffreys) alpha=.05;
run;