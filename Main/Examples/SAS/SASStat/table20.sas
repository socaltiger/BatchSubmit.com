data matched;
  input first second count @@;
  datalines;
1 1 175 1 2 16 2 1 54 2 2 188
;
run;

proc freq; weight count;
  tables first*second / agree; exact mcnem;
run;

proc catmod; weight count;
  response marginals;
  model first*second = (1 0 ,
                        1 1 ) ;
run;