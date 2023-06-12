/* 
    Do not run this script directly, as it requires
    macro variables parm1,parm2,parm3, run input.par instead.
*/

%let l = &parm1;
%let h = &parm2;
%let b = &parm3;

data volume;
    v = &l*&h*&b;
	output;
run;

proc print data=volume;
run;