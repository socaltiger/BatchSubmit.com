* This is a simple SAS program you own, ;
* you can edit, save, run, or delete it.  ;

data first;
    INPUT x y z $;
    cards;
1  2.3  A
4  5.6  B
7  8.9  C
;
run;

proc print;
run;