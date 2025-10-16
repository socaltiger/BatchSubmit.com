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

pswd2.cgi
csprpm
cspr2.cgi
main2.cgi
m.main2.cgi
YaBB.2.5.2