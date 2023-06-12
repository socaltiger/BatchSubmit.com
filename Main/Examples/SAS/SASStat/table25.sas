data abortion;
  input a b c count m111 m11p m1p1 mp11 m1pp m222 @@;
  datalines;
1 1 1 466 1 0 0 0 0 0 1 1 2 3 -1 1 0 0 0 0
1 2 1 71 -1 0 1 0 0 0 1 2 2 3 1 -1 -1 0 1 0
2 1 1 39 -1 0 0 1 0 0 2 1 2 1 1 -1 0 -1 1 0
2 2 1 423 1 0 -1 -1 1 0 2 2 2 147 0 0 0 0 0 1
;
run;

proc genmod;
  model count = m111 m11p m1p1 mp11 m1pp m222 / dist=poi link=identity;
run;

proc catmod; weight count; response marginals;
  model a*b*c = _response_ / freq;
  repeated item 3;
run;