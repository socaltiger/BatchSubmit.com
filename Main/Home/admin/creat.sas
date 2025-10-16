options mprint symbolgen;

%macro create (name, number);
%do n=1 %to &number;
      &name.&n
%end;
%mend create;
data %create(abc,3);
input a@@;
if a=1 then output abc1;
else if a=2 then output abc2;
else if a=3 then output abc3;
cards;
1 2 3
;
proc print data=abc1;
run;
proc print data=abc2;
run;
proc print data=abc3;
run;