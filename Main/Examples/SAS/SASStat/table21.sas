data migrate;
  input then $ now $ count m11 m12 m13 m21 m22 m23 m31 m32 m33 m44 m1 m2 m3;
  datalines;
ne ne 266 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1
ne mw 15 0 1 0 0 0 0 0 0 0 0 0 0 0 2 5
ne s 61 0 0 1 0 0 0 0 0 0 0 0 0 0 3 5
ne w 28 -1 -1 -1 0 0 0 0 0 0 0 1 0 0 4 5
mw ne 10 0 0 0 1 0 0 0 0 0 0 0 0 0 2 5
mw mw 414 0 0 0 0 1 0 0 0 0 0 0 0 0 5 2
mw s 50 0 0 0 0 0 1 0 0 0 0 0 0 0 6 5
mw w 40 0 0 0 -1 -1 -1 0 0 0 0 0 1 0 7 5
s ne 8 0 0 0 0 0 0 1 0 0 0 0 0 0 3 5
s mw 22 0 0 0 0 0 0 0 1 0 0 0 0 0 6 5
s s 578 0 0 0 0 0 0 0 0 1 0 0 0 0 8 3
s w 22 0 0 0 0 0 0 -1 -1 -1 0 0 0 1 9 5
w ne 7 -1 0 0 -1 0 0 -1 0 0 0 1 0 0 4 5
w mw 6 0 -1 0 0 -1 0 0 -1 0 0 0 1 0 7 5
w s 27 0 0 -1 0 0 -1 0 0 -1 0 0 0 1 9 5
w w 301 0 0 0 0 0 0 0 0 0 1 0 0 0 10 4
;
run;

proc genmod;
  model count = m11 m12 m13 m21 m22 m23 m31 m32 m33 m44 m1 m2 m3 /
  dist=poi link=identity;
run;

proc catmod; weight count; response marginals;
  model then*now = _response_ / freq;
  repeated time 2;
run;