/* 
    Do not run this script directly, as it requires
    macro variables parm1,parm2,parm3, run QuadEquation.par instead.
*/

%let a = &parm1;
%let b = &parm2;
%let c = &parm3;

data work;

a = &a;
b = &b;
c = &c;

d = (b**2) - (4*a*c);

X1 = (-b+sqrt(d))/(2*a);
X2 = (-b-sqrt(d))/(2*a);

run;

proc print data=work; 
    var x1 x2;
run;
