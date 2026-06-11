data divorce;
  input state $ incompat cruelty desertn non_supp alcohol
        felony impotenc insanity separate ;
  datalines;
California 1 0 0 0 0 0 0 1 0
Florida 1 0 0 0 0 0 0 1 0
Illinois 0 1 1 0 1 1 1 0 0
Massachusetts 1 1 1 1 1 1 1 0 1
Michigan 1 0 0 0 0 0 0 0 0
NewYork 0 1 1 0 0 1 0 0 1
Texas 1 1 1 0 0 1 0 1 1
Washington 1 0 0 0 0 0 0 0 1
;
run;

title Grounds for Divorce;

proc distance data=divorce method=djaccard absent=0 out=distjacc;
  var anominal(incompat--separate);
  id state;
run;

proc print data=distjacc(obs=8);
  id state;
  title2 Only 8 states;
run;

proc cluster data=distjacc method=average
  pseudo outtree=tree;
  id state;
run;

proc tree data=tree horizontal n=7 out=out ;
  id state;
run;