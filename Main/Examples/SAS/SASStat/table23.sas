data baseball;
  input wins games boston newyork tampabay toronto baltimore ;
  datalines;
12 18 1 -1 0 0 0
6 18 1 0 -1 0 0
10 18 1 0 0 -1 0
10 18 1 0 0 0 -1
9 18 0 1 -1 0 0
11 18 0 1 0 -1 0
13 18 0 1 0 0 -1
12 18 0 0 1 -1 0
9 18 0 0 1 0 -1
12 18 0 0 0 1 -1
;
run;

proc genmod;
  model wins/games = boston newyork tampabay toronto baltimore /
  dist=bin link=logit noint covb obstats;
run;