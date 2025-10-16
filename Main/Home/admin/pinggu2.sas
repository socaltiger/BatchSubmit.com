options mprint symbolgen;

data test;
    input id year;
cards;
1 2001
1 2003
1 2005
2 2002
2 2004
2 2007
;
run;

proc sort data=test out=test; 
    by id year;
run;

proc print; run;

proc sql;
    create table test1 as
    select id, min(year) as ymin, max(year) as ymax from test
    group by id
    order by id;
quit;

data test2;
    set test1;
    year = ymin;
    do while(year ge ymin and year le ymax);
         output;
         year + 1;
    end;
run;

proc print; run;

