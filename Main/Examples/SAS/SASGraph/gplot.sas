goptions reset=all border;
 
data jobs;
   length eng $5;
   input eng dollars num;
   datalines;
Civil 27308 73273
Aero  29844 70192
Elec  22920 89382
Mech  32816 19601
Chem  28116 25541
Petro 18444 34833
;
run;
 
title1 "Member Profile";
title2 "Salaries and Number of Member Engineers";
footnote j=r "GPLBUBL1";
 
axis1 offset=(5,5);

filename sasgraph 'gplot.png';
goptions gsfname=sasgraph dev=png xpixels=500 ypixels=400;

proc gplot data=jobs;
   format dollars dollar9.;
   bubble dollars*eng=num / haxis=axis1;
run;

quit;