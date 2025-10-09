OPTIONS nocenter;

DATA hsb25;
  INPUT id female race ses schtype $ prog
        read write math science socst;
DATALINES;
 147 1 1 3 pub 1 47  62  53  53  61
 108 0 1 2 pub 2 34  33  41  36  36
  18 0 3 2 pub 3 50  33  49  44  36
 153 0 1 2 pub 3 39  31  40  39  51
  50 0 2 2 pub 2 50  59  42  53  61
  51 1 2 1 pub 2 42  36  42  31  39
 102 0 1 1 pub 1 52  41  51  53  56
  57 1 1 2 pub 1 71  65  72  66  56
 160 1 1 2 pub 1 55  65  55  50  61
 136 0 1 2 pub 1 65  59  70  63  51
  88 1 1 1 pub 1 68  60  64  69  66
 177 0 1 2 pri 1 55  59  62  58  51
  95 0 1 1 pub 1 73  60  71  61  71
 144 0 1 1 pub 2 60  65  58  61  66
 139 1 1 2 pub 1 68  59  61  55  71
 135 1 1 3 pub 1 63  60  65  54  66
 191 1 1 1 pri 1 47  52  43  48  61
 171 0 1 2 pub 1 60  54  60  55  66
  22 0 3 2 pub 3 42  39  39  56  46
  47 1 2 3 pub 1 47  46  49  33  41
  56 0 1 2 pub 3 55  45  46  58  51
 128 0 1 1 pub 1 39  33  38  47  41
  36 1 2 3 pub 2 44  49  44  35  51
  53 0 2 2 pub 3 34  37  46  39  31
  26 1 4 1 pub 1 60  59  62  61  51
;
RUN;

filename outgraph 'graph.gif';
goptions gsfname=outgraph dev=gif373;
symbol c=black v=circle h=0.8;
proc gplot data=hsb25;
  plot read*math =1;
run;

quit;