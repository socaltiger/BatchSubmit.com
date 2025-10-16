data test;

input sbject 1-2 gender $ 4 exam1 6-8 exam2 9-11 hw_geade $ 12;
datalines;
10 m 80 84 A
7  m 85 89 A
4  F 90 86 B
20 m 82 85 B
25 F 94 94 A
14 F 88 84 C
;

proc means data=test;
run;