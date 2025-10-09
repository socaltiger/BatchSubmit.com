/* 
    Do not run this script directly, as it requires
    a macro variable parm1. Run c4_3_input.par instead.
*/

%let age = &parm1;

proc print data=sasuser.admit;
   var age height weight fee;
   where age > &age;
run;