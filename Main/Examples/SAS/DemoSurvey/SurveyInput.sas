* Please DO NOT run this program directly, as it requires 4 paramaters, ;
* Run SurveyInput.par instead. ;

libname mylib '.';

data newentry;
    gender = "&parm1";
    age    = "&parm2"*1;
    weight = "&parm3"*1;
    height = "&parm4"*1;
    output;
run;

data mylib.surveydata;
    set mylib.surveydata newentry;
run;

proc print data=mylib.surveydata;
run;

filename sasgraph 'SurveyInput.png';
goptions gsfname=sasgraph dev=png xpixels=500 ypixels=400;

proc gplot data=mylib.surveydata;
   plot height*weight;
run;