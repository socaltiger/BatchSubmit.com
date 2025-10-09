data _null_;
   set sasuser.stress2;
   file 'c5_4.txt';
   put id 1-4 name 6-25 resthr 27-28 maxhr 30-32
       rechr 34-36 timemin 38-39 timesec 41-42
       tolerance 44;
run;

data mystress2;
   infile 'c5_4.txt'; 
   input id 1-4 name $6-25 resthr 27-28 maxhr 30-32
       rechr 34-36 timemin 38-39 timesec 41-42
       tolerance $44;
run;

proc contents data=mystress2;
run;

proc print data=mystress2;
run;