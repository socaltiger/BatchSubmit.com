%global samplesize;

%macro checkparm;

    %if %symexist(parm1) %then %let samplesize = &parm1;
    %else %let samplesize = 1000000;

%mend;

%checkparm;


%macro  area(time);


data random;

do i=1 to &time;

x=20*ranuni(0);

y=10*ranuni(0);

output;

end;

run;


data count;

set random;

if x<5 and y<5 and y<0.5*x and (x-5)*(x-5)+(y-5)*(y-5)>25 then flag=1;

else flag=0;

run;


proc sql;

create table area&time as select

&time as samplesize, 100-25*constant('pi')-sum(flag)/count(flag)*200 as area

from count;

quit;


proc print data=area&time;

run;

%mend;


%area(&samplesize);