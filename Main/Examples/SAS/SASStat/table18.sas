data rake;
  input partyid polviews count;
  log_ct = log(count); pseudo = 100/3;
  datalines;
1 1 306
1 2 279
1 3 116
2 1 185
2 2 312
2 3 194
3 1 26
3 2 134
3 3 338
;
run;

proc genmod; class partyid polviews;
  model pseudo = partyid polviews / dist=poi link=log offset=log_ct
  obstats;
run;