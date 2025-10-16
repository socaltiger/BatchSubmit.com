%let _start=369869001;
%let _end=400000000;

%let _BIRTHDAY='05JUL2017'D;
%let _EXPIRE='31JUL2018'D;

*%let _BIRTHDAY='05JAN2017'D;
*%let _EXPIRE='31DEC2017'D;

title " ";

option nonumber nodate nostimer ls=130;

%macro _findpw();

%do _pw=&_start. %to &_end.;

proc printto log="findpw.txt" %if %substr(&_pw,7)=%str(001) %then %do; new %end;;
run;

%put Password is &_pw from &_BIRTHDAY to &_EXPIRE..;

PROC SETINIT RELEASE='9.4';
SITEINFO NAME='NATIONAL TAIWAN UNIVERSITY'
SITE=12000398 OSNAME='WX64_WKS' RECREATE WARN=30 GRACE=30
BIRTHDAY=&_BIRTHDAY. EXPIRE=&_EXPIRE. PASSWORD=&_pw.;
CPU MODEL=' ' MODNUM=' ' SERIAL=' ' NAME=CPU000;
EXPIRE 'PRODNUM000' 'PRODNUM001' 'PRODNUM002' 'PRODNUM003'
'PRODNUM004' 'PRODNUM005' 'PRODNUM006' 'PRODNUM007'
'PRODNUM008' 'PRODNUM010' 'PRODNUM013' 'PRODNUM015'
'PRODNUM025' 'PRODNUM035' 'PRODNUM050' 'PRODNUM070'
'PRODNUM075' 'PRODNUM094' 'PRODNUM095' 'PRODNUM119'
'PRODNUM123' 'PRODNUM164' 'PRODNUM165' 'PRODNUM166'
'PRODNUM167' 'PRODNUM192' 'PRODNUM194' 'PRODNUM204'
'PRODNUM208' 'PRODNUM209' 'PRODNUM215' 'PRODNUM219'
'PRODNUM222' 'PRODNUM225' 'PRODNUM448' 'PRODNUM535'
'PRODNUM538' 'PRODNUM550' 'PRODNUM555' 'PRODNUM557'
'PRODNUM560' 'PRODNUM561' 'PRODNUM563' 'PRODNUM564'
'PRODNUM565' 'PRODNUM567' 'PRODNUM568' 'PRODNUM677'
'PRODNUM678' 'PRODNUM884' 'PRODNUM964' &_EXPIRE.
/ CPU=CPU000;
SAVE; RUN;

proc printto;
run;

%if %substr(&_pw,7)=%str(000) %then %do;

option nonotes;

data findpw;
   infile "findpw.txt" length=len;
   input record $varying200. len;
   length finding $ 100;
   retain finding;
   if index(record,"Password is") then finding=record;
   if index(record,"ERROR: User does not have appropriate authorization level");
run;

data _null_;
   set findpw;
   if _n_=1 then do;
      call symput("_pw","&_end.");
      file "finding.txt";
      put finding $60.;
   end;
run;

option notes;

%end;

%end;

%mend;

%_findpw();

option stimer;