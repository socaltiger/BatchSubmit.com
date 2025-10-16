/*******************************************************************\           
| Copyright (C) 2012 by SAS Institute Inc., Cary, NC, USA.          |           
|                                                                   |           
| SAS (R) is a registered trademark of SAS Institute Inc.           |           
|                                                                   |           
| This program sets up practice data for some of the examples       |
| in the Certification Prep Guide: Base Programming for SAS 9.      |
|                                                                   |
| Last updated: July 8, 2015                                        |
\*******************************************************************/           




options nosource nonotes nocardimage validvarname=V7 replace;

   /* create sample data */

data _null_;

   /* determine fileref paths, delimiters, file options */

   length fileno fileyes $18 fileset $ 1024;

   oshost=trim(substr(symget('sysscp'),1,2));
   filepath=trim(pathname("sasuser"));
      if (oshost = "OS") and (length(symget('sysscp'))=2) then
         do;
            filepath=scan(filepath,1);
            dlm=".";
            fileno="disp=(new,catlg)";
            fileyes="disp=(old,catlg)";
         end;
      else do;
         host=trim(substr(symget('sysscp'),1,3));
            if (host in ('WIN','OS2')) then
               do;
                  filepath=trim(pathname("sasuser"));
                  dlm="\";
                  fileno="";
                  fileyes="";
               end;
           else if (host = "VMS") then
               do;
                  filepath="";
                  dlm="";
                  fileno="";
                  fileyes="";
               end;
           else
               do;
                  filepath=trim(pathname("sasuser"));
                  dlm="/";
                  fileno="";
                  fileyes="";
               end;
      end;

   /* assign filerefs */

   array filelst1{8} $ filesas1-filesas8 ('accnt','accnt01','accnt02',
                                          'accnt03',
                                          'accnt04','activity','fee',
                                          'printfee');
      do i=1 to dim(filelst1);
         if (host = "CMS") then fileset=trim(filelst1(i)) || " sas *";
         else fileset=trim(filepath) || dlm || trim(filelst1(i)) || ".sas";
         isfile=fileexist(fileset);
         if isfile=1 then fileopts=trim(fileyes);
         else fileopts=trim(fileno);
         rc=filename(filelst1(i),fileset,"",fileopts);
      end;

   array filelst2{48} $ filedt1-filedt48 ('admit','aprdata','aug99dat',
         'bookdata','cardata','census','choldata','citydata','credit2','credit3',
         'credit4','credit5','creditc','creditcr','cc','cccomma','data97',
         'empdata','excdata1',
         'excdata2','excdata3','exer','group3','invent','invent1','invent2',
         'jan98dat','loan','memdata','newloans','orderdat','patdata','personel',
         'phonsurv','powerdat','pubdata','rawdata','salary','saledata','satdata1','satdata2',
         'stordata','survey1','tempdata','tests','tests2','topten', 'vandata');
      do i=1 to dim(filelst2);
         if (host="CMS") then fileset=trim(filelst2(i)) || " data *";
         else fileset=trim(filepath) || dlm || trim(filelst2(i)) || ".dat";
         isfile=fileexist(fileset);
         if isfile=1 then fileopts=trim(fileyes);
         else fileopts=trim(fileno);
         rc=filename(filelst2(i),fileset,"",fileopts);
      end;
run;

   /* create SAS programs*/

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file accnt03;
        put text;
datalines4;
data work.reliable;
set clini.insure;
where company='FRED SMYTHE;
run;
proc print data=work.reliable
var id name company total balancedue;
run;
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 70;
        input text $varying70. l;
        file accnt04;
        put text;
datalines4;
data work.billing;
set sasuser.insure;
run;
proc print data=work.billing keylabel;
label total='Total Balance' balancedue='Balance Due';
run;
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file accnt;
        put text;
datalines4;
data work.balance;
set sasuser.insure;
run;
proc print data=work.balnce;
run;
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file accnt02;
        put text;
datalines4;
data work.balnew2;
set sasuser.insure;
run;
proc print data=work.balnew2
var id name total balancedue;
run;
;;;;
run;



data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file accnt01;
        put text;
datalines4;
data work.balnew1;
set sasuser.insure;
run;
proc print data=work.balnew1;
var id name total balancedue;
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file activity;
        put text;
datalines4;
proc print data=sasuser.admit;
   var id name actlevel;
run;
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file fee;
        put text;
datalines4;
data sasuser.admit2;
set sasuser.admit;run;
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file printfee;
        put text;
datalines4;

proc print data=sasuser.admit2;
run;
;;;;
run;
/* ***************************/
/* ***************************/
/* ***************************/
   /* create raw data files*/
/* ***************************/
/* ***************************/
/* ***************************/
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file admit pad lrecl=80;
        put text;
datalines;
2458 Murray, W        72    185   128     12      38     D
2462 Almers, C        68    171   133     10       5     I
2501 Bonaventure, T   78    177   139     11      13     I
2523 Johnson, R       69    162   114      9      42     S
2539 LaMance, K       75    168   141     11      46     D
2544 Jones, M         79    187   136     12      26     N
2552 Reberson, P      69    158   139     15      41     D
2555 King, E          70    167   122     13      13     I
2563 Pitts, D         71    159   116     10      22     S
2568 Eberhardt, S     72    182   122     16      49     N
2571 Nunnelly, A      65    181   141     15       2     I 
2572 Oberon, M        74    177   138     12      11     D
2574 Peterson, V      80    164   137     14       9     D
2575 Quigley, M       74    152   113     11      26     I
2578 Cameron, L       75    158   108     14      27     I
2579 Underwood, K     72    165   127     13      19     S
2584 Takahashi, Y     76    163   135     16       7     D
2586 Derber, B        68    176   119     17      35     N
2588 Ivan, H          70    182   126     15      41     N
2589 Wilcox, E        78    189   138     14      57     I
2595 Warren, C        77    170   136     12      10     S
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file aprdata pad lrecl=80;
        put text;
datalines;
Akron    04/05/99 04/09/99  175.00 298.45
Brown    04/12/99 05/01/99  125.00 326.78
Carnes   04/27/99 04/29/99  125.00 174.24
Denison  04/11/99 04/12/99  175.00  87.41
Fields   04/15/99 04/22/99  175.00 378.96
Jamison  04/16/99 04/23/99  125.00 346.28
;




data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file aug99dat pad lrecl=80;
        put text;
datalines;
100 02AUG99 R   6  30.00  180.00
103 03AUG99 C  20   3.99   79.80
102 04AUG99 T   4 200.00  800.00
103 08AUG99 T   5 200.00 1000.00
102 09AUG99 R  15  30.00  450.00
101 10AUG99 C 100   3.99  399.00
101 12AUG99 R  18  30.00  540.00
104 15AUG99 T  10 200.00 2000.00
103 18AUG99 C   9   3.99   35.91
100 22AUG99 T   3 200.00  600.00
102 23AUG99 R  10  30.00  300.00
100 25AUG99 C 100   3.99  399.00
101 30AUG99 T   3 200.00  600.00
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file bookdata pad lrecl=80;
        put text;
datalines;
AES358 PAPER 24
AES358 HARDBACK 43
AMZ114 PAPER 256
AMZ114 HARDBACK 235
ARS102 PAPER 28
ARS102 HARDBACK 58
ASD862 PAPER 287
ASD862 HARDBACK 145
AZX002 PAPER 17
AZX002 HARDBACK 92
BAE487 PAPER 67
BAE487 HARDBACK 81
BMW243 PAPER 120
BMW243 HARDBACK 181
BOP102 PAPER 228
BOP810 HARDBACK 134
BSX892 PAPER 73
BSX892 HARDBACK 109
BSY101 PAPER 187
BSY101 HARDBACK 91
BXT894 PAPER 0
BXT258 HARDBACK 8
BZZ543 PAPER 15
BZZ543 HARDBACK 33
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file cardata pad lrecl=80;
        put text;
datalines;
1998 US     CARS   194,324.12
1998 US     TRUCKS 142,290.30
1998 CANADA CARS    10,483.44
1998 CANADA TRUCKS  93,543.64
1998 MEXICO CARS    22,500.57
1998 MEXICO TRUCKS  10,098.88
1998 JAPAN  CARS    15,066.43
1998 JAPAN  TRUCKS  40,700.34
1997 US     CARS   213,504.05
1997 US     TRUCKS 116,735.65
1997 CANADA CARS       904.89
1997 CANADA TRUCKS  76,576.12
1997 MEXICO CARS    10,899.56
1997 MEXICO TRUCKS  13,000.45
1997 JAPAN  CARS    10,000.18
1997 JAPAN  TRUCKS  50,458.22
;
run;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file census pad lrecl=80;
        put text;
datalines;
H 321 S. MAIN ST
P MARY E    21 F
P WILLIAM M 23 M
P SUSAN K    3 F
H 324 S. MAIN ST
P THOMAS H  79 M
P WALTER S  46 M
P ALICE A   42 F
P MARYANN A 20 F
P JOHN S    16 M
H 325A S. MAIN ST
P JAMES L   34 M
P LIZA A    31 F
;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file choldata;
        file choldata pad lrecl=80;
        put text;
datalines;
BECKER   ED429174.1
DE HARTE ED102273.4
JOHNSON  MK832187.7
LYLES    SL934220.7
MC CAULEYAD524202.3
MORGAN   AD243229.5
PETERSON MK208259.4
ROBERTS  ED097203.7
THOMAS   SL029198.7
VAN HORN MK148178.7
;
run;


data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file citydata pad lrecl=80;
        put text;
datalines;
ANCHORAGE 48081 174431
ATLANTA 495039 425022
BOSTON 641071 562994
CHARLOTTE 241420 314447
CHICAGO 3369357 3005072
DALLAS 844401 904078
DENVER 514678 492365
DETROIT 1514063 1203339
MIAMI 334859 346865
PHILADELPHIA 1949996 1688210
SACRAMENTO 257105 275741
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file credit2 pad lrecl=80;
        put text;
datalines;
MALE,,1,8,0,0
FEMALE,29,3,14,5,10
FEMALE,34,2,10,3,3
MALE,35,2,12,4,8
FEMALE,36,4,16,3,7
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file credit3 pad lrecl=80;
        put text;
datalines;
MALE**1*8*0*0
FEMALE*29*3*14*5*10
FEMALE*34*2*10*3*3
MALE*35*2*12*4*8
FEMALE*36*4*16*3*7
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file credit4 pad lrecl=80;
        put text;
datalines;
,27,1,8,0,0
FEMALE,29,3,14,5,10
FEMALE,34,2,10,3,3
MALE,35,2,12,4,8
FEMALE,36,4,16,3,7
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file credit5 pad lrecl=80;
        put text;
datalines;
MALE  27 1 8 0 0
FEMALE 29 3 14 5 10
FEMALE 34 2 10 3 3
MALE 35 2 12 4 8
FEMALE 36 4 16 3 7
;
/* creditc goes with examples in Ch.17, p. 330, renamed because of conflict w/ data in end=of=chapter example */
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file creditc pad lrecl=80;
        put text;
datalines;
MALE 27 1 8 0 0
FEMALE 29 3 14 5 10
FEMALE 34 2 10 3 3
MALE 35 2 12 4 8
FEMALE 36 4 16 3 7
MALE 21 1 5 0 0
MALE 25 2 9 2 1
FEMALE 21 1 4 2 6
MALE 38 3 11 4 3
FEMALE 30 3 5 1 0
;

/* creditcr goes with the example in Ch.17, p. 544,"Reading Missing Values at the End of a Record". */
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file creditcr pad lrecl=80;
        put text;
datalines;
MALE 27 1 8 0 0
FEMALE 29 3 14 5 10
FEMALE 34 2 10  
MALE 35 2 12 4 8
FEMALE 36 4 16 3 7
MALE 21 1 5 0 0
MALE 25 2 9 2 1
FEMALE 21 1 4 2 6
MALE 38 3 11 4 3
FEMALE 30 3 5 1 0
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file cc pad lrecl=80;
        put text;
datalines;
EVANS#m#27#3#2
HELMS#f#29#2#1
LARSON#f#33#3#3
HIGGINS#m#35#2#2
MOORE#f#36#3#1
POWELL#m#21#2#3
RILEY#f#25#3#2
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file cccomma pad lrecl=80;
        put text;
datalines;
MALE,27,1,8,0,0
FEMALE,29,3,14,5,10
FEMALE,34,2,10,3,3
MALE,35,2,12,4,8
FEMALE,36,4,16,3,7
MALE,21,1,5,0,0
MALE,25,2,9,2,1
FEMALE,21,1,4,2,6
MALE,38,3,11,4,3
FEMALE,30,3,5,1,0
;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file data97 pad lrecl=80;
        put text;
datalines;
0734 1,323.34 2,472.85 3,276.65 5,345.52
0943 1,908.34 2,560.38 3,472.09 5,290.86
1009 2,934.12 3,308.41 4,176.18 7,581.81
1043 1,295.38 5,980.28 8,876.84 6,345.94
1190 2,189.84 5,023.57 2,794.67 4,243.35
1382 3,456.34 2,065.83 3,139.08 6,503.49
1734 2,345.83 3,423.32 1,034.43 1,942.28
1824 1,323.34 2,472.85                  
1943 1,908.34                           
2046 1,423.52 1,673.46 3,276.65         
2063 2,345.34 2,452.45 3,523.52 2,983.01
;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file excdata1 pad lrecl=80;
        put text;
datalines;
EVANS    DONNY 112 29996.63
HELMS    LISA  105 18567.23
HIGGINS  JOHN  111 25309.00
LARSON   AMY   113 32696.78
MOORE    MARY  112 29945.89
POWELL   JASON 103 35099.50
RILEY    JUDY  111 25309.00
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file excdata1 pad lrecl=80;
        put text;
datalines;
1001 sedentary 1002 daily 1003 moderate
1004 sedentary 1005 moderate 1006 sedentary
1007 daily 1008 daily 1009 moderate
1010 sedentary 1011 daily 1012 sedentary
1013 moderate 1014 moderate 1015 sedentary
1016 daily 1017 moderate 1018 moderate
1019 daily 1020 daily 1021 moderate
1022 sedentary 1023 daily 1024 sedentary
1025 moderate 1026 moderate 1027 sedentary
1028 daily 1029 moderate 1030 moderate
1031 daily 1032 daily 1033 moderate
1034 sedentary 1035 daily 1036 moderate
1037 moderate 1038 moderate 1039 sedentary
1040 sedentary 1041 daily 1042 sedentary
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file excdata2 pad lrecl=80;
        put text;
datalines;
1001 TENNIS SWIMMING AEROBICS
1002 FOOTBALL BASKETBALL TENNIS
1003 AEROBICS SWIMMING CYCLING
1004 GOLF JOGGING TENNIS
1005 WALKING AEROBICS TENNIS
1006 TENNIS SWIMMING AEROBICS
1007 FOOTBALL GOLF TENNIS
1008 BASEBALL SWIMMING CYCLING
1009 AEROBICS WALKING SQUASH
1010 WALKING AEROBICS TENNIS
1011 TENNIS SWIMMING AEROBICS
1012 GOLF SWIMMING TENNIS
1013 AEROBICS SWIMMING CYCLING
1014 SWIMMING WALKING SQUASH
1015 WALKING AEROBICS TENNIS
1016 TENNIS SWIMMING AEROBICS
1017 FOOTBALL BASEBALL GOLF
1018 AEROBICS SWIMMING CYCLING
1019 WALKING GOLF TENNIS
1020 WALKING AEROBICS TENNIS
1021 TENNIS SWIMMING AEROBICS
1022 FOOTBALL BASKETBALL TENNIS
1023 AEROBICS GOLF CYCLING
1024 AEROBICS WALKING GOLF
1025 WALKING AEROBICS TENNIS
1026 TENNIS SWIMMING AEROBICS
1027 FOOTBALL BASKETBALL TENNIS
1028 AEROBICS SWIMMING CYCLING
1029 TENNIS SQUASH VOLLEYBALL
1030 SWIMMING VOLLEYBALL BASKETBALL
1031 TENNIS SWIMMING AEROBICS
1032 FOOTBALL BASKETBALL TENNIS
1033 AEROBICS SWIMMING CYCLING
1034 AEROBICS WALKING GOLF
1035 WALKING AEROBICS TENNIS
1036 WALKING SWIMMING AEROBICS
1037 FOOTBALL BASKETBALL TENNIS
1038 BASEBALL SWIMMING CYCLING
1039 AEROBICS WALKING SOFTBALL
1040 BASKETBALL AEROBICS TENNIS
1041 TENNIS TENNIS TENNIS
1042 BASKETBALL SWIMMING TENNIS
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file excdata3 pad lrecl=80;
        put text;
datalines;
1051 TENNIS SWIMMING AEROBICS
1052 JOGGING BASKETBALL
1053 AEROBICS SWIMMING CYCLING
1054 GOLF JOGGING TENNIS
1055 WALKING AEROBICS
1056 TENNIS SWIMMING
1057 FOOTBALL GOLF TENNIS
1058 BASEBALL SWIMMING CYCLING
1059 AEROBICS WALKING SQUASH
1060 WALKING
1061 TENNIS SWIMMING AEROBICS
1062 GOLF SWIMMING TENNIS
1063 AEROBICS SWIMMING CYCLING
1064 SWIMMING WALKING SQUASH
1065 WALKING AEROBICS TENNIS
1066 TENNIS
1067 FOOTBALL BASEBALL GOLF
1068 AEROBICS SWIMMING CYCLING
1069 WALKING GOLF TENNIS
1070 WALKING AEROBICS
1071 TENNIS SWIMMING
1072 FOOTBALL BASKETBALL TENNIS
1073 AEROBICS GOLF CYCLING
1074 AEROBIC
1075 WALKING AEROBICS TENNIS
1076 TENNIS SWIMMING AEROBICS
1077 VOLLEYBALL
1078 AEROBICS SWIMMING CYCLING
1079 TENNIS SQUASH VOLLEYBALL
1080 SWIMMING VOLLEYBALL
1081 TENNIS SWIMMING AEROBICS
1082 FOOTBALL BASKETBALL TENNIS
1083 AEROBICS SWIMMING CYCLING
1084 GOLF
1085 WALKING AEROBICS
1086 WALKING SWIMMING AEROBICS
1087 BASKETBALL TENNIS
1088 BASEBALL SWIMMING CYCLING
1089 AEROBICS WALKING
1090 BASKETBALL AEROBICS TENNIS
;
run;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file exer pad lrecl=80;
        put text;
datalines;
2810 61 MOD  F 
2804 38 HIGH F
2807 42 LOW  M
2816 26 HIGH M
2833 32 MOD  F
2823 29 HIGH M
;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file group3 pad lrecl=80;
        put text;
datalines;
24 23334 20149 550443 336029
55 23344 54566 433559 838287
32 32233 55043 553254 898632
44 71040 55454 236344 440000
24 23344 40766 234669 263344
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file invent pad lrecl=80;
        put text;
datalines;
Bird Feeder   LG088  3 20
6 Glass Mugs  SB082  6 12
Glass Tray    BQ049 12  6
Padded Hangrs MN256 15  6
Jewelry Box   AJ498 23  0
Red Apron     AQ072  9 12
Crystal Vase  AQ672 27  0
Picnic Basket LS930 21  0
Brass Clock   AN910  2 10
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file invent1 pad lrecl=80;
        put text;
datalines;
AES358:GERALD:H:3
AES358:GERALD:P:6
AMZ114:MORGAN:H:2
AMZ114:MORGAN:P:12
ARS102:VANDEER:H:7
ARS102:VANDEER:P:12
ASD862:REEDY:H:0
ASD862:REEDY:P:5
AZX002:NESBITT:H:4
AZX002:NESBITT:P:8
BAE487:LOGANN:H:3
BAE487:LOGANN:P:0
BMW243:MARSHALL:H:4
BMW243:MARSHALL:P:4
BOP102:HAINS:H:8
BOP102:HAINS:P:15
BSX892:NICKELS:H:11
BSX892:NICKELS:P:22
BXT894:BARSTOW:H:7
BXT894:BARSTOW:P:11
BZZ543:DURNING:H:3
BZZ543:DURNING:P:9
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file invent2 pad lrecl=80;
        put text;
datalines;
CFR009 SPOTTISWOOD H 3
CFR009 SPOTTISWOOD P 6
RJH340 ROCHESTER H 2
RJH340 ROCHESTER P 12
KRS102 DASEM H 7
KRS102 DASEM P 11
ASD777 ROLLINGS H 0
ASD777 ROLLINGS P 5
NZE002 FRIEDMANN H 4
NZE002 FRIEDMANN P 8
BAE487 HOLLOWAIT H 3
BAE487 HOLLOWAIT P 18
UNM578 MARSHALL H 1
UNM578 MARSHALL P 15
LAR333 PLAGENHOEF H 9
LAR333 PLAGENHOEF P 21
BSX892 PORTERFIELD H 5
BSX892 PORTERFIELD P 8
TXT894 HELLINGS H 7
TXT894 HELLINGS P 7
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file jan98dat pad lrecl=80;
        put text;
datalines;
P 1095 SMITH, HOWARD
C 01-08-98 $45.0
C 01-17-98 $37.5
P 1096 BARCLAY, NICK
C 01-09-98 $156.5
P 1097 REISCH, DEBORAH
C 01-02-98 $109.0
P 1099 WILSON, ERNEST
C 01-03-98 $45.0
C 01-05-98 $45.0
P 1107 SCOTT, JANELLE
C 01-22-98 $45.0
P 1112 BARTON, LISA
C 01-10-98 $37.0
C 01-15-98 $45.0
P 1131 THOMPSON, SUSAN
C 01-30-98 $65.0
P 1145 JONES, MARGARET
C 01-10-97 $45.0
P 1149 LAWSON, JIM
C 01-22-98 $37.0
C 01-31-98 $45.0
P 1181 SPRINGER, ADAM
C 01-26-98 $37.0
P 1201 GUNTHER, ROGER
C 01-26-97 $115.0
C 01-31-97 $18.0
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file loan pad lrecl=80;
        put text;
datalines;
1 22000    .10   60       60
1 114000   .095  360      36
1 10000    .105  36       36
2 3500     .105  12       12
2 8700     .105  24       24
2 18500    .10   60       60
3 5000     .105  48       48
3 87500    .095  360      36
3 30000    .0975 360      36
;


data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file newloans pad lrecl=80;
        put text;
datalines;
1092.10 22000 
1731.09 114000 
1289.10 10000
3144.10 3500 
1135.10 8700 
1994.10 18500 
2335.10 5000 
3864.09 87500 
3891.09 30000 
;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file memdata pad lrecl=80;
        put text;
datalines;
LEE ATHNOS
1215 RAINTREE CIRCLE
PHOENIX   AZ 85044
HEIDIE BAKER
1751 DIEHL ROAD
VIENNA    VA 22124
MYRON BARKER
131 DONERAIL DRIVE
ATLANTA   GA 30363
JOYCE BENET
85 MAPAVENUE
MENLO PARK  CA 94025
;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file orderdat pad lrecl=80;
        put text;
datalines;
123 AES358 07SEP99 HARDBACK 6
104 AES358 07SEP99 PAPER 12
104 AMZ114 31AUG99 HARDBACK 6
104 ARS102 14SEP99 HARDBACK 6
123 ARS102 14SEP99 PAPER 12
199 ASD862 31AUG99 PAPER 6
199 AZX002 07SEP99 HARDBACK 12
211 BAE487 07SEP99 PAPER 12
211 BMW243 31AUG99 PAPER 12
166 BZZ543 07SEP99 HARDBACK 6
121 CFR009 07SEP99 HARDBACK 6
211 RJH340 14SEP99 PAPER 12
121 ASD777 31AUG99 HARDBACK 6
166 NZE002 14SEP99 HARDBACK 6
108 BAE487 14SEP99 PAPER 12
166 UNM578 31AUG99 PAPER 6
108 UNM578 07SEP99 HARDBACK 12
174 LAR333 07SEP99 PAPER 12
108 BSX892 31AUG99 PAPER 6
174 TXT894 14SEP99 HARDBACK 6
;
run;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file patdata pad lrecl=80;
        put text;
datalines;
ALEX BEDWAN
609 WILTON MEADOW DRIVE
GARNER NC 27529
XM034 FLOYD
ALISON BEYER
8521 HOLLY SPRINGS ROAD
APEX NC 27502
XF124 LAWSON
LISA BONNER
109 BRAMPTON AVENUE
CARY NC 27511
XF232 LAWSON
GEORGE CHESSON
3801 WOODSIDE COURT
GARNER NC 27529
XM065 FLOYD
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file personel pad lrecl=80;
        put text;
datalines;
ADAMS, LARRY   1352
133 SALES
32,696.78
BICKETT, PAT   1238
133 SALES
35,099.50
BIRCH, CARLA   1252
133 SALES
37,098.71
CARTER, WANDA  1424
105 MARKETING
17,098.71
DAWSON, EVAN   1266
112 PUBLICATIONS
29,996.63
DODSON, WENDY  1004
101 EDUCATION
31,875.46
HARRIS, WALTER 1112
109 RESEARCH
31,875.46
JONES, HARRY   1522
101 EDUCATION
25,309.00
JORDAN, RACHEL 1143
101 EDUCATION
28,309.00
LANDE, HALLIE  1084
105 MARKETING
28,567.23
LIEBEE, MARY   1442
112 PUBLICATIONS
28,945.89
MANN, NAOMI    1331
109 RESEARCH
27,354.56
REEVES, NEAL   1255
109 RESEARCH
36,180.00
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file phonsurv pad lrecl=80;
        put text;
datalines;
1000 23 94 56 85 99
1001 26 55 49 87 85
1002 33 99 54 82 94
1003 71 33 22 44 92
1004 88 49 29 57 83
;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file powerdat pad lrecl=80;
        put text;
datalines;
17JAN99  16FEB99  1425  .0735
17FEB99  20MAR99  1374  .0735
21MAR99  18APR99  1268  .0735
19APR99  19MAY99  1218  .0735
20MAY99  19JUN99  1253  .0795
20JUN99  18JUL99  1349  .0835
19JUL99  17AUG99  1421  .0835
18AUG99  18SEP99  1475  .0835
19SEP99  18OCT99  1278  .0835
19OCT99  17NOV99  1233  .0795
18NOV99  15DEC99  1381  .0735
15DEC99  14JAN00  1402  .0735
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file pubdata pad lrecl=80;
        put text;
datalines;
ASL324 SMITH AND SONS  1998
LAS484 MAJOR UNIVERSITY PRESS  1989
IOD859 SMITH AND SONS  1988
REU701 TOWN PRESS  1995
WRE142 LITTLE FEET  1990
ITE246 RAVENPRESS  1988
AIE987 HANSON AND ASSOCIATES  1999
NWD143 TOWN PRESS  1987
FLE546 MAJOR UNIVERSITY PRESS  1996
QER306 MAJOR UNIVERSITY PRESS  1989
RGA452 RAVEN PRESS  1990
BNC430 SMITH AND SONS  1988
NPC123 BARTON BOOKS  1981
YCO574 TOWN PRESS  1992
IWA937 UNIVERSE BOOKS  1991
GCD274 RAVENPRESS  1994
UIT436 UNIVERSE BOOKS  1988
IOK257 RAVENPRESS  1990
QAH186 LITTLE FEET  1990
AIE987 HANSON AND ASSOCIATES  1999
;
run;
data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file rawdata;
        put text;
datalines;
209-20-3721 07JAN78 41983 SALES 2896
223-96-8933 03MAY86 41983 EDUCATION 2344
232-18-3845 17AUG81 41983 MARKETING 2674
251-25-9392 08SEP84 41983 RESEARCH 2956
;
run;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file saledata pad lrecl=80;
        put text;
datalines;
SMITH   JAN 140097.98 440356.70
DAVIS   JAN 385873.00 178234.00
JOHNSON JAN  98654.32 339485.00
SMITH   FEB 225983.09  12250.00
DAVIS   FEB  88456.23  55564.00
JOHNSON FEB 135837.34  32423.00
SMITH   MAR      0.00 584593.00
DAVIS   MAR  89342.00 173222.00
JOHNSON MAR 398573.90 193567.00
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file satdata1 recfm=v;
        put text;
datalines;
182-04-7814ASPDEN530
302-57-5023ATWOOD480
123-89-8470BROSNAN560
152-64-0014BROSSO780
813-63-7456CUTCHINS790
186-79-3143HOLERBACH670
187-46-5981HOLMBERG510
879-41-3513JENKE600
891-72-6989LAMBERSON490
816-74-1456LIVINGOOD620
168-41-8671MAUPIN550
185-05-8749MCBENNETT650
518-18-5024MEYER720
583-12-1458NEWTON780
845-17-8145PAINTER640
542-79-3458PITTMAN710
125-78-2853RICHARDS770
528-75-1378ROLLINS680
549-37-1542SALEEBY590
345-97-4239VICKERS730
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file satdata2 recfm=v;
        put text;
datalines;
182-04-7814 09FEB99 530 04MAY99 610
302-57-5023 09FEB99 480 04MAY99 530
123-89-8470 09FEB99 560 04MAY99 570 13JUL99 610
152-64-0014 09FEB99 780
813-63-7456 09FEB99 790
186-79-3143 09FEB99 670
187-46-5981 09FEB99 510 04MAY99 590
879-41-3513 09FEB99 600
891-72-6989 09FEB99 490 04MAY99 540 13JUL99 600
816-74-1456 09FEB99 620
168-41-8671 09FEB99 550 04MAY99 610
185-05-8749 09FEB99 650
518-18-5024 09FEB99 720
583-12-1458 09FEB99 780
845-17-8145 09FEB99 640 04MAY99 600 13JUL99 660
542-79-3458 09FEB99 710
125-78-2853 09FEB99 770
528-75-1378 09FEB99 680 04MAY99 700
549-37-1542 09FEB99 590 04MAY99 630
345-97-4239 09FEB99 730
;
run;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file stordata pad lrecl=80;
        put text;
datalines;
1000 23 94 56 85 99
1001 26 55 49 87 85
1002 33 99 54 82 94
1003 71 33 22 44 92
1004 88 49 29 57 83
;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file survey1 pad lrecl=80;
        put text;
datalines;
7 Y N Y
8 Y Y Y
9 N N
7 N Y
10 Y Y Y
6 N Y Y
7 N N Y
10 N
9 Y Y Y
8 Y N Y
10 N N Y
10 N N
10 Y Y Y
9 Y Y N
8 N Y N
8 Y
7 Y Y
9 N N Y
9 Y Y Y
7 N Y
;
run;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file tempdata pad lrecl=80;
        put text;
datalines;
01APR90 68 02APR90 67 03APR90 70
04APR90 74 05APR90 72 06APR90 73
07APR90 71 08APR90 75 09APR90 76
10APR90 78 11APR90 70 12APR90 69
13APR90 71 14APR90 72 15APR90 74
16APR90 73 17APR90 71 18APR90 75
19APR90 75 20APR90 73 21APR90 75
22APR90 77 23APR90 78 24APR90 80
25APR90 78 26APR90 77 27APR90 79
28APR90 81 29APR90 81 81APR90 84
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file tests pad lrecl=80;
        put text;
datalines;
2458 Murray, W            72  185 128 12 38 D
2462 Almers, C            68  171 133 10  5 I
2501 Bonaventure, T       78  177 139 11 13 I
2523 Johnson, R           69  162 114  9 42 S
2539 LaMance, K           75  168 141 11 46 D
2544 Jones, M             79  187 136 12 26 N
2552 Reberson, P          69  158 139 15 41 D
2555 King, E              70  167 122 13 13 I
2563 Pitts, D             71  159 116 10 22 S
2568 Eberhardt, S         72  182 122 16 49 N
2571 Nunnelly, A          65  181 141 15  2 I
2572 Oberon, M            74  177 138 12 11 D
2574 Peterson, V          80  164 137 14  9 D
2575 Quigley, M           74  152 Q13 11 26 I
2578 Cameron, L           75  158 108 14 27 I
2579 Underwood, K         72  165 127 13 19 S
2584 Takahashi, Y         76  163 135 16  7 D
2586 Derber, B            68  176 119 17 35 N
2588 Ivan, H              70  182 126 15 41 N
2589 Wilcox, E            78  189 138 14 57 I
2595 Warren, C            77  170 136 12 10 S
;
run;

data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file tests2 pad lrecl=80;
        put text;
datalines;
2458 Murray, W            72  185 128 12 38 D
2462 Almers, C            68  171 133 10  5 I
2501 Bonaventure, T       78  177 139 11 13 I
2523 Johnson, R           69  162 114  9 42 S
2539 LaMance, K           75  168 141 11 46 D
2544 Jones, M             79  187 136 12 26 N
2552 Reberson, P          69  158 139 15 41 D
2555 King, E              70  167 122 13 13 I
2563 Pitts, D             71  159 116 10 22 S
2568 Eberhardt, S         72  182 122 16 49 N
2571 Nunnelly, A          65  181 141 15  2 I
2572 Oberon, M            74  177 138 12 11 D
2574 Peterson, V          80  164 137 14  9 D
2575 Quigley, M           74  152 113 11 26 I
2578 Cameron, L           75  158 108 14 27 I
2579 Underwood, K         72  165 127 13 19 S
2584 Takahashi, Y         76  163 135 16  7 D
2586 Derber, B            68  176 119 17 35 N
2588 Ivan, H              70  182 126 15 41 N
2589 Wilcox, E            78  189 138 14 57 I
2595 Warren, C            77  170 136 12 10 S
;
run;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file topten pad lrecl=80;
        put text;
datalines;
 1 NEW YORK     7,262,700
 2 LOS ANGELES  3,259,340
 3 CHICAGO      3,009,530
 4 HOUSTON      1,728,910
 5 PHILADELPHIA  1,642,900
 6 DETROIT      1,086,220
 7 SAN DIEGO    1,015,190
 8 DALLAS       1,003,520
 9 SAN ANTONIO  914,350
10 PHOENIX      894,070
;
data _null_;
        infile cards missover length=l;
        length text $ 50;
        input text $varying50. l;
        file vandata pad lrecl=80;
        put text;
datalines;
NorthEast   1  158,510
SouthWest   4  292,801
NorthEast   3  172,301
SouthWest   1  384,220
NorthEast   2  506,510
SouthWest   3  392,202
NorthEast   4  148,510
SouthEast   1  284,720
NorthWest   2  348,803
SouthEast   3  122,220
NorthWest   4  384,840
SouthEast   1  339,880
;


   /* create SAS data sets in sasuser */

data sasuser.admit;
   input ID $ 1-4 Name $ 6-19 Sex $ 22 Age 26-27 Date 30-31
         Height 36-37 Weight 43-45 ActLevel $ 50-53 Fee 57-62;
   format fee 7.2;
datalines;
2458 Murray, W       M   27   1    72     168    HIGH    85.20
2462 Almers, C       F   34   3    66     152    HIGH   124.80
2501 Bonaventure, T  F   31  17    61     123    LOW    149.75
2523 Johnson, R      F   43  31    63     137    MOD    149.75
2539 LaMance, K      M   51   4    71     158    LOW    124.80
2544 Jones, M        M   29   6    76     193    HIGH   124.80
2552 Reberson, P     F   32   9    67     151    MOD    149.75
2555 King, E         M   35  13    70     173    MOD    149.75
2563 Pitts, D        M   34  22    73     154    LOW    124.80
2568 Eberhardt, S    F   49  27    64     172    LOW    124.80
2571 Nunnelly, A     F   44  19    66     140    HIGH   149.75
2572 Oberon, M       F   28  17    62     118    LOW     85.20
2574 Peterson, V     M   30   6    69     147    MOD    149.75
2575 Quigley, M      F   40   8    69     163    HIGH   124.80
2578 Cameron, L      M   47   5    72     173    MOD    124.80
2579 Underwood, K    M   60  22    71     191    LOW    149.75
2584 Takahashi, Y    F   43  29    65     123    MOD    124.80
2586 Derber, B       M   25  23    75     188    HIGH    85.20
2588 Ivan, H         F   22  20    63     139    LOW     85.20
2589 Wilcox, E       F   41  16    67     141    HIGH   149.75
2595 Warren, C       M   54   7    71     183    MOD    149.75
;

data sasuser.admitjune;
   input ID $ 1-4 Name $ 6-19 Sex $ 22 Age 25-26 @29 Date mmddyy8.
         Height 39-40 Weight 43-45 ActLevel $ 48-51 Fee 54-59;
   format date mmddyy8. fee 6.2;
datalines;
2588 Ivan, H         F  22  06/02/97  63  139  LOW    85.20
2586 Derber, B       M  25  06/04/97  75  188  HIGH   85.20
2458 Murray, W       M  27  06/05/97  72  168  HIGH   85.20
2572 Oberon, M       F  28  06/05/97  62  118  LOW    85.20
2544 Jones, M        M  29  06/07/97  76  193  HIGH  124.80
2574 Peterson, V     M  30  06/08/97  69  147  MOD   149.75
2501 Bonaventure, T  F  31  06/09/97  61  123  LOW   149.75
2552 Reberson, P     F  32  06/10/97  67  151  MOD   149.75
2462 Almers, C       F  34  06/12/97  66  152  HIGH  124.80
2563 Pitts, D        M  34  06/14/97  73  154  LOW   124.80
2555 King, E         M  35  06/14/97  70  173  MOD   149.75
2575 Quigley, M      F  40  06/06/97  69  163  HIGH  124.80
2589 Wilcox, E       F  41  06/17/97  67  141  HIGH  149.75
2523 Johnson, R      F  43  06/17/97  63  137  MOD   149.75
2584 Takahashi, Y    F  43  06/18/97  65  123  MOD   124.80
2571 Nunnelly, A     F  44  06/19/97  66  140  HIGH  149.75
2578 Cameron, L      M  47  06/20/97  72  173  MOD   124.80
2568 Eberhardt, S    F  49  06/21/97  64  172  LOW   124.80
2539 LaMance, K      M  51  06/22/97  71  158  LOW   124.80
2595 Warren, C       M  54  06/15/97  71  183  MOD   149.75
2579 Underwood, K    M  60  06/11/97  71  191  LOW   149.75
;
data sasuser.before;
  input name $ 1-30;
  datalines;
Mrs. Millicent Garrett Fawcett
Miss Charlotte Despard
Mrs. Emmeline Pankhurst
Miss Sylvia Pankhurst
;

data sasuser.cltrials;
   input Name $ 1-11 Sex $ 13 Placebo $ 15-17 Cholesterol $ 22-24 Triglyc 26-28 uric 30-32
   TestDate 34-42;
datalines;                              
johnson,R   F YES 30 200 180 3.7
LaMance,K   M YES 30 250 230 5.1
Eberhardt,S F NO  30 244 320 4.6
Nunnelly,A  F YES 30 210 300 4.0
Quigley,M   F NO  30 192 139 6.2
Cameron,L   M YES 30 198 150 4.3
Underwood,K M NO  30 159 110 4.9
;


data sasuser.company;
  input Name $ 1-22 Age 24-25 Sex $ 27 SSN $ 29-39;
datalines;
Morrison, Michael      32 M
Rudelich, Herbert      39 M 029-46-9261
Vincent, Martina       34 F 074-53-9892
Benito, Gisela         32 F 228-88-9649
Sirignano, Emily       12 F 442-21-8075
Harbinger, Nicholas    36 M 446-93-2122
Phillipon, Marie-Odile 28 F 776-84-5391
Gunter, Thomas         27 M 929-75-0218
;

data sasuser.credit;
   input Account $ 1-4 Name $ 6-22 Type $ 24 Transaction $ 26-31;
datalines;
1118 ART CONTUCK       D  57.69
2287 MICHAEL WINSTONE  D 145.89
6201 MARY WATERS       C  45.00
7821 MICHELLE STANTON  A 304.45
6621 WALTER LUND       C 234.76
1086 KATHERINE MORRY   A  64.98
0556 LEE McDONALD      D  70.82
7821 ELIZABETH WESTIN  C 188.23
0265 JEFFREY DONALDSON C  78.90
1010 MARTIN LYNN       D 150.55
;

data sasuser.demog;
   input ID $ 1-4 Age 6-7 Sex $ 9 Date mmddyy8.;
   format date mmddyy8.;
datalines;
A001 21 m 05/22/75
A002 32 m 06/15/63
A003 24 f 08/17/72
A004      01/27/69
A005 44 f 02/24/52
A007 39 m 11/11/57
;




data sasuser.diabetes;
   input ID $ 1-4 Sex $ 6 Age 8-9 Height 11-12 Weight 14-16
         Pulse 18-20 FastGluc 22-24 PostGluc 26-28;
datalines;
2304 F 16 61 102 100 568 625
1128 M 43 71 218  76 156 208
4425 F 48 66 162  80 244 322
1387 F 57 64 142  70 177 206
9012 F 39 63 157  68 257 318
6312 M 52 72 240  77 362 413
5438 F 42 62 168  83 247 304
3788 M 38 73 234  71 486 544
9125 F 56 64 159  70 166 215
3438 M 15 66 140  67 492 547
1274 F 50 65 153  70 193 271
3347 M 53 70 193  78 271 313
2486 F 63 65 157  70 152 224
1129 F 48 61 137  69 267 319
9723 M 52 75 219  65 348 403
8653 M 49 68 185  79 259 311
4451 M 54 71 196  81 373 431
3279 M 40 70 213  82 447 504
4759 F 60 68 164  71 155 215
6488 F 59 64 154  75 362 409
;

data sasuser.europe;
   input Flight $ 1-3 @5 Date date7. @13 Depart time5.
         Orig $ 19-21 Dest $ 23-25 Miles 27-30 Mail 32-34
         Freight 36-38 Boarded 40-42 Transferred 44-45
         NonRevenue 47 Deplaned 49-51 Capacity 53-55 DayOfMonth 57-58
         Revenue 60-65;
   format Date date7. Depart time5.;
datalines;
821 04MAR99 9:31  LGA LON 3442 403 209 167 17 7 222 250  1 150634
271 04MAR99 11:40 LGA PAR 3856 492 308 146  8 3 163 250  1 156804
271 05MAR99 12:19 LGA PAR 3857 366 498 177 15 5 227 250  1 190098
821 06MAR99 14:56 LGA LON 3442 345 243 167 13 4 222 250  1 150634
821 07MAR99 13:17 LGA LON 3635 248 307 215 14 6 158 250  1 193930
271 07MAR99 9:31  LGA PAR 3442 353 205 155 18 7 172 250  2 166470
821 08MAR99 11:40 LGA LON 3856 391 395 186  8 1 114 250  2 167772
271 08MAR99 12:19 LGA PAR 3857 366 279 152  7 4 187 250  2 163248
821 09MAR99 14:56 LGA LON 3442 219 368 203  6 3 210 250  2 183106
271 09MAR99 13:17 LGA PAR 3635 357 282 159 15 4 191 250  2 170766
821 10MAR99 9:31  LGA LON 3442 389 479 188  8 6 211 250  3 169576
271 10MAR99 11:40 LGA PAR 3856 415 463 182  9 6 153 250  3 195468
622 03MAR99 12:19 LGA FRA 3857 296 414 180 16 4 200 250  3 187636
821 03MAR99 14:56 LGA LON 3442 448 282 151 17 4 172 250  3 143561
271 03MAR99 13:17 LGA PAR 3635 352 351 147 29 7 183 250  3 123456
219 04MAR99 9:31  LGA LON 3442 331 376 232 18 0 250 250  4 189065
387 04MAR99 11:40 LGA CPH 3856 395 217  81 21 1 103 250  4 196540
622 04MAR99 12:19 LGA FRA 3857 296 232 137 14 4 155 250  4 165456
821 04MAR99 14:56 LGA LON 3442 403 209 167  9 6 182 250  4 170766
271 04MAR99 13:17 LGA PAR 3635 492 308 146 13 4 163 250  4 125632
219 05MAR99 9:31  LGA LON 3442 485 267 160  4 3 167 250  5 197456
387 05MAR99 11:40 LGA CPH 3856 393 304 142  8 2 152 250  5 134561
622 05MAR99 12:19 LGA FRA 3857 340 311 185 11 3 199 250  5 125436
271 05MAR99 13:17 LGA PAR 3635 366 498 177 22 4 203 250  5 128972
219 06MAR99 9:31  LGA LON 3442 388 298 163 14 6 183 250  6 162343
821 06MAR99 14:56 LGA LON 3442 345 243 167 16 2 185 250  6 129560
219 07MAR99 9:31  LGA LON 3442 421 356 241  9 0 250 250  7 134520
387 07MAR99 11:40 LGA CPH 3856 546 204 131  5 6 142 250  7 135632
622 07MAR99 12:19 LGA FRA 3857 391 423 210 22 5 237 250  7 107865
821 07MAR99 14:56 LGA LON 3442 248 307 215 11 5 231 250  7 196736
271 07MAR99 13:17 LGA PAR 3635 353 205 155 21 4 180 250  7 153423
219 08MAR99 9:31  LGA LON 3442 447 299 183 11 3 197 250  8 106753
387 08MAR99 11:40 LGA CPH 3856 415 367 150  9 3 162 250  8 128564
622 08MAR99 12:19 LGA FRA 3857 346   . 176  5 6 187 250  8 178543
821 08MAR99 14:56 LGA LON 3442 391 395 186 11 5 202 250  8 125344
271 08MAR99 13:17 LGA PAR 3635 366 279 152 20 4 176 250  8 133345
219 09MAR99 9:31  LGA LON 3442 356 547 211 18 6 235 250  9 122766
387 09MAR99 11:40 LGA CPH 3856 363 297 128 14 3 145 250  9 134523
622 09MAR99 12:19 LGA FRA 3857 317 421 173 11 5 189 250  9 100987
821 09MAR99 14:56 LGA LON 3442 219 368 203 11 4 218 250  9 166543
271 09MAR99 13:17 LGA PAR 3635 357 282 159 18 5 182 250  9 126543
219 10MAR99 9:31  LGA LON 3442 272 370 167  7 7 181 250 10 198744
387 10MAR99 11:40 LGA CPH 3856 336 377 154 18 5 177 250 10 109885
622 10MAR99 12:19 LGA FRA 3857 272 363 129 12 6 147 250 10 134459
821 10MAR99 14:56 LGA LON 3442 389 479 188  5 4 197 250 10 129745
271 10MAR99 13:17 LGA PAR 3635 415 463 182  9 7 198 250 10 134976
;

data sasuser.finance;
  input SSN $ 1-11 Name $ 13-24 Salary 26-30 +1 Date mmddyy6.;
  format date mmddyy8.;
  datalines;
074-53-9892 Vincent      35000 052297
776-84-5391 Phillipon    29750 121596
929-75-0218 Gunter       27500 043097
446-93-2122 Harbinger    33900 070896
228-88-9649 Benito       28000 030496
029-46-9261 Rudelich     35000 021595
442-21-8075 Sirignano     5000 112295
;
data sasuser.fitclass;
   input Name $ weight1 weight2 weight3 weight4 weight5 weight6;
datalines;
Alicia  69.6 68.9 68.8 67.4 66.0 66.2
Betsy   52.6 52.6 51.7 50.4 49.8 49.1
Brenda  68.6 67.6 67.0 66.4 65.8 65.2
Carl    67.6 66.6 66.0 65.4 64.8 64.2
Carmela 63.6 62.5 61.9 61.4 60.8 58.2
David   70.6 69.8 69.2 68.4 67.8 67.0
;
data sasuser.funddrive;
   input LastName $ 1-9 Qtr1 15-16 Qtr2 23-24 Qtr3 31-32 Qtr4 39-40;
datalines;
ADAMS         18      18      20      20
ALEXANDER     15      18      15      10
APPLE         25      25      25      25
ARTHUR        10      25      20      30
AVERY         15      15      15      15
BAREFOOT      20      20      20      20
BAUCOM        25      20      20      30
BLAIR         10      10       5      10
BLALOCK        5      10      10      15
BOSTIC        20      25      30      25
BRADLEY       12      16      14      18
BRADY         20      20      20      20
BROWN         18      18      18      18
BRYANT        16      18      20      18
BURNETTE      10      10      10      10
CHEUNG        30      30      30      30
LEHMAN        20      20      20      20
VALADEZ       14      18      40      25
;

data sasuser.funddrv;
   input LastName $ 1-9 Qtr1 15-16 Qtr2 23-24 Qtr3 31-32 Qtr4 39-40;
datalines;
ADAMS         18      18      20      20
ALEXANDER     15      18      15      10
APPLE         25      25      25      25
ARTHUR        10      25      20      30
AVERY         15      15      15      15
BAREFOOT      20      20      20      20
BAUCOM        25      20      20      30
BLAIR         10      10       5      10
BLALOCK        5      10      10      15
BOSTIC        20      25      30      25
BRADLEY       12      16      14      18
BRADY         20      20      20      20
BROWN         18      18      18      18
BRYANT        16      18      20      18
BURNETTE      10      10      10      10
CHEUNG        30      30      30      30
LEHMAN        20      20      20      20
VALADEZ       14      18      40      25
;



data sasuser.heart;
   input Patient $ 1-3 Sex 8 Survive $ 12-15 Shock $ 19-26
         Arterial 31-33 Heart 38-40 Cardiac 45-47 Urinary 53-55;
datalines;
203    1   SURV   NONSHOCK     88     95     66     110
 54    1   DIED   HYPOVOL      83    183     95       0
664    2   SURV   CARDIO       72    111    332      12
210    2   DIED   BACTER       74     97    369       0
101    2   DIED   NEURO        80    130    291       0
102    2   SURV   OTHER        87    107    471      65
529    1   DIED   CARDIO      103    106    217      15
524    2   DIED   CARDIO      145     99    156      10
426    1   SURV   OTHER        68     77    410      75
509    2   SURV   OTHER        79     84    256      90
742    1   DIED   HYPOVOL     100     54    135       0
609    2   DIED   NONSHOCK     93    101    260      90
318    2   DIED   OTHER        72     81    410     405
412    1   SURV   BACTER       61     87    296      44
601    1   DIED   BACTER       84    101    260     377
402    1   SURV   CARDIO       88    137    312      75
 98    2   SURV   CARDIO       84     87    260     377
  4    1   SURV   HYPOVOL      81    149    406     200
 50    2   SURV   HYPOVOL      72    111    332      12
  2    2   DIED   OTHER       101    114    424      97
;

data sasuser.insure;
   input ID $ 1-4 Name $ 6-19 Policy $ 21-25 Company $ 27-37
         PctInsured 39-41 Total 43-49 BalanceDue 57-62;
   format balancedue 6.2;
datalines;
2458 Murray, W      32668 MUTUALITY   100   98.64         0.00
2462 Almers, C      95824 RELIABLE     80  780.23       156.05
2501 Bonaventure, T 87795 A&R          80   47.38         9.48
2523 Johnson, R     39022 ACME         50  122.07        61.04
2539 LaMance, K     63265 PARNASSUS    50   87.35        43.68
2544 Jones, M       92478 ESSENTIAL    80  262.08        52.42
2552 Reberson, P    25530 USA INC.     60  518.53       207.41
2555 King, E        18744 ACME         80  135.97        27.19
2563 Pitts, D       60976 HOMELIFE     80 1554.12       310.82
2568 Eberhardt, S   81589 RURITAN      50  346.33       173.17
2571 Nunnelly, A    99120 EMPLOYERS   100  583.55         0.00
2572 Oberon, M      44544 ACME        100 4537.77         0.00
2574 Peterson, V    75986 FRED SMYTHE  60  569.99       228.00
2575 Quigley, M     97048 RELIABLE     50  198.01        99.01
2578 Cameron, L     42351 COVINGTON    50  222.82       111.41
2579 Underwood, K   14592 ESSENTIAL   100  541.64         0.00
2584 Takahashi, Y   54219 FRED SMYTHE  60  466.46       186.58
2586 Derber, B      74653 RELIABLE     60  590.28       236.11
2588 Ivan, H        83809 HOMELIFE    100  474.50         0.00
2589 Wilcox, E      94034 ACME         60  530.49       212.20
2595 Warren, C      20347 RELIABLE     60  411.11       164.44
;

data sasuser.laguardia;
   input Flight $ 1-3 @5 Date date7. @14 Depart time5.
         Orig $ 22-24 Dest $ 28-30 Boarded 33-35
         Transferred 38-39 Deplaned 42-44 Revenue 47-52;
   format Date date7. Depart time5.;
datalines;
219 04MAR99  9:31    LGA   LON  232  18  250  189065
219 05MAR99  9:31    LGA   LON  160   4  167  197456
219 06MAR99  9:31    LGA   LON  163  14  183  162343
219 07MAR99  9:31    LGA   LON  241   9  250  134520
219 08MAR99  9:31    LGA   LON  183  11  197  106753
219 09MAR99  9:31    LGA   LON  211  18  235  122766
219 10MAR99  9:31    LGA   LON  167   7  181  198744
271 04MAR99  11:40   LGA   PAR  146   8  163  156804
271 05MAR99  12:19   LGA   PAR  177  15  227  190098
271 07MAR99  9:31    LGA   PAR  155  18  172  166470
271 08MAR99  12:19   LGA   PAR  152   7  187  163248
271 09MAR99  13:17   LGA   PAR  159  15  191  170766
271 10MAR99  11:40   LGA   PAR  182   9  153  195468
271 03MAR99  13:17   LGA   PAR  147  29  183  123456
271 04MAR99  13:17   LGA   PAR  146  13  163  125632
271 05MAR99  13:17   LGA   PAR  177  22  203  128972
271 07MAR99  13:17   LGA   PAR  155  21  180  153423
271 08MAR99  13:17   LGA   PAR  152  20  176  133345
271 09MAR99  13:17   LGA   PAR  159  18  182  126543
271 10MAR99  13:17   LGA   PAR  182   9  198  134976
387 04MAR99  11:40   LGA   CPH   81  21  103  196540
387 05MAR99  11:40   LGA   CPH  142   8  152  134561
387 07MAR99  11:40   LGA   CPH  131   5  142  135632
387 08MAR99  11:40   LGA   CPH  150   9  162  128564
387 09MAR99  11:40   LGA   CPH  128  14  145  134523
387 10MAR99  11:40   LGA   CPH  154  18  177  109885
622 03MAR99  12:19   LGA   FRA  180  16  200  187636
622 04MAR99  12:19   LGA   FRA  137  14  155  165456
622 05MAR99  12:19   LGA   FRA  185  11  199  125436
622 07MAR99  12:19   LGA   FRA  210  22  237  107865
622 08MAR99  12:19   LGA   FRA  176   5  187  178543
622 09MAR99  12:19   LGA   FRA  173  11  189  100987
622 10MAR99  12:19   LGA   FRA  129  12  147  134459
821 04MAR99  9:31    LGA   LON  167  17  222  150634
821 06MAR99  14:56   LGA   LON  167  13  222  150634
821 07MAR99  13:17   LGA   LON  215  14  158  193930
821 08MAR99  11:40   LGA   LON  186   8  114  167772
821 09MAR99  14:56   LGA   LON  203   6  210  183106
821 10MAR99  9:31    LGA   LON  188   8  211  169576
821 03MAR99  14:56   LGA   LON  151  17  172  143561
821 04MAR99  14:56   LGA   LON  167   9  182  170766
821 06MAR99  14:56   LGA   LON  167  16  185  129560
821 07MAR99  14:56   LGA   LON  215  11  231  196736
821 08MAR99  14:56   LGA   LON  186  11  202  125344
821 09MAR99  14:56   LGA   LON  203  11  218  166543
821 10MAR99  14:56   LGA   LON  188   5  197  129745
;

data sasuser.loans;
   input Account $ 1-8 Amount 10-15 Rate 17-21 Months 23-25
         Payment 27-32;
   format amount dollar8. rate percent8.2 payment dollar10.2;
datalines;
101-1092  22000 .10    60 467.43
101-1731 114000 .095  360 958.57
101-1289  10000 .105   36 325.02
101-3144   3500 .105   12 308.52
103-1135   8700 .105   24 403.47
103-1994  18500 .10    60 393.07
103-2335   5000 .105   48 128.02
103-3864  87500 .095  360 735.75
103-3891  30000 .0975 360 257.75
;


data sasuser.measure;
   input ID $ 1-4 Height 6-7 Weight 9-11;
datalines;
1129 61 137
1387 64 142
2304 61 102
5438 62 168
6488 64 154
9012 63 157                  
;

data sasuser.newloans;
   input Account $ 1-8 Amount 10-15 Rate 17-21 Months 23-25
         Payment 27-32;
   format amount dollar8. rate percent8.2 payment dollar10.2;
datalines;
101-1092  22000 .10    60 467.43
101-1731 114000 .095  360 958.57
101-1289  10000 .105   36 325.02
101-3144   3500 .105   12 308.52
103-1135   8700 .105   24 403.47
103-1994  18500 .10    60 393.07
103-2335   5000 .105   48 128.02
103-3864  87500 .095  360 735.75
103-3891  30000 .0975 360 257.75
;


data sasuser.newadmit;
   input ID $ 1-4 Name $ 6-19 Sex $ 21 Age 23-24 Date 26-27
         Height 29-30 Weight 32-34 ActLevel $ 36-39 Fee 41-46
         MeterHgt 48-54 KgWgt 56-62;
   format fee 6.2 meterhgt 7.5 kgwgt 7.4;
datalines;
2458 Murray, W      M 27  1 72 168 HIGH  85.20 1.82880 76.3636
2462 Almers, C      F 34  3 66 152 HIGH 124.80 1.67640 69.0909
2501 Bonaventure, T F 31 17 61 123 LOW  149.75 1.54940 55.9091
2523 Johnson, R     F 43 31 63 137 MOD  149.75 1.60020 62.2727
2539 LaMance, K     M 51  4 71 158 LOW  124.80 1.80340 71.8182
2544 Jones, M       M 29  6 76 193 HIGH 124.80 1.93040 87.7273
2552 Reberson, P    F 32  9 67 151 MOD  149.75 1.70180 68.6364
2555 King, E        M 35 13 70 173 MOD  149.75 1.77800 78.6364
2563 Pitts, D       M 34 22 73 154 LOW  124.80 1.85420 70.0000
2568 Eberhardt, S   F 49 27 64 172 LOW  124.80 1.62560 78.1818
2571 Nunnelly, A    F 44 19 66 140 HIGH 149.75 1.67640 63.6364
2572 Oberon, M      F 28 17 62 118 LOW   85.20 1.57480 53.6364
2574 Peterson, V    M 30  6 69 147 MOD  149.75 1.75260 66.8182
2575 Quigley, M     F 40  8 69 163 HIGH 124.80 1.75260 74.0909
2578 Cameron, L     M 47  5 72 173 MOD  124.80 1.82880 78.6364
2579 Underwood, K   M 60 22 71 191 LOW  149.75 1.80340 86.8182
2584 Takahashi, Y   F 43 29 65 123 MOD  124.80 1.65100 55.9091
2586 Derber, B      M 25 23 75 188 HIGH  85.20 1.90500 85.4545
2588 Ivan, H        F 22 20 63 139 LOW   85.20 1.60020 63.1818
2589 Wilcox, E      F 41 16 67 141 HIGH 149.75 1.70180 64.0909
2595 Warren, C      M 54  7 71 183 MOD  149.75 1.80340 83.1818
;

data sasuser.patients;
   input ID $ 1-4 Sex $ 6 Age 8-9;
datalines;
1129 F 48
1837 F 57
2304 F 16
2486 F 63
4759 F 60
5438 F 42
6488 F 59
9012 F 39
9125 F 56
;

data sasuser.records;
   input Account $ 1-8 Amount 10-14 Rate 16-20 Months 22-24
         Payment 26-31 Code $ 33;
   format amount dollar8. rate percent8.2 payment dollar7.2;
datalines;
101-1092 22000 .10    60 467.43 1
101-1731 14000 .095  360 958.57 2
101-1289 10000 .105   36 325.02 2
101-3144  3500 .105   12 308.52 1
103-1135  8700 .105   24 403.47 1
103-1994 18500 .10    60 393.07 2
103-2335  5000 .105   48 128.02 1
103-3864 87500 .095  360 735.75 1
103-3891 30000 .0975 360 257.75 2
;
run;

data sasuser.repertory;
  input Play $ 1-19 Role $ 21-37 SSN $ 39-49 @51 Date mmddyy6.;
  format date mmddyy8.;
  datalines;
The Glass Menagerie Jim O'Connor      029-46-9261 092397
The Dear Departed   Henry Slater      029-46-9261 112297
No Exit             Estelle           074-53-9892 071197
Happy Days          Winnie            074-53-9892 081397
The Dear Departed   Mrs. Jordan       074-53-9892 112297
The Glass Menagerie Amanda Wingfield  228-88-9649 092397
The Dear Departed   Mrs. Slater       228-88-9649 112297
The Dear Departed   Victoria Slater   442-21-8075 112297
No Exit             Garcin            446-93-2122 071197
Happy Days          Willie            446-93-2122 081397
The Dear Departed   Ben Jordan        446-93-2122 112297
No Exit             Inez              776-84-5391 071197
The Glass Menagerie Laura Wingfield   776-84-5391 092397
No Exit             Valet             929-75-0218 071197
The Glass Menagerie Tom Wingfield     929-75-0218 092397
The Dear Departed   Abel Merryweather 929-75-0218 112297
;

data sasuser.reps;
   attrib IDnum length=$4;
   attrib LastName length=$10;
   attrib FirstName length=$8;
   attrib City length=$10;
   attrib State length=$2;
   attrib Sex length=$1;
   attrib JobCode length=$3;
   attrib Salary length=8 format=8.2;
   attrib Birth length=8 format=DATE7.;
   attrib Hired length=8 format=DATE7.;
   attrib HomePhone length=$12;

   infile datalines dsd;
   input
      IDnum
      LastName
      FirstName
      City
      State
      Sex
      JobCode
      Salary
      Birth
      Hired
      HomePhone
;
datalines4;
1269,CASTON,FRANKLIN,STAMFORD,CT,M,NA1,41690,126,7640,203/781-3335
1935,FERNANDEZ,KATRINA,BRIDGEPORT,CT,,NA2,51081,-6485,3579,203/675-2962
1417,NEWKIRK,WILLIAM,PATERSON,NJ,",",NA2,52270,-2741,6278,201/732-6611
1839,NORRIS,DIANE,NEW YORK,YN,F,NA1,43433,-395,7857,718/384-1767
1111,RHODES,JEREMY,PRINCETON,NJ,M,NA1,40586,563,7612,201/812-1837
1352,RIVERS,SIMON,NEW YORK,NY,M,NA2,5379.8,-4044,5405,718/383-3345
1332,STEPHENSON,ADAM,BRIDGEPORT,CT,M,NA1,42178,-468,7097,203/675-1497
1443,WELLS,AGNES,STAMFORD,CT,F,NA1,422.74,-1137,7183,203/781-5546
;;;;
run;
data sasuser.sch;
   input Program $ 1-21 Producer $ 23-26 @28 AirDate mmddyy10.;
   format AirDate mmddyy8.;
datalines;
All Things Considered NPR  04/12/2000
BBC World             BBC  04/04/2000
Morning Edition       NPR  04/13/2000
River to River        NPR  04/01/2000
World Cafe            WXPN 04/08/2000
Talk of the Town      NPR  04/04/2000
Classical Music       NPR  04/08/2000
Symphony Live         NPR  04/01/2000
All Things Considered NPR  04/19/2000
Morning Edition       NPR  04/14/2000
BBC World             BBC  04/06/2000
Morning Edition       NPR  04/17/2000
BBC World             BBC  04/07/2000
Morning Edition       NPR  04/18/2000
BBC World             BBC  04/10/2000
Morning Edition       NPR  04/20/2000
Symphony Live         NPR  04/16/2000
World Cafe            WXPN 04/08/2000
;
data sasuser.stress;
   input ID $ 1-4 Name $ 6-19 RestHR 23-24 MaxHR 29-31
         RecHR 35-37 TimeMin 43-44 TimeSec 51-52
         Tolerance $ 58;
datalines;
2458 Murray, W        72    185   128     12      38     D
2462 Almers, C        68    171   133     10       5     I
2501 Bonaventure, T   78    177   139     11      13     I
2523 Johnson, R       69    162   114      9      42     S
2539 LaMance, K       75    168   141     11      46     D
2544 Jones, M         79    187   136     12      26     N
2552 Reberson, P      69    158   139     15      41     D
2555 King, E          70    167   122     13      13     I
2563 Pitts, D         71    159   116     10      22     S
2568 Eberhardt, S     72    182   122     16      49     N
2571 Nunnelly, A      65    181   141     15       2     I 
2572 Oberon, M        74    177   138     12      11     D
2574 Peterson, V      80    164   137     14       9     D
2575 Quigley, M       74    152   113     11      26     I
2578 Cameron, L       75    158   108     14      27     I
2579 Underwood, K     72    165   127     13      19     S
2584 Takahashi, Y     76    163   135     16       7     D
2586 Derber, B        68    176   119     17      35     N
2588 Ivan, H          70    182   126     15      41     N
2589 Wilcox, E        78    189   138     14      57     I
2595 Warren, C        77    170   136     12      10     S
;

data sasuser.stress2;
   input ID $ 1-4 Name $ 6-19 RestHR 23-24 MaxHR 29-31
         RecHR 35-37 TimeMin 43-44 TimeSec 51-52
         Tolerance $ 58;
datalines;
2458 Murray, W        72    185   128     12      38     D
2462 Almers, C        68    171   133     10       5     I
2501 Bonaventure, T   78    177   139     11      13     I
2523 Johnson, R       69    162   114      9      42     S
2539 LaMance, K       75    168   141     11      46     D
2544 Jones, M         79    187   136     12      26     N
2552 Reberson, P      69    158   139     15      41     D
2555 King, E          70    167   122     13      13     I
2563 Pitts, D         71    159   116     10      22     S
2568 Eberhardt, S     72    182   122     16      49     N
2571 Nunnelly, A      65    181   141     15       2     I
2572 Oberon, M        74    177   138     12      11     D
2574 Peterson, V      80    164   137     14       9     D
2575 Quigley, M       74    152   113     11      26     I
2578 Cameron, L       75    158   108     14      27     I
2579 Underwood, K     72    165   127     13      19     S
2584 Takahashi, Y     76    163   135     16       7     D
2586 Derber, B        68    176   119     17      35     N
2588 Ivan, H          70    182   126     15      41     N
2589 Wilcox, E        78    189   138     14      57     I
2595 Warren, C        77    170   136     12      10     S
;

data sasuser.stress98;
   input ID $ 1-4 Name $ 8-19 RestHR 25-26 MaxHR 33-35 RecHR 41-43
         TimeMin 51-52 TimeSec 61-62 Tolerance $ 70 Year 75-78;
datalines;
2458   Murray, W        72      185     128       12        38       D    1998
2462   Almers, C        68      171     133       10         5       I    1998
2523   Johnson, R       69      162     114        9        42       S    1998
2539   LaMance, K       75      168     141       11        46       D    1998
2555   King, E          70      167     122       13        13       I    1998
2563   Pitts, D         71      159     116       10        22       S    1998
2572   Oberon, M        74      177     138       12        11       D    1998
2574   Peterson, V      80      164     137       14         9       D    1998
2575   Quigley, M       74      152     113       11        26       I    1998
2584   Takahashi, Y     76      163     135       16         7       D    1998
2586   Derber, B        68      176     119       17        35       N    1998
2589   Wilcox, E        78      189     138       14        57       I    1998
;

data sasuser.stress99;
   input ID $ 1-4 Name $ 7-18 RestHR 25-26 MaxHR 32-34 RecHR 39-41
         TimeMin 48-49 TimeSec 57-58 Tolerance $ 65 Year 70-73;
datalines;
2501  Bonaventure, T    78     177    139      11       13      I    1999
2544  Jones, M          79     187    136      12       26      N    1999
2552  Reberson, P       69     158    139      15       41      D    1999
2568  Eberhardt, S      72     182    122      16       49      N    1999
2571  Nunnelly, A       65     181    141      15        2      I    1999
2578  Cameron, L        75     158    108      14       27      I    1999
2579  Underwood, K      72     165    127      13       19      S    1999
2588  Ivan, H           70     182    126      15       41      N    1999
2595  Warren, C         77     170    136      12       10      S    1999
;

data sasuser.stresstest;
   input ID $ 1-4 Name $ 7-20 RestHR 25-26 MaxHR 32-34 RecHR 39-41
         TimeMin 48-49 TimeSec 57-58 Tolerance $ 65 @70 Date mmddyy8.;
   format date mmddyy8.;
datalines;
                        72     185    128      12       38      D    05/22/97
2462  Almers, C         68     171    133      10        5      I    05/22/97
2501  Bonaventure, T    78     177    139      11       13      I    05/23/97
2578  Cameron, L         .     158    108      14       27      I    05/23/97
2586  Derber, B         68     176    119      17       35      N    05/23/97
2568  Eberhardt, S      72     182    122      16       49           05/24/97
2588  Ivan, H           70     182    126      15       41      N    05/24/97
2523  Johnson, R        69     162    114       9       42      S    05/24/97
2544  Jones, M          79     187      .      12       26      N    05/25/97
2555  King, E           70     167    122      13       13      I    05/25/97
2539  LaMance, K        75     168    141      11       46      D    05/26/97
2571  Nunnelly, A       65     181    141      15        2      I    05/26/97
2572  Oberon, M         74     177    138      12       11      D    05/27/97
2574  Peterson, V       80     164    137      14        9      D    05/27/97
2563  Pitts, D          71     159    116      10       22      S    05/28/97
2575  Quigley, M        74     152    113      11       26      I    05/28/97
2552  Reberson, P       69     158    139      15       41      D    05/29/97
2584  Takahashi, Y      76     163    135      16        7      D    05/29/97
2579  Underwood, K      72     165    127      13       19      S    05/30/97
2595  Warren, C         77     170    136      12       10      S    05/30/97
2589  Wilcox, E         78     189    138      14       57      I    05/31/97
;

data sasuser.survey;
   input FirstName $ 1-8 Item1 10 Item2 13 Item3 16 Item4 19
         Item5 22 Item6 25 Item7 28 Item8 31 Item9 34
         Item10 37 Item11 40 Item12 43 Item13 46 Item14 49
         Item15 52 Item16 55 Item17 58 Item18 61;

datalines;
Alicia   4  3  5  4  3  4  1  2  2  3  1  2  2  3  1  1  2  3
Bernard  2  1  4  3  1  2  5  4  5  2  5  3  4  5  5  3  4  5
Betsy    5  3  4  5  5  4  4  4  3  5  4  3  4  2  3  5  2  3
Carmela  4  5  4  2  3  5  2  1  2  3  2  3  1  2  3  1  4  2
;

data work.talent1;
   input LastName $ 1-13 FirstName $ 15-22 Address1 $ 24-44
         Address2 $ 46-61 @63 Rate dollar6.;
   format rate dollar6.;

datalines;
SAMUELS       LAWRENCE 123 PEACHBLOSSOM LANE WILLIAMS, NJ     $1,200
INGER         STEVEN   4 LAKEVIEW DR         RIVERTON, NJ     $2,400
NARANJA       IGNES    666 TORROBA           CENTERVILLE, NJ  $2,400
LEBEAU        MARTINE  4434 CENTER AVE.      JEFFERSON, NJ    $2,100
OPULEE        FELICIA  5 QUINCE BLVD         KNEELAND, NJ     $3,600
EATON         AARON    75 SORRELL LAKE DRIVE MERCED, NJ       $1,800
NEWTON        ISAH     8 HOLLY LANE          RIVERTON, NJ     $2,400
WILLOBY       CHESTER  900 STAR ROUTE DRIVE  WINTSON, NJ      $2,700
HOLLOWAY      RANDY    67 H STREET           RIVERTON, NJ     $3,600
JACOBY        WILMA    789A DEPARTURE ROAD   CHESAPEAKE, NJ   $1,200
BUXTER        JEROME   127 SILT STREET       HILLSBORO, NJ    $2,700
HARGROVE      BRADLEY  5721 INVERNESS LANE   CANTON, NJ       $1,800
GARDE         OLGA     45 FIFTH STREET       CANTON, NJ       $2,400
RUFFLE        ROSE     3 FOIL AVE            MOUNTAINVIEW, NJ $2,700
TURLINGTON    BETTY    090 JICAMA STREET     WASHINGTON, NJ   $2,100
THORNER       CHARLES  1111 TELEGRAPH AVE    TAYLOR, NJ       $2,700
BRIETENBERGER WALDO    6 HIGHLAND BLVD       STANTON, NJ      $2,400
WESTLEY       KIP      868 MESA DRIVE        GLENVIEW, NJ     $2,700
DORTON        DAVID    7 OVERLAND ROAD       JEFFERSON, NJ    $2,100
SPECTOR       TERRI    8 FILDEN CIRCLE       STANFORD, NJ     $2,400
NOME          HORACE   6 OAKTREE LANE        PITTSBORO, NJ    $2,400
HOLDEN        RHETT    89 SPOONS DRIVE       HOLDON, NJ       $2,700
LAKER         DORIS    80 SETTING CIRCLE     HOLDON, NJ       $2,700
SPECTRUM      TERRI    8 HIDDEN CIRCLE       EDGETON, NJ      $2,400
;

data work.talent2;
   input Agency $ 1-20 Comment $ 22-51;
datalines;
TALENT TALENT TALENT southern accent
GEORGE STICKS        industrial
UNIVERSAL            directing,speaks spanish
HORIZONS             commercials,french accent
SYCAMORE             mime award winner
GOLDEN GUILD
GOLDEN GUILD         radio broadcasting,dialects
ACTORS SQUARE        british accent,commercials
LAURELS              producer,writer
ARTS TALENT
FINDERS              film
ALL STARS            stage,directing,commercials
ALL STARS            sports casting
ALL STARS            stuntman,speaks french
UNLIMITED            film
STARS AND STRIPES    age range 30-45
SETTINGS             extensive dp video training
STARS AND STRIPES    rodeo
UNIVERSAL LIGHTS     speaks spanish,several accents
MODELS AND MAGIC     modeling,singing,mostly stage
HORIZONS
HARDY STELSON        newscaster,ex dj
AKA TALENT           stage only
MODELS AND MAGIC     modeling,singing,stage
;

data work.talent3;
   input ID $ 1-4 Phone 6-12 @14 LastHired date9.
         @24 BirthDate date9. Height $ 34-35 Month 37-38 Day 40-41;
   format lasthired birthdate date9.;
datalines;
327M 5553489 08APR2000 25APR1978 69  4  8
102M 5556012 20AUG1999 16MAR1955 70  8 20
131F 5556781 16MAY1999 10SEP1976 64  6 25
709F 5554023 25JUN1999 08JAN1962 69  9 17
056F 5559909 17SEP1999 31JAN1930 59 12 10
287M 5557024 10DEC1999 14JUL1969 78 11 23
097F 5557045 23NOV1999 17AUG1972 68 11 12
070M 5555602 12NOV1999 14FEB1946 71  3 27
217M 5558114 27MAR2000 19MAY1963 71  7 18
118F 5559100 11OCT1999 06OCT1977 66 12  2
187M 5553688 18JUL1999 22MAR1925 76  1  7
035M 5555131 02DEC1999 23JUN1974 70 12  6
254F 5554950 07JAN2000 27FEB1940 63  8 25
167F 5558333 06DEC1999 27OCT1969 69  5 22
093F 5552525 25AUG1999 05NOV1963 57  2 25
261M 5557831 22MAY1999 01NOV1965 70 11 15
088M 5551006 25FEB2000 28MAY1950 69  9 17
134M 5559945 15NOV1999 16AUG1959 73 11  1
207M 5556563 17SEP1999 15APR1947 67 11 25
158F 5555613 01NOV1999 10JAN1971 65 10 28
065M 5552709 04DEC1999 23JUL1964 60  9 30
288M 5551856 25NOV1999 01JUL1965 73  2 22
134F 5554442 28OCT1999 18SEP1979 69  5  5
025F 5552442 30SEP1999 07MAY1971 65 10 15
;

data sasuser.talent;
   merge work.talent1 work.talent2 work.talent3;
   format rate dollar6. lasthired birthdate date9.;
run;

data sasuser.therapy;
   input Date $ 1-7 AerClass 14-15 WalkJogRun 22-24 Swim 30-31;
datalines;
JAN1999      56       78     14
FEB1999      32      109     19
MAR1999      35      106     22
APR1999      47      115     24
MAY1999      55      121     31
JUN1999      61      114     67
JUL1999      67      102     72
AUG1999      64       76     77
SEP1999      78       77     54
OCT1999      81       62     47
NOV1999      84       31     52
DEC1999     102       44     55
JAN2000      37       91     83
FEB2000      41      102     27
MAR2000      52       98     19
APR2000      61      118     22
MAY2000      49       88     29
JUN2000      24      101     54
JUL2000      45       91     69
AUG2000      63       65     53
SEP2000      60       49     68
OCT2000      78       70     41
NOV2000      82       44     58
DEC2000      93       57     47
;

data sasuser.therapy1999;
   input Month $ 1-2 Year 10-13 AerClass 20-21 WalkJogRun 29-31
         Swim 37-38;
datalines;
01       1999      26        78     14
02       1999      32       109     19
03       1999      15       106     22
04       1999      47       115     24
05       1999      95       121     31
06       1999      61       114     67
07       1999      67       102     72
08       1999      24        76     77
09       1999      78        77     54
10       1999      81        62     47
11       1999      84        31     52
12       1999      92        44     55
;

data sasuser.therapy2000;
   input Month $ 1-2 Year 10-13 AerClass 20-21 WalkJogRun 29-31
         Swim 37-38;
datalines;
01       2000      37        91     83
02       2000      41       102     27
03       2000      52        98     19
04       2000      61       118     22
05       2000      49        88     29
06       2000      24       101     54
07       2000      45        91     69
08       2000      63        65     53
09       2000      60        49     68
10       2000      78        70     41
11       2000      82        44     58
12       2000      93        57     47
;

data sasuser.totals2000;
   input Month $ 1-2 Therapy 11-13 NewAdmit 23-25 Treadmill 35-36;
datalines;
01        211          27         11
02        210          63         43
03        179          11          2
04        224          52         36
05        134          76         57
06        249          83         66
07        185         101         68
08        211          49         34
09        147         124         87
10        159         131         89
11        124          72         56
12        157          96         29
;

data sasuser.usa;  
   input Dept $ 1-5 WageCat $ 7 WageRate  9-15 
         Manager $ 17-23 JobType  25-27;
   datalines;
ADM10 S 3392.50 Coxe    3
ADM10 S 3420.00 Coxe    50
ADM10 S 6862.50 Coxe    50
ADM10 H   13.65 Coxe    240
ADM20 S 4522.50 Coxe    240
ADM20 S 2960.00 Delgado 240
ADM20 S 5260.00 Delgado 240
ADM20 S 1572.50 Delgado 420
ADM30 S 3819.20 Delgado 420
ADM30 S 1813.30 Delgado 440
CAM10 S 6855.90 Overby  1
CAM10 S 4045.80 Overby  5
CAM20 S 4480.50 Overby  10
ADM10 S 5910.80 Overby  20
CAM10 S 9073.80 Overby  20
;
data sasuser.visit;
   input ID $ 1-4 Visit $ 6-7 SysBP 8-10 DiasBP 12-13 Weight 15-17 Date mmddyy8.;
   format date mmddyy8.;
datalines;
A001 1 140 85 195 11/05/98
A001 2 138 90 198 10/13/98
A001 3 145 95 200 07/04/98
A002 1 121 75 168 04/14/98
A003 1 118 68 125 08/12/98
A003 2 112 65 123 08/21/98
A004 1 143 86 204 03/30/98
A005 1 132 76 174 02/27/98
A005 2 132 78 175 07/11/98
A005 3 134 78 176 04/16/98
A008 1 126 80 182 05/22/98
;




/* remove unwanted temporary data sets **********************************************************/

proc datasets library=work nodetails nolist;
   delete talent1 talent2;
run;
quit;

data sasuser.mechanics;
   attrib ID length=$4;
   attrib LastName length=$9;
   attrib FirstName length=$9;
   attrib City length=$12;
   attrib State length=$2;
   attrib Gender length=$1;
   attrib Salary length=8 format=8.2;
   attrib Birth length=8 format=DATE7.;
   attrib Hired length=8 format=DATE7.;
   attrib HomePhone length=$12;
   attrib SSN length=8;
   attrib JobCategory length=$2;
   attrib JobLevel length=$1;

   infile datalines dsd;
   input
      ID
      LastName
      FirstName
      City
      State
      Gender
      Salary
      Birth
      Hired
      HomePhone
      SSN
      JobCategory
      JobLevel
   ;
datalines4;
1653,ALEXANDER,SUSAN,BRIDGEPORT,CT,G,35108,-2631,6798,203/675-7715,,ME,2
1400,APPLE,TROY,NEW YORK,NY,M,29769,-1515,6866,212/586-0808,,ME,1
1499,BAREFOOT,JOSEPH,PRINCETON,NJ,M,43025,-6456,3083,201/812-5665,,ME,3
1403,BOWDEN,EARL,BRIDGEPORT,CT,M,28072,-1065,7297,203/675-3434,,ME,1
1782,BROWN,JASON,STAMFORD,CT,M,35345,-390,7360,203/781-0019,,ME,2
1244,BRYANT,LEONARD,NEW YORK,NY,M,,-3042,5863,718/383-3334,,ME,2
1065,CHAPMAN,NEIL,NEW YORK,NY,M,35090,-10199,5488,718/384-5618,,ME,2
1129,COOK,BRENDA,NEW YORK,NY,F,3492.9,-3673,7171,718/383-2313,,ME,2
1406,FOSTER,GERALD,BRIDGEPORT,CT,M,351.85,-3948,5529,203/675-6363,,ME,2
1120,GARCIA,JACK,NEW YORK,NY,M,28619,257,7953,718/384-4930,,ME,1
1409,HARTFORD,RAYMOND,STAMFORD,CT,M,41551,-7924,3585,203/781-9697,,,
1121,HERNANDEZ,MICHAEL,NEW YORK,NY,M,29112,-94,7283,718/384-3313,,ME,1
1356,HOWARD,MICHAEL,NEW YORK,NY,M,36869,-5207,4073,212/586-8411,,ME,2
1292,HUNTER,HELEN,BRIDGEPORT,CT,F,36691,-2618,6395,203/675-4830,,ME,2
1440,JACKSON,LAURA,STAMFORD,CT,F,,-3380,7041,203/781-0088,,ME,2
1900,KING,WILLIAM,NEW YORK,NY,M,35105,-3505,5781,718/383-3698,,ME,2
1379,MORGAN,ALFRED,STAMFORD,CT,M,42264,-3795,4547,203/781-2216,,ME,3
1412,MURPHEY,JOHN,PRINCETON,NJ,N,27799,-5672,7281,201/812-4414,,ME,1
1423,OSWALD,LESLIE,MT. VERNON,NY,F,35773,-1324,6808,914/468-9171,,ME,2
1200,OVERMAN,MICHELLE,STAMFORD,CT,F,27816,-353,7534,203/781-1835,,ME,1
1521,PARKER,JAY,NEW YORK,NY,M,41526,-3183,6041,212/587-7603,,ME,3
1385,RAYNOR,MILTON,BRIDGEPORT,CT,M,43900,-3634,5207,203/675-2846,,ME,3
1432,REED,MARILYN,MT. VERNON,NY,F,35327,-3708,4792,914/468-5454,,ME,2
1420,ROUSE,JEREMY,PATERSON,NJ,M,43071,-2504,5684,201/732-9834,,ME,3
1882,TUCKER,ALAN,NEW YORK,NY,M,41538,-5285,2519,718/384-0216,,ME,3
1050,TUTTLE,THOMAS,WHITE PLAINS,NY,M,35167,-3090,5352,914/455-2119,,ME,2
1995,VARNER,ELIZABETH,NEW YORK,NY,F,28810,604,7935,718/384-7113,,ME,1
1418,WATSON,BERNARD,NEW YORK,NY,M,28005,-5388,7313,718/383-1298,,ME,1
1105,YOUNG,LAWRENCE,NEW YORK,NY,M,34805,-3590,6802,718/384-0008,,ME,2
;;;;
run;

data sasuser.navigators;
   attrib ID length=$4;
   attrib LastName length=$10;
   attrib FirstName length=$8;
   attrib City length=$10;
   attrib State length=$2;
   attrib Gender length=$1;
   attrib JobCode length=$3;
   attrib Salary length=8 format=8.2;
   attrib Birth length=8 format=DATE7.;
   attrib Hired length=8 format=DATE7.;
   attrib HomePhone length=$12;

   infile datalines dsd;
   input
      ID
      LastName
      FirstName
      City
      State
      Gender
      JobCode
      Salary
      Birth
      Hired
      HomePhone
   ;
datalines4;
1269,CASTON,FRANKLIN,STAMFORD,CT,M,NA1,41690,126,7640,203/781-3335
1935,FERNANDEZ,KATRINA,BRIDGEPORT,CT,,NA2,51081,-6485,3579,203/675-2962
1417,NEWKIRK,WILLIAM,PATERSON,NJ,",",NA2,52270,-2741,6278,201/732-6611
1839,NORRIS,DIANE,NEW YORK,YN,F,NA1,43433,-395,7857,718/384-1767
1111,RHODES,JEREMY,PRINCETON,NJ,M,NA1,40586,563,7612,201/812-1837
1352,RIVERS,SIMON,NEW YORK,NY,M,NA2,5379.8,-4044,5405,718/383-3345
1332,STEPHENSON,ADAM,BRIDGEPORT,CT,M,NA1,42178,-468,7097,203/675-1497
1443,WELLS,AGNES,STAMFORD,CT,F,NA1,422.74,-1137,7183,203/781-5546
;;;;
run;

data sasuser.pilots;
   attrib ID length=$4;
   attrib LastName length=$10;
   attrib FirstName length=$9;
   attrib City length=$12;
   attrib State length=$2;
   attrib Gender length=$1;
   attrib JobCode length=$3;
   attrib Salary length=8;
   attrib Birth length=8 format=DATE7.;
   attrib Hired length=8 format=DATE7.;
   attrib HomePhone length=$12;

   infile datalines dsd;
   input
      ID
      LastName
      FirstName
      City
      State
      Gender
      JobCode
      Salary
      Birth
      Hired
      HomePhone
   ;
datalines4;
1333,BLAIR,JUSTIN,STAMFORD,CT,M,PT2,88606,-3926,3331,203/781-1777
1739,BOYCE,JONATHAN,NEW YORK,NY,M,PT1,66517,-2560,6969,212/587-1247
1428,BRADY,CHRISTINE,STAMFORD,CT,F,PT1,68767,-634,7262,203/781-1212
1404,CARTER,DONALD,NEW YORK,NY,M,PT2,91376,-6882,2925,718/384-2946
1118,DENNIS,ROGER,NEW YORK,NY,M,PT3,111379,-10209,3277,718/383-1122
1905,GRAHAM,ALVIN,NEW YORK,NY,M,PT1,65111,109,7457,212/586-8815
1407,GRANT,DANIEL,MT. VERNON,NY,M,PT1,68096,-1011,6654,914/468-1616
1410,HARRIS,CHARLES,STAMFORD,CT,M,PT2,84685,-1701,5427,203/781-0937
1439,HARRISON,FELICIA,BRIDGEPORT,CT,F,PT1,70736,-2854,6830,203/675-4987
1545,HUNTER,CLYDE,STAMFORD,CT,M,PT1,66130,-4522,6726,203/781-1119
1777,LUFKIN,ROY,NEW YORK,NY,M,PT3,109630,-7402,3462,718/383-4413
1106,MARSHBURN,JASPER,STAMFORD,CT,M,PT2,89632,-5166,4614,203/781-1457
1333,NEWKIRK,SANDRA,PRINCETON,NJ,F,PT2,84536,-1941,5949,201/812-3331
1478,NEWTON,JAMES,NEW YORK,NY,M,PT2,84203,-4525,6874,212/587-5549
1556,PENNINGTON,MICHAEL,NEW YORK,NY,M,PT1,71349,-2746,7287,718/383-5681
1890,STEPHENSON,ROBERT,NEW YORK,NY,M,PT2,85896,-7467,2888,718/384-9874
1107,THOMPSON,WAYNE,NEW YORK,NY,M,PT2,89977,-6412,2600,718/384-3785
1830,TRIPP,KATHY,BRIDGEPORT,CT,F,PT2,84471,-5329,4049,203/675-2479
1928,UPCHURCH,LARRY,WHITE PLAINS,NY,M,PT2,89858,-6313,6771,914/455-5009
1076,VENTER,RANDALL,NEW YORK,NY,M,PT1,66558,290,7218,718/383-2321
;;;;
run;
data sasuser.salary;
   input Dept $ 1-5 WageCat $ 7 WageRate 9-14 
         Manager $ 17-23 JobType  25-27;
datalines;
ADM10 S 3392.50 Coxe    3
ADM10 S 3420.00 Coxe    50
ADM10 S 6862.50 Coxe    50
ADM10 H   13.65 Coxe    240
ADM20 S 4522.50 Coxe    240
ADM20 S 2960.00 Delgado 240
ADM20 S 5260.00 Delgado 240
ADM20 S 1572.50 Delgado 420
ADM30 S 3819.20 Delgado 420
ADM30 S 1813.30 Delgado 440
CAM10 S 6855.90 Overby  1
CAM10 S 4045.80 Overby  5
CAM20 S 4480.50 Overby  10
ADM10 S 5910.80 Overby  20
CAM10 S 9073.80 Overby  20

data sasuser.staff;
   infile datalines;
   input ID $ 1-4 Name $ 6-17 @19 DOB
         WageCategory $ 26 @28 WageRate
         @36 Bonus;
   format wagerate bonus 7.2;
datalines;
1351 Farr, Sue     -4685 S 3392.50 1187.38
161  Cox, Kay B    -5114 S 5093.75 1782.81
212  Moore, Ron    -2415 S 1813.30  634.65
2512 Ruth, G H     -2819 S 1572.50  550.37
2532 Hobbs, Roy     -780 H   13.48  500.00
282  Shaw, Rick    -3090 S 2192.25  767.29
3131 Gant, Amy    -10199 H   13.50  500.00
341  Mann, Mary      290 H   13.55  500.00
3551 Cobb, Joy F    -636 H   13.65  500.00
3782 Bond, Jim S   -4045 S 2247.50  786.63
381  Smith, Anna   -3493 S 2082.75  728.96
3922 Dow, Tony     -4472 S 2960.00 1036.00
412  Star, Burt    -1412 S 2300.00  805.00
4331 King, Jan S   -3170 H   11.85  500.00
442  Lewis, Ed D   -3590 S 3420.00 1197.00
452  Fox, Jim E    -5166 S 3902.35 1365.82
4551 Wong, Kim P   -6412 S 3442.50 1204.88
472  Hall, Joe B     563 S 2262.50  791.88
482  Chin, Mike    -2586 S 2938.00 1028.30
4921 Smyth, Nan    -1444 H   15.33  500.00
5002 Welch, W B     -832 S 5910.75 2068.76
5112 Delgado, Ed   -4146 S 4045.85 1416.05
511  Vega, Julie    -822 S 4480.50 1568.18
5132 Overby, Phil  -3129 S 6855.90 2399.57
5151 Coxe, Susan  -10209 S 3163.00 1107.05
1351 Farr, Sue     -4685 S 3392.50 1187.38
;
run;

data work.patients;
   input ID $ 1-4 Name $ 6-19 Gender $ 22 Age 26-28 Date 30-31
         Height 36-37 Weight 43-45 ActLevel $ 50-53 Fee 57-62;
   format fee 7.2;
datalines;
2458 Murray, W       F   44   1    72     168    HIGH    85.20
2462 Almers, C       F   61   3    66     152    HIGH   124.80
2501 Bonaventure, T  M   64  17    61     123    LOW    149.75
2598 Watt, A         G   242  7    71     183    MOD    149.75
;

data work.reps;
   input Salesrep $ Type $ UnitSold Net $ Commission;
datalines;
TFB VCR 12 1270.00 63.50
MDC VCR 22 2385.00 119.00
JFL LAP 02 1600.00 150.00
MKL DSK 05 2500.00 250.00
WKK VCR 14 1388.00 69.00
;
data sasuser.temp;
   attrib Address length=$19;
   attrib City length=$11;
   attrib State length=$2;
   attrib Zip length=$5;
   attrib Phone length=$7;
   attrib Startdate length=5 format=date9.;
   attrib Enddate length=5  format=date9.;
   attrib Payrate length=$2;
   attrib Days length=$2;
   attrib Hours length=3;
   attrib Birthdate length=4 format=date9.;
   attrib Job length=$29;
   attrib Contact length=$16;
   attrib Dept length=$4;
   attrib Site length=$02;

   infile datalines dsd;
   input
    Address
    City
	State
	Zip
	Phone
	Startdate
	Enddate
	Payrate
	Days
	Hours
	Birthdate
	Job
	Contact
	Dept
	Site
; 
datalines4;
65 ELM DR,CARY,NC,27513,6224549,14567,14621,10,11,088,7054,word processing,WORD PROCESSOR,DP,26
11 SUN DR,CARY,NC,27513,6223251,14524,14565, 8,25,200,5757,Filing Admin.Duties,ADMIN. ASST.,PURH,57
712 HARDWICK STREET,CHAPEL HILL,NC,27514,9974749,14570,14608,40,26,208,3156,Organizational Dev. Specialist,CONSULTANT,PERS,34
5372 WHITEBUD ROAD,RALEIGH,NC,27612,6970540,14516,14527,15,10,080,6097,Bookkeeping word processing,BOOKKEEPER ASST.,BK,57
11 TALYN COURT,DURHAM,NC,27713,3633618,14550,14561,12, 9,072,4327,word processing sec. work,WORD PROCESSOR,DP,95
101 HYNERIAN DR,CARRBORO,NC,27510,9976732,14564,14613,15, 7,064,5644,Bookkeeping word processing,BOOKKEEPER ASST.,BK,44
11 RYGEL ROAD,CHAPEL HILL,NC,27514,9972070,14093,14108,12,12,096,5644,word processing,WORD PROCESSOR,DP,59
121 E. MOYA STREET,DURHAM,NC,27713,3633020,14158,14162,10, 5,040,4347,word processing sec. work,WORD PROCESSOR,PUB,38
1905 DOCK STREET,CARY,NC,27513,6565303,14524,14172,10, 5,030,4327,word processing,WORD PROCESSOR,DP,44
1304 CRESCENT AVE,RALEIGH,NC,27612,4341557,14424,14182,15, 5,025,4527,word processing,WORD PROCESSOR,DP,90
;;;;
run;

data sasuser.temps;
   input mon 1-4 @6 tue wed 11-14 thr 16-19 fri 21-24 sat 26-29 sun 31-34;
datalines;
88.4 98.8 94.2 92.5 88.3 87.4 86.1
98.2 96.2 91.5 85.0 89.5 84.3 88.2
87.5 88.8 88.7 84.6 81.5 81.4 82.3
;


***** data for SQL course ********************************************************;


data sasuser.flightdelays;
   informat Date date9.;
   input FlightNumber $ 1-3 @6 Date date9. Origin $ 17-19
         Destination $ 22-24 DelayCategory $ 27-41
         DestinationType $ 44-58 DayOfWeek 61 Delay @65;
   format date date9.;
datalines;
182  01MAR2000  LGA  YYZ  No Delay         International    4    0
114  01MAR2000  LGA  LAX  1-10 Minutes     Domestic         4    8
202  01MAR2000  LGA  ORD  No Delay         Domestic         4   -5
219  01MAR2000  LGA  LHR  11+ Minutes      International    4   18
439  01MAR2000  LGA  LAX  No Delay         Domestic         4   -4
387  01MAR2000  LGA  CPH  No Delay         International    4   -2
290  01MAR2000  LGA  WAS  No Delay         Domestic         4   -8
523  01MAR2000  LGA  ORD  1-10 Minutes     Domestic         4    4
982  01MAR2000  LGA  DFW  No Delay         Domestic         4    0
622  01MAR2000  LGA  FRA  No Delay         International    4   -5
821  01MAR2000  LGA  LHR  11+ Minutes      International    4   16
872  01MAR2000  LGA  LAX  1-10 Minutes     Domestic         4    3
416  01MAR2000  LGA  WAS  1-10 Minutes     Domestic         4    4
132  01MAR2000  LGA  YYZ  11+ Minutes      International    4   14
829  01MAR2000  LGA  WAS  No Delay         Domestic         4   -6
183  01MAR2000  LGA  WAS  No Delay         Domestic         4   -8
271  01MAR2000  LGA  CDG  1-10 Minutes     International    4    5
921  01MAR2000  LGA  DFW  No Delay         Domestic         4   -5
302  01MAR2000  LGA  WAS  No Delay         Domestic         4   -2
431  01MAR2000  LGA  LAX  11+ Minutes      Domestic         4   13
308  01MAR2000  LGA  ORD  No Delay         Domestic         4   -5
182  02MAR2000  LGA  YYZ  1-10 Minutes     International    5    2
114  02MAR2000  LGA  LAX  No Delay         Domestic         5    0
202  02MAR2000  LGA  ORD  1-10 Minutes     Domestic         5    5
219  02MAR2000  LGA  LHR  11+ Minutes      International    5   18
439  02MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    2
387  02MAR2000  LGA  CPH  No Delay         International    5  -10
290  02MAR2000  LGA  WAS  No Delay         Domestic         5   -3
523  02MAR2000  LGA  ORD  No Delay         Domestic         5   -5
982  02MAR2000  LGA  DFW  1-10 Minutes     Domestic         5    9
622  02MAR2000  LGA  FRA  No Delay         International    5    0
821  02MAR2000  LGA  LHR  No Delay         International    5   -9
872  02MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    7
416  02MAR2000  LGA  WAS  No Delay         Domestic         5    0
132  02MAR2000  LGA  YYZ  1-10 Minutes     International    5    5
829  02MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    1
183  02MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    5
271  02MAR2000  LGA  CDG  1-10 Minutes     International    5    4
921  02MAR2000  LGA  DFW  1-10 Minutes     Domestic         5    5
302  02MAR2000  LGA  WAS  No Delay         Domestic         5    0
431  02MAR2000  LGA  LAX  11+ Minutes      Domestic         5   15
308  02MAR2000  LGA  ORD  No Delay         Domestic         5   -6
182  03MAR2000  LGA  YYZ  11+ Minutes      International    6   14
114  03MAR2000  LGA  LAX  No Delay         Domestic         6   -1
202  03MAR2000  LGA  ORD  No Delay         Domestic         6   -1
219  03MAR2000  LGA  LHR  1-10 Minutes     International    6    4
439  03MAR2000  LGA  LAX  1-10 Minutes     Domestic         6    4
387  03MAR2000  LGA  CPH  No Delay         International    6   -5
290  03MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    6
523  03MAR2000  LGA  ORD  1-10 Minutes     Domestic         6    7
982  03MAR2000  LGA  DFW  1-10 Minutes     Domestic         6    1
622  03MAR2000  LGA  FRA  No Delay         International    6   -2
821  03MAR2000  LGA  LHR  11+ Minutes      International    6   16
872  03MAR2000  LGA  LAX  11+ Minutes      Domestic         6   14
132  03MAR2000  LGA  YYZ  1-10 Minutes     International    6    6
829  03MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    7
183  03MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    5
271  03MAR2000  LGA  CDG  1-10 Minutes     International    6    2
921  03MAR2000  LGA  DFW  No Delay         Domestic         6   -7
302  03MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    5
431  03MAR2000  LGA  LAX  1-10 Minutes     Domestic         6    5
308  03MAR2000  LGA  ORD  No Delay         Domestic         6   -2
182  04MAR2000  LGA  YYZ  1-10 Minutes     International    7    4
114  04MAR2000  LGA  LAX  11+ Minutes      Domestic         7   15
202  04MAR2000  LGA  ORD  No Delay         Domestic         7   -5
219  04MAR2000  LGA  LHR  1-10 Minutes     International    7    3
439  04MAR2000  LGA  LAX  11+ Minutes      Domestic         7   20
387  04MAR2000  LGA  CPH  11+ Minutes      International    7   13
290  04MAR2000  LGA  WAS  No Delay         Domestic         7   -8
523  04MAR2000  LGA  ORD  11+ Minutes      Domestic         7   12
982  04MAR2000  LGA  DFW  No Delay         Domestic         7   -3
622  04MAR2000  LGA  FRA  11+ Minutes      International    7   30
821  04MAR2000  LGA  LHR  1-10 Minutes     International    7    5
872  04MAR2000  LGA  LAX  No Delay         Domestic         7   -1
416  04MAR2000  LGA  WAS  No Delay         Domestic         7   -5
132  04MAR2000  LGA  YYZ  No Delay         International    7   -5
829  04MAR2000  LGA  WAS  1-10 Minutes     Domestic         7    3
183  04MAR2000  LGA  WAS  1-10 Minutes     Domestic         7    6
271  04MAR2000  LGA  CDG  1-10 Minutes     International    7    5
921  04MAR2000  LGA  DFW  1-10 Minutes     Domestic         7    8
302  04MAR2000  LGA  WAS  1-10 Minutes     Domestic         7    7
431  04MAR2000  LGA  LAX  1-10 Minutes     Domestic         7    7
308  04MAR2000  LGA  ORD  11+ Minutes      Domestic         7   11
182  05MAR2000  LGA  YYZ  1-10 Minutes     International    1   10
114  05MAR2000  LGA  LAX  No Delay         Domestic         1   -2
202  05MAR2000  LGA  ORD  1-10 Minutes     Domestic         1    2
219  05MAR2000  LGA  LHR  1-10 Minutes     International    1    3
439  05MAR2000  LGA  LAX  1-10 Minutes     Domestic         1    3
387  05MAR2000  LGA  CPH  11+ Minutes      International    1   11
290  05MAR2000  LGA  WAS  No Delay         Domestic         1   -1
523  05MAR2000  LGA  ORD  No Delay         Domestic         1   -8
982  05MAR2000  LGA  DFW  1-10 Minutes     Domestic         1   10
622  05MAR2000  LGA  FRA  No Delay         International    1   -6
872  05MAR2000  LGA  LAX  11+ Minutes      Domestic         1   18
416  05MAR2000  LGA  WAS  1-10 Minutes     Domestic         1    5
132  05MAR2000  LGA  YYZ  1-10 Minutes     International    1    3
829  05MAR2000  LGA  WAS  11+ Minutes      Domestic         1   15
183  05MAR2000  LGA  WAS  No Delay         Domestic         1   -2
271  05MAR2000  LGA  CDG  1-10 Minutes     International    1    5
921  05MAR2000  LGA  DFW  No Delay         Domestic         1   -5
302  05MAR2000  LGA  WAS  No Delay         Domestic         1   -7
431  05MAR2000  LGA  LAX  No Delay         Domestic         1    0
308  05MAR2000  LGA  ORD  1-10 Minutes     Domestic         1    9
182  06MAR2000  LGA  YYZ  1-10 Minutes     International    2    2
114  06MAR2000  LGA  LAX  No Delay         Domestic         2   -1
202  06MAR2000  LGA  ORD  No Delay         Domestic         2   -3
219  06MAR2000  LGA  LHR  11+ Minutes      International    2   27
439  06MAR2000  LGA  LAX  1-10 Minutes     Domestic         2    6
290  06MAR2000  LGA  WAS  No Delay         Domestic         2   -1
523  06MAR2000  LGA  ORD  No Delay         Domestic         2   -6
982  06MAR2000  LGA  DFW  1-10 Minutes     Domestic         2    4
821  06MAR2000  LGA  LHR  No Delay         International    2   -2
872  06MAR2000  LGA  LAX  No Delay         Domestic         2   -6
416  06MAR2000  LGA  WAS  No Delay         Domestic         2   -6
132  06MAR2000  LGA  YYZ  1-10 Minutes     International    2    7
829  06MAR2000  LGA  WAS  No Delay         Domestic         2    0
183  06MAR2000  LGA  WAS  No Delay         Domestic         2   -1
921  06MAR2000  LGA  DFW  1-10 Minutes     Domestic         2    2
302  06MAR2000  LGA  WAS  1-10 Minutes     Domestic         2    1
431  06MAR2000  LGA  LAX  No Delay         Domestic         2   -7
308  06MAR2000  LGA  ORD  11+ Minutes      Domestic         2   17
182  07MAR2000  LGA  YYZ  No Delay         International    3    0
114  07MAR2000  LGA  LAX  No Delay         Domestic         3   -1
202  07MAR2000  LGA  ORD  No Delay         Domestic         3   -2
219  07MAR2000  LGA  LHR  11+ Minutes      International    3   15
439  07MAR2000  LGA  LAX  1-10 Minutes     Domestic         3    8
387  07MAR2000  LGA  CPH  No Delay         International    3   -7
290  07MAR2000  LGA  WAS  1-10 Minutes     Domestic         3    3
523  07MAR2000  LGA  ORD  No Delay         Domestic         3  -10
982  07MAR2000  LGA  DFW  No Delay         Domestic         3   -5
622  07MAR2000  LGA  FRA  11+ Minutes      International    3   21
821  07MAR2000  LGA  LHR  1-10 Minutes     International    3    7
872  07MAR2000  LGA  LAX  1-10 Minutes     Domestic         3    3
416  07MAR2000  LGA  WAS  No Delay         Domestic         3   -5
132  07MAR2000  LGA  YYZ  No Delay         International    3   -2
829  07MAR2000  LGA  WAS  No Delay         Domestic         3   -3
183  07MAR2000  LGA  WAS  1-10 Minutes     Domestic         3    1
271  07MAR2000  LGA  CDG  1-10 Minutes     International    3    4
921  07MAR2000  LGA  DFW  No Delay         Domestic         3   -6
302  07MAR2000  LGA  WAS  No Delay         Domestic         3    0
431  07MAR2000  LGA  LAX  1-10 Minutes     Domestic         3    8
308  07MAR2000  LGA  ORD  No Delay         Domestic         3    0
114  08MAR2000  LGA  LAX  11+ Minutes      Domestic         4   13
202  08MAR2000  LGA  ORD  11+ Minutes      Domestic         4   17
219  08MAR2000  LGA  LHR  No Delay         International    4   -4
439  08MAR2000  LGA  LAX  1-10 Minutes     Domestic         4    6
387  08MAR2000  LGA  CPH  11+ Minutes      International    4   15
290  08MAR2000  LGA  WAS  1-10 Minutes     Domestic         4    3
523  08MAR2000  LGA  ORD  No Delay         Domestic         4   -5
982  08MAR2000  LGA  DFW  1-10 Minutes     Domestic         4    2
622  08MAR2000  LGA  FRA  No Delay         International    4   -5
821  08MAR2000  LGA  LHR  11+ Minutes      International    4   26
872  08MAR2000  LGA  LAX  No Delay         Domestic         4    0
416  08MAR2000  LGA  WAS  1-10 Minutes     Domestic         4    5
132  08MAR2000  LGA  YYZ  No Delay         International    4   -8
829  08MAR2000  LGA  WAS  1-10 Minutes     Domestic         4   10
183  08MAR2000  LGA  WAS  No Delay         Domestic         4   -2
271  08MAR2000  LGA  CDG  No Delay         International    4   -4
921  08MAR2000  LGA  DFW  1-10 Minutes     Domestic         4    3
302  08MAR2000  LGA  WAS  No Delay         Domestic         4   -4
431  08MAR2000  LGA  LAX  1-10 Minutes     Domestic         4    1
308  08MAR2000  LGA  ORD  1-10 Minutes     Domestic         4    7
182  09MAR2000  LGA  YYZ  No Delay         International    5   -1
114  09MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    8
202  09MAR2000  LGA  ORD  11+ Minutes      Domestic         5   18
219  09MAR2000  LGA  LHR  No Delay         International    5   -6
439  09MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    3
387  09MAR2000  LGA  CPH  11+ Minutes      International    5   17
290  09MAR2000  LGA  WAS  No Delay         Domestic         5   -2
523  09MAR2000  LGA  ORD  No Delay         Domestic         5    0
982  09MAR2000  LGA  DFW  No Delay         Domestic         5   -1
622  09MAR2000  LGA  FRA  No Delay         International    5   -6
821  09MAR2000  LGA  LHR  No Delay         International    5  -10
872  09MAR2000  LGA  LAX  11+ Minutes      Domestic         5   18
416  09MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    3
132  09MAR2000  LGA  YYZ  1-10 Minutes     International    5    6
829  09MAR2000  LGA  WAS  No Delay         Domestic         5   -9
183  09MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    3
271  09MAR2000  LGA  CDG  1-10 Minutes     International    5    8
921  09MAR2000  LGA  DFW  11+ Minutes      Domestic         5   12
302  09MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    2
431  09MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    1
308  09MAR2000  LGA  ORD  1-10 Minutes     Domestic         5    2
182  10MAR2000  LGA  YYZ  No Delay         International    6   -1
114  10MAR2000  LGA  LAX  1-10 Minutes     Domestic         6    5
202  10MAR2000  LGA  ORD  1-10 Minutes     Domestic         6    1
219  10MAR2000  LGA  LHR  11+ Minutes      International    6   26
439  10MAR2000  LGA  LAX  1-10 Minutes     Domestic         6    7
387  10MAR2000  LGA  CPH  1-10 Minutes     International    6    2
290  10MAR2000  LGA  WAS  No Delay         Domestic         6   -3
523  10MAR2000  LGA  ORD  No Delay         Domestic         6  -10
982  10MAR2000  LGA  DFW  No Delay         Domestic         6    0
622  10MAR2000  LGA  FRA  11+ Minutes      International    6   14
821  10MAR2000  LGA  LHR  No Delay         International    6   -5
872  10MAR2000  LGA  LAX  1-10 Minutes     Domestic         6    5
416  10MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    8
132  10MAR2000  LGA  YYZ  No Delay         International    6   -2
829  10MAR2000  LGA  WAS  No Delay         Domestic         6   -1
183  10MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    4
271  10MAR2000  LGA  CDG  No Delay         International    6   -2
921  10MAR2000  LGA  DFW  No Delay         Domestic         6   -2
302  10MAR2000  LGA  WAS  No Delay         Domestic         6   -6
431  10MAR2000  LGA  LAX  No Delay         Domestic         6    0
308  10MAR2000  LGA  ORD  1-10 Minutes     Domestic         6    4
182  11MAR2000  LGA  YYZ  1-10 Minutes     International    7    7
114  11MAR2000  LGA  LAX  11+ Minutes      Domestic         7   21
219  11MAR2000  LGA  LHR  1-10 Minutes     International    7    4
439  11MAR2000  LGA  LAX  1-10 Minutes     Domestic         7    5
387  11MAR2000  LGA  CPH  No Delay         International    7    0
523  11MAR2000  LGA  ORD  1-10 Minutes     Domestic         7    4
982  11MAR2000  LGA  DFW  11+ Minutes      Domestic         7   14
622  11MAR2000  LGA  FRA  1-10 Minutes     International    7    9
821  11MAR2000  LGA  LHR  No Delay         International    7   -5
872  11MAR2000  LGA  LAX  1-10 Minutes     Domestic         7    3
416  11MAR2000  LGA  WAS  1-10 Minutes     Domestic         7    2
132  11MAR2000  LGA  YYZ  1-10 Minutes     International    7    7
829  11MAR2000  LGA  WAS  1-10 Minutes     Domestic         7    1
183  11MAR2000  LGA  WAS  1-10 Minutes     Domestic         7    3
271  11MAR2000  LGA  CDG  11+ Minutes      International    7   13
921  11MAR2000  LGA  DFW  No Delay         Domestic         7   -1
302  11MAR2000  LGA  WAS  11+ Minutes      Domestic         7   13
431  11MAR2000  LGA  LAX  1-10 Minutes     Domestic         7    1
308  11MAR2000  LGA  ORD  No Delay         Domestic         7   -1
182  12MAR2000  LGA  YYZ  1-10 Minutes     International    1    2
114  12MAR2000  LGA  LAX  No Delay         Domestic         1    0
202  12MAR2000  LGA  ORD  1-10 Minutes     Domestic         1    8
219  12MAR2000  LGA  LHR  11+ Minutes      International    1   13
439  12MAR2000  LGA  LAX  1-10 Minutes     Domestic         1    4
387  12MAR2000  LGA  CPH  1-10 Minutes     International    1   10
290  12MAR2000  LGA  WAS  No Delay         Domestic         1   -5
523  12MAR2000  LGA  ORD  No Delay         Domestic         1   -3
982  12MAR2000  LGA  DFW  1-10 Minutes     Domestic         1    8
622  12MAR2000  LGA  FRA  11+ Minutes      International    1   22
872  12MAR2000  LGA  LAX  1-10 Minutes     Domestic         1    6
416  12MAR2000  LGA  WAS  No Delay         Domestic         1   -3
132  12MAR2000  LGA  YYZ  1-10 Minutes     International    1    1
829  12MAR2000  LGA  WAS  1-10 Minutes     Domestic         1    3
183  12MAR2000  LGA  WAS  1-10 Minutes     Domestic         1   10
271  12MAR2000  LGA  CDG  No Delay         International    1   -6
921  12MAR2000  LGA  DFW  11+ Minutes      Domestic         1   14
302  12MAR2000  LGA  WAS  1-10 Minutes     Domestic         1    5
431  12MAR2000  LGA  LAX  1-10 Minutes     Domestic         1    7
308  12MAR2000  LGA  ORD  1-10 Minutes     Domestic         1    5
182  13MAR2000  LGA  YYZ  No Delay         International    2   -4
114  13MAR2000  LGA  LAX  1-10 Minutes     Domestic         2    6
202  13MAR2000  LGA  ORD  No Delay         Domestic         2   -9
219  13MAR2000  LGA  LHR  11+ Minutes      International    2   14
439  13MAR2000  LGA  LAX  1-10 Minutes     Domestic         2    6
290  13MAR2000  LGA  WAS  No Delay         Domestic         2   -1
523  13MAR2000  LGA  ORD  1-10 Minutes     Domestic         2    3
982  13MAR2000  LGA  DFW  No Delay         Domestic         2   -2
821  13MAR2000  LGA  LHR  No Delay         International    2   -2
872  13MAR2000  LGA  LAX  11+ Minutes      Domestic         2   13
416  13MAR2000  LGA  WAS  No Delay         Domestic         2   -3
132  13MAR2000  LGA  YYZ  1-10 Minutes     International    2    6
829  13MAR2000  LGA  WAS  1-10 Minutes     Domestic         2    6
183  13MAR2000  LGA  WAS  1-10 Minutes     Domestic         2    3
921  13MAR2000  LGA  DFW  11+ Minutes      Domestic         2   12
302  13MAR2000  LGA  WAS  1-10 Minutes     Domestic         2    8
431  13MAR2000  LGA  LAX  11+ Minutes      Domestic         2   17
308  13MAR2000  LGA  ORD  1-10 Minutes     Domestic         2    2
182  14MAR2000  LGA  YYZ  No Delay         International    3   -3
114  14MAR2000  LGA  LAX  11+ Minutes      Domestic         3   12
202  14MAR2000  LGA  ORD  1-10 Minutes     Domestic         3    2
219  14MAR2000  LGA  LHR  1-10 Minutes     International    3    3
439  14MAR2000  LGA  LAX  1-10 Minutes     Domestic         3    8
387  14MAR2000  LGA  CPH  No Delay         International    3   -9
290  14MAR2000  LGA  WAS  1-10 Minutes     Domestic         3    1
523  14MAR2000  LGA  ORD  11+ Minutes      Domestic         3   18
982  14MAR2000  LGA  DFW  No Delay         Domestic         3   -5
622  14MAR2000  LGA  FRA  No Delay         International    3   -5
821  14MAR2000  LGA  LHR  1-10 Minutes     International    3    9
872  14MAR2000  LGA  LAX  11+ Minutes      Domestic         3   15
416  14MAR2000  LGA  WAS  1-10 Minutes     Domestic         3    6
132  14MAR2000  LGA  YYZ  1-10 Minutes     International    3    5
829  14MAR2000  LGA  WAS  No Delay         Domestic         3  -10
183  14MAR2000  LGA  WAS  No Delay         Domestic         3    0
921  14MAR2000  LGA  DFW  1-10 Minutes     Domestic         3    2
302  14MAR2000  LGA  WAS  No Delay         Domestic         3    0
431  14MAR2000  LGA  LAX  1-10 Minutes     Domestic         3    1
308  14MAR2000  LGA  ORD  No Delay         Domestic         3   -9
182  15MAR2000  LGA  YYZ  1-10 Minutes     International    4    5
114  15MAR2000  LGA  LAX  No Delay         Domestic         4   -8
202  15MAR2000  LGA  ORD  1-10 Minutes     Domestic         4    4
219  15MAR2000  LGA  LHR  No Delay         International    4   -9
439  15MAR2000  LGA  LAX  No Delay         Domestic         4   -2
387  15MAR2000  LGA  CPH  11+ Minutes      International    4   26
290  15MAR2000  LGA  WAS  No Delay         Domestic         4   -5
523  15MAR2000  LGA  ORD  1-10 Minutes     Domestic         4    1
982  15MAR2000  LGA  DFW  1-10 Minutes     Domestic         4    7
622  15MAR2000  LGA  FRA  No Delay         International    4   -2
821  15MAR2000  LGA  LHR  No Delay         International    4   -9
872  15MAR2000  LGA  LAX  No Delay         Domestic         4   -1
416  15MAR2000  LGA  WAS  No Delay         Domestic         4   -2
132  15MAR2000  LGA  YYZ  1-10 Minutes     International    4    6
829  15MAR2000  LGA  WAS  No Delay         Domestic         4   -3
183  15MAR2000  LGA  WAS  No Delay         Domestic         4    0
271  15MAR2000  LGA  CDG  No Delay         International    4   -3
921  15MAR2000  LGA  DFW  1-10 Minutes     Domestic         4    4
302  15MAR2000  LGA  WAS  No Delay         Domestic         4   -2
431  15MAR2000  LGA  LAX  No Delay         Domestic         4    0
308  15MAR2000  LGA  ORD  1-10 Minutes     Domestic         4    7
182  16MAR2000  LGA  YYZ  1-10 Minutes     International    5    9
114  16MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    4
202  16MAR2000  LGA  ORD  No Delay         Domestic         5    0
219  16MAR2000  LGA  LHR  11+ Minutes      International    5   13
439  16MAR2000  LGA  LAX  No Delay         Domestic         5   -3
387  16MAR2000  LGA  CPH  No Delay         International    5   -1
290  16MAR2000  LGA  WAS  No Delay         Domestic         5   -1
523  16MAR2000  LGA  ORD  11+ Minutes      Domestic         5   14
982  16MAR2000  LGA  DFW  1-10 Minutes     Domestic         5    6
821  16MAR2000  LGA  LHR  1-10 Minutes     International    5    2
872  16MAR2000  LGA  LAX  1-10 Minutes     Domestic         5   10
416  16MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    6
132  16MAR2000  LGA  YYZ  No Delay         International    5    0
829  16MAR2000  LGA  WAS  No Delay         Domestic         5   -2
183  16MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    1
271  16MAR2000  LGA  CDG  11+ Minutes      International    5   20
921  16MAR2000  LGA  DFW  1-10 Minutes     Domestic         5    8
302  16MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    2
431  16MAR2000  LGA  LAX  No Delay         Domestic         5   -1
308  16MAR2000  LGA  ORD  No Delay         Domestic         5   -2
114  17MAR2000  LGA  LAX  11+ Minutes      Domestic         6   11
202  17MAR2000  LGA  ORD  11+ Minutes      Domestic         6   19
219  17MAR2000  LGA  LHR  1-10 Minutes     International    6    3
439  17MAR2000  LGA  LAX  No Delay         Domestic         6   -2
387  17MAR2000  LGA  CPH  No Delay         International    6   -8
290  17MAR2000  LGA  WAS  No Delay         Domestic         6   -4
523  17MAR2000  LGA  ORD  11+ Minutes      Domestic         6   17
982  17MAR2000  LGA  DFW  No Delay         Domestic         6   -1
622  17MAR2000  LGA  FRA  No Delay         International    6   -1
821  17MAR2000  LGA  LHR  No Delay         International    6   -7
872  17MAR2000  LGA  LAX  1-10 Minutes     Domestic         6    3
416  17MAR2000  LGA  WAS  No Delay         Domestic         6   -5
132  17MAR2000  LGA  YYZ  1-10 Minutes     International    6    6
829  17MAR2000  LGA  WAS  No Delay         Domestic         6    0
183  17MAR2000  LGA  WAS  No Delay         Domestic         6   -3
271  17MAR2000  LGA  CDG  11+ Minutes      International    6   12
921  17MAR2000  LGA  DFW  1-10 Minutes     Domestic         6    4
302  17MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    4
431  17MAR2000  LGA  LAX  1-10 Minutes     Domestic         6    3
308  17MAR2000  LGA  ORD  1-10 Minutes     Domestic         6    4
182  18MAR2000  LGA  YYZ  No Delay         International    7   -9
114  18MAR2000  LGA  LAX  1-10 Minutes     Domestic         7    5
202  18MAR2000  LGA  ORD  No Delay         Domestic         7    0
219  18MAR2000  LGA  LHR  No Delay         International    7  -10
439  18MAR2000  LGA  LAX  1-10 Minutes     Domestic         7    5
387  18MAR2000  LGA  CPH  No Delay         International    7   -6
290  18MAR2000  LGA  WAS  1-10 Minutes     Domestic         7    5
523  18MAR2000  LGA  ORD  No Delay         Domestic         7   -5
982  18MAR2000  LGA  DFW  11+ Minutes      Domestic         7   12
622  18MAR2000  LGA  FRA  No Delay         International    7   -7
821  18MAR2000  LGA  LHR  1-10 Minutes     International    7    9
872  18MAR2000  LGA  LAX  1-10 Minutes     Domestic         7   10
416  18MAR2000  LGA  WAS  1-10 Minutes     Domestic         7    2
132  18MAR2000  LGA  YYZ  No Delay         International    7   -5
829  18MAR2000  LGA  WAS  No Delay         Domestic         7    0
183  18MAR2000  LGA  WAS  No Delay         Domestic         7   -8
271  18MAR2000  LGA  CDG  1-10 Minutes     International    7    4
921  18MAR2000  LGA  DFW  1-10 Minutes     Domestic         7    2
302  18MAR2000  LGA  WAS  1-10 Minutes     Domestic         7    2
431  18MAR2000  LGA  LAX  No Delay         Domestic         7   -3
308  18MAR2000  LGA  ORD  No Delay         Domestic         7   -5
182  19MAR2000  LGA  YYZ  1-10 Minutes     International    1    6
114  19MAR2000  LGA  LAX  11+ Minutes      Domestic         1   16
202  19MAR2000  LGA  ORD  11+ Minutes      Domestic         1   14
219  19MAR2000  LGA  LHR  1-10 Minutes     International    1    4
439  19MAR2000  LGA  LAX  1-10 Minutes     Domestic         1   10
387  19MAR2000  LGA  CPH  1-10 Minutes     International    1    1
290  19MAR2000  LGA  WAS  11+ Minutes      Domestic         1   11
523  19MAR2000  LGA  ORD  11+ Minutes      Domestic         1   18
982  19MAR2000  LGA  DFW  1-10 Minutes     Domestic         1    1
622  19MAR2000  LGA  FRA  1-10 Minutes     International    1    2
872  19MAR2000  LGA  LAX  1-10 Minutes     Domestic         1    6
416  19MAR2000  LGA  WAS  No Delay         Domestic         1   -6
132  19MAR2000  LGA  YYZ  No Delay         International    1   -9
829  19MAR2000  LGA  WAS  1-10 Minutes     Domestic         1    2
183  19MAR2000  LGA  WAS  No Delay         Domestic         1   -3
271  19MAR2000  LGA  CDG  11+ Minutes      International    1   26
921  19MAR2000  LGA  DFW  1-10 Minutes     Domestic         1    1
302  19MAR2000  LGA  WAS  1-10 Minutes     Domestic         1    6
431  19MAR2000  LGA  LAX  No Delay         Domestic         1   -6
308  19MAR2000  LGA  ORD  No Delay         Domestic         1   -5
182  20MAR2000  LGA  YYZ  1-10 Minutes     International    2   10
114  20MAR2000  LGA  LAX  No Delay         Domestic         2   -1
202  20MAR2000  LGA  ORD  11+ Minutes      Domestic         2   19
219  20MAR2000  LGA  LHR  No Delay         International    2   -6
439  20MAR2000  LGA  LAX  No Delay         Domestic         2   -6
290  20MAR2000  LGA  WAS  1-10 Minutes     Domestic         2    3
523  20MAR2000  LGA  ORD  No Delay         Domestic         2   -7
982  20MAR2000  LGA  DFW  1-10 Minutes     Domestic         2    8
821  20MAR2000  LGA  LHR  1-10 Minutes     International    2    1
872  20MAR2000  LGA  LAX  1-10 Minutes     Domestic         2    9
416  20MAR2000  LGA  WAS  No Delay         Domestic         2   -1
132  20MAR2000  LGA  YYZ  1-10 Minutes     International    2    9
829  20MAR2000  LGA  WAS  1-10 Minutes     Domestic         2    3
183  20MAR2000  LGA  WAS  1-10 Minutes     Domestic         2    6
921  20MAR2000  LGA  DFW  1-10 Minutes     Domestic         2    3
302  20MAR2000  LGA  WAS  No Delay         Domestic         2   -4
431  20MAR2000  LGA  LAX  No Delay         Domestic         2   -4
308  20MAR2000  LGA  ORD  11+ Minutes      Domestic         2   13
182  21MAR2000  LGA  YYZ  No Delay         International    3   -6
114  21MAR2000  LGA  LAX  1-10 Minutes     Domestic         3    8
202  21MAR2000  LGA  ORD  No Delay         Domestic         3   -3
219  21MAR2000  LGA  LHR  1-10 Minutes     International    3    1
439  21MAR2000  LGA  LAX  No Delay         Domestic         3   -8
387  21MAR2000  LGA  CPH  No Delay         International    3   -1
290  21MAR2000  LGA  WAS  1-10 Minutes     Domestic         3    2
523  21MAR2000  LGA  ORD  1-10 Minutes     Domestic         3    9
982  21MAR2000  LGA  DFW  11+ Minutes      Domestic         3   20
622  21MAR2000  LGA  FRA  No Delay         International    3   -6
821  21MAR2000  LGA  LHR  1-10 Minutes     International    3    3
872  21MAR2000  LGA  LAX  No Delay         Domestic         3    0
416  21MAR2000  LGA  WAS  No Delay         Domestic         3   -5
132  21MAR2000  LGA  YYZ  1-10 Minutes     International    3    5
829  21MAR2000  LGA  WAS  1-10 Minutes     Domestic         3    1
183  21MAR2000  LGA  WAS  No Delay         Domestic         3   -9
271  21MAR2000  LGA  CDG  11+ Minutes      International    3   25
921  21MAR2000  LGA  DFW  1-10 Minutes     Domestic         3    5
302  21MAR2000  LGA  WAS  1-10 Minutes     Domestic         3    4
431  21MAR2000  LGA  LAX  11+ Minutes      Domestic         3   27
308  21MAR2000  LGA  ORD  1-10 Minutes     Domestic         3    5
182  22MAR2000  LGA  YYZ  No Delay         International    4    0
114  22MAR2000  LGA  LAX  11+ Minutes      Domestic         4   15
202  22MAR2000  LGA  ORD  No Delay         Domestic         4   -5
219  22MAR2000  LGA  LHR  No Delay         International    4   -5
439  22MAR2000  LGA  LAX  1-10 Minutes     Domestic         4    6
387  22MAR2000  LGA  CPH  1-10 Minutes     International    4    6
290  22MAR2000  LGA  WAS  No Delay         Domestic         4   -6
523  22MAR2000  LGA  ORD  11+ Minutes      Domestic         4   13
982  22MAR2000  LGA  DFW  1-10 Minutes     Domestic         4    6
622  22MAR2000  LGA  FRA  1-10 Minutes     International    4    5
821  22MAR2000  LGA  LHR  No Delay         International    4   -4
872  22MAR2000  LGA  LAX  1-10 Minutes     Domestic         4    9
416  22MAR2000  LGA  WAS  No Delay         Domestic         4   -4
132  22MAR2000  LGA  YYZ  1-10 Minutes     International    4    7
829  22MAR2000  LGA  WAS  1-10 Minutes     Domestic         4    6
271  22MAR2000  LGA  CDG  11+ Minutes      International    4   22
921  22MAR2000  LGA  DFW  No Delay         Domestic         4   -3
302  22MAR2000  LGA  WAS  1-10 Minutes     Domestic         4    8
431  22MAR2000  LGA  LAX  11+ Minutes      Domestic         4   16
308  22MAR2000  LGA  ORD  1-10 Minutes     Domestic         4    4
182  23MAR2000  LGA  YYZ  1-10 Minutes     International    5    6
114  23MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    3
202  23MAR2000  LGA  ORD  No Delay         Domestic         5   -1
219  23MAR2000  LGA  LHR  1-10 Minutes     International    5    4
439  23MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    6
387  23MAR2000  LGA  CPH  11+ Minutes      International    5   21
290  23MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    5
523  23MAR2000  LGA  ORD  No Delay         Domestic         5   -3
982  23MAR2000  LGA  DFW  No Delay         Domestic         5   -9
622  23MAR2000  LGA  FRA  11+ Minutes      International    5   34
821  23MAR2000  LGA  LHR  1-10 Minutes     International    5    1
872  23MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    9
416  23MAR2000  LGA  WAS  No Delay         Domestic         5    0
132  23MAR2000  LGA  YYZ  No Delay         International    5    0
829  23MAR2000  LGA  WAS  11+ Minutes      Domestic         5   11
183  23MAR2000  LGA  WAS  No Delay         Domestic         5    0
271  23MAR2000  LGA  CDG  1-10 Minutes     International    5    8
921  23MAR2000  LGA  DFW  1-10 Minutes     Domestic         5    2
302  23MAR2000  LGA  WAS  No Delay         Domestic         5   -6
431  23MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    4
308  23MAR2000  LGA  ORD  No Delay         Domestic         5   -3
182  24MAR2000  LGA  YYZ  No Delay         International    6   -8
114  24MAR2000  LGA  LAX  1-10 Minutes     Domestic         6    6
202  24MAR2000  LGA  ORD  No Delay         Domestic         6   -7
219  24MAR2000  LGA  LHR  No Delay         International    6   -3
439  24MAR2000  LGA  LAX  11+ Minutes      Domestic         6   13
387  24MAR2000  LGA  CPH  11+ Minutes      International    6   19
290  24MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    6
523  24MAR2000  LGA  ORD  No Delay         Domestic         6   -6
982  24MAR2000  LGA  DFW  No Delay         Domestic         6   -2
622  24MAR2000  LGA  FRA  11+ Minutes      International    6   28
821  24MAR2000  LGA  LHR  11+ Minutes      International    6   17
872  24MAR2000  LGA  LAX  No Delay         Domestic         6   -1
416  24MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    3
132  24MAR2000  LGA  YYZ  1-10 Minutes     International    6    2
829  24MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    4
183  24MAR2000  LGA  WAS  No Delay         Domestic         6   -4
271  24MAR2000  LGA  CDG  No Delay         International    6   -2
921  24MAR2000  LGA  DFW  1-10 Minutes     Domestic         6    9
302  24MAR2000  LGA  WAS  No Delay         Domestic         6   -4
431  24MAR2000  LGA  LAX  No Delay         Domestic         6   -3
308  24MAR2000  LGA  ORD  1-10 Minutes     Domestic         6    1
182  25MAR2000  LGA  YYZ  No Delay         International    7   -2
114  25MAR2000  LGA  LAX  No Delay         Domestic         7    0
202  25MAR2000  LGA  ORD  1-10 Minutes     Domestic         7    6
219  25MAR2000  LGA  LHR  11+ Minutes      International    7   14
439  25MAR2000  LGA  LAX  No Delay         Domestic         7   -4
387  25MAR2000  LGA  CPH  No Delay         International    7   -6
290  25MAR2000  LGA  WAS  No Delay         Domestic         7   -7
523  25MAR2000  LGA  ORD  No Delay         Domestic         7    0
982  25MAR2000  LGA  DFW  1-10 Minutes     Domestic         7    4
622  25MAR2000  LGA  FRA  No Delay         International    7   -4
821  25MAR2000  LGA  LHR  11+ Minutes      International    7   30
416  25MAR2000  LGA  WAS  1-10 Minutes     Domestic         7    3
132  25MAR2000  LGA  YYZ  1-10 Minutes     International    7    7
829  25MAR2000  LGA  WAS  No Delay         Domestic         7  -10
183  25MAR2000  LGA  WAS  No Delay         Domestic         7   -5
271  25MAR2000  LGA  CDG  1-10 Minutes     International    7    1
921  25MAR2000  LGA  DFW  1-10 Minutes     Domestic         7    3
302  25MAR2000  LGA  WAS  No Delay         Domestic         7   -5
431  25MAR2000  LGA  LAX  1-10 Minutes     Domestic         7    6
308  25MAR2000  LGA  ORD  11+ Minutes      Domestic         7   17
182  26MAR2000  LGA  YYZ  1-10 Minutes     International    1   10
114  26MAR2000  LGA  LAX  1-10 Minutes     Domestic         1    4
202  26MAR2000  LGA  ORD  1-10 Minutes     Domestic         1    8
219  26MAR2000  LGA  LHR  11+ Minutes      International    1   25
439  26MAR2000  LGA  LAX  11+ Minutes      Domestic         1   21
387  26MAR2000  LGA  CPH  11+ Minutes      International    1   18
290  26MAR2000  LGA  WAS  No Delay         Domestic         1    0
523  26MAR2000  LGA  ORD  1-10 Minutes     Domestic         1    9
982  26MAR2000  LGA  DFW  No Delay         Domestic         1   -8
622  26MAR2000  LGA  FRA  1-10 Minutes     International    1    3
872  26MAR2000  LGA  LAX  No Delay         Domestic         1   -4
416  26MAR2000  LGA  WAS  1-10 Minutes     Domestic         1    5
132  26MAR2000  LGA  YYZ  1-10 Minutes     International    1    1
829  26MAR2000  LGA  WAS  1-10 Minutes     Domestic         1    4
183  26MAR2000  LGA  WAS  1-10 Minutes     Domestic         1    2
271  26MAR2000  LGA  CDG  11+ Minutes      International    1   16
921  26MAR2000  LGA  DFW  1-10 Minutes     Domestic         1    3
302  26MAR2000  LGA  WAS  1-10 Minutes     Domestic         1    3
431  26MAR2000  LGA  LAX  1-10 Minutes     Domestic         1    9
308  26MAR2000  LGA  ORD  1-10 Minutes     Domestic         1    6
182  27MAR2000  LGA  YYZ  No Delay         International    2   -9
114  27MAR2000  LGA  LAX  11+ Minutes      Domestic         2   11
202  27MAR2000  LGA  ORD  1-10 Minutes     Domestic         2    6
219  27MAR2000  LGA  LHR  1-10 Minutes     International    2   10
439  27MAR2000  LGA  LAX  No Delay         Domestic         2    0
290  27MAR2000  LGA  WAS  No Delay         Domestic         2   -1
523  27MAR2000  LGA  ORD  No Delay         Domestic         2   -5
821  27MAR2000  LGA  LHR  1-10 Minutes     International    2    1
872  27MAR2000  LGA  LAX  1-10 Minutes     Domestic         2    1
416  27MAR2000  LGA  WAS  No Delay         Domestic         2    0
132  27MAR2000  LGA  YYZ  1-10 Minutes     International    2    4
829  27MAR2000  LGA  WAS  1-10 Minutes     Domestic         2    3
183  27MAR2000  LGA  WAS  1-10 Minutes     Domestic         2    2
921  27MAR2000  LGA  DFW  No Delay         Domestic         2   -5
302  27MAR2000  LGA  WAS  No Delay         Domestic         2   -4
431  27MAR2000  LGA  LAX  1-10 Minutes     Domestic         2    3
308  27MAR2000  LGA  ORD  11+ Minutes      Domestic         2   17
182  28MAR2000  LGA  YYZ  No Delay         International    3   -9
114  28MAR2000  LGA  LAX  1-10 Minutes     Domestic         3    5
202  28MAR2000  LGA  ORD  11+ Minutes      Domestic         3   13
219  28MAR2000  LGA  LHR  1-10 Minutes     International    3    6
439  28MAR2000  LGA  LAX  1-10 Minutes     Domestic         3    9
387  28MAR2000  LGA  CPH  11+ Minutes      International    3   12
290  28MAR2000  LGA  WAS  1-10 Minutes     Domestic         3    7
523  28MAR2000  LGA  ORD  11+ Minutes      Domestic         3   16
982  28MAR2000  LGA  DFW  1-10 Minutes     Domestic         3   10
622  28MAR2000  LGA  FRA  11+ Minutes      International    3   13
821  28MAR2000  LGA  LHR  1-10 Minutes     International    3    9
872  28MAR2000  LGA  LAX  No Delay         Domestic         3   -1
416  28MAR2000  LGA  WAS  No Delay         Domestic         3   -4
132  28MAR2000  LGA  YYZ  No Delay         International    3   -4
829  28MAR2000  LGA  WAS  1-10 Minutes     Domestic         3    8
183  28MAR2000  LGA  WAS  No Delay         Domestic         3   -2
271  28MAR2000  LGA  CDG  11+ Minutes      International    3   14
921  28MAR2000  LGA  DFW  No Delay         Domestic         3   -5
302  28MAR2000  LGA  WAS  No Delay         Domestic         3   -2
431  28MAR2000  LGA  LAX  No Delay         Domestic         3   -6
308  28MAR2000  LGA  ORD  No Delay         Domestic         3    0
182  29MAR2000  LGA  YYZ  1-10 Minutes     International    4   10
114  29MAR2000  LGA  LAX  No Delay         Domestic         4   -7
202  29MAR2000  LGA  ORD  No Delay         Domestic         4   -1
219  29MAR2000  LGA  LHR  11+ Minutes      International    4   27
439  29MAR2000  LGA  LAX  No Delay         Domestic         4   -4
387  29MAR2000  LGA  CPH  11+ Minutes      International    4   22
290  29MAR2000  LGA  WAS  1-10 Minutes     Domestic         4    6
523  29MAR2000  LGA  ORD  1-10 Minutes     Domestic         4    6
982  29MAR2000  LGA  DFW  No Delay         Domestic         4   -7
622  29MAR2000  LGA  FRA  1-10 Minutes     International    4    3
821  29MAR2000  LGA  LHR  11+ Minutes      International    4   14
872  29MAR2000  LGA  LAX  No Delay         Domestic         4   -4
416  29MAR2000  LGA  WAS  1-10 Minutes     Domestic         4    3
132  29MAR2000  LGA  YYZ  1-10 Minutes     International    4    5
183  29MAR2000  LGA  WAS  11+ Minutes      Domestic         4   11
271  29MAR2000  LGA  CDG  11+ Minutes      International    4   39
921  29MAR2000  LGA  DFW  11+ Minutes      Domestic         4   13
302  29MAR2000  LGA  WAS  No Delay         Domestic         4   -6
431  29MAR2000  LGA  LAX  11+ Minutes      Domestic         4   16
308  29MAR2000  LGA  ORD  No Delay         Domestic         4   -4
182  30MAR2000  LGA  YYZ  1-10 Minutes     International    5    2
114  30MAR2000  LGA  LAX  No Delay         Domestic         5   -7
202  30MAR2000  LGA  ORD  1-10 Minutes     Domestic         5    7
219  30MAR2000  LGA  LHR  No Delay         International    5    0
439  30MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    7
387  30MAR2000  LGA  CPH  1-10 Minutes     International    5    8
290  30MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    4
523  30MAR2000  LGA  ORD  1-10 Minutes     Domestic         5   10
982  30MAR2000  LGA  DFW  1-10 Minutes     Domestic         5    8
622  30MAR2000  LGA  FRA  1-10 Minutes     International    5    1
821  30MAR2000  LGA  LHR  No Delay         International    5   -1
872  30MAR2000  LGA  LAX  11+ Minutes      Domestic         5   12
416  30MAR2000  LGA  WAS  No Delay         Domestic         5   -4
132  30MAR2000  LGA  YYZ  1-10 Minutes     International    5    6
829  30MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    3
183  30MAR2000  LGA  WAS  1-10 Minutes     Domestic         5    3
271  30MAR2000  LGA  CDG  11+ Minutes      International    5   16
921  30MAR2000  LGA  DFW  No Delay         Domestic         5   -3
302  30MAR2000  LGA  WAS  No Delay         Domestic         5   -6
431  30MAR2000  LGA  LAX  1-10 Minutes     Domestic         5    2
308  30MAR2000  LGA  ORD  No Delay         Domestic         5   -1
182  31MAR2000  LGA  YYZ  No Delay         International    6   -6
114  31MAR2000  LGA  LAX  No Delay         Domestic         6   -2
202  31MAR2000  LGA  ORD  No Delay         Domestic         6   -8
219  31MAR2000  LGA  LHR  No Delay         International    6   -4
439  31MAR2000  LGA  LAX  1-10 Minutes     Domestic         6    7
387  31MAR2000  LGA  CPH  1-10 Minutes     International    6    9
290  31MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    6
523  31MAR2000  LGA  ORD  1-10 Minutes     Domestic         6    3
982  31MAR2000  LGA  DFW  1-10 Minutes     Domestic         6    7
622  31MAR2000  LGA  FRA  11+ Minutes      International    6   19
821  31MAR2000  LGA  LHR  1-10 Minutes     International    6    2
872  31MAR2000  LGA  LAX  No Delay         Domestic         6   -1
416  31MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    5
132  31MAR2000  LGA  YYZ  No Delay         International    6   -3
829  31MAR2000  LGA  WAS  No Delay         Domestic         6   -4
183  31MAR2000  LGA  WAS  1-10 Minutes     Domestic         6    6
271  31MAR2000  LGA  CDG  1-10 Minutes     International    6    7
921  31MAR2000  LGA  DFW  No Delay         Domestic         6   -1
302  31MAR2000  LGA  WAS  No Delay         Domestic         6   -2
431  31MAR2000  LGA  LAX  1-10 Minutes     Domestic         6    8
308  31MAR2000  LGA  ORD  1-10 Minutes     Domestic         6    1
;
run;
data sasuser.flightschedule;
   informat Date date9. Destination FlightNumber $3.;
   input FlightNumber $ 1-3 @10 Date date9.
         Destination $ 27-29 EmpID $ 38-41;
   format date date9. Destination FlightNumber $3.;
datalines;
132      01MAR2000        YYZ        1739
132      01MAR2000        YYZ        1478
132      01MAR2000        YYZ        1130
132      01MAR2000        YYZ        1390
132      01MAR2000        YYZ        1983
132      01MAR2000        YYZ        1111
182      01MAR2000        YYZ        1076
182      01MAR2000        YYZ        1118
182      01MAR2000        YYZ        1094
182      01MAR2000        YYZ        1122
182      01MAR2000        YYZ        1115
182      01MAR2000        YYZ        1269
219      01MAR2000        LHR        1407
219      01MAR2000        LHR        1777
219      01MAR2000        LHR        1103
219      01MAR2000        LHR        1125
219      01MAR2000        LHR        1350
219      01MAR2000        LHR        1332
271      01MAR2000        CDG        1439
271      01MAR2000        CDG        1442
271      01MAR2000        CDG        1132
271      01MAR2000        CDG        1411
271      01MAR2000        CDG        1988
271      01MAR2000        CDG        1443
387      01MAR2000        CPH        1428
387      01MAR2000        CPH        1928
387      01MAR2000        CPH        1113
387      01MAR2000        CPH        1135
387      01MAR2000        CPH        1431
387      01MAR2000        CPH        1839
622      01MAR2000        FRA        1545
622      01MAR2000        FRA        1890
622      01MAR2000        FRA        1116
622      01MAR2000        FRA        1221
622      01MAR2000        FRA        1433
622      01MAR2000        FRA        1352
821      01MAR2000        LHR        1556
821      01MAR2000        LHR        1830
821      01MAR2000        LHR        1124
821      01MAR2000        LHR        1368
821      01MAR2000        LHR        1437
821      01MAR2000        LHR        1417
132      02MAR2000        YYZ        1556
132      02MAR2000        YYZ        1478
132      02MAR2000        YYZ        1113
132      02MAR2000        YYZ        1411
132      02MAR2000        YYZ        1574
132      02MAR2000        YYZ        1111
182      02MAR2000        YYZ        1076
182      02MAR2000        YYZ        1777
182      02MAR2000        YYZ        1414
182      02MAR2000        YYZ        1125
182      02MAR2000        YYZ        1434
182      02MAR2000        YYZ        1269
219      02MAR2000        LHR        1407
219      02MAR2000        LHR        1118
219      02MAR2000        LHR        1132
219      02MAR2000        LHR        1135
219      02MAR2000        LHR        1441
219      02MAR2000        LHR        1332
271      02MAR2000        CDG        1739
271      02MAR2000        CDG        1442
271      02MAR2000        CDG        1103
271      02MAR2000        CDG        1413
271      02MAR2000        CDG        1115
271      02MAR2000        CDG        1443
387      02MAR2000        CPH        1428
387      02MAR2000        CPH        1928
387      02MAR2000        CPH        1130
387      02MAR2000        CPH        1221
387      02MAR2000        CPH        1475
387      02MAR2000        CPH        1839
622      02MAR2000        FRA        1439
622      02MAR2000        FRA        1890
622      02MAR2000        FRA        1124
622      02MAR2000        FRA        1368
622      02MAR2000        FRA        1477
622      02MAR2000        FRA        1352
821      02MAR2000        LHR        1545
821      02MAR2000        LHR        1830
821      02MAR2000        LHR        1116
821      02MAR2000        LHR        1390
821      02MAR2000        LHR        1555
821      02MAR2000        LHR        1417
132      03MAR2000        YYZ        1739
132      03MAR2000        YYZ        1928
132      03MAR2000        YYZ        1425
132      03MAR2000        YYZ        1135
132      03MAR2000        YYZ        1437
132      03MAR2000        YYZ        1111
182      03MAR2000        YYZ        1407
182      03MAR2000        YYZ        1410
182      03MAR2000        YYZ        1094
182      03MAR2000        YYZ        1413
182      03MAR2000        YYZ        1574
182      03MAR2000        YYZ        1269
219      03MAR2000        LHR        1428
219      03MAR2000        LHR        1442
219      03MAR2000        LHR        1130
219      03MAR2000        LHR        1411
219      03MAR2000        LHR        1115
219      03MAR2000        LHR        1332
271      03MAR2000        CDG        1905
271      03MAR2000        CDG        1118
271      03MAR2000        CDG        1970
271      03MAR2000        CDG        1125
271      03MAR2000        CDG        1983
271      03MAR2000        CDG        1443
387      03MAR2000        CPH        1439
387      03MAR2000        CPH        1478
387      03MAR2000        CPH        1132
387      03MAR2000        CPH        1390
387      03MAR2000        CPH        1350
387      03MAR2000        CPH        1839
622      03MAR2000        FRA        1545
622      03MAR2000        FRA        1830
622      03MAR2000        FRA        1414
622      03MAR2000        FRA        1368
622      03MAR2000        FRA        1431
622      03MAR2000        FRA        1352
821      03MAR2000        LHR        1556
821      03MAR2000        LHR        1890
821      03MAR2000        LHR        1422
821      03MAR2000        LHR        1221
821      03MAR2000        LHR        1433
821      03MAR2000        LHR        1417
132      04MAR2000        YYZ        1428
132      04MAR2000        YYZ        1118
132      04MAR2000        YYZ        1103
132      04MAR2000        YYZ        1390
132      04MAR2000        YYZ        1350
132      04MAR2000        YYZ        1111
182      04MAR2000        YYZ        1905
182      04MAR2000        YYZ        1442
182      04MAR2000        YYZ        1132
182      04MAR2000        YYZ        1122
182      04MAR2000        YYZ        1988
182      04MAR2000        YYZ        1269
219      04MAR2000        LHR        1739
219      04MAR2000        LHR        1478
219      04MAR2000        LHR        1130
219      04MAR2000        LHR        1125
219      04MAR2000        LHR        1983
219      04MAR2000        LHR        1332
271      04MAR2000        CDG        1407
271      04MAR2000        CDG        1410
271      04MAR2000        CDG        1094
271      04MAR2000        CDG        1411
271      04MAR2000        CDG        1115
271      04MAR2000        CDG        1443
387      04MAR2000        CPH        1556
387      04MAR2000        CPH        1830
387      04MAR2000        CPH        1124
387      04MAR2000        CPH        1135
387      04MAR2000        CPH        1437
387      04MAR2000        CPH        1839
622      04MAR2000        FRA        1545
622      04MAR2000        FRA        1890
622      04MAR2000        FRA        1116
622      04MAR2000        FRA        1221
622      04MAR2000        FRA        1433
622      04MAR2000        FRA        1352
821      04MAR2000        LHR        1439
821      04MAR2000        LHR        1928
821      04MAR2000        LHR        1113
821      04MAR2000        LHR        1368
821      04MAR2000        LHR        1431
821      04MAR2000        LHR        1417
132      05MAR2000        YYZ        1556
132      05MAR2000        YYZ        1890
132      05MAR2000        YYZ        1113
132      05MAR2000        YYZ        1475
132      05MAR2000        YYZ        1431
132      05MAR2000        YYZ        1111
182      05MAR2000        YYZ        1407
182      05MAR2000        YYZ        1410
182      05MAR2000        YYZ        1414
182      05MAR2000        YYZ        1122
182      05MAR2000        YYZ        1555
182      05MAR2000        YYZ        1269
219      05MAR2000        LHR        1428
219      05MAR2000        LHR        1442
219      05MAR2000        LHR        1422
219      05MAR2000        LHR        1413
219      05MAR2000        LHR        1574
219      05MAR2000        LHR        1332
271      05MAR2000        CDG        1739
271      05MAR2000        CDG        1928
271      05MAR2000        CDG        1103
271      05MAR2000        CDG        1477
271      05MAR2000        CDG        1433
271      05MAR2000        CDG        1443
387      05MAR2000        CPH        1439
387      05MAR2000        CPH        1478
387      05MAR2000        CPH        1425
387      05MAR2000        CPH        1434
387      05MAR2000        CPH        1988
387      05MAR2000        CPH        1839
622      05MAR2000        FRA        1545
622      05MAR2000        FRA        1830
622      05MAR2000        FRA        1970
622      05MAR2000        FRA        1441
622      05MAR2000        FRA        1350
622      05MAR2000        FRA        1352
132      06MAR2000        YYZ        1333
132      06MAR2000        YYZ        1890
132      06MAR2000        YYZ        1414
132      06MAR2000        YYZ        1475
132      06MAR2000        YYZ        1437
132      06MAR2000        YYZ        1111
182      06MAR2000        YYZ        1905
182      06MAR2000        YYZ        1777
182      06MAR2000        YYZ        1422
182      06MAR2000        YYZ        1413
182      06MAR2000        YYZ        1574
182      06MAR2000        YYZ        1269
219      06MAR2000        LHR        1106
219      06MAR2000        LHR        1118
219      06MAR2000        LHR        1425
219      06MAR2000        LHR        1434
219      06MAR2000        LHR        1555
219      06MAR2000        LHR        1332
821      06MAR2000        LHR        1107
821      06MAR2000        LHR        1928
821      06MAR2000        LHR        1970
821      06MAR2000        LHR        1441
821      06MAR2000        LHR        1477
821      06MAR2000        LHR        1417
132      07MAR2000        YYZ        1407
132      07MAR2000        YYZ        1118
132      07MAR2000        YYZ        1094
132      07MAR2000        YYZ        1555
132      07MAR2000        YYZ        1350
132      07MAR2000        YYZ        1111
182      07MAR2000        YYZ        1076
182      07MAR2000        YYZ        1442
182      07MAR2000        YYZ        1116
182      07MAR2000        YYZ        1122
182      07MAR2000        YYZ        1988
182      07MAR2000        YYZ        1269
219      07MAR2000        LHR        1905
219      07MAR2000        LHR        1478
219      07MAR2000        LHR        1124
219      07MAR2000        LHR        1434
219      07MAR2000        LHR        1983
219      07MAR2000        LHR        1332
271      07MAR2000        CDG        1410
271      07MAR2000        CDG        1777
271      07MAR2000        CDG        1103
271      07MAR2000        CDG        1574
271      07MAR2000        CDG        1115
271      07MAR2000        CDG        1443
387      07MAR2000        CPH        1106
387      07MAR2000        CPH        1830
387      07MAR2000        CPH        1422
387      07MAR2000        CPH        1441
387      07MAR2000        CPH        1437
387      07MAR2000        CPH        1839
622      07MAR2000        FRA        1107
622      07MAR2000        FRA        1890
622      07MAR2000        FRA        1425
622      07MAR2000        FRA        1475
622      07MAR2000        FRA        1433
622      07MAR2000        FRA        1352
821      07MAR2000        LHR        1333
821      07MAR2000        LHR        1928
821      07MAR2000        LHR        1970
821      07MAR2000        LHR        1477
821      07MAR2000        LHR        1431
821      07MAR2000        LHR        1417
;
run;

data frequentflyers1;
   input FFID $ 1-6 MemberType $ 9-14 Name $ 17-41
         Address $ 44-63 PhoneNumber $ 66-77;
   format name $25.;
datalines;
WD7152  BRONZE  COOPER, LESLIE             66 DRIVING WAY        501/377-0703
WD8472  BRONZE  LONG, RUSSELL              9813 SUMTER SQUARE    501/367-1097
WD1576  GOLD    BRYANT, ALTON              763 THISTLE DRIVE     501/776-0631
WD3947  SILVER  NORRIS, DIANE              77 PARKWAY PLAZA      501/377-3739
WD9347  SILVER  PEARSON, BRYAN             9999 MARKUP MANOR     501/855-4780
WD8375  BRONZE  COOPER, ANTHONY            12 PIEDPIPER PLACE    602/965-2305
WD7208  BRONZE  LONG, CASEY                66 SHOTTS COURT       602/870-3646
WD6061  BRONZE  RODRIGUEZ, MARIA           88 FREQUENT LANE      602/538-2470
WD0646  GOLD    BOSTIC, MARIE              451 CONESTOGA CT      602/988-8584
WD9829  GOLD    COOK, JENNIFER             5431 TAYLOR WAY       602/274-4633
WD0227  GOLD    FOSTER, GERALD             919 FOURTY-SIX ST.    602/250-9239
WD3022  SILVER  CAHILL, LEONARD            8888 EIGHTH AVENUE    602/954-8143
WD4382  SILVER  O'NEAL, ALICE              148 FINISHED CIRCLE   602/256-1139
WD6080  SILVER  SMART, JONATHAN            4534 AUSTIN AVENUE    602/869-2237
WD9506  BRONZE  BRADLEY, JEREMY            111 PEOPLES COURT     213/512-9244
WD6374  BRONZE  BURKE, CHRISTOPHER         875 TRUNIPGREEN LANE  408/746-7368
WD4762  BRONZE  CARAWAY, NEIL              66 PINE VALLEY        415/493-5589
WD7568  BRONZE  MONROE, JOYCE              22 DOODAD LANE        415/882-3951
WD7255  BRONZE  MORGAN, ALFRED             78 INDIANA FREEWAY    213/855-2514
WD3541  GOLD    AVERY, JERRY               TWENTY-FIRST AVENUE   408/732-1792
WD4451  GOLD    EDGERTON, JOSHUA           5830 HUNTLEIGH DRIVE  805/258-4515
WD5190  GOLD    SAYERS, RANDY              506 CAPRICE COURT     415/361-1787
WD9840  GOLD    VANDEUSEN, RICHARD         333 MAJOR DRIVE       916/427-0774
WD0273  GOLD    WANG, CHRISTOPHER          7329 BAKERS DRIVE     707/792-4673
WD0750  SILVER  ROUSE, JEREMY              27 FUR BLUFF          209/453-7477
WD4620  SILVER  WASHBURN, LAWRENCE         55 FOGHORN COURT      415/991-9259
WD9129  BRONZE  EATON, ALICIA              111 HUNTINGTON LANE   303/370-1889
WD2607  BRONZE  MURPHEY, JOHN              567 TOOTHY WAY        303/773-9404
WD0231  GOLD    GORDON, ANNE               3950 HICCUP HWY       303/939-0154
WD3521  SILVER  FIELDS, DIANA              3490 TART STREET      303/368-9510
WD2950  SILVER  OVERMAN, CAROL             888 FIFTH STREET      303/757-4147
WD7683  SILVER  VEGA, DEBORAH              24 CAULDRON CIRCLE    303/236-1231
WD6177  SILVER  YOUNG, LAWRENCE            15 BOOKER DRIVE       303/744-7909
WD8782  BRONZE  BAUCOM, ALVIN              1 AVOCADO FREEWAY     203/273-5793
WD5120  BRONZE  BAUCOM, WALTER             789 SEABROOK AVENUE   203/636-6393
WD2501  BRONZE  NEWKIRK, WILLIAM           67 HEARTHSTONE DRIVE  203/964-8475
WD8281  BRONZE  PEARSON, JAMES             78 RAISIN ALLEY       203/722-4744
WD5460  GOLD    BAREFOOT, JOSEPH           333 PITS CITY         203/273-0576
WD6343  GOLD    BLAIR, JUSTIN              BLACKSPUR FREEWAY     203/636-4956
WD9710  GOLD    HOWARD, GRETCHEN           3564 APT. B           203/630-5418
WD0023  GOLD    JACKSON, LAURA             35 HARRIS AVENUE      203/798-7399
WD6408  SILVER  CASTON, FRANKLIN           2453 OFFICE PARK      203/563-6115
WD6594  SILVER  GORDON, LEVI               BOX 147 RT. 66        203/244-1681
WD5520  SILVER  JEPSEN, RONALD             143 LANDING LANE      203/798-6221
WD9053  SILVER  STEPHENSON, ADAM           56 COFFEE CIRCLE      203/353-7154
WD8213  SILVER  TRENTON, MELISSA           706 MAYNARD ROAD      203/796-6751
WD3395  BRONZE  VICK, THERESA              S.W. 51ST STREET      202/357-2242
WD5408  BRONZE  YOUNG, DAVIS               TURNIP GREEN DRIVE    202/245-6817
WD7097  GOLD    KRAMER, JACKSON            4567 CABANA COURT     301/763-4147
WD7721  GOLD    LEE, RUSSELL               43 FARLEY DRIVE       301/763-9511
WD7515  GOLD    TUCKER, ALAN               430 APPLEBLOSSOM      202/727-7354
WD8208  SILVER  DUNLAP, DONNA              50 TUMPTON STREET     202/728-0815
WD7978  SILVER  LAWRENCE, KATHY            712 STUFFY CIRCLE     202/566-7927
WD7569  BRONZE  SANDERSON, EDITH           BOOTS LANE            904/488-0366
WD0823  BRONZE  WELCH, DARIUS              3 S. SALEM ROAD       904/488-4569
WD4563  BRONZE  WELCH, RONDA               996 COMMONS WAY       904/488-7217
WD2454  BRONZE  WELLS, JONATHAN            678 CANDLESTICK PARK  904/487-0332
WD9220  GOLD    WATSON, BERNARD            98 ROUGH ROAD         407/367-3818
WD6911  SILVER  GRANT, DANIEL              504 BASHFORD ROAD     904/872-0562
WD3943  SILVER  PATTERSON, RENEE           7618 WINTERSET DRIVE  904/730-5186
WD0357  SILVER  SAUNDERS, MICHAEL          1 ELM STREET          407/244-5603
WD9413  SILVER  WELLS, AGNES               99 PRIX LANE          904/488-8608
WD6613  BRONZE  BURNETTE, THOMAS           14 COMPUTER DRIVE     404/329-7633
WD8355  GOLD    DAVIDSON, JASON            KILLER CIRCLE         404/584-9374
WD8336  SILVER  VEGA, ANNA                 234 HURLY HEIGHT ST.  912/552-4417
WD1410  SILVER  GRAHAM, ALVIN              4513 CHERRY PIT LANE  319/395-9683
WD6271  SILVER  MORGAN, GEORGE             39 PEPPER PLACE       319/352-0167
WD6462  BRONZE  CARTER, DONALD             444 CAPRICE COURT     312/727-6373
WD3951  BRONZE  CARTER, DOROTHY            79 E. HALFTON ROAD    312/727-1004
WD8968  BRONZE  CHAPMAN, NEIL              66 SAULT STREET       312/923-6553
WD9995  BRONZE  RAYNOR, MILTON             19 DOODLE DRIVE       312/822-2333
WD2173  GOLD    ALEXANDER, SUSAN           247 THOMAS LANE       312/362-0596
WD6815  GOLD    NEWTON, JAMES              123 PACIFIC CIRCLE    312/744-8467
WD1691  GOLD    PARKER, ANNE               16 CRAWFORD PLACE     312/698-9009
WD1365  GOLD    REED, MARILYN              LUE STREET            312/822-2647
WD2609  GOLD    WALTERS, LEONARD           99 FREEDOM STREET     312/322-0639
WD8294  SILVER  BOWDEN, EARL               98 VARSITY LANE       312/967-9800
WD0845  SILVER  CARAWAY, DAVIS             66 DUNLOP ROAD        312/280-5998
WD4092  SILVER  CARTER, KAREN              77 PARKWAY EAST       312/906-4882
WD4065  SILVER  DONALDSON, KAREN           14 HORSEY AVENUE      312/470-2826
WD7092  SILVER  PARKER, JAY                222 WITHAVIEW WAY     312/294-3987
WD6184  SILVER  STARR, WILLIAM             12 PINEY PLACE        312/926-9430
WD2004  BRONZE  KING, LESLIE               789 TARA STREET       812/429-9352
WD6383  BRONZE  MCDANIEL, RONDA            354 CRAGGY MIRE       317/542-2396
WD2118  GOLD    JOHNSON, ANTHONY           78 PIPER PLACE        317/845-4646
WD5361  GOLD    PARKER, MARY               456 SHRIVELED COURT   317/353-9399
WD1636  GOLD    VANDEUSEN, ANNA            SUPREME STREET        317/276-5996
WD7791  SILVER  BRADY, CHRISTIN            78 BELMONT LANE       317/230-0346
WD3827  SILVER  KING, WILLIAM              14 PICTURE PLACE      812/429-6041
WD6971  SILVER  KIRBY, ANNE                DUNDEE COURT          812/429-4251
WD0213  SILVER  PITTS, ANTHONY             88 SHERLOCK CIRCLE    812/377-0607
WD6832  SILVER  RHODES, JEREMY             901 INTERCHANGE WAY   812/867-2790
WD1630  SILVER  UPDIKE, THERESA            9870 UMPTON COURT     317/276-3926
WD4945  SILVER  WARD, ELAINE               555 TRYON             317/773-0278
WD2122  BRONZE  JOHNSON, JACKSON           21 JUMP STREET        316/526-7384
WD4781  GOLD    HUNTER, CLYDE              717 PEARLY GATE       913/291-5739
WD1700  GOLD    WOOD, ALAN                 12 CLOWN AROUND CR.   913/628-2795
WD4970  SILVER  STEPHENSON, LARRY          14 MAPLE DRIVE        504/389-3563
WD3099  GOLD    OVERMAN, MICHELLE          FOREST HILLS ROAD     508/291-2628
WD1471  GOLD    STARR, ALTON               1 BOURBON STREET      508/371-1266
WD5201  SILVER  OVERBY, NADINE             99 VASE PLACE         617/821-6123
WD4925  SILVER  TUTTLE, JACK               77777 SEVENTH STREET  508/559-5820
WD0237  BRONZE  VENTER, RANDALL            46 CUPPER STREET      301/961-5424
WD8054  BRONZE  VENTER, RANDY              88 WOODSY GROVE       301/961-6083
WD9902  BRONZE  WOOD, SANDRA               S. CLIFTON STREET     301/689-5388
WD8789  SILVER  HOWARD, LEONARD            45 PECAN PLACE        207/775-3375
WD7036  BRONZE  HUNTER, HELEN              2001 CHINUP CIRCLE    313/225-5954
WD8058  BRONZE  O'NEAL, BRYAN              143 S. SAUNDERS ST.   906/486-6778
WD2082  BRONZE  THOMPSON, ALICE            905 WAITING WAY       517/496-4293
WD6356  BRONZE  VEGA, FRANKLIN             778 SWEET STREET      313/994-9697
WD8330  BRONZE  WHALEY, CAROLYN            3267 SHADED TREE LN.  313/337-0108
WD6169  BRONZE  WILDER, NEIL               78 PUMPKIN PLACE      313/845-0919
WD0632  GOLD    BROWN, JASON               99 BENTLEY PLACE      313/354-6755
WD8856  GOLD    STEPHENSON, ROBERT         812 MAIN STREET       517/636-5259
WD9870  GOLD    UPCHURCH, LARRY            19TH AVOCADO VILLAGE  313/236-9457
WD0445  SILVER  DENNIS, ROGER              567 CHERRYSTONE CT    313/352-0051
WD7716  SILVER  MORGAN, DIANA              112 MAIN STREET       517/774-6646
WD0599  SILVER  SAYERS, MARSHALL           2310 HOWELL STREET    313/746-2204
WD5669  SILVER  THOMPSON, JOSHUA           1 HASSLE WAY          517/496-2015
WD0140  SILVER  THOMPSON, WAYNE            2469 HUNTER STREET    517/496-3559
WD3129  BRONZE  FLOWERS, ANNETTE           BOX 7700 SUMTER WAY   878/626-4481
WD7998  BRONZE  JONES, LESLIE              202 SHOTTS COURT      919/748-8668
WD3671  BRONZE  MCDANIEL, JOANN            77 COWBOY DRIVE       248/821-1223
WD7206  GOLD    HOWARD, MICHAEL            N. NOWELL STREET      919/489-0988
WD8209  GOLD    MARSHBURN, JASPER          W. 51ST STREET        248/476-1305
WD3169  GOLD    YOUNG, JOANN               10 WITHER WAY         704/462-8020
WD5621  SILVER  EDWARDS, BRENDA            APT. 901              919/727-0077
WD3964  SILVER  MARKS, JOHN                7893 SUITE 246        248/845-1091
WD2536  SILVER  MOORE, SUZANNE             S. SHELL DRIVE        823/906-4458
WD9747  SILVER  TRIPP, KATHY               77 JUNGLE JUNCTION    919/598-5142
WD2615  GOLD    HARTFORD, RAYMOND          356 PEACHTREE         402/390-4675
WD0825  GOLD    WASHBURN, GAYLE            8750 INDIAN WAY       402/399-6453
WD3076  SILVER  HENDERSON, WILLIAM         44 S. MAGNOLIA DRIVE  603/224-4299
WD3205  GOLD    DUNLAP, MARIA              45 MACY'S PLACE       201/316-4476
WD7286  GOLD    HOWARD, ROGER              567 MAIN STREET       201/456-3478
WD1974  BRONZE  APPLE, TROY                H2O AGUA LANE         516/663-7830
WD1339  BRONZE  ARTHUR, BARBARA            33 EYEGLASS COURT     516/663-3573
WD1354  BRONZE  KIRBY, JANICE              303 CAREY LANE        718/403-0324
WD8186  BRONZE  NELSON, SANDRA             S. COMMONS PLACE      212/906-1008
WD1637  GOLD    NELSON, FELICIA            NORTH STREET          516/326-9294
WD4885  GOLD    PETERS, RANDALL            RT. 10 BOX 87         212/746-7822
WD4604  GOLD    PITTS, MICHAEL             12 ENDING DRIVE       212/709-7960
WD4646  GOLD    RICHARDS, CASEY            1961 ERIE STREET      212/392-9309
WD8536  SILVER  NEWKIRK, SANDRA            1010 WUTHERING HTS.   212/906-5282
WD5818  SILVER  PENNINGTON, THOMAS         76 LADYINRED CORNER   607/255-5457
WD9165  SILVER  PETERSON, LEVI             14 LAMPLEY DRIVE      516/535-9282
WD3392  SILVER  PHELPS, WILLIAM            RT. 50 BOX 88         201/285-1281
WD3000  SILVER  PORTER, SUSAN              1 BAMBOO COURT        212/709-8890
WD6488  SILVER  UPCHURCH, MICHAEL          8803 CAT SCRATCH DR.  716/647-8055
WD5091  SILVER  WALTERS, DIANE             12 HASSLE FRWY        212/720-6911
WD3121  BRONZE  BURNETTE, MICHELLE         34 VELLEY DRIVE       419/435-9721
WD1961  GOLD    JONES, NATHAN              8 BOLOXI CIRCLE       216/379-5842
WD9959  SILVER  FERNANDEZ, KATRINA         17 CLYDE DRIVE        513/425-3195
WD1218  SILVER  GRAHAM, MARY               76 CELEBRATION CT.    614/424-1420
WD9080  SILVER  MURPHY, ANNE               WESTGATE AVENUE       513/784-0791
WD9894  SILVER  OSWALD, LESLIE             8830 DUMPY DRIVE      216/444-4796
WD3879  SILVER  PARKER, RICHARD            1 BEECH CREEK LANE    614/438-1239
WD8000  SILVER  PEARCE, THOMAS             THIRD AVENUE          405/767-5329
WD6674  SILVER  PEARCE, CAROL              14 RIVALRY ROAD       503/757-2469
WD3353  SILVER  YANCEY, ROBIN              99 SPUD STREET        503/669-1826
WD3468  BRONZE  BRYANT, LEONARD            999 TRADE ST.         412/337-3046
WD4692  BRONZE  DEAN, SANDRA               APPLEBLOSSOM COURT    215/972-4500
WD4049  BRONZE  GREEN, JANICE              783 TOPCAT LANE       814/533-4165
WD8667  BRONZE  YOUNG, DEBORAH             53 PINE PLACE         215/531-4407
WD5134  GOLD    COOK, BRENDA               1 PACIFIC HWY         215/443-0488
WD4963  GOLD    HARRIS, CHARLES            TUMBLEWEED ROAD       215/694-2748
WD7963  GOLD    RICHARDS, JAY              S. ATHENS DRIVE       215/697-7239
WD2369  GOLD    WANG, CHIN                 RT. 5 BOX 123         215/985-3691
WD5156  SILVER  BOYCE, JONATHAN            90 DOORWAY DRIVE      814/332-9419
WD2741  SILVER  EDGERTON, WAYNE            15 CHIPMUNK WAY       717/587-4776
WD5687  SILVER  EDWARDS, JENNIFER          3 PEGBOARD PLACE      717/231-4906
WD9642  SILVER  FLETCHER, MARIE            ROUND-THE-BEND CR     215/439-0562
WD4331  SILVER  GREEN, GEORGE              999 LIMEST WAY        215/694-0498
WD3127  SILVER  MOORE, LESLIE              717 AUSTIN AVENUE     412/268-9024
WD2719  SILVER  TUCKER, NEIL               35 TURQUOISE WAY      717/657-4442
WD4616  BRONZE  MORGAN, DONNA              14 198TH STREET       514/374-9839
WD1827  SILVER  SANDERS, RAYMOND           876 WITCHES WAY       514/848-5771
WD0715  SILVER  PARKER, WALTER             539 HEMLOCK BLUFF     615/327-9871
WD8111  BRONZE  CAHILL, MARSHALL           56 ANN STREET         713/831-7236
WD8545  BRONZE  LUFKIN, ROY                67 E. GROUPER         817/878-1876
WD1883  BRONZE  PENNINGTON, MICHAEL        22 57TH STREET        214/754-2538
WD1175  BRONZE  WOOD, ROBERT               W. 1ST STREET         214/353-5453
WD5282  GOLD    TUTTLE, THOMAS             88 WHARF STREET       214/272-6563
WD9641  GOLD    VARNER, CHIN               478 FRYE STREET       713/656-6916
WD3498  SILVER  MEYERS, PRESTON            567 TURNER LANE       713/552-7167
WD1042  SILVER  VARNER, ELIZABET           14 NOVA WAY           915/683-7784
WD0815  BRONZE  OVERBY, PHILLIP            E. FIRST STREET       804/253-3102
WD0448  GOLD    MORGAN, CHRISTOPHER        210 NEW HILL RD.      703/824-8273
WD0668  GOLD    RIVERS, SIMON              RT. 54 BOX 100        703/274-2887
WD6504  GOLD    WELLS, NADINE              52 TREETORN DRIVE     804/490-3454
WD1673  SILVER  MURPHY, ALICE              15 HUMPHREY PLACE     804/594-3547
WD8159  SILVER  PETERSON, SUZANNE          117 MARTIN ST NW      804/270-0916
WD0051  SILVER  SAUNDERS, JACK             8757 DOGWOOD DRIVE    804/786-2802
WD4657  SILVER  WALTERS, ANNE              36 ALICIA LANE        703/733-9565
WD7916  BRONZE  SANDERSON, NATHAN          202 S. FAIRVIEW ST.   206/753-8227
WD4757  BRONZE  DEAN, SHARON               256 DONE DRIVE        414/647-2143
WD3561  BRONZE  NICHOLLS, HENRY            214 ALMOST DRIVE      414/278-2446
WD1445  BRONZE  WOOD, DEBORAH              14 CAT STREET         414/735-8586
WD1447  GOLD    BLALOCK, RALPH             8899 PADUKAH WAY      414/734-2097
WD5020  GOLD    BOYCE, RANDALL             456 JEFFERSON FWY     414/382-9729
WD8478  GOLD    DELGADO, DARIUS            55 MILKY WAY          414/647-5891
WD4231  GOLD    DELGADO, MARIA             8880 BLOSSOM DRIVE    414/647-6597
WD2453  GOLD    DENNIS, FELICIA            55 TIN PAN ALLEY      414/647-8145
WD4991  SILVER  ADAMS, GERALD              45 POTTER DRIVE       414/721-4288
WD2455  SILVER  CHAPMAN, GAYLE             56 EAST PARKWAY       414/734-5265
WD6437  SILVER  JONES, RUSSELL             102 PLANTING POT ST.  414/259-6209
;
run;

data frequentflyers2;
   input City $ 1-20 State $ 26-27 ZipCode $ 34-38
         MilesTraveled 48-52 PointsEarned 62-66
         PointsUsed 76-80;
   format city $20. state $2. zipcode $5.
          milestraveled pointsearned pointsused 10.;
datalines;
Little Rock              AR      72201         30833         31333             0
Monticello               AR      71655         25570         26070             0
Bauxite                  AR      72011         56144         58644         27000
North Little Rock        AR      72119         40922         45922         23000
Bella Vista              AR      72714          4839          9839             0
Tempe                    AZ      85287         30007         30507         25000
Phoenix                  AZ      85024         48943         49443         30000
Fort Huachuca            AZ      85613         60142         60642         40000
Williams AFB             AZ      85240         87044         89544         25000
Phoenix                  AZ      85012          1901          4401             0
Phoenix                  AZ      85004         46579         49079         20000
Phoenix                  AZ      85016         41386         46386             0
Phoenix                  AZ      85003         30047         35047             0
Phoenix                  AZ      85027         11266         16266             0
Torrance                 CA      90509         40975         41475         30000
Sunnyvale                CA      94086         35813         36313         30000
Palo Alto                CA      94302         75669         76169             0
San Francisco            CA      94105         74292         74792         50000
Los Angeles,             CA      90048         10314         10814             0
Santa Clara              CA      95054         70523         73023         35000
Edwards AFB              CA      93523            19          2519             0
Redwood City             CA      94063         17848         20348             0
Sacramento               CA      95823         42026         44526         40000
Petaluma                 CA      94952         71343         73843         20000
Fresno                   CA      93727         49290         54290         25000
Daly City                CA      94015         74476         79476             0
Denver                   CO      80279         58049         58549         40000
Englewood                CO      80111         26663         27163             0
Boulder                  CO      80306          5446          7946         21000
Aurora                   CO      80014          8849         13849         20000
Denver                   CO      80222         91495         96495         22500
Lakewood                 CO      80228         46844         51844         40000
Denver                   CO      80209          7366         12366             0
Hartford                 CT      06156         17355         17855             0
Hartford                 CT      06156         99076         99576         80000
Stamford                 CT      06902         46911         47411         25000
Hartford                 CT      06103         62248         62748             0
Hartford                 CT      06156         16414         18914             0
Hartford                 CT      06156         57335         59835         40000
North Haven              CT      06473         33345         35845             0
Ridgefield               CT      06877         17495         19995         20000
Rocky Hill               CT      06067         98178        103178             0
East Hartford            CT      06108          6659         11659             0
Richfield                CT      06877         59209         64209         40000
Stamford                 CT      06902         98831        103831             0
Bethel                   CT      06801         94726         99726         40000
Washington               DC      20001         59359         59859         25000
Washington               DC      20204         16140         16640             0
Washington               DC      20233         34722         37222             0
Washington               DC      20233          4765          7265             0
Washington               DC      20001         45974         48474             0
Washington               DC      20049         64762         69762         40000
Washington               DC      20226         63623         68623         50000
Tallahassee              FL      32301         10392         10892             0
Tallahassee              FL      32399         37753         38253         20500
Tallahassee              FL      32399         94023         94523             0
Tallahassee              FL      32301         92761         93261         20000
Boca Raton               FL      33431         42204         44704         30000
Panama City              FL      32401         65027         70027         40000
Jacksonville             FL      32217         52151         57151         20000
Orlando                  FL      32801         44250         49250         20500
Tallahassee              FL      32399           206          5206             0
Atlanta                  GA      30329         20567         21067             0
Atlanta                  GA      30303         21588         24088         20000
Sandersville             GA      31082         85155         90155             0
Cedar Rapids             IA      52406         89797         94797         30000
Waverly                  IA      50677         50963         55963         40000
Chicago                  IL      60606         49431         49931         30000
Chicago                  IL      60606         21937         22437         20000
Chicago                  IL      60611         62051         62551             0
Chicago                  IL      60685         56383         56883         35000
Libertyville             IL      60048         58671         61171         22300
Chicago                  IL      60602         65625         68125         30000
Rosemont                 IL      60018         68603         71103         22900
Chicago                  IL      60685         92351         94851         20000
Chicago                  IL      60690         89616         92116         30000
Skokie                   IL      60077         55425         60425             0
Chicago                  IL      60611         96996        101996         30000
Chicago                  IL      60606         89019         94019         30000
Morton Grove             IL      60053          8267         13267         20000
Chicago                  IL      60603         74400         79400             0
Fort Sheridan            IL      60037         86814         91814             0
Evansville               IN      47721         75162         75662         25000
Indianapolis             IN      46219         28455         28955         25000
Indianapolis             IN      46250         28109         30609         30000
Indianapolis             IN      46219         74277         76777         50000
Indianapolis             IN      46285         30605         33105         20800
Indianapolis             IN      46206         58153         63153         20000
Evansville               IN      47721         27234         32234         30000
Evansville               IN      47721         51826         56826         40000
Columbus                 IN      47202         50902         55902         23090
Evansville               IN      47711         73291         78291         50000
Indianapolis             IN      46285         75743         80743         20000
Noblesville              IN      46060         79067         84067         50000
Wichita                  KS      67277         57416         57916         22000
Topeka                   KS      66629         29431         31931         30000
Hays                     KS      67601          9664         12164         25000
Plaquemine               LA      70765         50164         55164         40000
Wareham                  MA      02571         89554         92054         25000
Concord                  MA      01742         70771         73271         21000
Canton                   MA      02021          3668          8668             0
W. Bridgewater           MA      02379          7037         12037             0
Bethesda                 MD      20814         39978         40478         20000
Bethesda                 MD      20814         51816         52316         40000
Frostburg                MD      21537         59505         60005         30000
Portland                 ME      04101         65032         70032             0
Detroit                  MI      48232         77271         77771         60000
Ishpeming                MI      49849         74988         75488         70000
Auburn                   MI      48611         70505         71005         20000
Ann Arbor                MI      48105         67571         68071         40000
Dearborn                 MI      48121         75686         76186         40000
Dearborn                 MI      48121         61476         61976         40000
Southfield               MI      48075          8133         10633         30000
Midland                  MI      48674         86215         88715             0
Flint                    MI      48550         79828         82328         40000
Southfield               MI      48076         65352         70352         30000
Mt. Pleasant             MI      48859         57611         62611             0
Southfield               MI      48086         83471         88471         22000
Midland,                 MI      48686         86491         91491         60000
Midland,                 MI      48686         53549         58549         20800
Raleigh                  NC      27604         21865         22365         40000
Winston Salem            NC      27103         51510         52010         45000
RTP                      NC      27709         35271         35771         20550
Durham                   NC      27702         81926         84426         50000
RTP                      NC      27709         29324         31824             0
Hickory                  NC      28601         54272         56772         22000
Winston Salem            NC      27102         28431         33431             0
RTP                      NC      27709         65191         70191         20000
Raleigh                  NC      27886          1636          6636             0
Durham                   NC      27703         26735         31735             0
Omaha                    NE      68180         50477         52977         20000
Omaha                    NE      68114         49321         51821         20000
Concord                  NH      03306         64312         69312             0
Parsippany               NJ      07054         59350         61850         25000
Newark                   NJ      07101         43720         46220             0
Garden City              NY      11530         36452         36952         20000
Garden City              NY      11530         76282         76782         35000
Brooklyn                 NY      11201         82161         82661         20000
New York                 NY      10043         81275         81775             0
Lake Success             NY      11040         14303         16803         22850
New York                 NY      10021         83643         86143         70000
New York                 NY      10019          1723          4223             0
New York                 NY      10048         79862         82362             0
New York City            NY      10043         38882         43882         30000
Ithica                   NY      14853          7729         12729             0
Mineola                  NY      11501         80500         85500         80000
Morristown               NY      07960         91827         96827         22500
New York                 NY      10004         91403         96403         30000
Rochester                NY      14606         50700         55700         50000
New York                 NY      10045         32672         37672         20000
Fostoria                 OH      44830         53294         53794         20000
Akron                    OH      44317         83458         85958         30000
Middletown               OH      45043         17425         22425         20000
Columbus                 OH      43201         17559         22559         23000
Cincinnati               OH      45202         30145         35145         30000
Cleveland                OH      44195         78871         83871         40000
Worthington              OH      43085         47549         52549         20000
Ponca City               OK      74603         32388         37388         30000
Corvallis                OR      97330         49633         54633             0
Gresham                  OR      97030         88154         93154         30000
Alcoa Center             PA      15069         89121         89621         23500
Philadelphia             PA      13912         78963         79463             0
Johnstown                PA      15907         51606         52106         40000
Philadelphia             PA      19101         77764         78264             0
Horsham                  PA      19044         29041         31541         20000
Bethlehem                PA      18016         60405         62905         60000
Philadelphia             PA      19111         95140         97640         80000
Philadelphia             PA      19109         36745         39245         22780
Meadville                PA      16335         64219         69219             0
Clarks Summit            PA      18411           988          5988         35000
Harrisburg               PA      17104         19406         24406             0
Allentown                PA      18103         99293        104293             0
Bethlehem                PA      18016         26998         31998         20000
Pittsburgh               PA      15213         19016         24016             0
Harrisburg               PA      17110         27643         32643         20000
Montreal                 PQ      H2E 1         31348         31848             0
Montreal                 QU      H3G 1         28499         33499         25000
Nashville                TN      37208         95146        100146         20400
Houston                  TX      77253         21682         22182             0
Ft. Worth                TX      76102         83307         83807         80000
Dallas                   TX      75201         15543         16043         20000
Plano                    TX      75024         38474         38974             0
Dallas                   TX      75243         11051         13551             0
Houston                  TX      77002         48728         51228             0
Houston                  TX      77210         71666         76666         20000
Midland                  TX      79702         43248         48248         20700
Williamsburg             VA      23185         90051         90551         21000
Alexandria               VA      22302         58108         60608         20000
Alexandria               VA      22333         76850         79350         20000
Virginia Beach           VA      23462         44541         47041         45000
Newport News             VA      23661         63475         68475         20000
Richmond                 VA      23229         66121         71121             0
Richmond                 VA      23240         27133         32133         25000
Reston                   VA      22090         51955         56955             0
Olympia                  WA      98504         25623         26123         20000
Milwaukee                WI      53215         40916         41416             0
Milwaukee                WI      53202         83956         84456         22000
Appleton                 WI      54913         59275         59775         33000
Appleton                 WI      54919         62051         64551         21000
Milwaukee                WI      53024         19422         21922         20000
Milwaukee                WI      53215         95498         97998         45000
Milwaukee                WI      53215         46702         49202         20000
Milwaukee                WI      53215         33740         36240         25000
Neenah                   WI      54956         38589         43589         30000
Appleton                 WI      54912         52431         57431         35000
Wauwatosa                WI      53222         27772         32772         30000
;
run;

data sasuser.frequentflyers;
   set frequentflyers1;
   set frequentflyers2;
run;

proc datasets library=work nodetails nolist;
   delete frequentflyers1 frequentflyers2;
run;
quit;

data sasuser.internationalflights;
   informat Date date9.;
   input FlightNumber $ 1-3 @10 Date date9.
         Destination $ 27-29 Boarded 40-42;
   format date date9.;
datalines;
182      01MAR2000        YYZ          104
219      01MAR2000        LHR          198
387      01MAR2000        CPH          152
622      01MAR2000        FRA          207
821      01MAR2000        LHR          205
132      01MAR2000        YYZ          115
271      01MAR2000        CDG          138
182      02MAR2000        YYZ          116
219      02MAR2000        LHR          147
387      02MAR2000        CPH          105
622      02MAR2000        FRA          176
821      02MAR2000        LHR          201
132      02MAR2000        YYZ          106
271      02MAR2000        CDG          172
182      03MAR2000        YYZ          137
219      03MAR2000        LHR          197
387      03MAR2000        CPH          138
622      03MAR2000        FRA          180
821      03MAR2000        LHR          151
132      03MAR2000        YYZ           75
271      03MAR2000        CDG          147
182      04MAR2000        YYZ          160
219      04MAR2000        LHR          232
387      04MAR2000        CPH           81
622      04MAR2000        FRA          137
821      04MAR2000        LHR          167
132      04MAR2000        YYZ          117
271      04MAR2000        CDG          146
182      05MAR2000        YYZ          125
219      05MAR2000        LHR          160
387      05MAR2000        CPH          142
622      05MAR2000        FRA          185
132      05MAR2000        YYZ          157
271      05MAR2000        CDG          177
182      06MAR2000        YYZ          122
219      06MAR2000        LHR          163
821      06MAR2000        LHR          167
132      06MAR2000        YYZ          150
182      07MAR2000        YYZ          155
219      07MAR2000        LHR          241
387      07MAR2000        CPH          131
622      07MAR2000        FRA          210
821      07MAR2000        LHR          215
132      07MAR2000        YYZ          164
271      07MAR2000        CDG          155
182      08MAR2000        YYZ          164
219      08MAR2000        LHR          183
387      08MAR2000        CPH          150
622      08MAR2000        FRA          176
821      08MAR2000        LHR          186
132      08MAR2000        YYZ          104
271      08MAR2000        CDG          152
182      09MAR2000        YYZ          140
219      09MAR2000        LHR          211
387      09MAR2000        CPH          128
622      09MAR2000        FRA          173
821      09MAR2000        LHR          203
132      09MAR2000        YYZ          119
271      09MAR2000        CDG          159
182      10MAR2000        YYZ          146
219      10MAR2000        LHR          167
387      10MAR2000        CPH          154
622      10MAR2000        FRA          129
821      10MAR2000        LHR          188
132      10MAR2000        YYZ           98
271      10MAR2000        CDG          182
182      11MAR2000        YYZ          165
219      11MAR2000        LHR          177
387      11MAR2000        CPH          115
622      11MAR2000        FRA          172
821      11MAR2000        LHR          174
132      11MAR2000        YYZ          141
271      11MAR2000        CDG          113
182      12MAR2000        YYZ          142
219      12MAR2000        LHR          229
387      12MAR2000        CPH          108
622      12MAR2000        FRA          204
132      12MAR2000        YYZ           93
271      12MAR2000        CDG          170
182      13MAR2000        YYZ           77
219      13MAR2000        LHR          160
821      13MAR2000        LHR          170
132      13MAR2000        YYZ          142
182      14MAR2000        YYZ          173
219      14MAR2000        LHR          166
387      14MAR2000        CPH          149
622      14MAR2000        FRA          190
821      14MAR2000        LHR          162
132      14MAR2000        YYZ          154
271      14MAR2000        CDG          100
182      15MAR2000        YYZ          114
219      15MAR2000        LHR          185
387      15MAR2000        CPH          158
622      15MAR2000        FRA          157
821      15MAR2000        LHR          159
132      15MAR2000        YYZ           71
271      15MAR2000        CDG          144
182      16MAR2000        YYZ           90
219      16MAR2000        LHR          145
387      16MAR2000        CPH          120
622      16MAR2000        FRA          177
821      16MAR2000        LHR          194
132      16MAR2000        YYZ           71
271      16MAR2000        CDG          128
182      17MAR2000        YYZ          123
219      17MAR2000        LHR          212
387      17MAR2000        CPH          114
622      17MAR2000        FRA          200
821      17MAR2000        LHR          232
132      17MAR2000        YYZ          137
271      17MAR2000        CDG          140
182      18MAR2000        YYZ          163
219      18MAR2000        LHR          188
387      18MAR2000        CPH          113
622      18MAR2000        FRA          160
821      18MAR2000        LHR          162
132      18MAR2000        YYZ          154
271      18MAR2000        CDG          111
182      19MAR2000        YYZ          134
219      19MAR2000        LHR          224
387      19MAR2000        CPH          117
622      19MAR2000        FRA          146
132      19MAR2000        YYZ          138
271      19MAR2000        CDG          137
182      20MAR2000        YYZ          158
219      20MAR2000        LHR          208
821      20MAR2000        LHR          176
132      20MAR2000        YYZ          102
182      21MAR2000        YYZ          151
219      21MAR2000        LHR          158
387      21MAR2000        CPH          163
622      21MAR2000        FRA          182
821      21MAR2000        LHR          223
132      21MAR2000        YYZ          105
271      21MAR2000        CDG          169
182      22MAR2000        YYZ           95
219      22MAR2000        LHR          166
387      22MAR2000        CPH          124
622      22MAR2000        FRA          175
821      22MAR2000        LHR          195
132      22MAR2000        YYZ           94
271      22MAR2000        CDG          191
182      23MAR2000        YYZ           86
219      23MAR2000        LHR          180
387      23MAR2000        CPH          138
622      23MAR2000        FRA          199
821      23MAR2000        LHR          125
132              .        YYZ           98
271      23MAR2000        CDG          173
182      24MAR2000        YYZ          141
219      24MAR2000        LHR          181
387      24MAR2000        CPH          152
622      24MAR2000        FRA          154
821      24MAR2000        LHR          184
132      24MAR2000        YYZ           79
271      24MAR2000        CDG          146
182      25MAR2000        YYZ          147
219      25MAR2000        LHR          196
387      25MAR2000        CPH          107
622      25MAR2000        FRA          168
821      25MAR2000        LHR          200
132      25MAR2000        YYZ          156
271      25MAR2000        CDG          118
182      26MAR2000        YYZ          116
219      26MAR2000        LHR          202
387      26MAR2000        CPH           92
622      26MAR2000        FRA          211
132      26MAR2000        YYZ           88
271      26MAR2000        CDG          170
182      27MAR2000        YYZ          138
219      27MAR2000        LHR          179
821      27MAR2000        LHR          194
132      27MAR2000        YYZ          103
182      28MAR2000        YYZ          158
219      28MAR2000        LHR          136
387      28MAR2000        CPH          119
622      28MAR2000        FRA          225
821      28MAR2000        LHR          162
132      28MAR2000        YYZ           88
271      28MAR2000        CDG          187
182      29MAR2000        YYZ          150
219      29MAR2000        LHR          202
387      29MAR2000        CPH          177
622      29MAR2000        FRA          110
821      29MAR2000        LHR          206
132      29MAR2000        YYZ          106
271      29MAR2000        CDG          168
182      30MAR2000        YYZ          115
219      30MAR2000        LHR          172
387      30MAR2000        CPH          175
622      30MAR2000        FRA          209
821      30MAR2000        LHR          113
132      30MAR2000        YYZ          149
271      30MAR2000        CDG          164
182      31MAR2000        YYZ           91
219      31MAR2000        LHR          173
387      31MAR2000        CPH          147
622      31MAR2000        FRA          197
821      31MAR2000        LHR          212
132      31MAR2000        YYZ           85
271      31MAR2000        CDG          138
;
run;

data sasuser.marchflights;
   informat Date date9. DepartureTime time5.;
   input FlightNumber $ 1-3 @6 Date date9. @17 DepartureTime time5.
         Origin $ 19-21 Destination $ 29-31 Distance 34-37 Mail 40-42
         Freight 45-47 Boarded 50-52 Transferred 55-56
         NonRevenue 59 Deplaned 62-64 PassengerCapacity 67-69;
   format Date date9. DepartureTime time5.;
datalines;
182  01MAR2000   8:21  LGA  YYZ   366  458  390  104  16  3  123  178
114  01MAR2000   7:10  LGA  LAX  2475  357  390  172  18  6  196  210
202  01MAR2000  10:43  LGA  ORD   740  369  244  151  11  5  157  210
219  01MAR2000   9:31  LGA  LHR  3442  412  334  198  17  7  222  250
439  01MAR2000  12:16  LGA  LAX  2475  422  267  167  13  5  185  210
387  01MAR2000  11:40  LGA  CPH  3856  423  398  152   8  3  163  250
290  01MAR2000   6:56  LGA  WAS   229  327  253   96  16  7  117  180
523  01MAR2000  15:19  LGA  ORD   740  476  456  177  20  3  185  210
982  01MAR2000  10:28  LGA  DFW  1383  383  355   49  19  2   56  180
622  01MAR2000  12:19  LGA  FRA  3857  255  243  207  15  5  227  250
821  01MAR2000  14:56  LGA  LHR  3442  334  289  205  13  4  222  250
872  01MAR2000  13:02  LGA  LAX  2475  316  357  145  13  5  163  210
416  01MAR2000   9:09  LGA  WAS   229  497  235   71  18  4   90  180
132  01MAR2000  15:35  LGA  YYZ   366  288  459  115  24  5  144  178
829  01MAR2000  13:38  LGA  WAS   229  487  235   75  16  5   88  180
183  01MAR2000  17:46  LGA  WAS   229  371  270   80  19  3   85  180
271  01MAR2000  13:17  LGA  CDG  3635  490  392  138  14  6  158  250
921  01MAR2000  17:11  LGA  DFW  1383  362  377  122   8  4  132  180
302  01MAR2000  20:22  LGA  WAS   229  363  273  105  24  3  128  180
431  01MAR2000  18:50  LGA  LAX  2475  403  427  153  14  6  173  210
308  01MAR2000  21:06  LGA  ORD   740  311  307  159  20  8  181  210
182  02MAR2000   8:21  LGA  YYZ   366  386  230  116  19  6  141  178
114  02MAR2000   7:10  LGA  LAX  2475  361  286  119  12  6  137  210
202  02MAR2000  10:43  LGA  ORD   740  399  161  120  15  2  124  210
219  02MAR2000   9:31  LGA  LHR  3442  285  164  147  18  7  172  250
439  02MAR2000  12:16  LGA  LAX  2475  575  353  126  17  5  148  210
387  02MAR2000  11:40  LGA  CPH  3856  355  457  105   8  1  114  250
290  02MAR2000   6:56  LGA  WAS   229  420  305  108  19  5  131  180
523  02MAR2000  15:19  LGA  ORD   740  362  445   95  24  5  100  210
982  02MAR2000  10:28  LGA  DFW  1383  239  177   95  15  3  109  180
622  02MAR2000  12:19  LGA  FRA  3857  370  469  176   7  4  187  250
821  02MAR2000  14:56  LGA  LHR  3442  530  391  201   6  3  210  250
872  02MAR2000  13:02  LGA  LAX  2475  340  434  130   4  5  139  210
416  02MAR2000   9:09  LGA  WAS   229  265  334   80   3  7   87  180
132  02MAR2000  15:35  LGA  YYZ   366  430  405  106  18  5  129  178
829  02MAR2000  13:38  LGA  WAS   229  339  153   88  14  5  103  180
183  02MAR2000  17:46  LGA  WAS   229  395  112   94  17  1  104  180
271  02MAR2000  13:17  LGA  CDG  3635  342  359  172  15  4  191  250
921  02MAR2000  17:11  LGA  DFW  1383  411  347  126  25  6  138  180
302  02MAR2000  20:22  LGA  WAS   229  511  224   78  10  5   92  180
431  02MAR2000  18:50  LGA  LAX  2475  326  163  165   6  6  177  210
308  02MAR2000  21:06  LGA  ORD   740  306  384  144  11  5  151  210
182  03MAR2000   8:21  LGA  YYZ   366  411  278  137  17  4  158  178
114  03MAR2000   7:10  LGA  LAX  2475  433  336  197   9  2  208  210
202  03MAR2000  10:43  LGA  ORD   740  458  370  118  27  2  138  210
219  03MAR2000   9:31  LGA  LHR  3442  369  441  197   8  6  211  250
439  03MAR2000  12:16  LGA  LAX  2475  381  281  153  13  6  172  210
387  03MAR2000  11:40  LGA  CPH  3856  465  421  138   9  6  153  250
290  03MAR2000   6:56  LGA  WAS   229  441  515  114  22  3  134  180
523  03MAR2000  15:19  LGA  ORD   740  368  363  162   8  5  167  210
982  03MAR2000  10:28  LGA  DFW  1383  195  439  134   8  8  149  180
622  03MAR2000  12:19  LGA  FRA  3857  296  414  180  16  4  200  250
821  03MAR2000  14:56  LGA  LHR  3442  448  282  151  17  4  172  250
872  03MAR2000  13:02  LGA  LAX  2475  366  284  151  12  4  167  210
416  03MAR2000   9:09  LGA  WAS   229  477  335   97  15  2  109  180
132  03MAR2000  15:35  LGA  YYZ   366  288  346   75   8  5   88  178
829  03MAR2000  13:38  LGA  WAS   229  355  252   80  15  5   94  180
183  03MAR2000  17:46  LGA  WAS   229  424  336   69  27  5   88  180
271  03MAR2000  13:17  LGA  CDG  3635  352  351  147  29  7  183  250
921  03MAR2000  17:11  LGA  DFW  1383  428  351   66  14  5   78  180
302  03MAR2000  20:22  LGA  WAS   229  411  310  123  21  5  132  180
431  03MAR2000  18:50  LGA  LAX  2475  304  351  160  14  5  179  210
308  03MAR2000  21:06  LGA  ORD   740  445  271  142   8  4  150  210
182  04MAR2000   8:21  LGA  YYZ   366  327  160  160  18  0  178  178
114  04MAR2000   7:10  LGA  LAX  2475  416  337  178  23  5  206  210
202  04MAR2000  10:43  LGA  ORD   740  295  464  148  11  4  154  210
219  04MAR2000   9:31  LGA  LHR  3442  331  376  232  18  0  250  250
439  04MAR2000  12:16  LGA  LAX  2475  574  208  181  16  7  204  210
387  04MAR2000  11:40  LGA  CPH  3856  395  217   81  21  1  103  250
290  04MAR2000   6:56  LGA  WAS   229  307  505  131   9  4  139  180
523  04MAR2000  15:19  LGA  ORD   740  334  351  193  17  0  199  210
982  04MAR2000  10:28  LGA  DFW  1383  405  227  159  14  5  172  180
622  04MAR2000  12:19  LGA  FRA  3857  296  232  137  14  4  155  250
821  04MAR2000  14:56  LGA  LHR  3442  403  209  167   9  6  182  250
872  04MAR2000  13:02  LGA  LAX  2475  478  277  106   9  3  118  210
416  04MAR2000   9:09  LGA  WAS   229  332  449  147   9  5  155  180
132  04MAR2000  15:35  LGA  YYZ   366  446   65  117   6  6  129  178
829  04MAR2000  13:38  LGA  WAS   229  345  308  125  13  4  133  180
183  04MAR2000  17:46  LGA  WAS   229  413  337  122   8  6  129  180
271  04MAR2000  13:17  LGA  CDG  3635  492  308  146  13  4  163  250
921  04MAR2000  17:11  LGA  DFW  1383  267  199  158  11  6  168  180
302  04MAR2000  20:22  LGA  WAS   229  345  335  115  14  4  125  180
431  04MAR2000  18:50  LGA  LAX  2475  465  216  181  19  5  205  210
308  04MAR2000  21:06  LGA  ORD   740  347  436  134   8  5  146  210
182  05MAR2000   8:21  LGA  YYZ   366  461  317  125  24  5  154  178
114  05MAR2000   7:10  LGA  LAX  2475  540  523  117  21  5  143  210
202  05MAR2000  10:43  LGA  ORD   740  357  494  104   6  6  114  210
219  05MAR2000   9:31  LGA  LHR  3442  485  267  160   4  3  167  250
439  05MAR2000  12:16  LGA  LAX  2475  451  401  116  18  5  139  210
387  05MAR2000  11:40  LGA  CPH  3856  393  304  142   8  2  152  250
290  05MAR2000   6:56  LGA  WAS   229  338  455   30  22  3   50  180
523  05MAR2000  15:19  LGA  ORD   740  368  432   47   9  3   53  210
982  05MAR2000  10:28  LGA  DFW  1383  487  335   90  23  7  103  180
622  05MAR2000  12:19  LGA  FRA  3857  340  311  185  11  3  199  250
872  05MAR2000  13:02  LGA  LAX  2475  435  182  122  12  5  139  210
416  05MAR2000   9:09  LGA  WAS   229  433  165   13  14  4   18  180
132  05MAR2000  15:35  LGA  YYZ   366  294  401  157  12  6  175  178
829  05MAR2000  13:38  LGA  WAS   229  444  478   60  15  6   68  180
183  05MAR2000  17:46  LGA  WAS   229  371  258   58  11  6   73  180
271  05MAR2000  13:17  LGA  CDG  3635  366  498  177  22  4  203  250
921  05MAR2000  17:11  LGA  DFW  1383  346  282   88  21  5  110  180
302  05MAR2000  20:22  LGA  WAS   229  466  436   83   4  4   89  180
431  05MAR2000  18:50  LGA  LAX  2475  395  365  145   7  6  158  210
308  05MAR2000  21:06  LGA  ORD   740  306  365   88  18  5   96  210
182  06MAR2000   8:21  LGA  YYZ   366  443  360  122  12  7  141  178
114  06MAR2000   7:10  LGA  LAX  2475  394  220  128  19  4  151  210
202  06MAR2000  10:43  LGA  ORD   740  383  286  115  19  3  136  210
219  06MAR2000   9:31  LGA  LHR  3442  388  298  163  14  6  183  250
439  06MAR2000  12:16  LGA  LAX  2475  234  120  157  16  3  176  210
290  06MAR2000   6:56  LGA  WAS   229  290  361   95  21  7  118  180
523  06MAR2000  15:19  LGA  ORD   740  435  404  106  11  7  116  210
982  06MAR2000  10:28  LGA  DFW  1383  376  330   93  12  5  100  180
821  06MAR2000  14:56  LGA  LHR  3442  345  243  167  16  2  185  250
872  06MAR2000  13:02  LGA  LAX  2475  366  392  178  16  3  197  210
416  06MAR2000   9:09  LGA  WAS   229  499  402   67  18  5   83  180
132  06MAR2000  15:35  LGA  YYZ   366  481  294  150   3  7  160  178
829  06MAR2000  13:38  LGA  WAS   229  350  312   72  11  3   75  180
183  06MAR2000  17:46  LGA  WAS   229  385  347   67  18  6   84  180
921  06MAR2000  17:11  LGA  DFW  1383  375  263  114  19  4  130  180
302  06MAR2000  20:22  LGA  WAS   229  465  322   66  15  7   87  180
431  06MAR2000  18:50  LGA  LAX  2475  423  310  129  26  2  157  210
308  06MAR2000  21:06  LGA  ORD   740  482  257  189  21  0  194  210
182  07MAR2000   8:21  LGA  YYZ   366  388  569  155  23  0  178  178
114  07MAR2000   7:10  LGA  LAX  2475  466  348  160  23  5  188  210
202  07MAR2000  10:43  LGA  ORD   740  439  220  175  10  3  183  210
219  07MAR2000   9:31  LGA  LHR  3442  421  356  241   9  0  250  250
439  07MAR2000  12:16  LGA  LAX  2475  338  204  196  14  0  210  210
387  07MAR2000  11:40  LGA  CPH  3856  546  204  131   5  6  142  250
290  07MAR2000   6:56  LGA  WAS   229  422  424  168  12  0  174  180
523  07MAR2000  15:19  LGA  ORD   740  338  477  170  22  2  180  210
982  07MAR2000  10:28  LGA  DFW  1383  474  249  113   7  4  121  180
622  07MAR2000  12:19  LGA  FRA  3857  391  423  210  22  5  237  250
821  07MAR2000  14:56  LGA  LHR  3442  248  307  215  11  5  231  250
872  07MAR2000  13:02  LGA  LAX  2475  371  353  194   7  7  208  210
416  07MAR2000   9:09  LGA  WAS   229  371  289  147  24  2  171  180
132  07MAR2000  15:35  LGA  YYZ   366  439  338  164   5  3  172  178
829  07MAR2000  13:38  LGA  WAS   229  316  249  133  16  2  150  180
183  07MAR2000  17:46  LGA  WAS   229  281  216  129  11  4  142  180
271  07MAR2000  13:17  LGA  CDG  3635  353  205  155  21  4  180  250
921  07MAR2000  17:11  LGA  DFW  1383  452  282  158  22  0  169  180
302  07MAR2000  20:22  LGA  WAS   229  425  435  135  16  5  141  180
431  07MAR2000  18:50  LGA  LAX  2475  356  298  195  15  0  210  210
308  07MAR2000  21:06  LGA  ORD   740  370  381  193  17  0  198  210
182  08MAR2000   8:21  LGA  YYZ   366  343  387  164  14  0  178  178
114  08MAR2000   7:10  LGA  LAX  2475  450  246  129  21  5  155  210
202  08MAR2000  10:43  LGA  ORD   740  508  334  130  11  4  136  210
219  08MAR2000   9:31  LGA  LHR  3442  447  299  183  11  3  197  250
439  08MAR2000  12:16  LGA       2475  247  187  150  13  4  167  210
387  08MAR2000  11:40  LGA  CPH  3856  415  367  150   9  3  162  250
290  08MAR2000   6:56  LGA  WAS   229  424  456   90  21  2  108  180
523  08MAR2000  15:19  LGA  ORD   740  457  342  160  21  2  182  210
982  08MAR2000  10:28  LGA  DFW  1383  228  213  116  15  4  123  180
622  08MAR2000  12:19  LGA  FRA  3857  346    .  176   5  6  187  250
821  08MAR2000  14:56  LGA  LHR  3442  391  395  186  11  5  202  250
872  08MAR2000  13:02  LGA  LAX  2475  352  293  131  23  4  158  210
416  08MAR2000   9:09  LGA  WAS   229  347  300   61  11  5   71  180
132  08MAR2000  15:35  LGA  YYZ   366  342  465  104  13  1  118  178
829  08MAR2000  13:38  LGA  WAS   229  397  387  100  14  2  102  180
183  08MAR2000  17:46  LGA  WAS   229  380  335   88  14  5   93  180
271  08MAR2000  13:17  LGA  CDG  3635  366  279  152  20  4  176  250
921  08MAR2000  17:11  LGA  DFW  1383  502  308   90  17  5   99  180
302  08MAR2000  20:22  LGA  WAS   229  427  362   65  10  2   70  180
431  08MAR2000  18:50  LGA  LAX  2475  416  151  184  16  6  206  210
308  08MAR2000  21:06  LGA  ORD   740  424  184  134  11  4  143  210
182  09MAR2000   8:21  LGA  YYZ   366  477  192  140  26  3  169  178
114  09MAR2000   7:10  LGA  LAX  2475  395  454  156  16  6  178  210
202  09MAR2000  10:43  LGA  ORD   740  335  323  141  15  5  150  210
219  09MAR2000   9:31  LGA  LHR  3442  356  547  211  18  6  235  250
439  09MAR2000  12:16  LGA  LAX  2475  365  398  136   5  6  147  210
387  09MAR2000  11:40  LGA  CPH  3856  363  297  128  14  3  145  250
290  09MAR2000   6:56  LGA  WAS   229  311  434   38  17  7   58  180
523  09MAR2000  15:19  LGA  ORD   740  224  201  161  15  5  172  210
982  09MAR2000  10:28  LGA  DFW  1383  266  410  163  17  0  173  180
622  09MAR2000  12:19  LGA  FRA  3857  317  421  173  11  5  189  250
821  09MAR2000  14:56  LGA  LHR  3442  219  368  203  11  4  218  250
872  09MAR2000  13:02  LGA  LAX  2475  317  380   99  21  4  124  210
416  09MAR2000   9:09  LGA  WAS   229  355  410   72  11  4   78  180
132  09MAR2000  15:35  LGA  YYZ   366  470  361  119   7  4  130  178
829  09MAR2000  13:38  LGA  WAS   229  458  506   82  16  3   93  180
183  09MAR2000  17:46  LGA  WAS   229  396  315   78  12  2   81  180
271  09MAR2000  13:17  LGA  CDG  3635  357  282  159  18  5  182  250
921  09MAR2000  17:11  LGA  DFW  1383  284  150   88   6  6   99  180
302  09MAR2000  20:22  LGA  WAS   229  454  631  106  21  5  112  180
431  09MAR2000  18:50  LGA  LAX  2475  373  339  142  14  4  160  210
308  09MAR2000  21:06  LGA  ORD   740  371  408  135  15  3  147  210
182  10MAR2000   8:21  LGA  YYZ   366  421  319  146   8  6  160  178
114  10MAR2000   7:10  LGA  LAX  2475  305  428  183  10  5  198  210
202  10MAR2000  10:43  LGA  ORD   740  535  386  127   9  3  137  210
219  10MAR2000   9:31  LGA  LHR  3442  272  370  167   7  7  181  250
439  10MAR2000  12:16  LGA  LAX  2475  343  302  164  15  5  184  210
387  10MAR2000  11:40  LGA  CPH  3856  336  377  154  18  5  177  250
290  10MAR2000   6:56  LGA  WAS   229  420  289   75  14  5   90  180
523  10MAR2000  15:19  LGA  ORD   740  459  253  144  13  3  152  210
982  10MAR2000  10:28  LGA  DFW  1383  337  132  116  14  5  121  180
622  10MAR2000  12:19  LGA  FRA  3857  272  363  129  12  6  147  250
821  10MAR2000  14:56  LGA  LHR  3442  389  479  188   5  4  197  250
872  10MAR2000  13:02  LGA  LAX  2475  357  437  170  18  6  194  210
416  10MAR2000   9:09  LGA  WAS   229  240  241   58  17  3   61  180
132  10MAR2000  15:35  LGA  YYZ   366  438  367   98  14  4  116  178
829  10MAR2000  13:38  LGA  WAS   229  354  391   63  19  2   81  180
183  10MAR2000  17:46  LGA  WAS   229  440  307   86  15  5   93  180
271  10MAR2000  13:17  LGA  CDG  3635  415  463  182   9  7  198  250
921  10MAR2000  17:11  LGA  DFW  1383  483  374   67  16  6   74  180
302  10MAR2000  20:22  LGA  WAS   229  304  455   91   3  4   96  180
431  10MAR2000  18:50  LGA  LAX  2475  284  346  192  18  0  210  210
308  10MAR2000  21:06  LGA  ORD   740  248  129  186  18  4  199  210
182  11MAR2000   8:21  LGA  YYZ   366  357  265  165  13  0  178  178
114  11MAR2000   7:10  LGA  LAX  2475  449  307  188  22  0  210  210
202  11MAR2000  10:43  LGA  ORD   740  438  435  165  12  4  173  210
219  11MAR2000   9:31  LGA  LHR  3442  327  374  177  15  3  195  250
439  11MAR2000  12:16  LGA  LAX  2475  309  223  196  14  0  210  210
387  11MAR2000  11:40  LGA  CPH  3856  327  378  115  20  1  136  250
290  11MAR2000   6:56  LGA  WAS   229  475  358   91  27  4  118  180
523  11MAR2000  15:19  LGA  ORD   740  339  329  176  18  5  196  210
982  11MAR2000  10:28  LGA  DFW  1383  214  431  118   9  4  128  180
622  11MAR2000  12:19  LGA  FRA  3857  375  301  172  17  5  194  250
821  11MAR2000  14:56  LGA  LHR  3442  272  497  174   5  4  183  250
872  11MAR2000  13:02  LGA  LAX  2475  346  328  166   7  1  174  210
416  11MAR2000   9:09  LGA  WAS   229  396  472  128  20  5  146  180
132  11MAR2000  15:35  LGA  YYZ   366  281  408  141  11  6  158  178
829  11MAR2000  13:38  LGA  WAS   229  378  336  118  21  3  139  180
183  11MAR2000  17:46  LGA  WAS   229  334  503  111   9  6  120  180
271  11MAR2000  13:17  LGA  CDG  3635  281  329  113  14  7  134  250
921  11MAR2000  17:11  LGA  DFW  1383  255  334  168  12  0  173  180
302  11MAR2000  20:22  LGA  WAS   229  442  557   75  14  4   83  180
431  11MAR2000  18:50  LGA  LAX  2475  442  387  147  16  4  167  210
308  11MAR2000  21:06  LGA  ORD   740  268  385  203   7  0  205  210
182  12MAR2000   8:21  LGA  YYZ   366  361  510  142  13  3  158  178
114  12MAR2000   7:10  LGA  LAX  2475  263  443  128  19  2  149  210
202  12MAR2000  10:43  LGA  ORD   740  280  213  112   9  2  117  210
219  12MAR2000   9:31  LGA  LHR  3442  380  122  229  16  3  248  250
439  12MAR2000  12:16  LGA  LAX  2475  211  269   88   9  5  102  210
387  12MAR2000  11:40  LGA  CPH  3856  392  477  108  20  6  134  250
290  12MAR2000   6:56  LGA  WAS   229  287  214   45  16  5   52  180
523  12MAR2000  15:19  LGA  ORD   740  344  323  103  13  4  117  210
982  12MAR2000  10:28  LGA  DFW  1383  316  245   31  14  4   35  180
622  12MAR2000  12:19  LGA  FRA  3857  328  441  204  25  3  232  250
872  12MAR2000  13:02  LGA  LAX  2475  300  222   77  22  6  105  210
416  12MAR2000   9:09  LGA  WAS   229  409  372   48   8  4   55  180
132  12MAR2000  15:35  LGA  YYZ   366  289  169   93  13  5  111  178
829  12MAR2000  13:38  LGA  WAS   229  396  219   68   9  6   80  180
183  12MAR2000  17:46  LGA  WAS   229  455  371   48  10  6   61  180
271  12MAR2000  13:17  LGA  CDG  3635  298  350  170   6  6  182  250
921  12MAR2000  17:11  LGA  DFW  1383  416  276  133  23  3  157  180
302  12MAR2000  20:22  LGA  WAS   229  395  293   53  21  5   65  180
431  12MAR2000  18:50  LGA  LAX  2475  364  193   77  26  6  109  210
308  12MAR2000  21:06  LGA  ORD   740  338  441  106  15  7  113  210
182  13MAR2000   8:21  LGA  YYZ   366  386  197   77  20  6  103  178
114  13MAR2000   7:10  LGA  LAX  2475  200  446  170  15  6  191  210
202  13MAR2000  10:43  LGA  ORD   740  390  422  109  17  2  111  210
219  13MAR2000   9:31  LGA  LHR  3442  477  427  160   9  3  172  250
439  13MAR2000  12:16  LGA  LAX  2475  334  165  135  22  2  159  210
290  13MAR2000   6:56  LGA  WAS   229  360  362   57  10  5   63  180
523  13MAR2000  15:19  LGA  ORD   740  370  188  144   9  4  150  210
982  13MAR2000  10:28  LGA  DFW  1383  440  492  110  18  8  128  180
821  13MAR2000  14:56  LGA  LHR  3442  249  314  170   5  6  181  250
872  13MAR2000  13:02  LGA  LAX  2475  526  321  170   6  4  180  210
416  13MAR2000   9:09  LGA  WAS   229  291  327   95   9  6  102  180
132  13MAR2000  15:35  LGA  YYZ   366  251  217  142  10  7  159  178
829  13MAR2000  13:38  LGA  WAS   229  417  276   88  20  4  102  180
183  13MAR2000  17:46  LGA  WAS   229  271  409   63  22  6   82  180
921  13MAR2000  17:11  LGA  DFW  1383  365  370   87  14  4   95  180
302  13MAR2000  20:22  LGA  WAS   229  461  287   99   6  3  104  180
431  13MAR2000  18:50  LGA  LAX  2475  375  283  159  14  3  176  210
308  13MAR2000  21:06  LGA  ORD   740  446  206  134  11  6  142  210
182  14MAR2000   8:21  LGA  YYZ   366  505  250  173   5  0  178  178
114  14MAR2000   7:10  LGA  LAX  2475  269  283  192  18  0  210  210
202  14MAR2000  10:43  LGA  ORD   740  336  369  156  15  6  169  210
219  14MAR2000   9:31  LGA  LHR  3442  474  397  166  22  3  191  250
439  14MAR2000  12:16  LGA  LAX  2475  396  301  179   8  5  192  210
387  14MAR2000  11:40  LGA  CPH  3856  524  389  149  16  4  169  250
290  14MAR2000   6:56  LGA  WAS   229  436  267  168  12  0  171  180
523  14MAR2000  15:19  LGA  ORD   740  381  464  199  11  0  207  210
982  14MAR2000  10:28  LGA  DFW  1383  327  354  150  22  5  160  180
622  14MAR2000  12:19  LGA  FRA  3857  277  387  190  15  3  208  250
821  14MAR2000  14:56  LGA  LHR  3442  288  309  162   9  2  173  250
872  14MAR2000  13:02  LGA  LAX  2475  266  289  181  11  5  197  210
416  14MAR2000   9:09  LGA  WAS   229  359  543  159  21  0  161  180
132  14MAR2000  15:35  LGA  YYZ   366  376  261  154  18  5  177  178
829  14MAR2000  13:38  LGA  WAS   229  329  328  158  17  3  161  180
183  14MAR2000  17:46  LGA  WAS   229  379  456  122  21  5  138  180
271  14MAR2000  13:17  LGA  CDG  3635  405  401  100   4  5  109  250
921  14MAR2000  17:11  LGA  DFW  1383  396  192  155  25  0  157  180
302  14MAR2000  20:22  LGA  WAS   229  395  357  140  17  3  155  180
431  14MAR2000  18:50  LGA  LAX  2475  444  447  189  21  0  210  210
308  14MAR2000  21:06  LGA  ORD   740  602  359  157  21  5  175  210
182  15MAR2000   8:21  LGA  YYZ   366  362  364  114  15  2  131  178
114  15MAR2000   7:10  LGA  LAX  2475  325  229  194  16  0  210  210
202  15MAR2000  10:43  LGA  ORD   740  486  346   93  14  2   97  210
219  15MAR2000   9:31  LGA  LHR  3442  411  352  185   9  5  199  250
439  15MAR2000  12:16  LGA  LAX  2475  374  360  142  16  6  164  210
387  15MAR2000  11:40  LGA  CPH  3856  405  277  158  26  4  188  250
290  15MAR2000   6:56  LGA  WAS   229  305  434   90  19  3  100  180
523  15MAR2000  15:19  LGA  ORD   740  421  312  168  15  7  177  210
982  15MAR2000  10:28  LGA  DFW  1383  381  462  108   8  4  117  180
622  15MAR2000  12:19  LGA  FRA  3857  397  332  157  13  7  177  250
821  15MAR2000  14:56  LGA  LHR  3442  375  396  159   7  4  170  250
872  15MAR2000  13:02  LGA  LAX  2475  317  372  114  10  5  129  210
416  15MAR2000   9:09  LGA  WAS   229  408  453   57  16  6   75  180
132  15MAR2000  15:35  LGA  YYZ   366  213  429   71  15  7   93  178
829  15MAR2000  13:38  LGA  WAS   229  346  313   93  15  6  111  180
183  15MAR2000  17:46  LGA  WAS   229  388  264   50  21  6   66  180
271  15MAR2000  13:17  LGA  CDG  3635  254  316  144  13  5  162  250
921  15MAR2000  17:11  LGA  DFW  1383  291  400  120  26  6  137  180
302  15MAR2000  20:22  LGA  WAS   229  542  368  116  24  4  142  180
431  15MAR2000  18:50  LGA  LAX  2475  319  322  149  15  5  169  210
308  15MAR2000  21:06  LGA  ORD   740  394  335  178  13  3  183  210
182  16MAR2000   8:21  LGA  YYZ   366  392  378   90  10  4  104  178
114  16MAR2000   7:10  LGA  LAX  2475  238  145  187   6  2  195  210
202  16MAR2000  10:43  LGA  ORD   740  249  178  142  13  6  152  210
219  16MAR2000   9:31  LGA  LHR  3442  327  391  145  10  3  158  250
439  16MAR2000  12:16  LGA  LAX  2475  354  495  143  18  9  170  210
387  16MAR2000  11:40  LGA  CPH  3856  359  226  120  13  7  140  250
290  16MAR2000   6:56  LGA  WAS   229  240  365   72  18  7   82  180
523  16MAR2000  15:19  LGA  ORD   740  304  167  166   5  3  172  210
982  16MAR2000  10:28  LGA  DFW  1383  314  385   88  17  3  106  180
622  16MAR2000  12:19  LGA  FRA  3857  479  193  177   6  5  188  250
821  16MAR2000  14:56  LGA  LHR  3442  428  315  194  20  3  217  250
872  16MAR2000  13:02  LGA  LAX  2475  349  247  167  10  5  182  210
416  16MAR2000   9:09  LGA  WAS   229  484  280   61   7  2   66  180
132  16MAR2000  15:35  LGA  YYZ   366  473  231   71  11  6   88  178
829  16MAR2000  13:38  LGA  WAS   229  426  263   79  21  4   92  180
183  16MAR2000  17:46  LGA  WAS   229  411  512  116  15  4  129  180
271  16MAR2000  13:17  LGA  CDG  3635  475  413  128   7  3  138  250
921  16MAR2000  17:11  LGA  DFW  1383  216  420  137  17  3  156  180
302  16MAR2000  20:22  LGA  WAS   229  371  340   64   8  2   70  180
431  16MAR2000  18:50  LGA  LAX  2475  515  247  136  19  3  158  210
308  16MAR2000  21:06  LGA  ORD   740  501  117  136  12  5  147  210
182  17MAR2000   8:21  LGA  YYZ   366  481  346  123  13  4  140  178
114  17MAR2000   7:10  LGA  LAX  2475  400  179  176  17  5  198  210
202  17MAR2000  10:43  LGA  ORD   740  535  333  159  17  4  168  210
219  17MAR2000   9:31  LGA  LHR  3442  398  324  212  14  1  227  250
439  17MAR2000  12:16  LGA  LAX  2475  394  389  146   9  5  160  210
387  17MAR2000  11:40  LGA  CPH  3856  424  413  114  11  3  128  250
290  17MAR2000   6:56  LGA  WAS   229  422  254  119   7  6  128  180
523  17MAR2000  15:19  LGA  ORD   740  303  268  161  20  4  178  210
982  17MAR2000  10:28  LGA  DFW  1383  430  233   88   7  5   95  180
622  17MAR2000  12:19  LGA  FRA  3857  507  275  200  15  2  217  250
821  17MAR2000  14:56  LGA  LHR  3442  350  292  232  18  0  250  250
872  17MAR2000  13:02  LGA  LAX  2475  354  181  171  11  2  184  210
416  17MAR2000   9:09  LGA  WAS   229  387  361   93  17  6  107  180
132  17MAR2000  15:35  LGA  YYZ   366  260  598  137  17  2  156  178
829  17MAR2000  13:38  LGA  WAS   229  343  131   84   5  6   90  180
183  17MAR2000  17:46  LGA  WAS   229  462  197   98  19  4  108  180
271  17MAR2000  13:17  LGA  CDG  3635  366  356  140  15  4  159  250
921  17MAR2000  17:11  LGA  DFW  1383  495  414   94  13  6  107  180
302  17MAR2000  20:22  LGA  WAS   229  426  452  117  17  4  126  180
431  17MAR2000  18:50  LGA  LAX  2475  315  447  156  16  4  176  210
308  17MAR2000  21:06  LGA  ORD   740  466  199  163  17  3  172  210
182  18MAR2000   8:21  LGA  YYZ   366  375  357  163  15  0  178  178
114  18MAR2000   7:10  LGA  LAX  2475  324  339  192  18  0  210  210
202  18MAR2000  10:43  LGA  ORD   740  425  265  149  13  6  162  210
219  18MAR2000   9:31  LGA  LHR  3442  337  276  188  20  6  214  250
439  18MAR2000  12:16  LGA  LAX  2475  486  258  161  14  6  181  210
387  18MAR2000  11:40  LGA  CPH  3856  361  375  113  12  5  130  250
290  18MAR2000   6:56  LGA  WAS   229  253  284  123  17  3  141  180
523  18MAR2000  15:19  LGA  ORD   740  378  267  108  11  5  117  210
982  18MAR2000  10:28  LGA  DFW  1383  291  352  126   7  6  134  180
622  18MAR2000  12:19  LGA  FRA  3857  412  342  160  13  2  175  250
821  18MAR2000  14:56  LGA  LHR  3442  463  236  162  14  6  182  250
872  18MAR2000  13:02  LGA  LAX  2475  389  356  199  11  0  210  210
416  18MAR2000   9:09  LGA  WAS   229  377  371  127  21  5  149  180
132  18MAR2000  15:35  LGA  YYZ   366  352  323  154  16  7  177  178
829  18MAR2000  13:38  LGA  WAS   229  290  254  138  17  3  141  180
183  18MAR2000  17:46  LGA  WAS   229  394  325  130  12  4  139  180
271  18MAR2000  13:17  LGA  CDG  3635  506  347  111  12  5  128  250
921  18MAR2000  17:11  LGA  DFW  1383  354  402  115   9  1  118  180
302  18MAR2000  20:22  LGA  WAS   229  398  371  100  17  2  102  180
431  18MAR2000  18:50  LGA  LAX  2475  344  358  200  10  0  210  210
308  18MAR2000  21:06  LGA  ORD   740  365  513  139  17  5  156  210
182  19MAR2000   8:21  LGA  YYZ   366  370  260  134   6  4  144  178
114  19MAR2000   7:10  LGA  LAX  2475  398  120   93  20  5  118  210
202  19MAR2000  10:43  LGA  ORD   740  412  337   73  19  7   91  210
219  19MAR2000   9:31  LGA  LHR  3442  315  303  224   8  4  236  250
439  19MAR2000  12:16  LGA  LAX  2475  348  181  114  13  7  134  210
387  19MAR2000  11:40  LGA  CPH  3856  578  334  117  19  5  141  250
290  19MAR2000   6:56  LGA  WAS   229  324  246   37  17  5   48  180
523  19MAR2000  15:19  LGA  ORD   740  345  448   68  10  2   79  210
982  19MAR2000  10:28  LGA  DFW  1383  462  447   95  17  4  106  180
622  19MAR2000  12:19  LGA  FRA  3857  324  245  146   4  6  156  250
872  19MAR2000  13:02  LGA  LAX  2475  254  466   99   9  6  114  210
416  19MAR2000   9:09  LGA  WAS   229  367  283  117  12  3  123  180
132  19MAR2000  15:35  LGA  YYZ   366  363  242  138  19  5  162  178
829  19MAR2000  13:38  LGA  WAS   229  374  386   94   7  6  106  180
183  19MAR2000  17:46  LGA  WAS   229  301  381   34  14  5   50  180
271  19MAR2000  13:17  LGA  CDG  3635  442  439  137  14  4  155  250
921  19MAR2000  17:11  LGA  DFW  1383  301  448   62  17  4   74  180
302  19MAR2000  20:22  LGA  WAS   229  414  490   76  11  4   90  180
431  19MAR2000  18:50  LGA  LAX  2475  416  373  102  20  3  125  210
308  19MAR2000  21:06  LGA  ORD   740  407  450  104  24  4  123  210
182  20MAR2000   8:21  LGA  YYZ   366  374  247  158  20  0  178  178
114  20MAR2000   7:10  LGA  LAX  2475  432  390  194  16  0  210  210
202  20MAR2000  10:43  LGA  ORD   740  322  426  107  13  6  120  210
219  20MAR2000   9:31  LGA  LHR  3442  475  248  208   7  5  220  250
439  20MAR2000  12:16  LGA  LAX  2475  382  224  145  18  2  165  210
290  20MAR2000   6:56  LGA  WAS   229  491  219   90  20  3   93  180
523  20MAR2000  15:19  LGA  ORD   740  420  521  138  27  5  144  210
982  20MAR2000  10:28  LGA  DFW  1383  408  366  142  15  3  148  180
821  20MAR2000  14:56  LGA  LHR  3442  276  260  176  19  4  199  250
872  20MAR2000  13:02  LGA  LAX  2475  351  310  142   9  3  154  210
416  20MAR2000   9:09  LGA  WAS   229  434  343   95   5  7  102  180
132  20MAR2000  15:35  LGA  YYZ   366  342  336  102  21  5  128  178
829  20MAR2000  13:38  LGA  WAS   229  379  438   95  13  3  109  180
183  20MAR2000  17:46  LGA  WAS   229  226  294   61  19  3   78  180
921  20MAR2000  17:11  LGA  DFW  1383  464  474   92   6  7  101  180
302  20MAR2000  20:22  LGA  WAS   229  341  393   93  15  4  105  180
431  20MAR2000  18:50  LGA  LAX  2475  416  342  109   4  5  118  210
308  20MAR2000  21:06  LGA  ORD   740  476  306  135  23  4  147  210
182  21MAR2000   8:21  LGA  YYZ   366  459  396  151  10  2  163  178
114  21MAR2000   7:10  LGA  LAX  2475  466  368  185  25  0  210  210
202  21MAR2000  10:43  LGA  ORD   740  337  353  151  21  6  163  210
219  21MAR2000   9:31  LGA  LHR  3442  340  378  158  11  4  173  250
439  21MAR2000  12:16  LGA  LAX  2475  443  392  188  16  4  208  210
387  21MAR2000  11:40  LGA  CPH  3856  404  395  163  16  5  184  250
290  21MAR2000   6:56  LGA  WAS   229  391  555  167  13  0  168  180
523  21MAR2000  15:19  LGA  ORD   740  330  242  189  21  0  198  210
982  21MAR2000  10:28  LGA  DFW  1383  442  346   43  13  5   48  180
622  21MAR2000  12:19  LGA  FRA  3857  442  305  182  11  5  198  250
821  21MAR2000  14:56  LGA  LHR  3442  304  231  223  15  7  245  250
872  21MAR2000  13:02  LGA  LAX  2475  283  532    .   9  0  210  210
416  21MAR2000   9:09  LGA  WAS   229  331  239  158   5  6  165  180
132  21MAR2000  15:35  LGA  YYZ   366  418  433  105  22  5  132  178
829  21MAR2000  13:38  LGA  WAS   229  249  363  165  15  0  177  180
183  21MAR2000  17:46  LGA  WAS   229  335  280  173   7  0  178  180
271  21MAR2000  13:17  LGA  CDG  3635  507  156  169  17  2  188  250
921  21MAR2000  17:11  LGA  DFW  1383  393  510  148  14  5  164  180
302  21MAR2000  20:22  LGA  WAS   229  401  534  111   7  1  113  180
431  21MAR2000  18:50  LGA  LAX  2475  398  120  198  12  0  210  210
308  21MAR2000  21:06  LGA  ORD   740  323  278  116  12  5  131  210
182  22MAR2000   8:21  LGA  YYZ   366  430  270   95  10  1  106  178
114  22MAR2000   7:10  LGA  LAX  2475  486  228  198  12  0  210  210
202  22MAR2000  10:43  LGA  ORD   740  461  383  133  20  4  153  210
219  22MAR2000   9:31  LGA  LHR  3442  251  388  166  14  5  185  250
439  22MAR2000  12:16  LGA  LAX  2475  365  545  111  11  3  125  210
387  22MAR2000  11:40  LGA  CPH  3856  376  226  124   7  6  137  250
290  22MAR2000   6:56  LGA  WAS   229  435  403  120  12  3  125  180
523  22MAR2000  15:19  LGA  ORD   740  392  270  162  13  7  173  210
982  22MAR2000  10:28  LGA  DFW  1383  412  368  121   9  5  131  180
622  22MAR2000  12:19  LGA  FRA  3857  398  312  175   8  5  188  250
821  22MAR2000  14:56  LGA  LHR  3442  382  113  195  16  6  217  250
872  22MAR2000  13:02  LGA  LAX  2475  319  406  181  19  7  207  210
416  22MAR2000   9:09  LGA  WAS   229  406  273  109  20  6  119  180
132  22MAR2000  15:35  LGA  YYZ   366  351  369   94  22  6  122  178
829  22MAR2000  13:38  LGA  WAS   229  440  245  104  23  4  121  180
183  22MAR2000  17:46  LGA  WAS   229  509  379   38  24  6   48  180
271  22MAR2000  13:17  LGA  CDG  3635  411  391  191  17  5  213  250
921  22MAR2000  17:11  LGA  DFW  1383  483  478  142  15  7  153  180
302  22MAR2000  20:22  LGA  WAS   229  369  333   25   4  4   32  180
431  22MAR2000  18:50  LGA  LAX  2475  385  271  145   8  5  158  210
308  22MAR2000  21:06  LGA  ORD   740  412  256  165   5  6  174  210
182  23MAR2000   8:21  LGA  YYZ   366  446  224   86  16  5  107  178
114  23MAR2000   7:10  LGA  LAX  2475  309  409  188  22  0  210  210
202  23MAR2000  10:43  LGA  ORD   740  572  466  143  15  3  157  210
219  23MAR2000   9:31  LGA  LHR  3442  473  301  180  12  4  196  250
439  23MAR2000  12:16  LGA  LAX  2475  413  289  158  18  5  181  210
387  23MAR2000  11:40  LGA  CPH  3856  319  405  138  13  5  156  250
290  23MAR2000   6:56  LGA  WAS   229  269  346   92  10  5   97  180
523  23MAR2000  15:19  LGA  ORD   740  356   57  169  18  4  187  210
982  23MAR2000  10:28  LGA  DFW  1383  409  355   75  10  5   80  180
622  23MAR2000  12:19  LGA  FRA  3857  239  355  199  18  2  219  250
821  23MAR2000  14:56  LGA  LHR  3442  252  395  125  17  5  147  250
872  23MAR2000  13:02  LGA  LAX  2475  347  359  145  17  3  165  210
416  23MAR2000   9:09  LGA  WAS   229  384  206  112   8  3  118  180
132          .  15:35  LGA  YYZ   366  354  292   98  15  4  117  178
829  23MAR2000  13:38  LGA  WAS   229  319  394   58  14  4   68  180
183  23MAR2000  17:46  LGA  WAS   229  433  339   88  18  4   94  180
271  23MAR2000  13:17  LGA  CDG  3635  363  424  173  25  5  203  250
921  23MAR2000  17:11  LGA  DFW  1383  353  148   80  19  5   87  180
302  23MAR2000  20:22  LGA  WAS   229  421  327   91  16  4   97  180
431  23MAR2000  18:50  LGA  LAX  2475  228  129  190  20  0  210  210
308  23MAR2000  21:06  LGA  ORD   740  369  193  166  10  4  177  210
182  24MAR2000   8:21  LGA  YYZ   366  371  456  141  18  4  163  178
114  24MAR2000   7:10  LGA  LAX  2475  356  377  129  13  3  145  210
202  24MAR2000  10:43  LGA  ORD   740  317  363  132   8  5  142  210
219  24MAR2000   9:31  LGA  LHR  3442  428  294  181  12  5  198  250
439  24MAR2000  12:16  LGA  LAX  2475  396  449  146  14  5  165  210
387  24MAR2000  11:40  LGA  CPH  3856  301  226  152  17  3  172  250
290  24MAR2000   6:56  LGA  WAS   229  388  273   62  19  4   66  180
523  24MAR2000  15:19  LGA  ORD   740  489  412  135  10  4  147  210
982  24MAR2000  10:28  LGA  DFW  1383  341  259  122  17  2  127  180
622  24MAR2000  12:19  LGA  FRA  3857  504  557  154  13  7  174  250
821  24MAR2000  14:56  LGA  LHR  3442  353  292  184  11  4  199  250
872  24MAR2000  13:02  LGA  LAX  2475  352  327  105  20  2  127  210
416  24MAR2000   9:09  LGA  WAS   229  417  420   50  19  2   63  180
132  24MAR2000  15:35  LGA  YYZ   366  389  253   79  16  3   98  178
829  24MAR2000  13:38  LGA  WAS   229  349  354   91  13  6   97  180
183  24MAR2000  17:46  LGA  WAS   229  341  225   82  19  2   97  180
271  24MAR2000  13:17  LGA  CDG  3635  387  265  146  18  3  167  250
921  24MAR2000  17:11  LGA  DFW  1383  357  297   86  15  3   91  180
302  24MAR2000  20:22  LGA  WAS   229  364  290   74  14  3   84  180
431  24MAR2000  18:50  LGA  LAX  2475  481  386  174  11  5  190  210
308  24MAR2000  21:06  LGA  ORD   740  537  426  131   9  4  135  210
182  25MAR2000   8:21  LGA  YYZ   366  357  471  147  23  6  176  178
114  25MAR2000   7:10  LGA  LAX  2475  309  333  172  10  4  186  210
202  25MAR2000  10:43  LGA  ORD   740  347  195  165  17  4  185  210
219  25MAR2000   9:31  LGA  LHR  3442  405  336  196  14  5  215  250
439  25MAR2000  12:16  LGA  LAX  2475  263  260  184  10  4  198  210
387  25MAR2000  11:40  LGA  CPH  3856  321  417  107  12  4  123  250
290  25MAR2000   6:56  LGA  WAS   229  338  433  143  10  6  152  180
523  25MAR2000  15:19  LGA  ORD   740  502  327  121  11  5  126  210
982  25MAR2000  10:28  LGA  DFW  1383  251  344  128   5  6  134  180
622  25MAR2000  12:19  LGA  FRA  3857  314  175  168  22  3  193  250
821  25MAR2000  14:56  LGA  LHR  3442  404  184  200   9  3  212  250
872  25MAR2000  13:02  LGA  LAX  2475  292  133  158  20  3  181  210
416  25MAR2000   9:09  LGA  WAS   229  495  507  119  22  3  135  180
132  25MAR2000  15:35  LGA  YYZ   366  422  238  156  22  0  178  178
829  25MAR2000  13:38  LGA  WAS   229  569  230   91  19  5  101  180
183  25MAR2000  17:46  LGA  WAS   229  361  387   21  19  3   24  180
271  25MAR2000  13:17  LGA  CDG  3635  344  232  118  10  5  133  250
921  25MAR2000  17:11  LGA  DFW  1383  335  540  115   9  3  123  180
302  25MAR2000  20:22  LGA  WAS   229  334  255  155  19  5  168  180
431  25MAR2000  18:50  LGA  LAX  2475  320   21  163  18  7  188  210
308  25MAR2000  21:06  LGA  ORD   740  349  402  175  14  6  185  210
182  26MAR2000   8:21  LGA  YYZ   366  414  414  116  13  3  132  178
114  26MAR2000   7:10  LGA  LAX  2475  622  341  108  22  6  136  210
202  26MAR2000  10:43  LGA  ORD   740  458  367   78  15  4   96  210
219  26MAR2000   9:31  LGA  LHR  3442  308  300  202  18  9  229  250
439  26MAR2000  12:16  LGA  LAX  2475  345  392  137  17  4  158  210
387  26MAR2000  11:40  LGA  CPH  3856  483   71   92  17  7  116  250
290  26MAR2000   6:56  LGA  WAS   229  462  260   51  11  7   61  180
523  26MAR2000  15:19  LGA  ORD   740  471  308  104  15  5  111  210
982  26MAR2000  10:28  LGA  DFW  1383  417  307   78  17  2   80  180
622  26MAR2000  12:19  LGA  FRA  3857  392  227  211   0  2  213  250
872  26MAR2000  13:02  LGA  LAX  2475  393  432  109  24  6  139  210
416  26MAR2000   9:09  LGA  WAS   229  263  408   58  14  4   67  180
132  26MAR2000  15:35  LGA  YYZ   366  466  293   88  10  4  102  178
829  26MAR2000  13:38  LGA  WAS   229  374  293   65  14  5   79  180
183  26MAR2000  17:46  LGA  WAS   229  388  214   92  18  5  107  180
271  26MAR2000  13:17  LGA  CDG  3635  459  385  170  16  6  192  250
921  26MAR2000  17:11  LGA  DFW  1383  405  281   49  13  6   66  180
302  26MAR2000  20:22  LGA  WAS   229  227  451   57  14  5   69  180
431  26MAR2000  18:50  LGA  LAX  2475  435  242  145  17  6  168  210
308  26MAR2000  21:06  LGA  ORD   740  483  421   75  14  4   83  210
182  27MAR2000   8:21  LGA  YYZ   366  520  206  138   7  7  152  178
114  27MAR2000   7:10  LGA  LAX  2475  353  285  198  12  0  210  210
202  27MAR2000  10:43  LGA  ORD   740  371  346  113  21  3  117  210
219  27MAR2000   9:31  LGA  LHR  3442  285  198  179  12  4  195  250
439  27MAR2000  12:16  LGA  LAX  2475  348  298  115  18  2  135  210
290  27MAR2000   6:56  LGA  WAS   229  325  276   55  15  7   64  180
523  27MAR2000  15:19  LGA  ORD   740  333  460  144   3  6  152  210
982  27MAR2000  10:28  LGA  DFW  1383  564  200   85   5  5   92  180
821  27MAR2000  14:56  LGA  LHR  3442  402  292  194  15  5  214  250
872  27MAR2000  13:02  LGA  LAX  2475  467  409  154  20  6  180  210
416  27MAR2000   9:09  LGA  WAS   229  307  417   53   9  4   61  180
132  27MAR2000  15:35  LGA  YYZ   366  445  408  103  16  3  122  178
829  27MAR2000  13:38  LGA  WAS   229  444  320  104  12  2  115  180
183  27MAR2000  17:46  LGA  WAS   229  280  365   76  16  5   82  180
921  27MAR2000  17:11  LGA  DFW  1383  282  250    .  16  5   79  180
302  27MAR2000  20:22  LGA  WAS   229  253  407   76  14  5   89  180
431  27MAR2000  18:50  LGA  LAX  2475  536  215  166  17  6  189  210
308  27MAR2000  21:06  LGA  ORD   740  239  427  168  19  2  172  210
182  28MAR2000   8:21  LGA  YYZ   366  394  291  158  20  0  178  178
114  28MAR2000   7:10  LGA  LAX  2475  387  278  200  10  0  210  210
202  28MAR2000  10:43  LGA  ORD   740  366  410  199  11  0  201  210
219  28MAR2000   9:31  LGA  LHR  3442  517  378  136  12  2  150  250
439  28MAR2000  12:16  LGA  LAX  2475  331  373  182   8  2  192  210
387  28MAR2000  11:40  LGA  CPH  3856  271  306  119  21  3  143  250
290  28MAR2000   6:56  LGA  WAS   229  444  438  173   7  0  177  180
523  28MAR2000  15:19  LGA  ORD   740  389  302  170  19  5  180  210
982  28MAR2000  10:28  LGA  DFW  1383  454  329  131  16  4  143  180
622  28MAR2000  12:19  LGA  FRA  3857  606  371  225  13  6  244  250
821  28MAR2000  14:56  LGA  LHR  3442  383  331  162  10  6  178  250
872  28MAR2000  13:02  LGA  LAX  2475  331  280  190  20  0  210  210
416  28MAR2000   9:09  LGA  WAS   229  375  291  154  17  5  168  180
132  28MAR2000  15:35  LGA  YYZ   366  291  458   88  29  7  124  178
829  28MAR2000  13:38  LGA  WAS   229  396  422  115  13  5  123  180
183  28MAR2000  17:46  LGA  WAS   229  366  296  150  13  3  164  180
271  28MAR2000  13:17  LGA  CDG  3635  382   94  187   7  7  201  250
921  28MAR2000  17:11  LGA  DFW  1383  401  449  139  23  4  154  180
302  28MAR2000  20:22  LGA  WAS   229  394  244  164  16  0  175  180
431  28MAR2000  18:50  LGA  LAX  2475  369  333  207   3  0  210  210
308  28MAR2000  21:06  LGA  ORD   740  387  469  177  12  6  189  210
182  29MAR2000   8:21  LGA  YYZ   366  435  427  150   4  7  161  178
114  29MAR2000   7:10  LGA  LAX  2475  365  530  182  12  4  198  210
202  29MAR2000  10:43  LGA  ORD   740  365  273  130  14  7  137  210
219  29MAR2000   9:31  LGA  LHR  3442  452  349  202  14  4  220  250
439  29MAR2000  12:16  LGA  LAX  2475  418  374  152   8  4  164  210
387  29MAR2000  11:40  LGA  CPH  3856  370  412  177  18  5  200  250
290  29MAR2000   6:56  LGA  WAS   229  378  398   70   0  4   74  180
523  29MAR2000  15:19  LGA  ORD   740  414  467  171  20  6  177  210
982  29MAR2000  10:28  LGA  DFW  1383  299  374   76  12  0   82  180
622  29MAR2000  12:19  LGA  FRA  3857  323  224  110  19  6  135  250
821  29MAR2000  14:56  LGA  LHR  3442  433  393  206  14  5  225  250
872  29MAR2000  13:02  LGA  LAX  2475  335  356  166  17  3  186  210
416  29MAR2000   9:09  LGA  WAS   229  404  409   88  11  6   95  180
132  29MAR2000  15:35  LGA  YYZ   366  434  498  106   8  6  120  178
829  29MAR2000  13:38  LGA  WAS   229  255  240   71  17  2   74  180
183  29MAR2000  17:46  LGA  WAS   229  352  349   89  11  5  104  180
271  29MAR2000  13:17  LGA  CDG  3635  381  363  168  24  6  198  250
921  29MAR2000  17:11  LGA  DFW  1383  391  568  112  21  3  117  180
302  29MAR2000  20:22  LGA  WAS   229  469  321   93  23  6  108  180
431  29MAR2000  18:50  LGA  LAX  2475  302  278  158  13  4  175  210
308  29MAR2000  21:06  LGA  ORD   740  330  517  124  15  6  132  210
182  30MAR2000   8:21  LGA  YYZ   366  407  465  115   9  4  128  178
114  30MAR2000   7:10  LGA  LAX  2475  273  419  126  15  4  145  210
202  30MAR2000  10:43  LGA  ORD   740  398  476  159  11  5  170  210
219  30MAR2000   9:31  LGA  LHR  3442  501  455  172  19  7  198  250
439  30MAR2000  12:16  LGA  LAX  2475  392  323  200  10  0  210  210
387  30MAR2000  11:40  LGA  CPH  3856    .  218  175  12  6  193  250
290  30MAR2000   6:56  LGA  WAS   229  401  277   57   6  5   65  180
523  30MAR2000  15:19  LGA  ORD   740  319  360  153  29  4  160  210
982  30MAR2000  10:28  LGA  DFW  1383  335  374   94  21  8  106  180
622  30MAR2000  12:19  LGA  FRA  3857  477  299  209  20  5  234  250
821  30MAR2000  14:56  LGA  LHR  3442  374  212  113  15  6  134  250
872  30MAR2000  13:02  LGA  LAX  2475  333  314  143   9  4  156  210
416  30MAR2000   9:09  LGA  WAS   229  448  452   95  17  4  103  180
132  30MAR2000  15:35  LGA  YYZ   366  401  346  149  11  6  166  178
829  30MAR2000  13:38  LGA  WAS   229  304  316   90   9  5   95  180
183  30MAR2000  17:46  LGA  WAS   229  492  300   86   5  4   93  180
271  30MAR2000  13:17  LGA  CDG  3635  416  489  164  15  6  185  250
921  30MAR2000  17:11  LGA  DFW  1383  539  442  101  20  4  106  180
302  30MAR2000  20:22  LGA  WAS   229  328  319   54  14  3   61  180
431  30MAR2000  18:50  LGA  LAX  2475  372  402  159  14  4  177  210
308  30MAR2000  21:06  LGA  ORD   740  379  218  121  18  6  131  210
182  31MAR2000   8:21  LGA  YYZ   366  467  270   91   7  6  104  178
114  31MAR2000   7:10  LGA  LAX  2475  433  457  183  14  4  201  210
202  31MAR2000  10:43  LGA  ORD   740  297  301  111  12  3  114  210
219  31MAR2000   9:31  LGA  LHR  3442  398  371  173  11  5  189  250
439  31MAR2000  12:16  LGA  LAX  2475  433  511   92  20  6  118  210
387  31MAR2000  11:40  LGA  CPH  3856  530  360  147  13  1  161  250
290  31MAR2000   6:56  LGA  WAS   229  441  380  104  22  5  130  180
523  31MAR2000  15:19  LGA  ORD   740  384  183  120  11  7  131  210
982  31MAR2000  10:28  LGA  DFW  1383  312  250   50  14  4   55  180
622  31MAR2000  12:19  LGA  FRA  3857  458  462  197  15  5  217  250
821  31MAR2000  14:56  LGA  LHR  3442  380  123  212   3  3  218  250
872  31MAR2000  13:02  LGA  LAX  2475  400  284  153  15  5  173  210
416  31MAR2000   9:09  LGA  WAS   229  278  468   90  12  4   97  180
132  31MAR2000  15:35  LGA  YYZ   366  353  496   85  20  5  110  178
829  31MAR2000  13:38  LGA  WAS   229  212  313   84  19  2   97  180
183  31MAR2000  17:46  LGA  WAS   229  434  309  129  10  3  138  180
271  31MAR2000  13:17  LGA  CDG  3635  358  449  138  14  3  155  250
921  31MAR2000  17:11  LGA  DFW  1383  353  195  131  20  4  138  180
302  31MAR2000  20:22  LGA  WAS   229  413  331   14  15  5   33  180
431  31MAR2000  18:50  LGA  LAX  2475  471  190  130  17  3  150  210
308  31MAR2000  21:06  LGA  ORD   740  424  376  105   9  3  113  210
;
run;

data sasuser.mechanicslevel1;
   input EmpID $ 1-4 JobCode $ 9-11
         @19 Salary dollar7.;
   format salary dollar9.;
datalines;
1400    ME1       $41,677
1403    ME1       $39,301
1120    ME1       $40,067
1121    ME1       $40,757
1412    ME1       $38,919
1200    ME1       $38,942
1995    ME1       $40,334
1418    ME1       $39,207
;
run;

data sasuser.mechanicslevel2;
   input EmpID $ 1-4 JobCode $ 9-11
         @19 Salary dollar7.;
   format salary dollar9.;
datalines;
1653    ME2       $49,151
1782    ME2       $49,483
1244    ME2       $51,695
1065    ME2       $49,126
1129    ME2       $48,901
1406    ME2       $49,259
1356    ME2       $51,617
1292    ME2       $51,367
1440    ME2       $50,060
1900    ME2       $49,147
1423    ME2       $50,082
1432    ME2       $49,458
1050    ME2       $49,234
1105    ME2       $48,727
;
run;

data sasuser.mechanicslevel3;
   input EmpID $ 1-4 JobCode $ 9-11
         @19 Salary dollar7.;
   format salary dollar9.;
datalines;
1499    ME3       $60,235
1409    ME3       $58,171
1379    ME3       $59,170
1521    ME3       $58,136
1385    ME3       $61,460
1420    ME3       $60,299
1882    ME3       $58,153
;
run;
data sasuser.monthly;
   input Year Month1 Month2 Month3 Month4 Month5 Month6 Month7 Month8 Month9 Month10 Month11
              Month12;
datalines;
1989 23000 21500 24600 23300 20000 21100 23000 21600 24600 24300 22700 24800
1990 23400 24400 25300 25100 22500 24400 28700 27400 27100 28700 26500 27600
1991 23500 24600 25300 28700 25500 27600 28700 28400 28100 29700 28800 29300 
;




data sasuser.payrollchanges;
   informat DateOfBirth DateOfHire date9.;
   input EmpID $ 1-4 Gender $ 7 JobCode $ 11-13
         @16 Salary dollar7. @27 DateOfBirth date9.
         @40 DateOfHire date9.;
   format salary dollar9. dateofbirth dateofhire date9.;
datalines;
1639  F   TA3  $59,164    30JUN1955    31JAN1982
1065  M   ME3  $53,326    29JAN1942    10JAN1985
1561  M   TA3  $51,120    03DEC1961    10OCT1985
1221  F   FA3  $41,854    25SEP1965    07OCT1989
1447  F   FA1  $30,972    11AUG1970    01NOV2000
1998  M   SCP  $32,340    13SEP1968    05NOV2000
;
run;

data sasuser.payrollmaster;
   informat DateOfBirth DateOfHire date9.;
   input EmpID $ 1-4 Gender $ 11 JobCode $ 19-21
         @28 Salary dollar8. @40 DateOfBirth date9.
         @53 DateOfHire date9.;
   format salary dollar9. dateofbirth dateofhire date9.;
datalines;
1919      M       TA2       $48,126    16SEP1958    07JUN1985
1653      F       ME2       $49,151    19OCT1962    12AUG1988
1400      M       ME1       $41,677    08NOV1965    19OCT1988
1350      F       FA3       $46,040    04SEP1963    01AUG1988
1401      M       TA3       $54,351    16DEC1948    21NOV1983
1499      M       ME3       $60,235    29APR1952    11JUN1978
1101      M       SCP       $26,212    09JUN1960    04OCT1988
1333      M       PT2      $124,048    03APR1959    14FEB1979
1402      M       TA2       $45,661    20JAN1961    05DEC1988
1479      F       TA3       $54,299    26DEC1966    09OCT1987
1403      M       ME1       $39,301    01FEB1967    24DEC1989
1739      M       PT1       $93,124    29DEC1962    30JAN1989
1658      M       SCP       $25,120    11APR1965    04MAR1990
1428      F       PT1       $96,274    07APR1968    19NOV1989
1782      M       ME2       $49,483    07DEC1968    25FEB1990
1244      M       ME2       $51,695    03SEP1961    20JAN1986
1383      M       BCK       $36,152    28JAN1966    24OCT1990
1574      M       FA2       $40,001    01MAY1958    24DEC1990
1789      M       SCP       $25,656    29JAN1955    14APR1976
1404      M       PT2      $127,926    28FEB1951    04JAN1978
1437      F       FA3       $46,346    24SEP1958    04SEP1982
1639      F       TA3       $56,364    30JUN1955    31JAN1982
1269      M       NA1       $58,366    07MAY1970    02DEC1990
1065      M       ME2       $49,126    29JAN1942    10JAN1985
1876      M       TA3       $55,545    23MAY1956    01MAY1983
1037      F       TA1       $39,981    14APR1962    17SEP1990
1129      F       ME2       $48,901    12DEC1959    20AUG1989
1988      M       FA3       $45,104    03DEC1957    22SEP1982
1405      M       SCP       $25,278    08MAR1964    29JAN1990
1430      F       TA2       $46,095    03MAR1960    30APR1985
1983      F       FA3       $46,787    03MAR1960    30APR1985
1134      F       TA2       $46,847    09MAR1967    25DEC1986
1118      M       PT3      $155,931    19JAN1942    22DEC1978
1438      F       TA3       $54,912    19MAR1963    21NOV1985
1125      F       FA2       $40,443    12NOV1966    14DEC1985
1475      F       FA2       $38,902    19DEC1959    16JUL1988
1117      M       TA3       $55,679    08JUN1961    17AUG1990
1935      F       NA2       $71,513    31MAR1952    20OCT1979
1124      F       FA1       $32,448    13JUL1956    04OCT1988
1422      F       FA1       $31,436    08JUN1962    09APR1989
1616      F       TA2       $47,792    04MAR1968    08JUN1991
1406      M       ME2       $49,259    12MAR1959    20FEB1985
1120      M       ME1       $40,067    15SEP1970    11OCT1991
1094      M       FA1       $31,175    05APR1968    20APR1989
1389      M       BCK       $35,039    18JUL1957    21AUG1988
1905      M       PT1       $91,155    20APR1970    02JUN1990
1407      M       PT1       $95,334    27MAR1967    21MAR1988
1114      F       TA2       $46,099    22SEP1967    30JUN1985
1410      M       PT2      $118,559    06MAY1965    10NOV1984
1439      F       PT1       $99,030    10MAR1962    13SEP1988
1409      M       ME3       $58,171    22APR1948    26OCT1979
1408      M       TA2       $47,793    02APR1958    17OCT1985
1121      M       ME1       $40,757    29SEP1969    10DEC1989
1991      F       TA1       $38,703    11MAY1970    16DEC1990
1102      M       TA2       $48,359    04OCT1957    18APR1989
1356      M       ME2       $51,617    30SEP1955    25FEB1981
1545      M       PT1       $92,582    15AUG1957    01JUN1988
1292      F       ME2       $51,367    01NOV1962    06JUL1987
1440      F       ME2       $50,060    30SEP1960    12APR1989
1368      M       FA2       $38,931    15JUN1959    07NOV1982
1369      M       TA2       $47,187    01JAN1960    16MAR1985
1411      M       FA2       $38,171    31MAY1959    05DEC1987
1113      F       FA1       $31,314    18JAN1966    20OCT1989
1704      M       BCK       $35,651    02SEP1964    01JUL1985
1900      M       ME2       $49,147    28MAY1960    30OCT1985
1126      F       TA3       $57,259    31MAY1961    25NOV1978
1677      M       BCK       $36,410    08NOV1961    31MAR1987
1441      F       FA2       $38,021    23NOV1967    26MAR1989
1421      M       TA2       $46,417    11JAN1957    03MAR1988
1119      M       TA1       $37,694    23JUN1960    10SEP1986
1834      M       BCK       $37,654    11FEB1970    06JUL1990
1777      M       PT3      $153,482    26SEP1949    25JUN1979
1663      M       BCK       $37,033    14JAN1965    14AUG1989
1106      M       PT2      $125,485    10NOV1955    20AUG1982
1103      F       FA1       $33,233    19FEB1966    27JUL1990
1477      M       FA2       $39,992    25MAR1962    11MAR1986
1476      F       TA2       $48,724    02JUN1964    20MAR1985
1379      M       ME3       $59,170    12AUG1959    14JUN1982
1104      M       SCP       $25,124    28APR1961    13JUN1989
1009      M       TA1       $40,432    05MAR1957    30MAR1990
1412      M       ME1       $38,919    22JUN1954    08DEC1989
1115      F       FA3       $45,779    26AUG1958    04MAR1978
1128      F       TA2       $45,888    27MAY1963    23OCT1988
1442      F       PT2      $118,350    08SEP1964    16APR1986
1417      M       NA2       $73,178    01JUL1962    11MAR1987
1478      M       PT2      $117,884    12AUG1957    27OCT1988
1673      M       BCK       $35,668    02MAR1968    18JUL1989
1839      F       NA1       $60,806    02DEC1968    07JUL1991
1347      M       TA3       $56,111    24SEP1965    10SEP1982
1423      F       ME2       $50,082    18MAY1966    22AUG1988
1200      F       ME1       $38,942    13JAN1969    18AUG1990
1970      F       FA1       $31,661    29SEP1962    15MAR1989
1521      M       ME3       $58,136    15APR1961    17JUL1986
1354      F       SCP       $25,669    01JUN1969    20JUN1990
1424      F       FA2       $40,569    08AUG1967    15DEC1987
1132      F       FA1       $31,378    03JUN1970    26OCT1991
1845      M       BCK       $36,394    23NOV1957    26MAR1978
1556      M       PT1       $99,889    26JUN1962    14DEC1989
1413      M       FA2       $38,409    20SEP1963    06JAN1988
1123      F       TA1       $39,770    04NOV1970    09DEC1990
1907      M       TA2       $46,661    19NOV1958    09JUL1985
1436      F       TA2       $48,265    15JUN1962    15MAR1985
1385      M       ME3       $61,460    20JAN1960    04APR1984
1432      F       ME2       $49,458    07NOV1959    14FEB1983
1111      M       NA1       $56,820    18JUL1971    04NOV1990
1116      F       FA1       $32,007    02OCT1967    24MAR1989
1352      M       NA2       $75,317    06DEC1958    19OCT1984
1555      F       FA2       $38,499    20MAR1966    08JUL1990
1038      F       TA1       $37,146    13NOV1967    26NOV1989
1420      M       ME3       $60,299    23FEB1963    25JUL1985
1561      M       TA2       $48,320    03DEC1961    10OCT1985
1434      F       FA2       $40,071    14JUL1960    31OCT1988
1414      M       FA1       $33,102    28MAR1970    16APR1990
1112      M       TA1       $37,667    03DEC1962    11DEC1990
1390      M       FA2       $38,865    23FEB1963    26JUN1989
1332      M       NA1       $59,049    20SEP1968    07JUN1989
1890      M       PT2      $120,254    23JUL1949    28NOV1977
1429      F       TA1       $39,115    03MAR1958    11AUG1990
1107      M       PT2      $125,968    12JUN1952    13FEB1977
1908      F       TA2       $46,193    14DEC1967    26APR1988
1830      F       PT2      $118,259    31MAY1955    01FEB1981
1882      M       ME3       $58,153    14JUL1955    24NOV1976
1050      M       ME2       $49,234    17JUL1961    27AUG1984
1425      F       FA1       $33,571    31DEC1969    04MAR1991
1928      M       PT2      $125,801    19SEP1952    16JUL1988
1480      F       TA3       $55,416    07SEP1955    29MAR1979
1100      M       BCK       $35,006    05DEC1958    11MAY1986
1995      F       ME1       $40,334    28AUG1971    23SEP1991
1135      F       FA2       $38,249    24SEP1958    03APR1988
1415      M       FA2       $39,589    12MAR1956    15FEB1986
1076      M       PT1       $93,181    18OCT1970    06OCT1989
1426      F       TA2       $46,187    08DEC1964    28JUN1988
1564      F       SCP       $26,366    15APR1960    05JUL1990
1221      F       FA2       $39,054    25SEP1965    07OCT1989
1133      M       TA1       $38,781    16JUL1964    15FEB1990
1435      F       TA3       $54,331    15MAY1957    11FEB1978
1418      M       ME1       $39,207    02APR1955    09JAN1990
1017      M       TA3       $57,201    01JAN1956    20OCT1979
1443      F       NA1       $59,184    21NOV1966    01SEP1989
1131      F       TA2       $45,605    29DEC1969    22APR1989
1427      F       TA2       $47,664    03NOV1968    03FEB1988
1036      F       TA3       $55,149    23MAY1963    27OCT1982
1130      F       FA1       $33,482    19MAY1969    09JUN1990
1127      F       TA2       $46,215    13NOV1962    10DEC1984
1433      F       FA3       $46,175    11JUL1964    20JAN1985
1431      F       FA3       $46,522    13JUN1962    09APR1986
1122      F       FA2       $39,138    04MAY1961    01DEC1986
1105      M       ME2       $48,727    04MAR1960    16AUG1988
;
run;
data sasuser.qsales;
   input SalesRep $ @10 Sales1 Sales2 Sales3 Sales4;
datalines;
Britt    8400 8800 9300 9800  9000 9300
Fruchten 9500 9300 9800 8900  9000 9300
Goodyear 9150 9200 9650 11000 9000 9300
;

data sasuser.staffchanges;
   input EmpID $ 1-4 LastName $ 9-23 FirstName $ 25-39
         City $ 41-55 State $ 57-58 PhoneNumber $ 65-76;
datalines;
1639    CARTER          KAREN           STAMFORD        CT      203/781-8839
1065    CHAPMAN         NEIL            NEW YORK        NY      718/384-5618
1561    SANDERS         RAYMOND         NEW YORK        NY      212/588-6615
1221    WALTERS         DIANE           NEW YORK        NY      718/384-1918
1447    BRIDESTON       AMY             NEW YORK        NY      718/384-1213
1998    POWELL          JIM             NEW YORK        NY      718/384-8642
;
run;

data sasuser.staffmaster;
   input EmpID $ 1-4 LastName $ 9-23 FirstName $ 25-39
         City $ 41-55 State $ 58-59 PhoneNumber $ 66-77;
datalines;
1919    ADAMS           GERALD          STAMFORD         CT      203/781-1255
1653    ALEXANDER       SUSAN           BRIDGEPORT       CT      203/675-7715
1400    APPLE           TROY            NEW YORK         NY      212/586-0808
1350    ARTHUR          BARBARA         NEW YORK         NY      718/383-1549
1401    AVERY           JERRY           PATERSON         NJ      201/732-8787
1499    BAREFOOT        JOSEPH          PRINCETON        NJ      201/812-5665
1101    BAUCOM          WALTER          NEW YORK         NY      212/586-8060
1333    BLAIR           JUSTIN          STAMFORD         CT      203/781-1777
1402    BLALOCK         RALPH           NEW YORK         NY      718/384-2849
1479    BOSTIC          MARIE           NEW YORK         NY      718/384-8816
1403    BOWDEN          EARL            BRIDGEPORT       CT      203/675-3434
1739    BOYCE           JONATHAN        NEW YORK         NY      212/587-1247
1658    BRADLEY         JEREMY          NEW YORK         NY      212/587-3622
1428    BRADY           CHRISTINE       STAMFORD         CT      203/781-1212
1782    BROWN           JASON           STAMFORD         CT      203/781-0019
1244    BRYANT          LEONARD         NEW YORK         NY      718/383-3334
1383    BURNETTE        THOMAS          NEW YORK         NY      718/384-3569
1574    CAHILL          MARSHALL        NEW YORK         NY      718/383-2338
1789    CARAWAY         DAVIS           NEW YORK         NY      212/587-9000
1404    CARTER          DONALD          NEW YORK         NY      718/384-2946
1437    CARTER          DOROTHY         BRIDGEPORT       CT      203/675-4117
1639    CARTER          KAREN           STAMFORD         CT      203/781-8839
1269    CASTON          FRANKLIN        STAMFORD         CT      203/781-3335
1065    CHAPMAN         NEIL            NEW YORK         NY      718/384-5618
1876    CHIN            JACK            NEW YORK         NY      212/588-5634
1037    CHOW            JANE            STAMFORD         CT      203/781-8868
1129    COOK            BRENDA          NEW YORK         NY      718/383-2313
1988    COOPER          ANTHONY         NEW YORK         NY      212/587-1228
1405    DAVIDSON        JASON           PATERSON         NJ      201/732-2323
1430    DEAN            SANDRA          BRIDGEPORT       CT      203/675-1647
1983    DEAN            SHARON          NEW YORK         NY      718/384-1647
1134    DELGADO         MARIA           STAMFORD         CT      203/781-1528
1118    DENNIS          ROGER           NEW YORK         NY      718/383-1122
1438    DONALDSON       KAREN           STAMFORD         CT      203/781-2229
1125    DUNLAP          DONNA           NEW YORK         NY      718/383-2094
1475    EATON           ALICIA          NEW YORK         NY      718/383-2828
1117    EDGERTON        JOSHUA          NEW YORK         NY      212/588-1239
1935    FERNANDEZ       KATRINA         BRIDGEPORT       CT      203/675-2962
1124    FIELDS          DIANA           WHITE PLAINS     NY      914/455-2998
1422    FLETCHER        MARIE           PRINCETON        NJ      201/812-0902
1616    FLOWERS         ANNETTE         NEW YORK         NY      718/384-3329
1406    FOSTER          GERALD          BRIDGEPORT       CT      203/675-6363
1120    GARCIA          JACK            NEW YORK         NY      718/384-4930
1094    GOMEZ           ALAN            BRIDGEPORT       CT      203/675-7181
1389    GORDON          LEVI            NEW YORK         NY      718/384-9326
1905    GRAHAM          ALVIN           NEW YORK         NY      212/586-8815
1407    GRANT           DANIEL          MT. VERNON       NY      914/468-1616
1114    GREEN           JANICE          NEW YORK         NY      212/588-1092
1410    HARRIS          CHARLES         STAMFORD         CT      203/781-0937
1439    HARRISON        FELICIA         BRIDGEPORT       CT      203/675-4987
1409    HARTFORD        RAYMOND         STAMFORD         CT      203/781-9697
1408    HENDERSON       WILLIAM         PRINCETON        NJ      201/812-4789
1121    HERNANDEZ       MICHAEL         NEW YORK         NY      718/384-3313
1991    HOWARD          GRETCHEN        BRIDGEPORT       CT      203/675-0007
1102    HOWARD          LEONARD         WHITE PLAINS     NY      914/455-0976
1356    HOWARD          MICHAEL         NEW YORK         NY      212/586-8411
1545    HUNTER          CLYDE           STAMFORD         CT      203/781-1119
1292    HUNTER          HELEN           BRIDGEPORT       CT      203/675-4830
1440    JACKSON         LAURA           STAMFORD         CT      203/781-0088
1368    JEPSEN          RONALD          STAMFORD         CT      203/781-8413
1369    JOHNSON         ANTHONY         NEW YORK         NY      212/587-5385
1411    JOHNSON         JACKSON         PATERSON         NJ      201/732-3678
1113    JONES           LESLIE          NEW YORK         NY      718/383-3003
1704    JONES           NATHAN          NEW YORK         NY      718/384-0049
1900    KING            WILLIAM         NEW YORK         NY      718/383-3698
1126    KIRBY           ANNE            NEW YORK         NY      212/586-1229
1677    KRAMER          JACKSON         BRIDGEPORT       CT      203/675-7432
1441    LAWRENCE        KATHY           PRINCETON        NJ      201/812-3337
1421    LEE             RUSSELL         MT. VERNON       NY      914/468-9143
1119    LI              JEFF            NEW YORK         NY      212/586-2344
1834    LONG            RUSSELL         NEW YORK         NY      718/384-0040
1777    LUFKIN          ROY             NEW YORK         NY      718/383-4413
1663    MARKS           JOHN            NEW YORK         NY      212/587-7742
1106    MARSHBURN       JASPER          STAMFORD         CT      203/781-1457
1103    MCDANIEL        RONDA           NEW YORK         NY      212/586-0013
1477    MEYERS          PRESTON         BRIDGEPORT       CT      203/675-8125
1476    MONROE          JOYCE           STAMFORD         CT      203/781-2837
1379    MORGAN          ALFRED          STAMFORD         CT      203/781-2216
1104    MORGAN          CHRISTOPHER     NEW YORK         NY      718/383-9740
1009    MORGAN          GEORGE          NEW YORK         NY      212/586-7753
1412    MURPHEY         JOHN            PRINCETON        NJ      201/812-4414
1115    MURPHY          ALICE           NEW YORK         NY      718/384-1982
1128    NELSON          FELICIA         BRIDGEPORT       CT      203/675-1166
1442    NEWKIRK         SANDRA          PRINCETON        NJ      201/812-3331
1417    NEWKIRK         WILLIAM         PATERSON         NJ      201/732-6611
1478    NEWTON          JAMES           NEW YORK         NY      212/587-5549
1673    NICHOLLS        HENRY           STAMFORD         CT      203/781-7770
1839    NORRIS          DIANE           NEW YORK         NY      718/384-1767
1347    O'NEAL          BRYAN           NEW YORK         NY      718/384-0230
1423    OSWALD          LESLIE          MT. VERNON       NY      914/468-9171
1200    OVERMAN         MICHELLE        STAMFORD         CT      203/781-1835
1970    PARKER          ANNE            NEW YORK         NY      718/383-3895
1521    PARKER          JAY             NEW YORK         NY      212/587-7603
1354    PARKER          MARY            WHITE PLAINS     NY      914/455-2337
1424    PATTERSON       RENEE           NEW YORK         NY      212/587-8991
1132    PEARCE          CAROL           NEW YORK         NY      718/384-1986
1845    PEARSON         JAMES           NEW YORK         NY      718/384-2311
1556    PENNINGTON      MICHAEL         NEW YORK         NY      718/383-5681
1413    PETERS          RANDALL         PRINCETON        NJ      201/812-2478
1123    PETERSON        SUZANNE         NEW YORK         NY      718/383-0077
1907    PHELPS          WILLIAM         STAMFORD         CT      203/781-1118
1436    PORTER          SUSAN           NEW YORK         NY      718/383-5777
1385    RAYNOR          MILTON          BRIDGEPORT       CT      203/675-2846
1432    REED            MARILYN         MT. VERNON       NY      914/468-5454
1111    RHODES          JEREMY          PRINCETON        NJ      201/812-1837
1116    RICHARDS        CASEY           NEW YORK         NY      212/587-1224
1352    RIVERS          SIMON           NEW YORK         NY      718/383-3345
1555    RODRIGUEZ       JULIA           BRIDGEPORT       CT      203/675-2401
1038    RODRIGUEZ       MARIA           BRIDGEPORT       CT      203/675-2048
1420    ROUSE           JEREMY          PATERSON         NJ      201/732-9834
1561    SANDERS         RAYMOND         NEW YORK         NY      212/588-6615
1434    SANDERSON       EDITH           STAMFORD         CT      203/781-1333
1414    SANDERSON       NATHAN          BRIDGEPORT       CT      203/675-1715
1112    SAYERS          RANDY           NEW YORK         NY      718/384-4895
1390    SMART           JONATHAN        NEW YORK         NY      718/383-1141
1332    STEPHENSON      ADAM            BRIDGEPORT       CT      203/675-1497
1890    STEPHENSON      ROBERT          NEW YORK         NY      718/384-9874
1429    THOMPSON        ALICE           STAMFORD         CT      203/781-3857
1107    THOMPSON        WAYNE           NEW YORK         NY      718/384-3785
1908    TRENTON         MELISSA         NEW YORK         NY      212/586-6262
1830    TRIPP           KATHY           BRIDGEPORT       CT      203/675-2479
1882    TUCKER          ALAN            NEW YORK         NY      718/384-0216
1050    TUTTLE          THOMAS          WHITE PLAINS     NY      914/455-2119
1425    UNDERWOOD       JENNY           STAMFORD         CT      203/781-0978
1928    UPCHURCH        LARRY           WHITE PLAINS     NY      914/455-5009
1480    UPDIKE          THERESA         NEW YORK         NY      212/587-8729
1100    VANDEUSEN       RICHARD         NEW YORK         NY      212/586-2531
1995    VARNER          ELIZABETH       NEW YORK         NY      718/384-7113
1135    VEGA            ANNA            NEW YORK         NY      718/384-5913
1415    VEGA            FRANKLIN        NEW YORK         NY      718/384-2823
1076    VENTER          RANDALL         NEW YORK         NY      718/383-2321
1426    VICK            THERESA         PRINCETON        NJ      201/812-2424
1564    WALTERS         ANNE            NEW YORK         NY      212/587-3257
1221    WALTERS         DIANE           NEW YORK         NY      718/384-1918
1133    WANG            CHIN            NEW YORK         NY      212/587-1956
1435    WARD            ELAINE          NEW YORK         NY      718/383-4987
1418    WATSON          BERNARD         NEW YORK         NY      718/383-1298
1017    WELCH           DARIUS          NEW YORK         NY      212/586-5535
1443    WELLS           AGNES           STAMFORD         CT      203/781-5546
1131    WELLS           NADINE          NEW YORK         NY      718/383-1045
1427    WHALEY          CAROLYN         MT. VERNON       NY      914/468-4528
1036    WONG            LESLIE          NEW YORK         NY      212/587-2570
1130    WOOD            DEBORAH         NEW YORK         NY      212/587-0013
1127    WOOD            SANDRA          NEW YORK         NY      212/587-2881
1433    YANCEY          ROBIN           PRINCETON        NJ      201/812-1874
1431    YOUNG           DEBORAH         STAMFORD         CT      203/781-2987
1122    YOUNG           JOANN           NEW YORK         NY      718/384-2021
1105    YOUNG           LAWRENCE        NEW YORK         NY      718/384-0008
;
run;

data sasuser.supervisors;
   input EmpID $ 1-4 State $ 10-11 JobCategory $ 21-22;
   label empid='Supervisor Id' jobcategory='Job Category';
datalines;
1677     CT         BC
1834     NY         BC
1431     CT         FA
1433     NJ         FA
1983     NY         FA
1385     CT         ME
1420     NJ         ME
1882     NY         ME
1935     CT         NA
1417     NJ         NA
1352     NY         NA
1106     CT         PT
1442     NJ         PT
1118     NY         PT
1405     NJ         SC
1564     NY         SC
1639     CT         TA
1401     NJ         TA
1126     NY         TA
;
run;

proc sql;
   create table sasuser.flightattendants as
      select staffmaster.empid, jobcode, lastname, firstname
      from sasuser.staffmaster, sasuser.payrollmaster
        where jobcode contains 'FA' and staffmaster.empid = payrollmaster.empid;
quit;


/*****************************************************************************************************\

/*****************************************************************************************************\

/*****************************************************************************************************\

***** data for Advanced Programming course ***********;
*/

data _null_;

   /* determine paths, delimiters, file options */

   length fileno fileyes $18 fileset $ 1024;

   oshost=trim(substr(symget('sysscp'),1,2));
   filepath=trim(pathname("sasuser"));
      if (oshost = "OS") and (length(symget('sysscp'))=2) then
         do;
            filepath=scan(filepath,1);
            dlm=".";
            fileno="disp=(new,catlg)";
            fileyes="disp=(old,catlg)";
         end;
      else do;
         host=trim(substr(symget('sysscp'),1,3));
            if (host = "WIN") then
               do;
                  filepath=trim(pathname("sasuser"));
                  dlm="\";
                  fileno="";
                  fileyes="";
               end;
           else if (host = "VMS") then
               do;
                  filepath="";
                  dlm="";
                  fileno="";
                  fileyes="";
               end;
           else
               do;
                  filepath=trim(pathname("sasuser"));
                  dlm="/";
                  fileno="";
                  fileyes="";
               end;
      end;

        /* create filerefs for regular raw data files*/

   array filerefs{22} $ file1-file22 ('month1',
         'month2','month3', 'month4', 'month5', 'month6','month7',
         'month8', 'month9','month10','month11','month12','sale2000',
         'flighttm','route1', 'route2','route3','route4','route5',
         'route8','route9','route10');
      do i=1 to dim(filerefs);
         fileset=trim(filepath) || dlm || trim(filerefs(i)) || ".dat";
         isfile=fileexist(fileset);
         if isfile=1 then fileopts=trim(fileyes);
         else fileopts=trim(fileno);
         rc=filename(filerefs(i),fileset,"",fileopts);
      end;

   call symput('filepath',trim(filepath));
   call symput('dlm',trim(dlm));
   call symput('fileyes',trim(fileyes));
   call symput('fileno',trim(fileno));

run;

    /* create filerefs for raw data files with variable years */

data _null_;
   currentyear=year(today());
      thisyear="y" || put(currentyear,4.);
      thisfile="&filepath" || "&dlm" || thisyear || ".dat";
      isfilethis=fileexist(thisfile);
      if isfilethis=1 then fileoptsthis="&fileyes";
      else fileoptsthis="&fileno";
      rc=filename(thisyear,thisfile,"",fileoptsthis);
        call symput('thisyear',thisyear);
   previousyear=currentyear-1;
      lastyear="y" || put(previousyear,4.);
      lastfile="&filepath" || "&dlm" || lastyear || ".dat";
      isfilelast=fileexist(lastfile);
      if isfilelast=1 then fileoptslast="&fileyes";
      else fileoptslast="&fileno";
      rc=filename(lastyear,lastfile,"",fileoptslast);
        call symput('lastyear',lastyear);
run;

    /* create raw data files (.dat) */

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file flighttm;
        put text;
datalines4;
IA10800,23700,14762
IA10801,34500,14762
IA10802,45300,14762
IA10803,56100,14762
IA10804,66900,14762
IA10805,77700,14762
IA10800,23700,14763
IA10801,34500,14763
IA10802,45300,14763
IA10803,56100,14763
IA10804,66900,14763
IA10805,77700,14763
IA10800,23700,14764
IA10801,34500,14764
IA10802,45300,14764
IA10803,56100,14764
IA10804,66900,14764
IA10805,77700,14764
IA10800,23700,14765
IA10801,34500,14765
IA10802,45300,14765
IA10803,56100,14765
IA10804,66900,14765
IA10805,77700,14765
IA10800,23700,14766
IA10801,34500,14766
IA10802,45300,14766
IA10803,56100,14766
IA10804,66900,14766
IA10805,77700,14766
IA10800,23700,14767
IA10801,34500,14767
IA10802,45300,14767
IA10803,56100,14767
IA10804,66900,14767
IA10805,77700,14767
IA10800,23700,14768
IA10801,34500,14768
IA10802,45300,14768
IA10803,56100,14768
IA10804,66900,14768
IA10805,77700,14768
IA10800,23700,14769
IA10801,34500,14769
IA10802,45300,14769
IA10803,56100,14769
IA10804,66900,14769
IA10805,77700,14769
IA10800,23700,14770
IA10801,34500,14770
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month1;
        put text;
datalines4;
IA10200 SYD HKG 01JAN2000 $191,187.00
IA10201 SYD HKG 01JAN2000 $169,653.00
IA10300 SYD CBR 01JAN2000 $850.00
IA10301 SYD CBR 01JAN2000 $970.00
IA10302 SYD CBR 01JAN2000 $1,030.00
IA10303 SYD CBR 01JAN2000 $1,410.00
IA10304 SYD CBR 01JAN2000 $870.00
IA10305 SYD CBR 01JAN2000 $730.00
IA10400 CBR SYD 01JAN2000 $1,390.00
IA10401 CBR SYD 01JAN2000 $750.00
IA10402 CBR SYD 01JAN2000 $1,210.00
IA10403 CBR SYD 01JAN2000 $1,310.00
IA10404 CBR SYD 01JAN2000 $1,090.00
IA10405 CBR SYD 01JAN2000 $1,210.00
IA10500 CBR WLG 01JAN2000 $42,780.00
IA10501 CBR WLG 01JAN2000 $39,100.00
IA10600 WLG CBR 01JAN2000 $41,492.00
IA10601 WLG CBR 01JAN2000 $40,020.00
IA10700 WLG AKL 01JAN2000 $1,900.00
IA10701 WLG AKL 01JAN2000 $1,460.00
IA10702 WLG AKL 01JAN2000 $2,500.00
IA10703 WLG AKL 01JAN2000 $2,380.00
IA10704 WLG AKL 01JAN2000 $2,260.00
IA10705 WLG AKL 01JAN2000 $2,260.00
IA10800 AKL WLG 01JAN2000 $1,740.00
IA10801 AKL WLG 01JAN2000 $2,260.00
IA10802 AKL WLG 01JAN2000 $2,660.00
IA10803 AKL WLG 01JAN2000 $1,660.00
IA10804 AKL WLG 01JAN2000 $1,780.00
IA10805 AKL WLG 01JAN2000 $1,780.00
IA00101 RDU LHR 01JAN2000 $117,600.00
IA00503 RDU JFK 01JAN2000 $9,882.00
IA00602 JFK RDU 01JAN2000 $8,910.00
IA00603 JFK RDU 01JAN2000 $8,856.00
IA00800 SFO RDU 01JAN2000 $53,244.00
IA01003 LAX RDU 01JAN2000 $51,404.00
IA01201 ORD RDU 01JAN2000 $3,567.00
IA01202 ORD RDU 01JAN2000 $4,387.00
IA01404 IAD RDU 01JAN2000 $2,025.00
IA02004 BOS RDU 01JAN2000 $4,641.00
IA02203 DFW RDU 01JAN2000 $9,313.00
IA02603 IND RDU 01JAN2000 $2,208.00
IA02900 SFO HNL 01JAN2000 $73,264.00
IA03300 RDU ANC 01JAN2000 $96,798.00
IA03505 RDU BNA 01JAN2000 $2,697.00
IA03904 RDU MCI 01JAN2000 $4,161.00
IA04503 LHR GLA 01JAN2000 $3,498.00
IA04703 LHR FRA 01JAN2000 $3,225.00
IA05002 BRU LHR 01JAN2000 $1,989.00
IA05003 BRU LHR 01JAN2000 $2,379.00
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month2;
        put text;
datalines4;
IA10200 SYD HKG 01FEB2000 $177,801.00
IA10201 SYD HKG 01FEB2000 $174,891.00
IA10300 SYD CBR 01FEB2000 $1,070.00
IA10301 SYD CBR 01FEB2000 $1,310.00
IA10302 SYD CBR 01FEB2000 $850.00
IA10303 SYD CBR 01FEB2000 $1,030.00
IA10304 SYD CBR 01FEB2000 $910.00
IA10305 SYD CBR 01FEB2000 $1,270.00
IA10400 CBR SYD 01FEB2000 $1,310.00
IA10401 CBR SYD 01FEB2000 $1,110.00
IA10402 CBR SYD 01FEB2000 $1,070.00
IA10403 CBR SYD 01FEB2000 $1,210.00
IA10404 CBR SYD 01FEB2000 $1,130.00
IA10405 CBR SYD 01FEB2000 $710.00
IA10500 CBR WLG 01FEB2000 $41,492.00
IA10501 CBR WLG 01FEB2000 $36,892.00
IA10600 WLG CBR 01FEB2000 $43,332.00
IA10601 WLG CBR 01FEB2000 $42,596.00
IA10700 WLG AKL 01FEB2000 $2,660.00
IA10701 WLG AKL 01FEB2000 $2,340.00
IA10702 WLG AKL 01FEB2000 $2,100.00
IA10703 WLG AKL 01FEB2000 $2,340.00
IA10704 WLG AKL 01FEB2000 $1,820.00
IA10705 WLG AKL 01FEB2000 $2,180.00
IA10800 AKL WLG 01FEB2000 $1,660.00
IA10801 AKL WLG 01FEB2000 $1,900.00
IA10802 AKL WLG 01FEB2000 $2,220.00
IA10803 AKL WLG 01FEB2000 $2,460.00
IA10804 AKL WLG 01FEB2000 $2,220.00
IA10805 AKL WLG 01FEB2000 $1,500.00
IA00101 RDU LHR 01FEB2000 $103,390.00
IA00602 JFK RDU 01FEB2000 $8,100.00
IA00700 RDU SFO 01FEB2000 $48,042.00
IA00901 RDU LAX 01FEB2000 $50,268.00
IA01201 ORD RDU 01FEB2000 $5,535.00
IA01300 RDU IAD 01FEB2000 $1,065.00
IA01502 RDU SEA 01FEB2000 $50,660.00
IA01700 SEA SFO 01FEB2000 $5,891.00
IA01703 SEA SFO 01FEB2000 $5,633.00
IA01900 RDU BOS 01FEB2000 $3,237.00
IA01902 RDU BOS 01FEB2000 $3,315.00
IA02301 RDU BHM 01FEB2000 $4,123.00
IA02400 BHM RDU 01FEB2000 $3,937.00
IA02404 BHM RDU 01FEB2000 $4,123.00
IA02504 RDU IND 01FEB2000 $2,528.00
IA02702 RDU MIA 01FEB2000 $4,092.00
IA02704 RDU MIA 01FEB2000 $3,916.00
IA02801 MIA RDU 01FEB2000 $3,212.00
IA03101 SFO ANC 01FEB2000 $43,942.00
IA03605 BNA RDU 01FEB2000 $2,349.00
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month3;
        put text;
datalines4;
IA10200 SYD HKG 01MAR2000 $181,293.00
IA10201 SYD HKG 01MAR2000 $173,727.00
IA10300 SYD CBR 01MAR2000 $1,150.00
IA10301 SYD CBR 01MAR2000 $910.00
IA10302 SYD CBR 01MAR2000 $1,170.00
IA10303 SYD CBR 01MAR2000 $1,050.00
IA10304 SYD CBR 01MAR2000 $1,330.00
IA10305 SYD CBR 01MAR2000 $1,270.00
IA10400 CBR SYD 01MAR2000 $1,210.00
IA10401 CBR SYD 01MAR2000 $910.00
IA10402 CBR SYD 01MAR2000 $1,370.00
IA10403 CBR SYD 01MAR2000 $990.00
IA10404 CBR SYD 01MAR2000 $1,270.00
IA10405 CBR SYD 01MAR2000 $1,370.00
IA10500 CBR WLG 01MAR2000 $38,916.00
IA10501 CBR WLG 01MAR2000 $36,340.00
IA10600 WLG CBR 01MAR2000 $40,572.00
IA10601 WLG CBR 01MAR2000 $44,436.00
IA10700 WLG AKL 01MAR2000 $1,940.00
IA10701 WLG AKL 01MAR2000 $2,660.00
IA10702 WLG AKL 01MAR2000 $2,180.00
IA10703 WLG AKL 01MAR2000 $2,180.00
IA10704 WLG AKL 01MAR2000 $1,980.00
IA10705 WLG AKL 01MAR2000 $2,620.00
IA10800 AKL WLG 01MAR2000 $2,020.00
IA10801 AKL WLG 01MAR2000 $1,580.00
IA10802 AKL WLG 01MAR2000 $1,660.00
IA10803 AKL WLG 01MAR2000 $2,340.00
IA10804 AKL WLG 01MAR2000 $1,660.00
IA10805 AKL WLG 01MAR2000 $2,340.00
IA00200 LHR RDU 01MAR2000 $119,070.00
IA00300 RDU FRA 01MAR2000 $121,500.00
IA00501 RDU JFK 01MAR2000 $8,694.00
IA00504 RDU JFK 01MAR2000 $7,128.00
IA00600 JFK RDU 01MAR2000 $6,642.00
IA01305 RDU IAD 01MAR2000 $1,995.00
IA01401 IAD RDU 01MAR2000 $2,025.00
IA01603 SEA RDU 01MAR2000 $48,574.00
IA01702 SEA SFO 01MAR2000 $5,461.00
IA01703 SEA SFO 01MAR2000 $5,891.00
IA01804 SFO SEA 01MAR2000 $5,891.00
IA02302 RDU BHM 01MAR2000 $2,325.00
IA02402 BHM RDU 01MAR2000 $3,813.00
IA02505 RDU IND 01MAR2000 $4,448.00
IA02703 RDU MIA 01MAR2000 $5,236.00
IA02704 RDU MIA 01MAR2000 $3,124.00
IA03101 SFO ANC 01MAR2000 $33,528.00
IA03300 RDU ANC 01MAR2000 $98,566.00
IA03500 RDU BNA 01MAR2000 $3,741.00
IA03700 RDU MSY 01MAR2000 $5,439.00
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month4;
        put text;
datalines4;
IA10200 SYD HKG 01APR2000 $176,055.00
IA10201 SYD HKG 01APR2000 $187,113.00
IA10300 SYD CBR 01APR2000 $850.00
IA10301 SYD CBR 01APR2000 $1,370.00
IA10302 SYD CBR 01APR2000 $690.00
IA10303 SYD CBR 01APR2000 $710.00
IA10304 SYD CBR 01APR2000 $770.00
IA10305 SYD CBR 01APR2000 $1,130.00
IA10400 CBR SYD 01APR2000 $1,050.00
IA10401 CBR SYD 01APR2000 $1,030.00
IA10402 CBR SYD 01APR2000 $1,090.00
IA10403 CBR SYD 01APR2000 $810.00
IA10404 CBR SYD 01APR2000 $930.00
IA10405 CBR SYD 01APR2000 $750.00
IA10500 CBR WLG 01APR2000 $42,780.00
IA10501 CBR WLG 01APR2000 $38,180.00
IA10600 WLG CBR 01APR2000 $39,468.00
IA10601 WLG CBR 01APR2000 $38,180.00
IA10700 WLG AKL 01APR2000 $2,740.00
IA10701 WLG AKL 01APR2000 $2,740.00
IA10702 WLG AKL 01APR2000 $2,300.00
IA10703 WLG AKL 01APR2000 $2,620.00
IA10704 WLG AKL 01APR2000 $2,100.00
IA10705 WLG AKL 01APR2000 $1,660.00
IA10800 AKL WLG 01APR2000 $1,860.00
IA10801 AKL WLG 01APR2000 $2,620.00
IA10802 AKL WLG 01APR2000 $1,740.00
IA10803 AKL WLG 01APR2000 $1,740.00
IA10804 AKL WLG 01APR2000 $2,460.00
IA10805 AKL WLG 01APR2000 $2,580.00
IA00201 LHR RDU 01APR2000 $105,840.00
IA00300 RDU FRA 01APR2000 $113,400.00
IA01201 ORD RDU 01APR2000 $4,387.00
IA01303 RDU IAD 01APR2000 $1,755.00
IA01401 IAD RDU 01APR2000 $1,485.00
IA01704 SEA SFO 01APR2000 $3,569.00
IA01803 SFO SEA 01APR2000 $3,397.00
IA01902 RDU BOS 01APR2000 $2,925.00
IA02001 BOS RDU 01APR2000 $4,719.00
IA02002 BOS RDU 01APR2000 $3,471.00
IA02003 BOS RDU 01APR2000 $3,393.00
IA02501 RDU IND 01APR2000 $2,976.00
IA02504 RDU IND 01APR2000 $3,232.00
IA02703 RDU MIA 01APR2000 $3,476.00
IA02705 RDU MIA 01APR2000 $3,828.00
IA02800 MIA RDU 01APR2000 $5,148.00
IA02804 MIA RDU 01APR2000 $5,852.00
IA02805 MIA RDU 01APR2000 $4,180.00
IA03200 ANC SFO 01APR2000 $45,974.00
IA03401 ANC RDU 01APR2000 $95,914.00
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month5;
        put text;
datalines4;
IA10200 SYD HKG 01MAY2000 $179,547.00
IA10201 SYD HKG 01MAY2000 $174,309.00
IA10300 SYD CBR 01MAY2000 $1,270.00
IA10301 SYD CBR 01MAY2000 $1,370.00
IA10302 SYD CBR 01MAY2000 $1,010.00
IA10303 SYD CBR 01MAY2000 $1,130.00
IA10304 SYD CBR 01MAY2000 $1,250.00
IA10305 SYD CBR 01MAY2000 $790.00
IA10400 CBR SYD 01MAY2000 $1,130.00
IA10401 CBR SYD 01MAY2000 $1,210.00
IA10402 CBR SYD 01MAY2000 $890.00
IA10403 CBR SYD 01MAY2000 $1,050.00
IA10404 CBR SYD 01MAY2000 $1,110.00
IA10405 CBR SYD 01MAY2000 $910.00
IA10500 CBR WLG 01MAY2000 $41,308.00
IA10501 CBR WLG 01MAY2000 $38,180.00
IA10600 WLG CBR 01MAY2000 $42,964.00
IA10601 WLG CBR 01MAY2000 $38,180.00
IA10700 WLG AKL 01MAY2000 $1,740.00
IA10701 WLG AKL 01MAY2000 $2,380.00
IA10702 WLG AKL 01MAY2000 $1,940.00
IA10703 WLG AKL 01MAY2000 $1,900.00
IA10704 WLG AKL 01MAY2000 $2,700.00
IA10705 WLG AKL 01MAY2000 $2,700.00
IA10800 AKL WLG 01MAY2000 $1,820.00
IA10801 AKL WLG 01MAY2000 $1,460.00
IA10802 AKL WLG 01MAY2000 $2,220.00
IA10803 AKL WLG 01MAY2000 $1,420.00
IA10804 AKL WLG 01MAY2000 $2,020.00
IA10805 AKL WLG 01MAY2000 $1,980.00
IA00301 RDU FRA 01MAY2000 $132,300.00
IA00400 FRA RDU 01MAY2000 $113,940.00
IA00604 JFK RDU 01MAY2000 $6,804.00
IA01202 ORD RDU 01MAY2000 $5,125.00
IA01401 IAD RDU 01MAY2000 $1,545.00
IA01905 RDU BOS 01MAY2000 $4,641.00
IA02000 BOS RDU 01MAY2000 $4,953.00
IA02502 RDU IND 01MAY2000 $4,192.00
IA02601 IND RDU 01MAY2000 $2,912.00
IA02604 IND RDU 01MAY2000 $4,384.00
IA02605 IND RDU 01MAY2000 $4,256.00
IA02701 RDU MIA 01MAY2000 $5,588.00
IA02800 MIA RDU 01MAY2000 $5,324.00
IA03301 RDU ANC 01MAY2000 $109,616.00
IA03401 ANC RDU 01MAY2000 $98,566.00
IA03504 RDU BNA 01MAY2000 $2,755.00
IA03600 BNA RDU 01MAY2000 $2,929.00
IA03602 BNA RDU 01MAY2000 $3,045.00
IA03704 RDU MSY 01MAY2000 $3,479.00
IA03802 MSY RDU 01MAY2000 $4,949.00
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month6;
        put text;
datalines4;
IA10200 SYD HKG 01JUN2000 $180,129.00
IA10201 SYD HKG 01JUN2000 $163,251.00
IA10300 SYD CBR 01JUN2000 $1,390.00
IA10301 SYD CBR 01JUN2000 $850.00
IA10302 SYD CBR 01JUN2000 $1,330.00
IA10303 SYD CBR 01JUN2000 $750.00
IA10304 SYD CBR 01JUN2000 $1,330.00
IA10305 SYD CBR 01JUN2000 $950.00
IA10400 CBR SYD 01JUN2000 $1,090.00
IA10401 CBR SYD 01JUN2000 $810.00
IA10402 CBR SYD 01JUN2000 $830.00
IA10403 CBR SYD 01JUN2000 $1,010.00
IA10404 CBR SYD 01JUN2000 $1,310.00
IA10405 CBR SYD 01JUN2000 $1,210.00
IA10500 CBR WLG 01JUN2000 $40,020.00
IA10501 CBR WLG 01JUN2000 $41,124.00
IA10600 WLG CBR 01JUN2000 $42,228.00
IA10601 WLG CBR 01JUN2000 $39,652.00
IA10700 WLG AKL 01JUN2000 $1,860.00
IA10701 WLG AKL 01JUN2000 $2,780.00
IA10702 WLG AKL 01JUN2000 $2,620.00
IA10703 WLG AKL 01JUN2000 $2,420.00
IA10704 WLG AKL 01JUN2000 $1,460.00
IA10705 WLG AKL 01JUN2000 $1,820.00
IA10800 AKL WLG 01JUN2000 $2,700.00
IA10801 AKL WLG 01JUN2000 $2,780.00
IA10802 AKL WLG 01JUN2000 $2,740.00
IA10803 AKL WLG 01JUN2000 $2,260.00
IA10804 AKL WLG 01JUN2000 $2,380.00
IA10805 AKL WLG 01JUN2000 $2,100.00
IA00101 RDU LHR 01JUN2000 $113,680.00
IA00500 RDU JFK 01JUN2000 $7,290.00
IA00501 RDU JFK 01JUN2000 $7,182.00
IA00504 RDU JFK 01JUN2000 $6,912.00
IA00800 SFO RDU 01JUN2000 $42,534.00
IA01300 RDU IAD 01JUN2000 $1,575.00
IA01400 IAD RDU 01JUN2000 $1,305.00
IA01500 RDU SEA 01JUN2000 $53,044.00
IA01702 SEA SFO 01JUN2000 $3,569.00
IA01804 SFO SEA 01JUN2000 $4,773.00
IA02001 BOS RDU 01JUN2000 $4,095.00
IA02100 RDU DFW 01JUN2000 $7,839.00
IA02102 RDU DFW 01JUN2000 $7,169.00
IA02400 BHM RDU 01JUN2000 $3,875.00
IA02603 IND RDU 01JUN2000 $2,528.00
IA03504 RDU BNA 01JUN2000 $2,233.00
IA03902 RDU MCI 01JUN2000 $6,213.00
IA04101 RDU PWM 01JUN2000 $5,764.00
IA04105 RDU PWM 01JUN2000 $4,884.00
IA04303 LHR CDG 01JUN2000 $2,170.00
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month7;
        put text;
datalines4;
IA10200 SYD HKG 01JUL2000 $184,785.00
IA10201 SYD HKG 01JUL2000 $163,833.00
IA10300 SYD CBR 01JUL2000 $910.00
IA10301 SYD CBR 01JUL2000 $890.00
IA10302 SYD CBR 01JUL2000 $1,310.00
IA10303 SYD CBR 01JUL2000 $1,370.00
IA10304 SYD CBR 01JUL2000 $1,390.00
IA10305 SYD CBR 01JUL2000 $870.00
IA10400 CBR SYD 01JUL2000 $770.00
IA10401 CBR SYD 01JUL2000 $1,110.00
IA10402 CBR SYD 01JUL2000 $1,150.00
IA10403 CBR SYD 01JUL2000 $830.00
IA10404 CBR SYD 01JUL2000 $770.00
IA10405 CBR SYD 01JUL2000 $1,190.00
IA10500 CBR WLG 01JUL2000 $43,332.00
IA10501 CBR WLG 01JUL2000 $43,148.00
IA10600 WLG CBR 01JUL2000 $39,836.00
IA10601 WLG CBR 01JUL2000 $38,548.00
IA10700 WLG AKL 01JUL2000 $1,460.00
IA10701 WLG AKL 01JUL2000 $2,460.00
IA10702 WLG AKL 01JUL2000 $2,140.00
IA10703 WLG AKL 01JUL2000 $1,500.00
IA10704 WLG AKL 01JUL2000 $1,580.00
IA10705 WLG AKL 01JUL2000 $2,620.00
IA10800 AKL WLG 01JUL2000 $1,940.00
IA10801 AKL WLG 01JUL2000 $2,380.00
IA10802 AKL WLG 01JUL2000 $2,340.00
IA10803 AKL WLG 01JUL2000 $1,620.00
IA10804 AKL WLG 01JUL2000 $2,500.00
IA10805 AKL WLG 01JUL2000 $2,820.00
IA00200 LHR RDU 01JUL2000 $107,310.00
IA00301 RDU FRA 01JUL2000 $113,940.00
IA01503 RDU SEA 01JUL2000 $53,640.00
IA02002 BOS RDU 01JUL2000 $4,563.00
IA02003 BOS RDU 01JUL2000 $3,549.00
IA02005 BOS RDU 01JUL2000 $4,953.00
IA02505 RDU IND 01JUL2000 $3,168.00
IA02601 IND RDU 01JUL2000 $3,232.00
IA02604 IND RDU 01JUL2000 $4,192.00
IA03501 RDU BNA 01JUL2000 $3,335.00
IA03702 RDU MSY 01JUL2000 $4,263.00
IA03705 RDU MSY 01JUL2000 $4,949.00
IA03805 MSY RDU 01JUL2000 $4,557.00
IA03901 RDU MCI 01JUL2000 $8,037.00
IA03905 RDU MCI 01JUL2000 $7,011.00
IA04003 MCI RDU 01JUL2000 $7,467.00
IA04405 CDG LHR 01JUL2000 $2,450.00
IA04700 LHR FRA 01JUL2000 $3,375.00
IA04802 FRA LHR 01JUL2000 $4,375.00
IA05205 GVA LHR 01JUL2000 $5,249.00
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month8;
        put text;
datalines4;
IA10200 SYD HKG 01AUG2000 $190,023.00
IA10201 SYD HKG 01AUG2000 $171,399.00
IA10300 SYD CBR 01AUG2000 $870.00
IA10301 SYD CBR 01AUG2000 $850.00
IA10302 SYD CBR 01AUG2000 $830.00
IA10303 SYD CBR 01AUG2000 $910.00
IA10304 SYD CBR 01AUG2000 $1,250.00
IA10305 SYD CBR 01AUG2000 $1,250.00
IA10400 CBR SYD 01AUG2000 $1,030.00
IA10401 CBR SYD 01AUG2000 $870.00
IA10402 CBR SYD 01AUG2000 $1,310.00
IA10403 CBR SYD 01AUG2000 $770.00
IA10404 CBR SYD 01AUG2000 $1,130.00
IA10405 CBR SYD 01AUG2000 $1,350.00
IA10500 CBR WLG 01AUG2000 $43,700.00
IA10501 CBR WLG 01AUG2000 $38,916.00
IA10600 WLG CBR 01AUG2000 $37,076.00
IA10601 WLG CBR 01AUG2000 $43,700.00
IA10700 WLG AKL 01AUG2000 $2,500.00
IA10701 WLG AKL 01AUG2000 $2,780.00
IA10702 WLG AKL 01AUG2000 $2,180.00
IA10703 WLG AKL 01AUG2000 $2,140.00
IA10704 WLG AKL 01AUG2000 $2,340.00
IA10705 WLG AKL 01AUG2000 $2,380.00
IA10800 AKL WLG 01AUG2000 $1,380.00
IA10801 AKL WLG 01AUG2000 $2,340.00
IA10802 AKL WLG 01AUG2000 $1,740.00
IA10803 AKL WLG 01AUG2000 $1,740.00
IA10804 AKL WLG 01AUG2000 $1,980.00
IA10805 AKL WLG 01AUG2000 $2,660.00
IA00603 JFK RDU 01AUG2000 $7,236.00
IA00801 SFO RDU 01AUG2000 $52,938.00
IA01205 ORD RDU 01AUG2000 $5,699.00
IA01300 RDU IAD 01AUG2000 $1,635.00
IA01401 IAD RDU 01AUG2000 $1,725.00
IA01404 IAD RDU 01AUG2000 $2,055.00
IA01800 SFO SEA 01AUG2000 $2,967.00
IA01904 RDU BOS 01AUG2000 $3,549.00
IA02100 RDU DFW 01AUG2000 $8,375.00
IA02600 IND RDU 01AUG2000 $4,128.00
IA03001 HNL SFO 01AUG2000 $66,880.00
IA03101 SFO ANC 01AUG2000 $33,274.00
IA03200 ANC SFO 01AUG2000 $34,798.00
IA03603 BNA RDU 01AUG2000 $2,349.00
IA03902 RDU MCI 01AUG2000 $7,353.00
IA04001 MCI RDU 01AUG2000 $6,783.00
IA04103 RDU PWM 01AUG2000 $5,060.00
IA04203 PWM RDU 01AUG2000 $5,852.00
IA04205 PWM RDU 01AUG2000 $3,740.00
IA04500 LHR GLA 01AUG2000 $3,586.00
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month9;
        put text;
datalines4;
IA10200 SYD HKG 01SEP2000 $189,441.00
IA10201 SYD HKG 01SEP2000 $175,473.00
IA10300 SYD CBR 01SEP2000 $1,370.00
IA10301 SYD CBR 01SEP2000 $710.00
IA10302 SYD CBR 01SEP2000 $1,210.00
IA10303 SYD CBR 01SEP2000 $970.00
IA10304 SYD CBR 01SEP2000 $1,150.00
IA10305 SYD CBR 01SEP2000 $1,050.00
IA10400 CBR SYD 01SEP2000 $1,170.00
IA10401 CBR SYD 01SEP2000 $1,290.00
IA10402 CBR SYD 01SEP2000 $850.00
IA10403 CBR SYD 01SEP2000 $1,270.00
IA10404 CBR SYD 01SEP2000 $1,250.00
IA10405 CBR SYD 01SEP2000 $810.00
IA10500 CBR WLG 01SEP2000 $41,308.00
IA10501 CBR WLG 01SEP2000 $39,284.00
IA10600 WLG CBR 01SEP2000 $41,492.00
IA10601 WLG CBR 01SEP2000 $40,020.00
IA10700 WLG AKL 01SEP2000 $2,260.00
IA10701 WLG AKL 01SEP2000 $2,340.00
IA10702 WLG AKL 01SEP2000 $2,580.00
IA10703 WLG AKL 01SEP2000 $2,260.00
IA10704 WLG AKL 01SEP2000 $2,500.00
IA10705 WLG AKL 01SEP2000 $2,220.00
IA10800 AKL WLG 01SEP2000 $1,660.00
IA10801 AKL WLG 01SEP2000 $2,420.00
IA10802 AKL WLG 01SEP2000 $1,780.00
IA10803 AKL WLG 01SEP2000 $2,300.00
IA10804 AKL WLG 01SEP2000 $2,380.00
IA10805 AKL WLG 01SEP2000 $2,740.00
IA00501 RDU JFK 01SEP2000 $9,666.00
IA00605 JFK RDU 01SEP2000 $7,830.00
IA01101 RDU ORD 01SEP2000 $4,141.00
IA01102 RDU ORD 01SEP2000 $3,239.00
IA01204 ORD RDU 01SEP2000 $3,157.00
IA01403 IAD RDU 01SEP2000 $1,785.00
IA01800 SFO SEA 01SEP2000 $5,117.00
IA01804 SFO SEA 01SEP2000 $4,687.00
IA02201 DFW RDU 01SEP2000 $6,767.00
IA02504 RDU IND 01SEP2000 $3,744.00
IA02603 IND RDU 01SEP2000 $2,976.00
IA02801 MIA RDU 01SEP2000 $4,004.00
IA03501 RDU BNA 01SEP2000 $2,871.00
IA03703 RDU MSY 01SEP2000 $5,537.00
IA04300 LHR CDG 01SEP2000 $1,750.00
IA05002 BRU LHR 01SEP2000 $1,859.00
IA05005 BRU LHR 01SEP2000 $2,197.00
IA05101 LHR GVA 01SEP2000 $3,741.00
IA05202 GVA LHR 01SEP2000 $4,089.00
IA05204 GVA LHR 01SEP2000 $3,741.00
;;;;
run;
data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month10;
        put text;
datalines4;
IA10200 SYD HKG 01OCT2000 $182,457.00
IA10201 SYD HKG 01OCT2000 $160,923.00
IA10300 SYD CBR 01OCT2000 $1,030.00
IA10301 SYD CBR 01OCT2000 $870.00
IA10302 SYD CBR 01OCT2000 $770.00
IA10303 SYD CBR 01OCT2000 $870.00
IA10304 SYD CBR 01OCT2000 $1,350.00
IA10305 SYD CBR 01OCT2000 $810.00
IA10400 CBR SYD 01OCT2000 $1,310.00
IA10401 CBR SYD 01OCT2000 $1,390.00
IA10402 CBR SYD 01OCT2000 $1,230.00
IA10403 CBR SYD 01OCT2000 $1,110.00
IA10404 CBR SYD 01OCT2000 $930.00
IA10405 CBR SYD 01OCT2000 $1,070.00
IA10500 CBR WLG 01OCT2000 $42,044.00
IA10501 CBR WLG 01OCT2000 $44,068.00
IA10600 WLG CBR 01OCT2000 $43,148.00
IA10601 WLG CBR 01OCT2000 $38,180.00
IA10700 WLG AKL 01OCT2000 $2,460.00
IA10701 WLG AKL 01OCT2000 $1,540.00
IA10702 WLG AKL 01OCT2000 $2,140.00
IA10703 WLG AKL 01OCT2000 $1,460.00
IA10704 WLG AKL 01OCT2000 $1,580.00
IA10705 WLG AKL 01OCT2000 $2,220.00
IA10800 AKL WLG 01OCT2000 $2,420.00
IA10801 AKL WLG 01OCT2000 $2,740.00
IA10802 AKL WLG 01OCT2000 $2,540.00
IA10803 AKL WLG 01OCT2000 $2,780.00
IA10804 AKL WLG 01OCT2000 $2,420.00
IA10805 AKL WLG 01OCT2000 $1,420.00
IA00101 RDU LHR 01OCT2000 $107,800.00
IA00401 FRA RDU 01OCT2000 $115,020.00
IA00504 RDU JFK 01OCT2000 $7,128.00
IA01105 RDU ORD 01OCT2000 $4,059.00
IA01201 ORD RDU 01OCT2000 $3,977.00
IA01300 RDU IAD 01OCT2000 $1,515.00
IA01304 RDU IAD 01OCT2000 $1,815.00
IA01405 IAD RDU 01OCT2000 $1,905.00
IA01501 RDU SEA 01OCT2000 $46,488.00
IA01701 SEA SFO 01OCT2000 $5,891.00
IA02304 RDU BHM 01OCT2000 $2,511.00
IA02305 RDU BHM 01OCT2000 $3,875.00
IA02504 RDU IND 01OCT2000 $4,448.00
IA02601 IND RDU 01OCT2000 $3,168.00
IA02700 RDU MIA 01OCT2000 $6,028.00
IA02703 RDU MIA 01OCT2000 $5,764.00
IA03503 RDU BNA 01OCT2000 $3,625.00
IA03504 RDU BNA 01OCT2000 $2,697.00
IA03804 MSY RDU 01OCT2000 $6,517.00
IA03903 RDU MCI 01OCT2000 $6,213.00
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month11;
        put text;
datalines4;
IA10200 SYD HKG 01NOV2000 $176,637.00
IA10201 SYD HKG 01NOV2000 $164,997.00
IA10300 SYD CBR 01NOV2000 $1,230.00
IA10301 SYD CBR 01NOV2000 $1,230.00
IA10302 SYD CBR 01NOV2000 $790.00
IA10303 SYD CBR 01NOV2000 $690.00
IA10304 SYD CBR 01NOV2000 $1,070.00
IA10305 SYD CBR 01NOV2000 $1,310.00
IA10400 CBR SYD 01NOV2000 $770.00
IA10401 CBR SYD 01NOV2000 $1,230.00
IA10402 CBR SYD 01NOV2000 $1,330.00
IA10403 CBR SYD 01NOV2000 $1,230.00
IA10404 CBR SYD 01NOV2000 $1,230.00
IA10405 CBR SYD 01NOV2000 $1,330.00
IA10500 CBR WLG 01NOV2000 $45,172.00
IA10501 CBR WLG 01NOV2000 $42,780.00
IA10600 WLG CBR 01NOV2000 $37,444.00
IA10601 WLG CBR 01NOV2000 $43,700.00
IA10700 WLG AKL 01NOV2000 $1,700.00
IA10701 WLG AKL 01NOV2000 $2,540.00
IA10702 WLG AKL 01NOV2000 $1,940.00
IA10703 WLG AKL 01NOV2000 $2,020.00
IA10704 WLG AKL 01NOV2000 $1,860.00
IA10705 WLG AKL 01NOV2000 $2,100.00
IA10800 AKL WLG 01NOV2000 $2,020.00
IA10801 AKL WLG 01NOV2000 $1,620.00
IA10802 AKL WLG 01NOV2000 $2,300.00
IA10803 AKL WLG 01NOV2000 $2,380.00
IA10804 AKL WLG 01NOV2000 $1,660.00
IA10805 AKL WLG 01NOV2000 $2,220.00
IA00201 LHR RDU 01NOV2000 $109,270.00
IA00900 RDU LAX 01NOV2000 $50,836.00
IA00902 RDU LAX 01NOV2000 $39,476.00
IA00903 RDU LAX 01NOV2000 $39,476.00
IA01503 RDU SEA 01NOV2000 $38,442.00
IA01701 SEA SFO 01NOV2000 $4,773.00
IA02203 DFW RDU 01NOV2000 $8,107.00
IA02502 RDU IND 01NOV2000 $3,680.00
IA02701 RDU MIA 01NOV2000 $5,500.00
IA02802 MIA RDU 01NOV2000 $3,300.00
IA03200 ANC SFO 01NOV2000 $45,974.00
IA03301 RDU ANC 01NOV2000 $93,704.00
IA03400 ANC RDU 01NOV2000 $105,638.00
IA03500 RDU BNA 01NOV2000 $2,001.00
IA03700 RDU MSY 01NOV2000 $4,361.00
IA03701 RDU MSY 01NOV2000 $6,419.00
IA03705 RDU MSY 01NOV2000 $6,419.00
IA03805 MSY RDU 01NOV2000 $6,223.00
IA03905 RDU MCI 01NOV2000 $4,389.00
IA04502 LHR GLA 01NOV2000 $3,454.00
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file month12;
        put text;
datalines4;
IA10200 SYD HKG 01DEC2000 $188,277.00
IA10201 SYD HKG 01DEC2000 $178,965.00
IA10300 SYD CBR 01DEC2000 $910.00
IA10301 SYD CBR 01DEC2000 $950.00
IA10302 SYD CBR 01DEC2000 $1,310.00
IA10303 SYD CBR 01DEC2000 $710.00
IA10304 SYD CBR 01DEC2000 $1,070.00
IA10305 SYD CBR 01DEC2000 $970.00
IA10400 CBR SYD 01DEC2000 $770.00
IA10401 CBR SYD 01DEC2000 $710.00
IA10402 CBR SYD 01DEC2000 $1,090.00
IA10403 CBR SYD 01DEC2000 $1,070.00
IA10404 CBR SYD 01DEC2000 $1,210.00
IA10405 CBR SYD 01DEC2000 $850.00
IA10500 CBR WLG 01DEC2000 $43,884.00
IA10501 CBR WLG 01DEC2000 $38,732.00
IA10600 WLG CBR 01DEC2000 $37,260.00
IA10601 WLG CBR 01DEC2000 $39,836.00
IA10700 WLG AKL 01DEC2000 $2,380.00
IA10701 WLG AKL 01DEC2000 $1,940.00
IA10702 WLG AKL 01DEC2000 $2,460.00
IA10703 WLG AKL 01DEC2000 $2,020.00
IA10704 WLG AKL 01DEC2000 $2,340.00
IA10705 WLG AKL 01DEC2000 $1,660.00
IA10800 AKL WLG 01DEC2000 $2,020.00
IA10801 AKL WLG 01DEC2000 $1,780.00
IA10802 AKL WLG 01DEC2000 $2,660.00
IA10803 AKL WLG 01DEC2000 $2,340.00
IA10804 AKL WLG 01DEC2000 $2,100.00
IA10805 AKL WLG 01DEC2000 $2,500.00
IA00400 FRA RDU 01DEC2000 $120,420.00
IA00700 RDU SFO 01DEC2000 $39,474.00
IA01103 RDU ORD 01DEC2000 $5,453.00
IA01701 SEA SFO 01DEC2000 $4,601.00
IA02103 RDU DFW 01DEC2000 $8,509.00
IA02402 BHM RDU 01DEC2000 $3,379.00
IA02503 RDU IND 01DEC2000 $3,744.00
IA02800 MIA RDU 01DEC2000 $5,060.00
IA03001 HNL SFO 01DEC2000 $65,664.00
IA03500 RDU BNA 01DEC2000 $3,915.00
IA03502 RDU BNA 01DEC2000 $2,581.00
IA03905 RDU MCI 01DEC2000 $4,731.00
IA04201 PWM RDU 01DEC2000 $5,236.00
IA04403 CDG LHR 01DEC2000 $2,142.00
IA04700 LHR FRA 01DEC2000 $3,775.00
IA04702 LHR FRA 01DEC2000 $3,925.00
IA04705 LHR FRA 01DEC2000 $3,325.00
IA04800 FRA LHR 01DEC2000 $4,575.00
IA04805 FRA LHR 01DEC2000 $3,625.00
IA05001 BRU LHR 01DEC2000 $2,093.00
;;;;
run;
/*removing, adv guide uses rawdata data set, not rawdata text file. Base guide creates a text file called rawdata 
so removing this since one interferes with another.
data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file rawdata;
        put text;
datalines4;
route1.dat
route2.dat
route3.dat
route4.dat
route5.dat
;;;;
run;
*/
data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file route1;
        put text;
datalines4;
0000001RDULHR 389316001090 531    2
0000003RDUFRA 428817611201 585    3
0000005RDUJFK  428 176 120  58    0
0000006JFKRDU  428 176 120  58    0
0000007RDUSFO 2419 993 677 330    2
0000008SFORDU 2419 993 677 330    2
0000009RDULAX 2255 926 631 307    1
0000010LAXRDU 2255 926 631 307    1
0000011RDUORD  645 265 181  88    0
0000012ORDRDU  645 265 181  88    0
0000013RDUIAD  233  95  65  32    0
0000014IADRDU  233  95  65  32    0
0000015RDUSEA 2372 974 664 323    1
0000016SEARDU 2372 974 664 323    1
0000017SEASFO  683 280 191  93    0
0000018SFOSEA  683 280 191  93    0
0000019RDUBOS  615 252 172  83    0
0000020BOSRDU  615 252 172  83    0
0000021RDUDFW 1061 435 297 144    1
0000022DFWRDU 1061 435 297 144    1
0000023RDUBHM  488 200 137  67    0
0000024BHMRDU  488 200 137  67    0
0000025RDUIND  502 206 140  68    0
0000026INDRDU  502 206 140  68    0
0000027RDUMIA  699 287 195  95    0
0000028MIARDU  699 287 195  95    0
0000029SFOHNL 2406 988 673 328    2
0000030HNLSFO 2406 988 673 328    2
0000031SFOANC 2025 832 567 276    1
0000032ANCSFO 2025 832 567 276    1
0000033RDUANC 35021439 980 477    2
0000034ANCRDU 35021439 980 477    2
0000035RDUBNA  453 186 127  62    0
0000036BNARDU  453 186 127  62    0
0000037RDUMSY  779 320 218 106    0
0000038MSYRDU  779 320 218 106    0
0000039RDUMCI  908 372 254 124    1
0000040MCIRDU  908 372 254 124    1
0000041RDUPWM  705 289 197  96    0
0000042PWMRDU  705 289 197  96    0
0000053RDULAX 2255 926 631 307    1
0000054LAXRDU 2255 926 631 307    1
0000112SFOHND 516921231447 705    3
0000001RDULHR 389319421323 645    3
0000003RDUFRA 428821391458 711    3
0000005RDUJFK  428 213 145  71    0
0000006JFKRDU  428 213 145  71    0
0000007RDUSFO 24191206 822 400    2
0000008SFORDU 24191206 822 400    2
0000009RDULAX 22551125 767 373    2
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file route2;
        put text;
datalines4;
0000102SYDHKG 460818931290 629    3
0000103SYDCBR  158  64  44  21    0
0000104CBRSYD  158  64  44  21    0
0000105CBRWLG 1453 596 407 198    1
0000106WLGCBR 1453 596 407 198    1
0000107WLGAKL  310 127  87  42    0
0000108AKLWLG  310 127  87  42    0
0000102SYDHKG 460822981567 763    4
0000103SYDCBR  158  78  54  26    0
0000104CBRSYD  158  78  54  26    0
0000105CBRWLG 1453 724 494 241    1
0000106WLGCBR 1453 724 494 241    1
0000107WLGAKL  310 154 105  51    0
0000108AKLWLG  310 154 105  51    0
0000102SYDHKG 460827041843 898    4
0000103SYDCBR  158  92  63  30    0
0000104CBRSYD  158  92  63  30    0
0000105CBRWLG 1453 852 581 283    1
0000106WLGCBR 1453 852 581 283    1
0000107WLGAKL  310 181 124  60    0
0000108AKLWLG  310 181 124  60    0
0000102SYDHKG 460821391458 711    3
0000103SYDCBR  158  72  50  24    0
0000104CBRSYD  158  72  50  24    0
0000105CBRWLG 1453 673 460 224    1
0000106WLGCBR 1453 673 460 224    1
0000107WLGAKL  310 144  98  47    0
0000108AKLWLG  310 144  98  47    0
0000102SYDHKG 460823661613 786    4
0000103SYDCBR  158  80  55  26    0
0000104CBRSYD  158  80  55  26    0
0000105CBRWLG 1453 745 509 248    1
0000106WLGCBR 1453 745 509 248    1
0000107WLGAKL  310 159 109  53    0
0000108AKLWLG  310 159 109  53    0
0000102SYDHKG 460825561742 849    4
0000103SYDCBR  158  86  59  28    0
0000104CBRSYD  158  86  59  28    0
0000105CBRWLG 1453 805 549 267    1
0000106WLGCBR 1453 805 549 267    1
0000107WLGAKL  310 171 117  57    0
0000108AKLWLG  310 171 117  57    0
0000102SYDHKG 460828401935 944    4
0000103SYDCBR  158  96  66  32    0
0000104CBRSYD  158  96  66  32    0
0000105CBRWLG 1453 894 611 297    1
0000106WLGCBR 1453 894 611 297    1
0000107WLGAKL  310 191 131  63    0
0000108AKLWLG  310 191 131  63    0
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file route3;
        put text;
datalines4;
0000002LHRRDU 389316001090 531    2
0000004FRARDU 428817611201 585    3
0000043LHRCDG  223  91  62  30    0
0000044CDGLHR  223  91  62  30    0
0000045LHRGLA  347 142  97  47    0
0000046GLALHR  347 142  97  47    0
0000047LHRFRA  397 163 111  54    0
0000048FRALHR  397 163 111  54    0
0000049LHRBRU  207  85  57  28    0
0000050BRULHR  207  85  57  28    0
0000051LHRGVA  465 190 130  63    0
0000052GVALHR  465 190 130  63    0
0000055FRAFCO  595 244 167  81    0
0000056FCOFRA  595 244 167  81    0
0000057FRACPH  424 174 118  57    0
0000059CDGMAD  644 265 180  88    0
0000060MADCDG  644 265 180  88    0
0000061CDGLIS  899 369 251 123    1
0000062LISCDG  899 369 251 123    1
0000063FRAFBU  690 284 193  94    0
0000065FRAARN  747 307 209 102    0
0000067LHRPRG  648 266 181  88    0
0000068PRGLHR  648 266 181  88    0
0000069LHRAMS  220  90  62  29    0
0000071FRAVIE  374 153 104  50    0
0000072VIEFRA  374 153 104  50    0
0000073FRAATH 1129 463 316 154    1
0000074ATHFRA 1129 463 316 154    1
0000075FRAJRS 1864 766 522 254    1
0000077FRADXB 30241242 846 412    2
0000079LHRHEL 1140 468 319 155    1
0000081LHRJED 29671219 830 405    2
0000083LHRJNB 567023301588 774    4
0000085FRACPT 586124081641 799    4
0000087FRANBO 394516211105 538    2
0000002LHRRDU 389319421323 645    3
0000004FRARDU 428821391458 711    3
0000043LHRCDG  223 111  76  37    0
0000044CDGLHR  223 111  76  37    0
0000045LHRGLA  347 173 117  57    0
0000046GLALHR  347 173 117  57    0
0000047LHRFRA  397 198 134  65    0
0000048FRALHR  397 198 134  65    0
0000049LHRBRU  207 103  70  34    0
0000050BRULHR  207 103  70  34    0
0000051LHRGVA  465 231 158  77    0
0000052GVALHR  465 231 158  77    0
0000055FRAFCO  595 297 202  99    0
0000056FCOFRA  595 297 202  99    0
0000057FRACPH  424 211 144  70    0
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file route8;
        put text;
datalines4;
0000090DELJRS 25101031 703 342    2
0000091DELCCU  819 336 229 111    1
0000092CCUDEL  819 336 229 111    1
0000093CCUSIN 1811 743 507 247    1
0000094SINCCU 1811 743 507 247    1
0000095SINBKK  895 368 251 122    1
0000096BKKSIN  895 368 251 122    1
0000097CCUPEK 2028 833 568 277    1
0000098PEKCCU 2028 833 568 277    1
0000099CCUHKG 1652 678 462 225    1
0000100HKGCCU 1652 678 462 225    1
0000101HKGSYD 460818931290 629    3
0000109HKGHND 1801 740 504 246    1
0000110HNDHKG 1801 740 504 246    1
0000111HNDSFO 516921231447 705    3
0000090DELJRS 25101252 853 416    2
0000091DELCCU  819 408 278 135    1
0000092CCUDEL  819 408 278 135    1
0000093CCUSIN 1811 903 615 300    1
0000094SINCCU 1811 903 615 300    1
0000095SINBKK  895 446 304 148    1
0000096BKKSIN  895 446 304 148    1
0000097CCUPEK 20281012 689 336    2
0000098PEKCCU 20281012 689 336    2
0000099CCUHKG 1652 824 561 274    1
0000100HKGCCU 1652 824 561 274    1
0000101HKGSYD 460822981567 763    4
0000109HKGHND 1801 898 612 298    1
0000110HNDHKG 1801 898 612 298    1
0000111HNDSFO 516925781757 856    4
0000090DELJRS 251014731004 489    2
0000091DELCCU  819 480 327 159    1
0000092CCUDEL  819 480 327 159    1
0000093CCUSIN 18111062 724 353    2
0000094SINCCU 18111062 724 353    2
0000095SINBKK  895 525 358 174    1
0000096BKKSIN  895 525 358 174    1
0000097CCUPEK 20281190 811 395    2
0000098PEKCCU 20281190 811 395    2
0000099CCUHKG 1652 969 660 322    1
0000100HKGCCU 1652 969 660 322    1
0000101HKGSYD 460827041843 898    4
0000109HKGHND 18011057 720 351    2
0000110HNDHKG 18011057 720 351    2
0000111HNDSFO 5169303320671007    5
0000090DELJRS 25101165 794 386    2
0000091DELCCU  819 380 259 125    1
0000092CCUDEL  819 380 259 125    1
0000093CCUSIN 1811 840 573 279    1
0000094SINCCU 1811 840 573 279    1
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file route9;
        put text;
datalines4;
0000058CPHFRA  424 174 118  57    0
0000064FBUFRA  690 284 193  94    0
0000066ARNFRA  747 307 209 102    0
0000070AMSLHR  220  90  62  29    0
0000080HELLHR 1140 468 319 155    1
0000058CPHFRA  424 211 144  70    0
0000064FBUFRA  690 344 235 114    1
0000066ARNFRA  747 372 253 123    1
0000070AMSLHR  220 110  75  36    0
0000080HELLHR 1140 569 388 189    1
0000058CPHFRA  424 248 169  82    0
0000064FBUFRA  690 405 276 134    1
0000066ARNFRA  747 438 298 145    1
0000070AMSLHR  220 129  88  42    0
0000080HELLHR 1140 669 456 222    1
0000058CPHFRA  424 197 133  64    0
0000064FBUFRA  690 321 218 106    0
0000066ARNFRA  747 347 236 115    1
0000070AMSLHR  220 102  70  33    0
0000080HELLHR 1140 529 360 175    1
0000058CPHFRA  424 218 148  71    0
0000064FBUFRA  690 355 241 118    1
0000066ARNFRA  747 384 261 128    1
0000070AMSLHR  220 113  78  36    0
0000080HELLHR 1140 585 399 194    1
0000058CPHFRA  424 235 159  77    0
0000064FBUFRA  690 383 261 127    1
0000066ARNFRA  747 414 282 138    1
0000070AMSLHR  220 122  84  39    0
0000080HELLHR 1140 632 431 209    1
0000058CPHFRA  424 261 177  86    0
0000064FBUFRA  690 426 290 141    1
0000066ARNFRA  747 461 314 153    1
0000070AMSLHR  220 135  93  44    0
0000080HELLHR 1140 702 479 233    1
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 50;
        input text $varying50. l;
        file route10;
        put text;
datalines4;
0000076JRSFRA  776 319 217 106    0
0000078DXBFRA 30241242 846 412    2
0000082JEDLHR 29671219 830 405    2
0000084JNBLHR 567023301588 774    4
0000086CPTFRA 586124081641 799    4
0000088NBOFRA 394516211105 538    2
0000089JRSDEL 25101031 703 342    2
0000076JRSFRA  776 387 264 128    1
0000078DXBFRA 302415081028 501    2
0000082JEDLHR 296714801008 491    2
0000084JNBLHR 567028291928 939    4
0000086CPTFRA 586129241992 971    4
0000088NBOFRA 394519681341 654    3
0000089JRSDEL 25101252 853 416    2
0000076JRSFRA  776 455 310 151    1
0000078DXBFRA 302417741209 589    3
0000082JEDLHR 296717411186 578    3
0000084JNBLHR 5670332822681105    5
0000086CPTFRA 5861344023441142    5
0000088NBOFRA 394523151578 769    4
0000089JRSDEL 251014731004 489    2
0000076JRSFRA  776 360 245 120    1
0000078DXBFRA 30241403 956 466    2
0000082JEDLHR 29671377 938 458    2
0000084JNBLHR 567026331794 875    4
0000086CPTFRA 586127211854 903    4
0000088NBOFRA 394518321249 608    3
0000089JRSDEL 25101165 794 386    2
0000076JRSFRA  776 399 271 133    1
0000078DXBFRA 302415531058 515    2
0000082JEDLHR 296715241038 506    2
0000084JNBLHR 567029131985 968    4
0000086CPTFRA 586130102051 999    5
0000088NBOFRA 394520261381 673    3
0000089JRSDEL 25101289 879 428    2
0000076JRSFRA  776 431 293 143    1
0000078DXBFRA 302416771142 556    3
0000082JEDLHR 296716461121 547    3
0000084JNBLHR 5670314621441045    5
0000086CPTFRA 5861325122151079    5
0000088NBOFRA 394521881492 726    3
0000089JRSDEL 25101392 949 462    2
0000076JRSFRA  776 479 326 159    1
0000078DXBFRA 302418631269 618    3
0000082JEDLHR 296718291245 608    3
0000084JNBLHR 5670349523821161    5
0000086CPTFRA 5861361224621199    6
0000088NBOFRA 394524321658 807    4
0000089JRSDEL 251015471055 513    2
;;;;
run;

data _null_;
        infile cards4 missover length=l;
        length text $ 100;
        input text $varying100. l;
        file sale2000 lrecl=108 recfm=v;
        put text;
datalines4;
IA10200,0000102,SYD,HKG,19,35,201,255,105500,14610,16,27,156,30288,34830,98124,JAN2000,65700,191187
IA02405,0000024,BHM,RDU,12,,138,150,36900,14613,12,,126,2400,,8442,JAN2000,9300,2883
IA09105,0000091,DEL,CCU,12,,138,150,36900,14616,10,,135,3360,,14985,JAN2000,7900,4108
IA03200,0000032,ANC,SFO,16,,251,267,77400,14620,13,,251,10816,,69276,JAN2000,24600,31242
IA09204,0000092,CCU,DEL,12,,138,150,36900,14623,10,,108,3360,,11988,JAN2000,13300,6916
IA01703,0000017,SEA,SFO,12,,138,150,36900,14627,10,,120,2800,,11160,JAN2000,10900,4687
IA10500,0000105,CBR,WLG,28,52,157,237,85900,14631,24,41,137,14304,16687,27126,JAN2000,45500,41860
IA04505,0000045,LHR,GLA,14,,125,139,39700,14634,11,,94,1562,,4418,JAN2000,18700,4114
IA10305,0000103,SYD,CBR,12,,138,150,36900,14638,10,,115,640,,2415,JAN2000,11900,1190
IA02301,0000023,RDU,BHM,12,,138,150,36900,14641,12,,106,2400,,7102,FEB2000,13300,4123
IA10500,0000105,CBR,WLG,28,52,157,237,85900,14645,23,51,137,13708,20757,27126,FEB2000,43700,40204
IA06202,0000062,LIS,CDG,14,,125,139,39700,14648,13,,98,4797,,12054,FEB2000,17500,9975
IA10400,0000104,CBR,SYD,12,,138,150,36900,14652,11,,111,704,,2331,FEB2000,12500,1250
IA04603,0000046,GLA,LHR,14,,125,139,39700,14655,14,,94,1988,,4418,FEB2000,18100,3982
IA10501,0000105,CBR,WLG,28,52,157,237,85900,14659,28,43,141,16688,17501,27918,FEB2000,43500,40020
IA01805,0000018,SFO,SEA,12,,138,150,36900,14662,12,,104,3360,,9672,FEB2000,13700,5891
IA10303,0000103,SYD,CBR,12,,138,150,36900,14666,11,,131,704,,2751,FEB2000,8500,850
IA00300,0000003,RDU,FRA,14,30,163,207,82400,14670,11,29,147,19371,34829,85995,MAR2000,45000,121500
IA09102,0000091,DEL,CCU,12,,138,150,36900,14673,12,,132,4032,,14652,MAR2000,8100,4212
IA02604,0000026,IND,RDU,12,,138,150,36900,14677,10,,119,2060,,8092,MAR2000,11100,3552
IA10700,0000107,WLG,AKL,12,,138,150,36900,14681,10,,117,1270,,4914,MAR2000,11500,2300
IA05204,0000052,GVA,LHR,14,,125,139,39700,14684,13,,96,2470,,6048,MAR2000,17900,5191
IA10601,0000106,WLG,CBR,28,52,157,237,85900,14688,24,42,140,14304,17094,27720,MAR2000,44700,41124
IA03000,0000030,HNL,SFO,14,30,163,207,82400,14691,11,30,150,10868,20190,49200,MAR2000,44200,67184
IA10303,0000103,SYD,CBR,12,,138,150,36900,14695,12,,137,768,,2877,MAR2000,7100,710
IA02100,0000021,RDU,DFW,12,,138,150,36900,14698,11,,132,4785,,19008,MAR2000,8300,5561
IA10300,0000103,SYD,CBR,12,,138,150,36900,14702,11,,131,704,,2751,APR2000,8500,850
IA02803,0000028,MIA,RDU,12,,138,150,36900,14705,10,,112,2870,,10640,APR2000,12500,5500
IA10601,0000106,WLG,CBR,28,52,157,237,85900,14709,27,48,126,16092,19536,24948,APR2000,45700,42044
IA02603,0000026,IND,RDU,12,,138,150,36900,14712,10,,133,2060,,9044,APR2000,8300,2656
IA07002,0000070,AMS,LHR,14,,125,139,39700,14715,11,,123,990,,3567,APR2000,12900,1806
IA10703,0000107,WLG,AKL,12,,138,150,36900,14719,12,,123,1524,,5166,APR2000,9900,1980
IA09401,0000094,SIN,CCU,28,52,157,237,85900,14722,24,52,126,17832,26364,31122,APR2000,45500,51870
IA03904,0000039,RDU,MCI,12,,138,150,36900,14726,12,,107,4464,,13268,APR2000,13100,7467
IA07101,0000071,FRA,VIE,14,,125,139,39700,14729,12,,99,1836,,4950,APR2000,17500,4200
IA01001,0000010,LAX,RDU,16,,251,267,77400,14733,13,,227,12038,,69689,MAY2000,29400,41748
IA06902,0000069,LHR,AMS,14,,125,139,39700,14736,14,,123,1260,,3567,MAY2000,12300,1722
IA10501,0000105,CBR,WLG,28,52,157,237,85900,14740,25,47,141,14900,19129,27918,MAY2000,43300,39836
IA08900,0000089,JRS,DEL,14,30,163,207,82400,14743,12,29,133,12372,20387,45486,MAY2000,47600,75208
IA10705,0000107,WLG,AKL,12,,138,150,36900,14747,10,,122,1270,,5124,MAY2000,10500,2100
IA06600,0000066,ARN,FRA,14,,125,139,39700,14750,12,,123,3684,,12546,MAY2000,12700,5969
IA10701,0000107,WLG,AKL,12,,138,150,36900,14754,12,,105,1524,,4410,MAY2000,13500,2700
IA05202,0000052,GVA,LHR,14,,125,139,39700,14757,12,,101,2280,,6363,MAY2000,17100,4959
IA10803,0000108,AKL,WLG,12,,138,150,36900,14761,12,,116,1524,,4872,MAY2000,11300,2260
IA08000,0000080,HEL,LHR,34,,256,290,85900,14764,33,,217,15444,,33635,JUN2000,35900,25848
IA10802,0000108,AKL,WLG,12,,138,150,36900,14768,10,,112,1270,,4704,JUN2000,12500,2500
IA06100,0000061,CDG,LIS,14,,125,139,39700,14771,11,,108,4059,,13284,JUN2000,15900,9063
IA04000,0000040,MCI,RDU,12,,138,150,36900,14775,12,,115,4464,,14260,JUN2000,11500,6555
IA10305,0000103,SYD,CBR,12,,138,150,36900,14779,11,,121,704,,2541,JUN2000,10500,1050
IA10501,0000105,CBR,WLG,28,52,157,237,85900,14782,25,40,133,14900,16280,26334,JUN2000,46300,42596
IA05204,0000052,GVA,LHR,14,,125,139,39700,14785,11,,116,2090,,7308,JUN2000,14300,4147
IA10800,0000108,AKL,WLG,12,,138,150,36900,14789,11,,122,1397,,5124,JUN2000,10300,2060
IA05704,0000057,FRA,CPH,14,,125,139,39700,14792,11,,120,1914,,6840,JUL2000,13500,3645
IA10802,0000108,AKL,WLG,12,,138,150,36900,14796,11,,120,1397,,5040,JUL2000,10700,2140
IA05505,0000055,FRA,FCO,14,,125,139,39700,14799,11,,95,2684,,7695,JUL2000,18500,7030
IA10705,0000107,WLG,AKL,12,,138,150,36900,14803,11,,114,1397,,4788,JUL2000,11900,2380
IA05502,0000055,FRA,FCO,14,,125,139,39700,14806,12,,111,2928,,8991,JUL2000,15100,5738
IA10701,0000107,WLG,AKL,12,,138,150,36900,14810,12,,123,1524,,5166,JUL2000,9900,1980
IA10200,0000102,SYD,HKG,19,35,201,255,105500,14814,15,33,185,28395,42570,116365,JUL2000,58900,171399
IA01402,0000014,IAD,RDU,12,,138,150,36900,14817,12,,107,1140,,3424,JUL2000,13100,1965
IA10402,0000104,CBR,SYD,12,,138,150,36900,14821,11,,107,704,,2247,JUL2000,13300,1330
IA00100,0000001,RDU,LHR,14,30,163,207,82400,14824,13,23,124,20800,25070,65844,AUG2000,50400,123480
IA04105,0000041,RDU,PWM,12,,138,150,36900,14827,10,,112,2890,,10752,AUG2000,12500,5500
IA10404,0000104,CBR,SYD,12,,138,150,36900,14831,10,,113,640,,2373,AUG2000,12300,1230
IA06201,0000062,LIS,CDG,14,,125,139,39700,14834,11,,107,4059,,13161,AUG2000,16100,9177
IA01705,0000017,SEA,SFO,12,,138,150,36900,14838,10,,129,2800,,11997,AUG2000,9100,3913
IA10302,0000103,SYD,CBR,12,,138,150,36900,14842,10,,134,640,,2814,AUG2000,8100,810
IA00600,0000006,JFK,RDU,16,,251,267,77400,14845,13,,232,2288,,13456,AUG2000,28400,7668
IA10704,0000107,WLG,AKL,12,,138,150,36900,14849,10,,128,1270,,5376,AUG2000,9300,1860
IA06404,0000064,FBU,FRA,14,,125,139,39700,14852,12,,120,3408,,11280,AUG2000,13300,5719
IA07902,0000079,LHR,HEL,34,,256,290,85900,14856,33,,215,15444,,33325,SEP2000,36300,26136
IA10804,0000108,AKL,WLG,12,,138,150,36900,14860,10,,126,1270,,5292,SEP2000,9700,1940
IA08700,0000087,FRA,NBO,14,30,163,207,82400,14863,11,28,137,17831,30940,73706,SEP2000,47200,117528
IA10805,0000108,AKL,WLG,12,,138,150,36900,14867,12,,106,1524,,4452,SEP2000,13300,2660
IA05702,0000057,FRA,CPH,14,,125,139,39700,14870,14,,119,2436,,6783,SEP2000,13100,3537
IA10404,0000104,CBR,SYD,12,,138,150,36900,14874,11,,134,704,,2814,SEP2000,7900,790
IA04005,0000040,MCI,RDU,12,,138,150,36900,14877,12,,136,4464,,16864,SEP2000,7300,4161
IA10803,0000108,AKL,WLG,12,,138,150,36900,14881,10,,124,1270,,5208,SEP2000,10100,2020
IA04405,0000044,CDG,LHR,14,,125,139,39700,14884,14,,124,1274,,3720,OCT2000,12100,1694
IA10600,0000106,WLG,CBR,28,52,157,237,85900,14888,27,46,141,16092,18722,27918,OCT2000,43100,39652
IA06104,0000061,CDG,LIS,14,,125,139,39700,14891,11,,103,4059,,12669,OCT2000,16900,9633
IA10601,0000106,WLG,CBR,28,52,157,237,85900,14895,23,44,132,13708,17908,26136,OCT2000,46100,42412
IA02100,0000021,RDU,DFW,12,,138,150,36900,14898,11,,129,4785,,18576,OCT2000,8900,5963
IA10201,0000102,SYD,HKG,19,35,201,255,105500,14902,17,33,199,32181,42570,125171,OCT2000,55700,162087
IA02803,0000028,MIA,RDU,12,,138,150,36900,14905,12,,109,3444,,10355,OCT2000,12700,5588
IA10501,0000105,CBR,WLG,28,52,157,237,85900,14909,22,49,153,13112,19943,30294,OCT2000,41100,37812
IA04701,0000047,LHR,FRA,14,,125,139,39700,14912,12,,101,1956,,5454,OCT2000,17100,4275
IA10301,0000103,SYD,CBR,12,,138,150,36900,14916,12,,108,768,,2268,NOV2000,12900,1290
IA05504,0000055,FRA,FCO,14,,125,139,39700,14919,12,,99,2928,,8019,NOV2000,17500,6650
IA10701,0000107,WLG,AKL,12,,138,150,36900,14923,11,,105,1397,,4410,NOV2000,13700,2740
IA10201,0000102,SYD,HKG,19,35,201,255,105500,14927,16,29,154,30288,37410,96866,NOV2000,65700,191187
IA04300,0000043,LHR,CDG,14,,125,139,39700,14930,12,,100,1092,,3000,NOV2000,17300,2422
IA09100,0000091,DEL,CCU,12,,138,150,36900,14933,10,,132,3360,,14652,NOV2000,8500,4420
IA00603,0000006,JFK,RDU,16,,251,267,77400,14937,16,,196,2816,,11368,NOV2000,35000,9450
IA10303,0000103,SYD,CBR,12,,138,150,36900,14941,10,,104,640,,2184,NOV2000,14100,1410
IA02500,0000025,RDU,IND,12,,138,150,36900,14944,12,,109,2472,,7412,NOV2000,12700,4064
IA03603,0000036,BNA,RDU,12,,138,150,36900,14951,10,,115,1860,,7130,DEC2000,11900,3451
IA10401,0000104,CBR,SYD,12,,138,150,36900,14955,11,,113,704,,2373,DEC2000,12100,1210
IA05601,0000056,FCO,FRA,14,,125,139,39700,14958,11,,108,2684,,8748,DEC2000,15900,6042
IA10200,0000102,SYD,HKG,19,35,201,255,105500,14945,19,29,156,35967,37410,98124,DEC2000,64700,188277
IA10200,0000102,SYD,HKG,19,35,201,255,105500,14953,17,30,168,32181,38700,105672,DEC2000,62500,181875
IA10200,0000102,SYD,HKG,19,35,201,255,105500,14961,18,33,198,34074,42570,124542,DEC2000,55700,162087
IA10200,0000102,SYD,HKG,19,35,201,255,105500,14969,17,31,199,32181,39990,125171,DEC2000,56100,163251
IA10304,0000103,SYD,CBR,12,,138,150,36900,14945,12,,119,768,,2499,DEC2000,10700,1070
IA10302,0000103,SYD,CBR,12,,138,150,36900,14948,11,,119,704,,2499,DEC2000,10900,1090
IA10300,0000103,SYD,CBR,12,,138,150,36900,14951,12,,106,768,,2226,DEC2000,13300,1330
IA10304,0000103,SYD,CBR,12,,138,150,36900,14953,10,,115,640,,2415,DEC2000,11900,1190
IA10302,0000103,SYD,CBR,12,,138,150,36900,14956,12,,125,768,,2625,DEC2000,9500,950
IA10300,0000103,SYD,CBR,12,,138,150,36900,14959,11,,108,704,,2268,DEC2000,13100,1310
IA10304,0000103,SYD,CBR,12,,138,150,36900,14961,11,,106,704,,2226,DEC2000,13500,1350
IA10302,0000103,SYD,CBR,12,,138,150,36900,14964,12,,114,768,,2394,DEC2000,11700,1170
IA10300,0000103,SYD,CBR,12,,138,150,36900,14967,12,,126,768,,2646,DEC2000,9300,930
IA10304,0000103,SYD,CBR,12,,138,150,36900,14969,10,,110,640,,2310,DEC2000,12900,1290
IA10302,0000103,SYD,CBR,12,,138,150,36900,14972,10,,113,640,,2373,DEC2000,12300,1230
IA10400,0000104,CBR,SYD,12,,138,150,36900,14945,12,,134,768,,2814,DEC2000,7700,770
IA10404,0000104,CBR,SYD,12,,138,150,36900,14947,12,,115,768,,2415,DEC2000,11500,1150
IA10402,0000104,CBR,SYD,12,,138,150,36900,14950,12,,134,768,,2814,DEC2000,7700,770
IA10400,0000104,CBR,SYD,12,,138,150,36900,14953,12,,135,768,,2835,DEC2000,7500,750
IA10404,0000104,CBR,SYD,12,,138,150,36900,14955,10,,131,640,,2751,DEC2000,8700,870
IA10402,0000104,CBR,SYD,12,,138,150,36900,14958,11,,116,704,,2436,DEC2000,11500,1150
IA10400,0000104,CBR,SYD,12,,138,150,36900,14961,12,,121,768,,2541,DEC2000,10300,1030
IA10404,0000104,CBR,SYD,12,,138,150,36900,14963,11,,118,704,,2478,DEC2000,11100,1110
IA10402,0000104,CBR,SYD,12,,138,150,36900,14966,12,,115,768,,2415,DEC2000,11500,1150
IA10400,0000104,CBR,SYD,12,,138,150,36900,14969,10,,124,640,,2604,DEC2000,10100,1010
IA10404,0000104,CBR,SYD,12,,138,150,36900,14971,11,,136,704,,2856,DEC2000,7500,750
IA10402,0000104,CBR,SYD,12,,138,150,36900,14974,10,,120,640,,2520,DEC2000,10900,1090
IA10500,0000105,CBR,WLG,28,52,157,237,85900,14951,22,43,144,13112,17501,28512,DEC2000,44100,40572
IA10500,0000105,CBR,WLG,28,52,157,237,85900,14959,22,46,139,13112,18722,27522,DEC2000,44500,40940
IA10500,0000105,CBR,WLG,28,52,157,237,85900,14967,28,43,137,16688,17501,27126,DEC2000,44300,40756
IA10600,0000106,WLG,CBR,28,52,157,237,85900,14945,27,47,153,16092,19129,30294,DEC2000,40500,37260
IA10600,0000106,WLG,CBR,28,52,157,237,85900,14953,22,47,129,13112,19129,25542,DEC2000,46300,42596
IA10600,0000106,WLG,CBR,28,52,157,237,85900,14961,26,43,134,15496,17501,26532,DEC2000,45300,41676
IA10600,0000106,WLG,CBR,28,52,157,237,85900,14969,24,52,138,14304,21164,27324,DEC2000,43100,39652
IA10704,0000107,WLG,AKL,12,,138,150,36900,14945,10,,116,1270,,4872,DEC2000,11700,2340
IA10702,0000107,WLG,AKL,12,,138,150,36900,14948,11,,116,1397,,4872,DEC2000,11500,2300
IA10700,0000107,WLG,AKL,12,,138,150,36900,14951,12,,121,1524,,5082,DEC2000,10300,2060
IA10704,0000107,WLG,AKL,12,,138,150,36900,14953,10,,131,1270,,5502,DEC2000,8700,1740
IA10702,0000107,WLG,AKL,12,,138,150,36900,14956,11,,134,1397,,5628,DEC2000,7900,1580
IA10700,0000107,WLG,AKL,12,,138,150,36900,14959,10,,125,1270,,5250,DEC2000,9900,1980
IA10704,0000107,WLG,AKL,12,,138,150,36900,14961,12,,136,1524,,5712,DEC2000,7300,1460
IA10702,0000107,WLG,AKL,12,,138,150,36900,14964,12,,106,1524,,4452,DEC2000,13300,2660
IA10700,0000107,WLG,AKL,12,,138,150,36900,14967,11,,107,1397,,4494,DEC2000,13300,2660
IA10704,0000107,WLG,AKL,12,,138,150,36900,14969,11,,137,1397,,5754,DEC2000,7300,1460
IA10702,0000107,WLG,AKL,12,,138,150,36900,14972,12,,129,1524,,5418,DEC2000,8700,1740
IA10800,0000108,AKL,WLG,12,,138,150,36900,14945,11,,123,1397,,5166,DEC2000,10100,2020
IA10804,0000108,AKL,WLG,12,,138,150,36900,14947,10,,137,1270,,5754,DEC2000,7500,1500
IA10802,0000108,AKL,WLG,12,,138,150,36900,14950,11,,115,1397,,4830,DEC2000,11700,2340
IA10800,0000108,AKL,WLG,12,,138,150,36900,14953,12,,128,1524,,5376,DEC2000,8900,1780
IA10804,0000108,AKL,WLG,12,,138,150,36900,14955,12,,112,1524,,4704,DEC2000,12100,2420
IA10802,0000108,AKL,WLG,12,,138,150,36900,14958,12,,138,1524,,5796,DEC2000,6900,1380
IA10800,0000108,AKL,WLG,12,,138,150,36900,14961,11,,127,1397,,5334,DEC2000,9300,1860
IA10804,0000108,AKL,WLG,12,,138,150,36900,14963,12,,136,1524,,5712,DEC2000,7300,1460
IA10802,0000108,AKL,WLG,12,,138,150,36900,14966,12,,133,1524,,5586,DEC2000,7900,1580
IA10800,0000108,AKL,WLG,12,,138,150,36900,14969,12,,115,1524,,4830,DEC2000,11500,2300
IA10804,0000108,AKL,WLG,12,,138,150,36900,14971,12,,122,1524,,5124,DEC2000,10100,2020
IA10802,0000108,AKL,WLG,12,,138,150,36900,14974,11,,126,1397,,5292,DEC2000,9500,1900
;;;;
run;

data _null_;
   attrib Flight length=$7;
   attrib Date length=8 format=DATE9.;
   attrib Depart length=$5;
   infile datalines dsd;
   input
      Flight
      Date
      Depart
   ;
     date=mdy(month(date), day(date), year(today()));
     file &thisyear dsd;
     put Flight Date Depart;
datalines4;
IA10800,15341,6:35
IA10801,15341,9:35
IA10802,15341,12:35
IA10803,15341,15:35
IA10804,15341,18:35
IA10805,15341,21:35
IA10800,15341,6:35
IA10801,15341,9:35
IA10802,15341,12:35
IA10803,15341,15:35
IA10804,15341,18:35
IA10805,15341,21:35
IA10800,15341,6:35
IA10801,15341,9:35
IA10802,15341,12:35
IA10803,15341,15:35
IA10804,15341,18:35
IA10805,15341,21:35
IA10800,15341,6:35
IA10801,15341,9:35
IA10802,15341,12:35
IA10803,15341,15:35
IA10804,15341,18:35
IA10805,15341,21:35
IA10800,15341,6:35
;;;;
run;

data _null_;
   attrib Flight length=$7;
   attrib Date length=8 format=DATE9.;
   attrib Depart length=$5;
   infile datalines dsd;
   input
      Flight
      Date
      Depart
   ;
     date=mdy(month(date), day(date), (year(today())-1));
     file &lastyear dsd;
     put Flight Date Depart;
datalines4;
IA10800,14976,6:35
IA10801,14976,9:35
IA10802,14976,12:35
IA10803,14976,15:35
IA10804,14976,18:35
IA10805,14976,21:35
IA10800,14976,6:35
IA10801,14976,9:35
IA10802,14976,12:35
IA10803,14976,15:35
IA10804,14976,18:35
IA10805,14976,21:35
IA10800,14976,6:35
IA10801,14976,9:35
IA10802,14976,12:35
IA10803,14976,15:35
IA10804,14976,18:35
IA10805,14976,21:35
IA10800,14976,6:35
IA10801,14976,9:35
IA10802,14976,12:35
IA10803,14976,15:35
IA10804,14976,18:35
IA10805,14976,21:35
IA10800,14976,6:35
;;;;
run;

    /* create SAS data sets */

data sasuser.acities;
   attrib City length=$22 label='City Where Airport is Located';
   attrib Code length=$3 label='Start Point';
   attrib Name length=$50 label='Airport Name';
   attrib Country length=$40 label='Country Where Airport is Located';

   infile datalines dsd;
   input
      City
      Code
      Name
      Country
   ;
datalines4;
Auckland,AKL,International,New Zealand
Amsterdam,AMS,Schiphol,Netherlands
"Anchorage, AK",ANC,Anchorage International Airport,USA
Stockholm,ARN,Arlanda,Sweden
Athens (Athinai),ATH,Hellinikon International Airport,Greece
"Birmingham, AL",BHM,Birmingham International Airport,USA
Bangkok,BKK,Don Muang International Airport,Thailand
"Nashville, TN",BNA,Nashville International Airport,USA
"Boston, MA",BOS,General Edward Lawrence Logan Internatio,USA
Brussels (Bruxelles),BRU,National/Zaventem,Belgium
"Canberra, Australian C",CBR,,Australia
Calcutta,CCU,Dum Dum International Airport,India
Paris,CDG,Charles de Gaulle,France
Kobenhavn (Copenhagen),CPH,Kastrup,Denmark
Cape Town,CPT,D.F. Malan,South Africa
Delhi,DEL,Indira Gandhi International Airport,India
"Dallas/Fort Worth, TX",DFW,Dallas/Fort Worth International Airport,USA
Dubai,DXB,,United Arab Emirates
Oslo,FBU,Fornebu,Norway
Roma (Rome),FCO,Leonardo da Vinci/Fiumicino,Italy
Frankfurt,FRA,Rhein-Main,Germany
"Glasgow, Scotland",GLA,Abbotsichn,United Kingdom
Geneva,GVA,Geneve-Cointrin,Switzerland
Helsinki,HEL,Vantaa,Finland
Hong Kong,HKG,Kai-Tak International Airport,Hong Kong
Tokyo,HND,Haneda,Japan
"Honolulu, HI",HNL,Honolulu International Airport,USA
"Washington, DC",IAD,Washington Dulles International Airport,USA
"Indianapolis, IN",IND,Indianapolis International Airport,USA
Jeddah,JED,King Abdul Aziz Airport,Saudi Arabia
"New York, NY",JFK,John F. Kennedy International Airport,USA
Johannesburg,JNB,Jan Smuts Airport,South Africa
Jerusalem,JRS,Atarot,Israel
"Los Angeles, CA",LAX,Los Angeles International Airport,USA
"London, England",LHR,Heathrow Airport,United Kingdom
Lisboa (Lisbon),LIS,Aeroporto da Portela de Sacavem,Portugal
Madrid,MAD,Barajas,Spain
"Kansas City, MO",MCI,Kansas City International Airport,USA
"Miami, FL",MIA,Miami International Airport,USA
"New Orleans, LA",MSY,New Orleans International Airport,USA
Nairobi,NBO,Jomo Kenyatta,Kenya
"Chicago, IL",ORD,Chicago-O'Hare International Airport,USA
Beijing (Peking),PEK,Capital,China
Praha (Prague),PRG,Ruzyne,Czech Republic
"Portland, ME",PWM,Portland International Jetport,USA
"Raleigh-Durham, NC",RDU,Raleigh-Durham International Airport,USA
"Seattle, WA",SEA,Seattle-Tacoma International Airport,USA
"San Francisco, CA",SFO,San Francisco International Airport,USA
Singapore,SIN,Changi International Airport,Singapore
"Sydney, New South Wale",SYD,Kingsford Smith,Australia
;;;;
run;

data sasuser.airports;
   attrib Code length=$3 label='Airport Code';
   attrib City length=$50 label='City Where Airport is Located';
   attrib Country length=$40 label='Country Where Airport is Located';
   attrib Name length=$50 label='Airport Name';

   infile datalines dsd;
   input
      Code
      City
      Country
      Name
   ;
datalines4;
01R,"Claiborne R, LA",USA,
01T,"High Island, LA",USA,
0E4,"Payson, AZ",USA,
0V1,"Custer, SD",USA,
0Z5,"Kilauea Pt, HI",USA,
18N,"New London, CT",USA,
1G0,"Bowling Green, OH",USA,Wood County Regional Airport
1G7,"Missippi Can, LA",USA,
1K5,"Elkhart, KS",USA,
1O5,"Montague, CA",USA,
1V1,"Rifle, CO",USA,
1Y7,"Yuma Prv Gd, AZ",USA,
1Z2,"Upolo Pt Ln, HI",USA,
1Z6,"Fr Frigate, HI",USA,
27U,"Salmon, ID",USA,
2C2,"White Sands, NM",USA,
2DP,"Dare Co Gr, NC",USA,
2V9,"Gunnison, CO",USA,
30B,"Cape Cod Can, MA",USA,
30N,"New Haven, CT",USA,
3B1,"Greenville, ME",USA,
3DU,"Drummond, MT",USA,
3HT,"Harlowton, MT",USA,
3KM,"Col. J Jabar, KS",USA,
3OI,"Lamoni, IA",USA,
3S2,"Aurora, OR",USA,
3SE,"Spencer, IA",USA,
3TH,"Thompson Fal, MT",USA,
41I,"Eugene Is., LA",USA,
43M,"Site R, PA",USA,
44W,"Diamond Sho, NC",USA,
4BK,"Brookings, OR",USA,
4BL,"Blanding, UT",USA,
4BQ,"Broadus, MT",USA,
4CR,"Corona, NM",USA,
4DG,"Douglas, WY",USA,
4HV,"Hanksville, UT",USA,
4LJ,"Lamar, CO",USA,
4LW,"Lake View, OR",USA,
4MC,"Moorcroft, WY",USA,
4MY,"Moriarity, NM",USA,
4OM,"Omak, WA",USA,
4SL,"Cuba Awrs, NM",USA,
4SU,"Superior Val, CA",USA,
51Q,"San Francisco, CA",USA,
53Q,"Pillaro Pt, CA",USA,
5BI,"Big River Lk, AK",USA,
5CE,"Cape St Eli, AK",USA,
5EA,"Healy River, AK",USA,
5GN,"Tahneta Pass, AK",USA,
;;;;
run;

data sasuser.allemps;
   attrib EmpID length=$6;
   attrib LastName length=$15;
   attrib Phone length=$4;
   attrib Location length=$13;
   attrib Division length=$30;

   infile datalines dsd;
   input
      EmpID
      LastName
      Phone
      Location
      Division
   ;
datalines4;
E00010,FOSKEY,1666,CARY,AIRPORT OPERATIONS
E00015,BROWN,1263,CARY,AIRPORT OPERATIONS
E00025,BROCKLEBANK,1248,CARY,AIRPORT OPERATIONS
E00029,MAROON,1325,CARY,AIRPORT OPERATIONS
E00042,ANDERSON,1045,CARY,AIRPORT OPERATIONS
E00053,CURTIS,1468,CARY,AIRPORT OPERATIONS
E00056,POOLE,1068,TORONTO,AIRPORT OPERATIONS
E00062,JONES,2046,CARY,AIRPORT OPERATIONS
E00064,LOWMAN,2232,CARY,AIRPORT OPERATIONS
E00067,OJEDA,2483,CARY,AIRPORT OPERATIONS
E00069,STEWART JR.,2889,CARY,AIRPORT OPERATIONS
E00077,TRACEY,1520,CARY,AIRPORT OPERATIONS
E00078,STEVENSON,2886,CARY,AIRPORT OPERATIONS
E00079,STONE,1086,TORONTO,AIRPORT OPERATIONS
E00080,BAGGETT,1085,CARY,AIRPORT OPERATIONS
E00086,LYLE,1319,CARY,AIRPORT OPERATIONS
E00097,LUNNEY,2243,CARY,AIRPORT OPERATIONS
E00101,WALSH,3082,CARY,AIRPORT OPERATIONS
E00102,YON,3236,CARY,AIRPORT OPERATIONS
E00108,VAN DUSEN,1065,ROCKVILLE,AIRPORT OPERATIONS
E00111,HOTARD,1236,CARY,AIRPORT OPERATIONS
E00115,BAILEY,1087,CARY,AIRPORT OPERATIONS
E00119,REID,1433,CARY,AIRPORT OPERATIONS
E00121,SWEETLAND,2930,CARY,AIRPORT OPERATIONS
E00123,SCHWAB,1468,CARY,AIRPORT OPERATIONS
E00124,FIALA,1633,CARY,AIRPORT OPERATIONS
E00128,DAURITY,1119,CARY,AIRPORT OPERATIONS
E00138,RAY,2640,CARY,AIRPORT OPERATIONS
E00146,BROWNRIGG,1268,CARY,AIRPORT OPERATIONS
E00153,WALTERS,3084,CARY,AIRPORT OPERATIONS
E00155,BROWNING,1267,CARY,AIRPORT OPERATIONS
E00157,MUSISA,2436,CARY,AIRPORT OPERATIONS
E00158,DANA,1117,CARY,AIRPORT OPERATIONS
E00160,COX,1441,CARY,AIRPORT OPERATIONS
E00162,KEA,1265,CARY,AIRPORT OPERATIONS
E00164,SMITH,1085,TORONTO,AIRPORT OPERATIONS
E00174,BLAHUNKA,1039,CARY,AIRPORT OPERATIONS
E00177,NEWELL,1067,AUSTIN,AIRPORT OPERATIONS
E00185,BASS,1120,CARY,AIRPORT OPERATIONS
E00189,LAIR,1289,CARY,AIRPORT OPERATIONS
E00196,KELLY,1268,CARY,AIRPORT OPERATIONS
E00201,SMITH,2844,CARY,AIRPORT OPERATIONS
E00206,MURDOCK,2432,CARY,AIRPORT OPERATIONS
E00210,MACKENZIE,2249,CARY,AIRPORT OPERATIONS
E00213,DICKEY,1519,CARY,AIRPORT OPERATIONS
E00226,BAUCOM,1124,CARY,AIRPORT OPERATIONS
E00231,SPENCER,2868,CARY,AIRPORT OPERATIONS
E00236,BAILEY,1088,CARY,AIRPORT OPERATIONS
E00243,FILIPOWSKI,1635,CARY,AIRPORT OPERATIONS
E00249,YUAN,3241,CARY,AIRPORT OPERATIONS
;;;;
run;

data sasuser.cap2000;
   attrib FlightID length=$7 label='Flight Number';
   attrib RouteID length=$7 label='Route Number';
   attrib Origin length=$3 label='Start Point';
   attrib Dest length=$3 label='Destination';
   attrib Cap1st length=8 label='Aircraft Capacity - First Class Passengers' format=8. informat=8.;
   attrib CapBusiness length=8 label='Aircraft Capacity - Business Class Passengers' format=8. informat=8.;
   attrib CapEcon length=8 label='Aircraft Capacity - Economy Class Passengers' format=8. informat=8.;
   attrib Date length=8 label='Scheduled Date of Flight' format=DATE9.;

   infile datalines dsd;
   input
      FlightID
      RouteID
      Origin
      Dest
      Cap1st:BEST32.
      CapBusiness:BEST32.
      CapEcon:BEST32.
      Date
   ;
datalines4;
IA00100,0000001,RDU,LHR,14,30,163,14622
IA00101,0000001,RDU,LHR,14,30,163,14625
IA00201,0000002,LHR,RDU,14,30,163,14620
IA00301,0000003,RDU,FRA,14,30,163,14636
IA00603,0000006,JFK,RDU,16,,251,14615
IA00900,0000009,RDU,LAX,16,,251,14619
IA00901,0000009,RDU,LAX,16,,251,14637
IA00903,0000009,RDU,LAX,16,,251,14640
IA01003,0000010,LAX,RDU,16,,251,14621
IA01100,0000011,RDU,ORD,12,,138,14620
IA01101,0000011,RDU,ORD,12,,138,14620
IA01203,0000012,ORD,RDU,12,,138,14613
IA01202,0000012,ORD,RDU,12,,138,14623
IA01202,0000012,ORD,RDU,12,,138,14627
IA01303,0000013,RDU,IAD,12,,138,14610
IA01302,0000013,RDU,IAD,12,,138,14613
IA01401,0000014,IAD,RDU,12,,138,14615
IA01402,0000014,IAD,RDU,12,,138,14624
IA01400,0000014,IAD,RDU,12,,138,14635
IA01401,0000014,IAD,RDU,12,,138,14637
IA01405,0000014,IAD,RDU,12,,138,14637
IA01405,0000014,IAD,RDU,12,,138,14638
IA01502,0000015,RDU,SEA,16,,251,14610
IA01601,0000016,SEA,RDU,16,,251,14635
IA01703,0000017,SEA,SFO,12,,138,14615
IA01703,0000017,SEA,SFO,12,,138,14618
IA01701,0000017,SEA,SFO,12,,138,14634
IA01903,0000019,RDU,BOS,12,,138,14618
IA02000,0000020,BOS,RDU,12,,138,14617
IA02001,0000020,BOS,RDU,12,,138,14637
IA02102,0000021,RDU,DFW,12,,138,14611
IA02201,0000022,DFW,RDU,12,,138,14618
IA02200,0000022,DFW,RDU,12,,138,14631
IA02200,0000022,DFW,RDU,12,,138,14632
IA02305,0000023,RDU,BHM,12,,138,14611
IA02304,0000023,RDU,BHM,12,,138,14615
IA02301,0000023,RDU,BHM,12,,138,14620
IA02301,0000023,RDU,BHM,12,,138,14629
IA02302,0000023,RDU,BHM,12,,138,14637
IA02404,0000024,BHM,RDU,12,,138,14623
IA02400,0000024,BHM,RDU,12,,138,14625
IA02403,0000024,BHM,RDU,12,,138,14625
IA02400,0000024,BHM,RDU,12,,138,14634
IA02405,0000024,BHM,RDU,12,,138,14636
IA02503,0000025,RDU,IND,12,,138,14630
IA02504,0000025,RDU,IND,12,,138,14633
IA02600,0000026,IND,RDU,12,,138,14611
IA02605,0000026,IND,RDU,12,,138,14614
IA02603,0000026,IND,RDU,12,,138,14625
IA02703,0000027,RDU,MIA,12,,138,14626
;;;;
run;

data sasuser.cap2001;
   attrib FlightID length=$7 label='Flight Number';
   attrib RouteID length=$7 label='Route Number';
   attrib Origin length=$3 label='Start Point';
   attrib Dest length=$3 label='Destination';
   attrib Cap1st length=8 label='Aircraft Capacity - First Class Passengers' format=8. informat=8.;
   attrib CapBusiness length=8 label='Aircraft Capacity - Business Class Passengers' format=8. informat=8.;
   attrib CapEcon length=8 label='Aircraft Capacity - Economy Class Passengers' format=8. informat=8.;
   attrib Date length=8 label='Scheduled Date of Flight' format=DATE9. informat=DATE9.;

   infile datalines dsd;
   input
      FlightID
      RouteID
      Origin
      Dest
      Cap1st:BEST32.
      CapBusiness:BEST32.
      CapEcon:BEST32.
      Date
   ;
datalines4;
IA00100,0000001,RDU,LHR,14,30,163,13JAN2001
IA00101,0000001,RDU,LHR,14,30,163,16JAN2001
IA00201,0000002,LHR,RDU,14,30,163,11JAN2001
IA00301,0000003,RDU,FRA,14,30,163,27JAN2001
IA00603,0000006,JFK,RDU,16,34,251,06JAN2001
IA00900,0000009,RDU,LAX,16,34,251,10JAN2001
IA00901,0000009,RDU,LAX,16,34,251,28JAN2001
IA00903,0000009,RDU,LAX,16,34,251,31JAN2001
IA01003,0000010,LAX,RDU,16,34,251,12JAN2001
IA01100,0000011,RDU,ORD,12,0,138,11JAN2001
IA01101,0000011,RDU,ORD,12,0,138,11JAN2001
IA01203,0000012,ORD,RDU,12,0,138,04JAN2001
IA01202,0000012,ORD,RDU,12,0,138,14JAN2001
IA01202,0000012,ORD,RDU,12,0,138,18JAN2001
IA01303,0000013,RDU,IAD,12,0,138,01JAN2001
IA01302,0000013,RDU,IAD,12,0,138,04JAN2001
IA01401,0000014,IAD,RDU,12,0,138,06JAN2001
IA01402,0000014,IAD,RDU,12,0,138,15JAN2001
IA01400,0000014,IAD,RDU,12,0,138,26JAN2001
IA01401,0000014,IAD,RDU,12,0,138,28JAN2001
IA01405,0000014,IAD,RDU,12,0,138,28JAN2001
IA01405,0000014,IAD,RDU,12,0,138,29JAN2001
IA01502,0000015,RDU,SEA,16,34,251,01JAN2001
IA01601,0000016,SEA,RDU,16,34,251,26JAN2001
IA01703,0000017,SEA,SFO,12,0,138,06JAN2001
IA01703,0000017,SEA,SFO,12,0,138,09JAN2001
IA01701,0000017,SEA,SFO,12,0,138,25JAN2001
IA01903,0000019,RDU,BOS,12,0,138,09JAN2001
IA02001,0000020,BOS,RDU,12,0,138,08JAN2001
IA02001,0000020,BOS,RDU,12,0,138,28JAN2001
IA02102,0000021,RDU,DFW,12,0,138,02JAN2001
IA02201,0000022,DFW,RDU,12,0,138,09JAN2001
IA02200,0000022,DFW,RDU,12,0,138,22JAN2001
IA02200,0000022,DFW,RDU,12,0,138,23JAN2001
IA02305,0000023,RDU,BHM,12,0,138,02JAN2001
IA02304,0000023,RDU,BHM,12,0,138,06JAN2001
IA02301,0000023,RDU,BHM,12,0,138,11JAN2001
IA02301,0000023,RDU,BHM,12,0,138,20JAN2001
IA02302,0000023,RDU,BHM,12,0,138,28JAN2001
IA02404,0000024,BHM,RDU,12,0,138,14JAN2001
IA02400,0000024,BHM,RDU,12,0,138,16JAN2001
IA02403,0000024,BHM,RDU,12,0,138,16JAN2001
IA02400,0000024,BHM,RDU,12,0,138,25JAN2001
IA02405,0000024,BHM,RDU,12,0,138,27JAN2001
IA02503,0000025,RDU,IND,12,0,138,21JAN2001
IA02504,0000025,RDU,IND,12,0,138,24JAN2001
IA02600,0000026,IND,RDU,12,0,138,02JAN2001
IA02605,0000026,IND,RDU,12,0,138,05JAN2001
IA02603,0000026,IND,RDU,12,0,138,16JAN2001
IA02703,0000027,RDU,MIA,12,0,138,17JAN2001
;;;;
run;

data sasuser.capacity;
   attrib FlightID length=$7 label='Flight Number';
   attrib RouteID length=$7 label='Route Number';
   attrib Origin length=$3 label='Start Point';
   attrib Dest length=$3 label='Destination';
   attrib Cap1st length=8 label='Aircraft Capacity - First Class Passengers' format=8. informat=8.;
   attrib CapBusiness length=8 label='Aircraft Capacity - Business Class Passengers' format=8. informat=8.;
   attrib CapEcon length=8 label='Aircraft Capacity - Economy Class Passengers' format=8. informat=8.;

   infile datalines dsd;
   input
      FlightID
      RouteID
      Origin
      Dest
      Cap1st:BEST32.
      CapBusiness:BEST32.
      CapEcon:BEST32.
   ;
datalines4;
IA00100,0000001,RDU,LHR,14,30,163
IA00201,0000002,LHR,RDU,14,30,163
IA00300,0000003,RDU,FRA,14,30,163
IA00400,0000004,FRA,RDU,14,30,163
IA00500,0000005,RDU,JFK,16,,251
IA00600,0000006,JFK,RDU,16,,251
IA00700,0000007,RDU,SFO,16,,251
IA00800,0000008,SFO,RDU,16,,251
IA00900,0000009,RDU,LAX,16,,251
IA01000,0000010,LAX,RDU,16,,251
IA01100,0000011,RDU,ORD,12,,138
IA01200,0000012,ORD,RDU,12,,138
IA01300,0000013,RDU,IAD,12,,138
IA01400,0000014,IAD,RDU,12,,138
IA01500,0000015,RDU,SEA,16,,251
IA01600,0000016,SEA,RDU,16,,251
IA01700,0000017,SEA,SFO,12,,138
IA01800,0000018,SFO,SEA,12,,138
IA01900,0000019,RDU,BOS,12,,138
IA02000,0000020,BOS,RDU,12,,138
IA02100,0000021,RDU,DFW,12,,138
IA02200,0000022,DFW,RDU,12,,138
IA02300,0000023,RDU,BHM,12,,138
IA02400,0000024,BHM,RDU,12,,138
IA02500,0000025,RDU,IND,12,,138
IA02600,0000026,IND,RDU,12,,138
IA02700,0000027,RDU,MIA,12,,138
IA02800,0000028,MIA,RDU,12,,138
IA02900,0000029,SFO,HNL,14,30,163
IA03000,0000030,HNL,SFO,14,30,163
IA03100,0000031,SFO,ANC,16,,251
IA03200,0000032,ANC,SFO,16,,251
IA03300,0000033,RDU,ANC,14,30,163
IA03400,0000034,ANC,RDU,14,30,163
IA03500,0000035,RDU,BNA,12,,138
IA03600,0000036,BNA,RDU,12,,138
IA03700,0000037,RDU,MSY,12,,138
IA03800,0000038,MSY,RDU,12,,138
IA03900,0000039,RDU,MCI,12,,138
IA04000,0000040,MCI,RDU,12,,138
IA04100,0000041,RDU,PWM,12,,138
IA04200,0000042,PWM,RDU,12,,138
IA04300,0000043,LHR,CDG,14,,125
IA04400,0000044,CDG,LHR,14,,125
IA04500,0000045,LHR,GLA,14,,125
IA04600,0000046,GLA,LHR,14,,125
IA04700,0000047,LHR,FRA,14,,125
IA04800,0000048,FRA,LHR,14,,125
IA04900,0000049,LHR,BRU,14,,125
IA05000,0000050,BRU,LHR,14,,125
;;;;
run;

data sasuser.capinfo;
   attrib FlightID length=$7 label='Flight Number';
   attrib RouteID length=$7 label='Route Number';
   attrib Origin length=$3 label='Start Point';
   attrib Dest length=$3 label='Dest';
   attrib Cap1st length=8 label='Aircraft Capacity - First Class Passengers' format=8. informat=8.;
   attrib CapBusiness length=8 label='Aircraft Capacity - Business Class Passengers' format=8. informat=8.;
   attrib CapEcon length=8 label='Aircraft Capacity - Economy Class Passengers' format=8. informat=8.;

   infile datalines dsd;
   input
      FlightID
      RouteID
      Origin
      Dest
      Cap1st:BEST32.
      CapBusiness:BEST32.
      CapEcon:BEST32.
   ;
datalines4;
IA00100,0000001,RDU,LHR,14,30,163
IA00201,0000002,LHR,RDU,14,30,163
IA00300,0000003,RDU,FRA,14,30,163
IA00400,0000004,FRA,RDU,14,30,163
IA00500,0000005,RDU,JFK,16,,251
IA00600,0000006,JFK,RDU,16,,251
IA00700,0000007,RDU,SFO,16,,251
IA00800,0000008,SFO,RDU,16,,251
IA00900,0000009,RDU,LAX,16,,251
IA01000,0000010,LAX,RDU,16,,251
IA01100,0000011,RDU,ORD,12,,138
IA01200,0000012,ORD,RDU,12,,138
IA01300,0000013,RDU,IAD,12,,138
IA01400,0000014,IAD,RDU,12,,138
IA01500,0000015,RDU,SEA,16,,251
IA01600,0000016,SEA,RDU,16,,251
IA01700,0000017,SEA,SFO,12,,138
IA01800,0000018,SFO,SEA,12,,138
IA01900,0000019,RDU,BOS,12,,138
IA02000,0000020,BOS,RDU,12,,138
IA02100,0000021,RDU,DFW,12,,138
IA02200,0000022,DFW,RDU,12,,138
IA02300,0000023,RDU,BHM,12,,138
IA02400,0000024,BHM,RDU,12,,138
IA02500,0000025,RDU,IND,12,,138
IA02600,0000026,IND,RDU,12,,138
IA02700,0000027,RDU,MIA,12,,138
IA02800,0000028,MIA,RDU,12,,138
IA02900,0000029,SFO,HNL,14,30,163
IA03000,0000030,HNL,SFO,14,30,163
IA03100,0000031,SFO,ANC,16,,251
IA03200,0000032,ANC,SFO,16,,251
IA03300,0000033,RDU,ANC,14,30,163
IA03400,0000034,ANC,RDU,14,30,163
IA03500,0000035,RDU,BNA,12,,138
IA03600,0000036,BNA,RDU,12,,138
IA03700,0000037,RDU,MSY,12,,138
IA03800,0000038,MSY,RDU,12,,138
IA03900,0000039,RDU,MCI,12,,138
IA04000,0000040,MCI,RDU,12,,138
IA04100,0000041,RDU,PWM,12,,138
IA04200,0000042,PWM,RDU,12,,138
IA04300,0000043,LHR,CDG,14,,125
IA04400,0000044,CDG,LHR,14,,125
IA04500,0000045,LHR,GLA,14,,125
IA04600,0000046,GLA,LHR,14,,125
IA04700,0000047,LHR,FRA,14,,125
IA04800,0000048,FRA,LHR,14,,125
IA04900,0000049,LHR,BRU,14,,125
IA05000,0000050,BRU,LHR,14,,125
;;;;
run;

data sasuser.cargorev;
   attrib Month length=8;
   attrib Date length=8;
   attrib RevCargo length=8;
   attrib Route length=$7;

   infile datalines dsd;
   input
      Month
      Date
      RevCargo
      Route
   ;
datalines4;
1,14610,2260,Route2
1,14610,220293,Route3
1,14610,4655,Route1
1,14610,4004,Route1
1,14611,8911,Route1
1,14611,102900,Route3
1,14612,1963,Route3
1,14612,3321,Route5
1,14612,2562,Route3
1,14612,9447,Route1
1,14612,47082,Route4
1,14613,4089,Route3
1,14613,1605,Route1
1,14614,1911,Route3
1,14614,7020,Route4
1,14614,6665,Route5
1,14614,5461,Route5
1,14614,5060,Route1
1,14614,2407,Route1
1,14614,53694,Route4
1,14615,5643,Route1
1,14616,4000,Route1
1,14616,120989,Route6
1,14617,7661,Route5
1,14617,5282,Route3
1,14617,3864,Route3
1,14617,190605,Route4
1,14617,2821,Route1
1,14617,4515,Route1
1,14618,2198,Route3
1,14618,4455,Route3
1,14618,21672,Route3
1,14618,5031,Route1
1,14619,43576,Route4
1,14619,5699,Route3
1,14619,3731,Route1
1,14620,4725,Route5
1,14620,71440,Route1
1,14620,7667,Route3
1,14620,4879,Route1
1,14620,3485,Route1
1,14620,2740,Route2
1,14620,44804,Route2
1,14621,2422,Route3
1,14621,3375,Route3
1,14621,4104,Route3
1,14622,2740,Route2
1,14622,3807,Route5
1,14622,5814,Route3
1,14622,49416,Route1
;;;;
run;

data sasuser.cargo99;
   attrib FlightID length=$7 label='Flight Number';
   attrib RouteID length=$7 label='Route Number';
   attrib Origin length=$3 label='Start Point';
   attrib Dest length=$3 label='Destination';
   attrib CapCargo length=8 label='Aircraft Capacity - Total Payload in Pounds' format=8. informat=8.;
   attrib Date length=8 label='Scheduled Date of Flight' format=DATE9.;
   attrib CargoWgt length=8 label='Weight of Cargo in Pounds';
   attrib CargoRev length=8 label='Revenue from Cargo' format=DOLLAR15.2;

   infile datalines dsd;
   input
      FlightID
      RouteID
      Origin
      Dest
      CapCargo:BEST32.
      Date
      CargoWgt
      CargoRev
   ;
datalines4;
IA00100,0000001,RDU,LHR,82400,14245,45600,111720
IA00100,0000001,RDU,LHR,82400,14457,44600,109270
IA00100,0000001,RDU,LHR,82400,14476,44600,109270
IA00100,0000001,RDU,LHR,82400,14489,47400,116130
IA00100,0000001,RDU,LHR,82400,14607,44200,108290
IA00101,0000001,RDU,LHR,82400,14245,48000,117600
IA00101,0000001,RDU,LHR,82400,14321,45400,111230
IA00101,0000001,RDU,LHR,82400,14344,49600,121520
IA00101,0000001,RDU,LHR,82400,14365,43000,105350
IA00101,0000001,RDU,LHR,82400,14474,47400,116130
IA00101,0000001,RDU,LHR,82400,14480,48800,119560
IA00200,0000002,LHR,RDU,82400,14292,46600,114170
IA00200,0000002,LHR,RDU,82400,14332,42800,104860
IA00200,0000002,LHR,RDU,82400,14558,44800,109760
IA00201,0000002,LHR,RDU,82400,14273,42200,103390
IA00201,0000002,LHR,RDU,82400,14292,43800,107310
IA00201,0000002,LHR,RDU,82400,14312,43000,105350
IA00201,0000002,LHR,RDU,82400,14371,43200,105840
IA00201,0000002,LHR,RDU,82400,14430,45800,112210
IA00201,0000002,LHR,RDU,82400,14467,44000,107800
IA00201,0000002,LHR,RDU,82400,14474,44400,108780
IA00201,0000002,LHR,RDU,82400,14478,47600,116620
IA00201,0000002,LHR,RDU,82400,14607,49200,120540
IA00300,0000003,RDU,FRA,82400,14270,44400,119880
IA00300,0000003,RDU,FRA,82400,14289,42800,115560
IA00300,0000003,RDU,FRA,82400,14304,45000,121500
IA00300,0000003,RDU,FRA,82400,14521,47200,127440
IA00300,0000003,RDU,FRA,82400,14530,44400,119880
IA00300,0000003,RDU,FRA,82400,14567,43800,118260
IA00301,0000003,RDU,FRA,82400,14313,44800,120960
IA00301,0000003,RDU,FRA,82400,14372,48800,131760
IA00301,0000003,RDU,FRA,82400,14450,45600,123120
IA00301,0000003,RDU,FRA,82400,14451,45400,122580
IA00301,0000003,RDU,FRA,82400,14463,43600,117720
IA00301,0000003,RDU,FRA,82400,14483,44800,120960
IA00301,0000003,RDU,FRA,82400,14558,45400,122580
IA00301,0000003,RDU,FRA,82400,14584,43400,117180
IA00301,0000003,RDU,FRA,82400,14605,48000,129600
IA00400,0000004,FRA,RDU,82400,14332,43600,117720
IA00400,0000004,FRA,RDU,82400,14429,43200,116640
IA00400,0000004,FRA,RDU,82400,14530,44400,119880
IA00400,0000004,FRA,RDU,82400,14575,49200,132840
IA00401,0000004,FRA,RDU,82400,14268,49800,134460
IA00401,0000004,FRA,RDU,82400,14572,45600,123120
IA00500,0000005,RDU,JFK,77400,14330,27000,7290
IA00500,0000005,RDU,JFK,77400,14344,26000,7020
IA00500,0000005,RDU,JFK,77400,14496,31600,8532
IA00500,0000005,RDU,JFK,77400,14539,25000,6750
IA00500,0000005,RDU,JFK,77400,14581,29600,7992
IA00501,0000005,RDU,JFK,77400,14477,33600,9072
;;;;
run;

data sasuser.cargo99(index=(FlghtDte=(flightid date)));
     set sasuser.cargo99;
run;

data sasuser.compete;
   attrib LastName length=$10;
   attrib FrstName length=$8;
   attrib Event length=8;
   attrib Finish length=8;

   infile datalines dsd;
   input
      LastName
      FrstName
      Event
      Finish
   ;
datalines4;
Tuttle,Thomas,1,1
Gomez,Alan,1,2
Chapman,Neil,1,3
Welch,Darius,1,4
Vandeusen,Richard,2,1
Tuttle,Thomas,2,2
Venter,Vince,2,3
Morgan,Mel,2,4
Chapman,Neil,3,1
Gomez,Alan,3,2
Morgan,Mel,3,3
Tuttle,Thomas,3,4
;;;;
run;

data sasuser.contrib;
   attrib EmpID length=$6 label='Employee Identification Number' format=$6. informat=$6.;
   attrib QtrNum length=$8;
   attrib Amount length=8;

   infile datalines dsd;
   input
      EmpID:$6.
      QtrNum
      Amount
   ;
datalines4;
E00224,qtr1,12
E00224,qtr2,33
E00224,qtr3,22
E00224,qtr4,
E00367,qtr1,35
E00367,qtr2,48
E00367,qtr3,40
E00367,qtr4,30
E00441,qtr1,
E00441,qtr2,63
E00441,qtr3,89
E00441,qtr4,90
E00587,qtr1,16
E00587,qtr2,19
E00587,qtr3,30
E00587,qtr4,29
E00598,qtr1,4
E00598,qtr2,8
E00598,qtr3,6
E00598,qtr4,1
E00621,qtr1,10
E00621,qtr2,12
E00621,qtr3,15
E00621,qtr4,25
E00630,qtr1,67
E00630,qtr2,86
E00630,qtr3,52
E00630,qtr4,84
E00705,qtr1,9
E00705,qtr2,7
E00705,qtr3,49
E00705,qtr4,2
E00727,qtr1,8
E00727,qtr2,27
E00727,qtr3,25
E00727,qtr4,14
E00860,qtr1,10
E00860,qtr2,15
E00860,qtr3,6
E00860,qtr4,20
E00901,qtr1,19
E00901,qtr2,21
E00901,qtr3,3
E00901,qtr4,24
E00907,qtr1,18
E00907,qtr2,26
E00907,qtr3,46
E00907,qtr4,65
E00947,qtr1,8
E00947,qtr2,10
;;;;
run;

data sasuser.ctargets;
   attrib Year length=8;
   attrib Jan length=8;
   attrib Feb length=8;
   attrib Mar length=8;
   attrib Apr length=8;
   attrib May length=8;
   attrib Jun length=8;
   attrib Jul length=8;
   attrib Aug length=8;
   attrib Sep length=8;
   attrib Oct length=8;
   attrib Nov length=8;
   attrib Dec length=8;

   infile datalines dsd;
   input
      Year
      Jan
      Feb
      Mar
      Apr
      May
      Jun
      Jul
      Aug
      Sep
      Oct
      Nov
      Dec
   ;
datalines4;
1997,192284420,86376721,28526103,260386468,109975326,102833104,196728648,236996122,112413744,125401565,72551855,136042505
1998,108645734,147656369,202158055,41160707,264294440,267135485,208694865,83456868,286846554,275721406,230488351,24901752
1999,85730444,74168740,39955768,312654811,318149340,187270927,123394421,34273985,151565752,141528519,178043261,181668256
;;;;
run;

data sasuser.dnunder;
   attrib FlightID length=$7 label='Flight Number';
   attrib RouteID length=$7 label='Route Number';
   attrib Date length=8 label='Scheduled Date of Flight' format=DATE9.;
   attrib Expenses length=8;

   infile datalines dsd;
   input
      FlightID
      RouteID
      Date
      Expenses
   ;
datalines4;
IA10200,0000102,14945,154269
IA10200,0000102,14953,175079
IA10200,0000102,14961,20041
IA10200,0000102,14969,124618
IA10304,0000103,14945,1167
IA10302,0000103,14948,836
IA10300,0000103,14951,2900
IA10304,0000103,14953,2259
IA10302,0000103,14956,1596
IA10300,0000103,14959,1831
IA10304,0000103,14961,2865
IA10302,0000103,14964,1259
IA10300,0000103,14967,622
IA10304,0000103,14969,1078
IA10302,0000103,14972,2413
IA10400,0000104,14945,495
IA10404,0000104,14947,1183
IA10402,0000104,14950,557
IA10400,0000104,14953,538
IA10404,0000104,14955,2199
IA10402,0000104,14958,292
IA10400,0000104,14961,1097
IA10404,0000104,14963,675
IA10402,0000104,14966,1533
IA10400,0000104,14969,2375
IA10404,0000104,14971,1870
IA10402,0000104,14974,599
IA10500,0000105,14951,24752
IA10500,0000105,14959,6599
IA10500,0000105,14967,14758
IA10600,0000106,14945,14986
IA10600,0000106,14953,5631
IA10600,0000106,14961,28187
IA10600,0000106,14969,59152
IA10704,0000107,14945,4846
IA10702,0000107,14948,4160
IA10700,0000107,14951,4036
IA10704,0000107,14953,6197
IA10702,0000107,14956,1265
IA10700,0000107,14959,5365
IA10704,0000107,14961,2278
IA10702,0000107,14964,3653
IA10700,0000107,14967,4706
IA10704,0000107,14969,6168
IA10702,0000107,14972,1656
IA10800,0000108,14945,667
IA10804,0000108,14947,5533
IA10802,0000108,14950,2030
IA10800,0000108,14953,451
IA10804,0000108,14955,5221
IA10802,0000108,14958,6019
IA10800,0000108,14961,4675
IA10804,0000108,14963,1190
IA10802,0000108,14966,1501
IA10800,0000108,14969,4869
IA10804,0000108,14971,1315
IA11802,0000108,14974,3720
;;;;
run;

data sasuser.econtrib;
   attrib EmpID length=$6 label='Employee Identification Number' format=$6. informat=$6.;
   attrib Qtr1 length=8 format=DOLLAR8.2;
   attrib Qtr2 length=8 format=DOLLAR8.2;
   attrib Qtr3 length=8 format=DOLLAR8.2;
   attrib Qtr4 length=8 format=DOLLAR8.2;

   infile datalines dsd;
   input
      EmpID:$6.
      Qtr1
      Qtr2
      Qtr3
      Qtr4
   ;
datalines4;
E00224,12,33,22,
E00367,35,48,40,30
E00441,,63,89,90
E00587,16,19,30,29
E00598,4,8,6,1
E00621,10,12,15,25
E00630,67,86,52,84
E00705,9,7,49,2
E00727,8,27,25,14
E00860,10,15,6,20
E00901,19,21,3,24
E00907,18,26,46,65
E00947,8,10,13,16
E00955,55,66,11,14
E00960,13,29,40,20
E00997,6,9,12,18
E01022,15,,20,25
E01442,50,72,54,52
E01486,50,35,26,32
E01577,34,22,37,17
E01684,21,16,8,24
E01717,14,16,18,20
E01732,30,37,42,49
E01860,31,87,29,27
E01917,27,36,29,
E02052,,14,10,10
E02185,39,47,61,60
E02205,32,36,40,44
E02212,5,7,13,23
E02253,28,23,54,22
E02429,2,15,16,17
E02513,,58,53,36
E02523,30,30,90,64
E02551,31,36,18,50
E02772,18,9,0,22
E03191,1,24,38,8
E03247,24,,24,25
E03303,21,21,36,12
E03313,6,36,20,36
E04249,65,11,6,11
E04271,89,2,77,36
E04397,49,58,16,58
E04446,72,58,4,56
E04488,34,26,5,24
E04582,5,28,38,
E04733,18,18,18,18
E04735,13,13,6,5
;;;;
run;

data sasuser.empdata;
   attrib Division length=$30 label='Division' format=$30. informat=$30.;
   attrib HireDate length=8 label='Employee Hire Date' format=DATE9. informat=DATE9.;
   attrib LastName length=$32 label='Employee Last Name' format=$32. informat=$32.;
   attrib FirstName length=$32 label='Employee First Name' format=$32. informat=$32.;
   attrib Country length=$25 label='Employee Country of Residence' format=$25. informat=$25.;
   attrib Location length=$16 label='Employee Office Location' format=$16. informat=$16.;
   attrib Phone length=$8 label='Employee Extension Number' format=$8. informat=$8.;
   attrib EmpID length=$6 label='Employee Identification Number' format=$6. informat=$6.;
   attrib JobCode length=$6 label='Job Code' format=$6. informat=$6.;
   attrib Salary length=8 label='Employee Salary' format=DOLLAR10. informat=DOLLAR10.;

   infile datalines dsd;
   input
      Division:$30.
      HireDate:BEST32.
      LastName:$32.
      FirstName:$32.
      Country:$25.
      Location:$16.
      Phone:$8.
      EmpID:$6.
      JobCode:$6.
      Salary:BEST32.
   ;
datalines4;
FLIGHT OPERATIONS,11758,MILLS,DOROTHY E,USA,CARY,2380,E00001,FLTAT3,25000
FINANCE & IT,8753,BOWER,EILEEN A.,USA,CARY,1214,E00002,FINCLK,27000
HUMAN RESOURCES & FACILITIES,9202,READING,TONY R.,USA,CARY,1428,E00003,VICEPR,120000
HUMAN RESOURCES & FACILITIES,10881,JUDD,CAROL A.,USA,CARY,2061,E00004,FACMNT,42000
AIRPORT OPERATIONS,8023,WONSILD,HANNA,DENMARK,COPENHAGEN,1086,E00005,GRCREW,19000
SALES & MARKETING,11439,ANDERSON,CHRISTOPHER,USA,CARY,1007,E00006,MKTCLK,31000
FLIGHT OPERATIONS,8440,MASSENGILL,ANNETTE M.,USA,CARY,2290,E00007,MECH01,29000
CORPORATE OPERATIONS,11733,BADINE,DAVID,CANADA,TORONTO,1000,E00008,OFFMGR,85000
FINANCE & IT,9887,DEMENT,CHARLES,USA,CARY,1506,E00009,ITPROG,34000
AIRPORT OPERATIONS,11284,FOSKEY,JERE D.,USA,CARY,1666,E00010,GRCREW,29000
FLIGHT OPERATIONS,11270,POOLE,JONI L.,USA,CARY,2594,E00011,FLTAT3,27000
SALES & MARKETING,12612,LEWIS,JOSEPH,USA,CARY,2207,E00012,MKTCLK,33000
HUMAN RESOURCES & FACILITIES,11585,DBAIBO,CATHRYN J.,USA,BOSTON,1002,E00013,RECEPT,22000
FLIGHT OPERATIONS,8852,KEARNEY,ANGELA E.,USA,CARY,2075,E00014,MECH02,19000
AIRPORT OPERATIONS,12484,BROWN,SHANNON T.,USA,CARY,1263,E00015,GRCSUP,41000
HUMAN RESOURCES & FACILITIES,12066,SIMPSON,ARTHUR P.,USA,CARY,2821,E00017,RESCLK,36000
HUMAN RESOURCES & FACILITIES,9447,CROSS,AARI Z.,USA,CARY,1459,E00018,FACMNT,33000
SALES & MARKETING,8107,DANZIN,MATHIAS,BELGIUM,BRUSSELS,1005,E00019,SALCLK,29000
HUMAN RESOURCES & FACILITIES,11710,JOHNSON,RANDALL D.,USA,CARY,1256,E00020,FACCLK,21000
SALES & MARKETING,12152,BAKER JR.,PEDRO,USA,HOUSTON,1001,E00021,SALMGR,43000
HUMAN RESOURCES & FACILITIES,7885,JOHNSON,NANCY C.,USA,CARY,1255,E00022,FACCLK,27000
FLIGHT OPERATIONS,8011,FORT,THERESA L.,USA,CARY,1172,E00023,FLTAT2,31000
FLIGHT OPERATIONS,12602,COCKERHAM,J. KEVIN,USA,CARY,1395,E00024,FLTAT3,21000
AIRPORT OPERATIONS,11339,BROCKLEBANK,ANNE V.,USA,CARY,1248,E00025,BAGCLK,23000
FINANCE & IT,9567,THOMPSON,AMY L.,USA,CARY,1516,E00026,ITSUPT,24000
FINANCE & IT,10998,BOWMAN,LYNNE C.,USA,CARY,1215,E00027,FINACT,31000
FINANCE & IT,8495,LICHTENSTEIN,MEIKE,GERMANY,FRANKFURT,1112,E00028,ITCLK,38000
AIRPORT OPERATIONS,9520,MAROON,SAMUEL PHILLIP,USA,CARY,1325,E00029,FLSCHD,17000
SALES & MARKETING,8922,BREWER,MARK,USA,AUSTIN,1009,E00030,MKTCLK,38000
FLIGHT OPERATIONS,8556,GOLDENBERG,DESIREE,USA,CARY,1741,E00031,PILOT3,28000
FINANCE & IT,11921,COUCH,VICKI A.,USA,CARY,1104,E00032,ITPROG,24000
FLIGHT OPERATIONS,10705,FISHER,ALEC,USA,CARY,1166,E00033,FLTAT2,35000
FLIGHT OPERATIONS,8980,TOMPKINS,JEFFREY J.,USA,CARY,2997,E00034,FLTAT3,28000
FINANCE & IT,9647,WEBB,JONATHAN W,USA,CARY,3115,E00035,ITSUPT,26000
FINANCE & IT,12592,REIBOLD,PETER,EUROPEAN HQ,FRANKFURT,1114,E00036,ITSUPT,20000
FINANCE & IT,11834,PEACE,NIK,UNITED KINGDOM,LONDON,1105,E00037,ITPROG,19000
HUMAN RESOURCES & FACILITIES,7826,SMITH,WILLIAM F.,USA,CARY,2853,E00038,FACCLK,20000
HUMAN RESOURCES & FACILITIES,8244,MCKINNON,VISH W.,CANADA,TORONTO,1053,E00039,FACCLK,38000
FLIGHT OPERATIONS,11730,WILLIAMS,ARLENE M.,USA,CARY,3157,E00040,FLTAT1,32000
SALES & MARKETING,9362,BRUTON,GAIL H.,CANADA,TORONTO,1008,E00041,MKTCLK,45000
AIRPORT OPERATIONS,7724,ANDERSON,GARY M.,USA,CARY,1045,E00042,BAGCLK,32000
FLIGHT OPERATIONS,8138,WIELENGA,NORMA JEAN,USA,CARY,3146,E00043,PILOT3,17000
SALES & MARKETING,12492,HALL,DREMA A.,USA,CARY,1804,E00044,SALCLK,25000
FINANCE & IT,11125,BELL,NIK,UNITED KINGDOM,LONDON,1011,E00045,FINMGR,21000
FLIGHT OPERATIONS,9000,GOODYEAR,GREGORY J.,USA,CARY,1754,E00046,FLTAT1,44000
FLIGHT OPERATIONS,9397,ECKHAUSEN,HANS,USA,CARY,1581,E00047,FLTAT3,40000
FLIGHT OPERATIONS,11724,MOELL,ESTHER,USA,CARY,2392,E00048,FLTAT3,19000
FLIGHT OPERATIONS,7758,CHASE JR.,MARJORIE J.,USA,CARY,1355,E00049,FLTAT1,29000
CORPORATE OPERATIONS,9434,DEXTER,NANCY A.,USA,PHOENIX,1000,E00050,OFFMGR,95000
FINANCE & IT,12435,LIVELY,ROBIN P.,USA,CARY,1307,E00051,ITPROG,19000
;;;;
run;

data sasuser.empdata(index=(EmpID/unique));
     set sasuser.empdata;
run;

data sasuser.empdatu;
   attrib Division length=$30 label='Division' format=$30. informat=$30.;
   attrib hireDate length=8 label='Employee Hire Date' format=DATE9. informat=DATE9.;
   attrib LastName length=$32 label='Employee Last Name' format=$32. informat=$32.;
   attrib FirstName length=$32 label='Employee First Name' format=$32. informat=$32.;
   attrib Country length=$25 label='Employee Country of Residence' format=$25. informat=$25.;
   attrib Location length=$16 label='Employee Office Location' format=$16. informat=$16.;
   attrib Phone length=$8 label='Employee Extension Number' format=$8. informat=$8.;
   attrib EmpID length=$6 label='Employee Identification Number' format=$6. informat=$6.;
   attrib JobCode length=$6 label='Job Code' format=$6. informat=$6.;
   attrib Salary length=8 label='Employee Salary' format=DOLLAR10. informat=DOLLAR10.;

   infile datalines dsd;
   input
      Division:$30.
      hireDate:BEST32.
      LastName:$32.
      FirstName:$32.
      Country:$25.
      Location:$16.
      Phone:$8.
      EmpID:$6.
      JobCode:$6.
      Salary:BEST32.
   ;
datalines4;
FLIGHT OPERATIONS,8852,KEARNEY,ANGELA E.,USA,CARY,2075,E00014,MECH03,19950
FINANCE & IT,12152,BAKER JR.,PEDRO,USA,HOUSTON,1001,E00021,ITMGR,45150
FINANCE & IT,8495,LICHTENSTEIN,MEIKE,GERMANY,FRANKFURT,0001,E00028,ITCLK,39900
;;;;
run;

data sasuser.empdatu2;
   attrib Division length=$30 label='Division' format=$30. informat=$30.;
   attrib HireDate length=8 label='Employee Hire Date' format=DATE9. informat=DATE9.;
   attrib LastName length=$32 label='Employee Last Name' format=$32. informat=$32.;
   attrib FirstName length=$32 label='Employee First Name' format=$32. informat=$32.;
   attrib Country length=$25 label='Employee Country of Residence' format=$25. informat=$25.;
   attrib Location length=$16 label='Employee Office Location' format=$16. informat=$16.;
   attrib Phone length=$8 label='Employee Extension Number' format=$8. informat=$8.;
   attrib EmpID length=$6 label='Employee Identification Number' format=$6. informat=$6.;
   attrib JobCode length=$6 label='Job Code' format=$6. informat=$6.;
   attrib Salary length=8 label='Employee Salary' format=DOLLAR10. informat=DOLLAR10.;

   infile datalines dsd;
   input
      Division:$30.
      HireDate:BEST32.
      LastName:$32.
      FirstName:$32.
      Country:$25.
      Location:$16.
      Phone:$8.
      EmpID:$6.
      JobCode:$6.
      Salary:BEST32.
   ;
datalines4;
FINANCE & IT,8753,SMITH,EILEEN A.,USA,CARY,1214,E00002,FINCLK,28350
AIRPORT OPERATIONS,8023,WONSILD,HANNA,DENMARK,COPENHAGEN,1086,E00005,GRCREW,21950
FINANCE & IT,9887,DEMENT,CHARLES,USA,CHICAGO,1506,E00009,ITPROG,35700
;;;;
run;

data sasuser.expenses;
   attrib FlightID length=$8;
   attrib Date length=8 format=DATE9.;
   attrib Expenses length=8;

   infile datalines dsd;
   input
      FlightID
      Date
      Expenses
   ;
datalines4;
IA03400,14580,89155
IA03400,14592,39599
IA03400,14604,66800
IA03401,14587,33076
IA03401,14599,106032
IA10500,14582,47870
IA10500,14594,16106
IA10500,14606,29206
IA10501,14589,36028
IA10501,14601,23105
IA09900,14584,57302
IA09900,14596,4013
IA09900,14608,45662
IA09901,14591,1261
IA09901,14603,35690
IA09700,14586,73887
IA09700,14598,24281
IA09701,14581,12366
IA09701,14593,58435
IA09701,14605,12876
IA09300,14588,1200
IA09300,14600,38140
IA09301,14583,47081
IA09301,14595,9187
IA09301,14607,7020
IA08601,14591,135330
IA09000,14586,50055
IA09000,14598,10592
IA09001,14581,40542
IA09001,14593,58189
IA09001,14605,65363
IA07800,14588,53526
IA07800,14600,68259
IA07801,14583,59421
IA07801,14595,4758
IA07801,14607,119249
IA08501,14592,220266
IA07700,14587,111046
IA07700,14599,103568
IA07701,14582,22721
IA07701,14594,35768
IA07701,14606,48923
IA08700,14589,118044
IA08700,14601,30288
IA00400,14584,22754
IA00400,14596,47782
IA00400,14608,85973
IA00401,14591,25243
IA00401,14603,111484
IA10000,14586,18928
IA10000,14598,41392
IA10001,14581,34004
IA10001,14593,73228
IA10001,14605,53602
IA10900,14588,59709
IA10900,14600,72139
IA10901,14583,65168
IA10901,14595,1321
IA10901,14607,12752
IA10100,14590,11326
IA10100,14602,82918
IA10101,14585,87730
IA10101,14597,166744
IA11000,14580,76521
IA11000,14592,57428
IA11000,14604,31209
IA11001,14587,7196
IA11001,14599,67623
IA11100,14582,136366
IA11100,14594,111941
IA11100,14606,91650
IA11101,14589,5589
IA11101,14601,109002
IA03000,14584,3070
IA03000,14596,645
IA03000,14608,64552
IA03001,14591,61365
IA03001,14603,32840
IA08200,14586,53436
IA08200,14598,4647
IA08201,14581,38418
IA08201,14593,13157
IA08201,14605,61546
IA08401,14586,200962
IA08900,14585,324
IA08900,14597,55347
IA08901,14580,81810
IA08901,14592,51008
IA08901,14604,37740
IA08100,14587,70755
IA08100,14599,38436
IA08101,14582,28159
IA08101,14594,114963
IA08101,14606,4618
IA08301,14587,228761
IA00200,14585,71756
IA00200,14597,46757
IA00201,14580,21380
IA00201,14592,10399
IA00201,14604,72312
IA08800,14587,65422
IA08800,14599,109003
IA09800,14582,76750
IA09800,14594,11937
IA09800,14606,52557
IA09801,14589,69022
IA09801,14601,17768
IA03300,14584,75484
IA03300,14596,40757
IA03300,14608,27584
IA03301,14591,9143
IA03301,14603,11853
IA00300,14586,111428
IA00300,14598,53959
IA00301,14581,122441
IA00301,14593,9292
IA00301,14605,37431
IA00100,14588,41096
IA00100,14600,58541
IA00101,14583,21473
IA00101,14595,15504
IA00101,14607,42258
IA11200,14590,178573
IA11200,14602,124293
IA11201,14585,196476
IA11201,14597,69644
IA02900,14580,35539
IA02900,14592,73737
IA02900,14604,36738
IA02901,14587,49702
IA02901,14599,6174
IA09400,14582,80058
IA09400,14594,32235
IA09400,14606,25237
IA09401,14589,9714
IA09401,14601,33359
IA10200,14584,176807
IA10200,14596,122033
IA10200,14608,25537
IA10201,14591,97347
IA10201,14603,8864
IA10600,14586,15675
IA10600,14598,27220
IA10601,14581,39364
IA10601,14593,4991
;;;;
run;


data sasuser.flights;
   attrib flight length=$8;
   attrib temp length=8;
   attrib wspeed length=8;

   infile datalines dsd;
   input
      flight
      temp
      wspeed
   ;
datalines4;
IA2736,-8,9
IA6352,-4,16
;;;;
run;

data sasuser.flights2;
   attrib Flight length=$8;
   attrib Temp length=8;
   attrib WSpeed length=8;

   infile datalines dsd;
   input
      Flight
      Temp
      WSpeed
   ;
datalines4;
IA1234,14,29
IA3456,12,27
IA2736,-7,9
IA6352,-4,11
IA1234,32,4
IA3456,22,21
IA2736,15,18
IA6352,0,10
;;;;
run;

data sasuser.flighttimes;
   attrib flight length=$7 label='Flight Number';
   attrib depart length=8 label='Scheduled Departure Time' format=TIME5. informat=TIME5.;
   attrib date length=8 label='Scheduled Date of Flight' format=DATE9.;

   infile flighttm dsd;
   input
      flight
      depart:BEST32.
      date
   ;
run;

data sasuser.jcodedat;
   attrib JobCode length=$6 label='Job Code' format=$6. informat=$6.;
   attrib Descript length=$50 label='Job Description' format=$50. informat=$50.;

   infile datalines dsd;
   input
      JobCode:$6.
      Descript:$50.
   ;
datalines4;
BAGCLK,BAGGAGE CLERK
BAGSUP,BAGGAGE SUPERVISOR
CHKCLK,CHECK IN CLERK
CHKSUP,CHECK IN SUPERVISOR
FACCLK,FACILITIES CLERK
FACMGR,FACILITES MANAGER
FACMNT,FACILITIES MAINTENANCE OPERATIVE
FINACT,FINANCIAL ACCOUNTANT
FINCLK,FINANCE CLERK
FINMGR,FINANCE MANAGER
FLSCHD,FLIGHT SCHEDULER
FLSMGR,FLIGHT SCHEDULING MANAGER
FLTAT1,FLIGHT ATTENDANT GRADE 1
FLTAT2,FLIGHT ATTENDANT GRADE 2
FLTAT3,FLIGHT ATTENDANT GRADE 3
FSVCLK,FLIGHT SERVICES CLERK
FSVMGR,FLIGHT SERVICES MANAGER
GRCREW,GROUND CREW
GRCSUP,GROUND CREW SUPERVISOR
HRCLK,HUMAN RESOURCES CLERK
HRMGR,HUMAN RESOURCES MANAGER
ITCLK,IT CLERK
ITMGR,IT MANAGER
ITPROG,COMPUTER PROGRAMMER
ITSUPT,IT SUPPORT SPECIALIST
MECH01,MECHANIC GRADE 1
MECH02,MECHANIC GRADE 2
MECH03,MECHANIC GRADE 3
MKTCLK,MARKETING CLERK
MKTMGR,MARKETING MANAGER
OFFMGR,OFFICE MANAGER
PILOT1,PILOT GRADE 1
PILOT2,PILOT GRADE 2
PILOT3,PILOT GRADE 3
PRES,COMPANY PRESIDENT
RECEPT,RECEPTIONIST
RESCLK,RESERVATIONS CLERK
RESMGR,RESERVATIONS MANAGER
SALCLK,SALES CLERK
SALMGR,SALES MANAGER
TELOP,TELEPHONE SWITCHBOARD OPERATOR
VICEPR,VICE PRESIDENT
;;;;
run;

data sasuser.jobhstry;
   attrib LastName length=$25;
   attrib Job1 length=$6;
   attrib Job2 length=$6;
   attrib Job3 length=$8;

   infile datalines dsd;
   input
      LastName
      Job1
      Job2
      Job3
   ;
datalines4;
MILLS,FLTAT1,FLTAT2,FLTAT3
BOWER,FINCLK,,
READING,ITPROG,ITMGR,VICEPR
JUDD,FACMNT,,
MASSENGILL,MECH01,,
BADINE,RECEPT,OFFMGR,
DEMENT,ITPROG,,
FOSKEY,GRCREW,,
POOLE,FLTAT2,FLTAT3,
;;;;
run;

data sasuser.mealplan;
   attrib DOW length=8;
   attrib HOUR length=8;
   attrib MEAL length=$10;

   infile datalines dsd;
   input
      DOW
      HOUR
      MEAL
   ;
datalines4;
1,1,None
1,2,None
1,3,None
1,4,None
1,5,None
1,6,Breakfast
1,7,Breakfast
1,8,Breakfast
1,9,Breakfast
1,10,None
1,11,None
1,12,Lunch
1,13,Snack
1,14,None
1,15,None
1,16,None
1,17,Snack
1,18,Dinner
1,19,Dinner
1,20,None
1,21,None
1,22,None
1,23,None
1,24,None
2,1,None
2,2,None
2,3,None
2,4,None
2,5,None
2,6,Breakfast
2,7,Breakfast
2,8,Breakfast
2,9,Breakfast
2,10,None
2,11,None
2,12,Lunch
2,13,Snack
2,14,None
2,15,None
2,16,None
2,17,Snack
2,18,Dinner
2,19,Dinner
2,20,None
2,21,None
2,22,None
2,23,None
2,24,None
3,1,None
3,2,None
;;;;
run;

data sasuser.monthsum;
   attrib SaleMon length=$7 label='Sales Month';
   attrib RevCargo length=8 format=DOLLAR15.2;
   attrib Rev1st length=8 format=DOLLAR15.2;
   attrib RevBusiness length=8 format=DOLLAR15.2;
   attrib RevEcon length=8 format=DOLLAR15.2;
   attrib MonthNo length=8;

   infile datalines dsd;
   input
      SaleMon
      RevCargo
      Rev1st
      RevBusiness
      RevEcon
      MonthNo
   ;
datalines4;
JAN1997,171520869.1,51136353,34897844,169193900,1
JAN1998,238786807.599999,71197270,48749365,235462316,1
JAN1999,280350393,83667651,57385822,278553207,1
FEB1997,177671530.399999,52867177,36397032,175250984,2
FEB1998,215959695.5,64092727,44111168,212667536,2
FEB1999,253999924,75811358,51871453,251355652,2
MAR1997,196591378.2,58562490,40116649,193982585,3
MAR1998,239056025.55,71173645,48767636,235501953,3
MAR1999,281433310,83864006,57546222,278491696,3
APR1997,380804120.200003,113826330,77817068,375598996,4
APR1998,231609633.7,68910955,47381292,227978686,4
APR1999,272049319,81059042,55786262,269547946,4
MAY1997,196261573.199999,58604030,40112475,194336811,5
MAY1998,238245242.85,71099462,48712345,235727428,5
MAY1999,280369422,83864513,57572886,278797273,5
JUN1997,190560828.5,56741721,38819235,187727540,6
JUN1998,230952368.65,68888876,47285354,228396559,6
JUN1999,271894927,81059185,55809052,269688978,6
JUL1997,197163278.199999,58606766,40257451,193861879,7
JUL1998,239396211.7,71265477,48963239,235369298,7
JUL1999,280649618,83816720,57513302,278553244,7
AUG1997,196639501.099999,58583691,40137702,193618096,8
AUG1998,238629758.199999,71069513,48835260,235620482,8
AUG1999,281582229,83786273,57497600,277956633,8
SEP1997,190535012.499999,56702750,38989785,187695144,9
SEP1998,231186018.35,68862789,47306665,228130158,9
SEP1999,272253650,81013380,55709005,269787324,9
OCT1997,196957153.399998,58699076,40198082,194082116,10
OCT1998,238905712.4,71173722,48730203,235350192,10
OCT1999,280100981,83811034,57459052,278739086,10
NOV1997,190228066.7,56626819,38751654,187579685,11
NOV1998,231314162.65,68892713,47407571,227933862,11
NOV1999,272428947,81128123,55698892,269158794,11
DEC1997,196504412.999999,58561897,40418188,194509877,12
DEC1998,238689980.699999,71261837,48955361,236136735,12
DEC1999,272149940,81277002,55898552,269719327,12
;;;;
run;

data sasuser.newcgnum;
   attrib FlightID length=$8;
   attrib RouteID length=$8;
   attrib Origin length=$8;
   attrib Dest length=$8;
   attrib CapCargo length=8;
   attrib Date length=8;
   attrib CargoWgt length=8;
   attrib CargoRev length=8;

   infile datalines dsd;
   input
      FlightID
      RouteID
      Origin
      Dest
      CapCargo
      Date
      CargoWgt
      CargoRev
   ;
datalines4;
IA00100,0000011,RDU,LHR,35055,14245,,121879.9
IA00101,0000011,LHR,RDU,35055,14321,14190,2322
IA00200,0000012,LHR,RDU,35055,14332,10102,9857.6
IA00300,0000013,RDU,FRA,35055,14289,,3973.2
IA00400,0000014,FRA,RDU,35055,14332,11770,5521.2
;;;;
run;

data sasuser.newemps;
   attrib EmpID length=$6;
   attrib LastName length=$15;
   attrib Phone length=8;
   attrib Location length=$13;
   attrib Division length=$30;

   infile datalines dsd;
   input
      EmpID
      LastName
      Phone
      Location
      Division
   ;
datalines4;
E00490,CANCELLO,1015,ROME,FINANCE & IT
E00496,PRESTON,1111,LONDON,FINANCE & IT
E00499,ZILSTORFF,1087,COPENHAGEN,AIRPORT OPERATIONS
E00500,LEY,1110,FRANKFURT,FINANCE & IT
E00503,BRAMMER,1008,COPENHAGEN,SALES & MARKETING
E00514,JENSEN,1032,COPENHAGEN,AIRPORT OPERATIONS
E00515,MAGGS,1082,FRANKFURT,AIRPORT OPERATIONS
E00519,MOHRMANN,1119,FRANKFURT,AIRPORT OPERATIONS
E00530,FROMKORTH,1041,FRANKFURT,AIRPORT OPERATIONS
E00532,KOITZSCH,1095,FRANKFURT,FLIGHT OPERATIONS
E00191,GOH,1001,SINGAPORE,SALES & MARKETING
E00203,ISHII,1016,TOKYO,FINANCE & IT
E00251,TAKENAKA,1062,TOKYO,HUMAN RESOURCES & FACILITIES
E00270,YOSHIKAWA,1079,TOKYO,FLIGHT OPERATIONS
E00349,TIDBALL,1073,TOKYO,FLIGHT OPERATIONS
E00378,HIRATA,1009,TOKYO,SALES & MARKETING
E00399,NOMURA,1042,TOKYO,AIRPORT OPERATIONS
E00401,SATO,1053,TOKYO,HUMAN RESOURCES & FACILITIES
E00464,IMAKI,1012,TOKYO,FINANCE & IT
E00470,BABA,1005,TOKYO,SALES & MARKETING
E00531,LEONG,1002,SINGAPORE,HUMAN RESOURCES & FACILITIES
E00687,TANEBE,1064,TOKYO,AIRPORT OPERATIONS
E00761,WANG,1008,SINGAPORE,SALES & MARKETING
E00777,ARAI,1004,TOKYO,SALES & MARKETING
E00784,ZUSHI,1081,TOKYO,AIRPORT OPERATIONS
E00019,DANZIN,1005,BRUSSELS,SALES & MARKETING
E00059,BAUWENS,1001,BRUSSELS,SALES & MARKETING
E00068,PENDERGRASS,1060,SYDNEY,HUMAN RESOURCES & FACILITIES
E00070,TENGESDAL,1029,OSLO,HUMAN RESOURCES & FACILITIES
E00125,VRANCKX,1035,BRUSSELS,AIRPORT OPERATIONS
E00129,DIERCHX,1012,BRUSSELS,FINANCE & IT
E00131,STEENERSEN,1024,OSLO,HUMAN RESOURCES & FACILITIES
E00159,VANDENBUSSCHE,1034,BRUSSELS,AIRPORT OPERATIONS
E00228,MIDYA,1054,SYDNEY,HUMAN RESOURCES & FACILITIES
E00230,KOEKEMOER,1005,JOHANNESBURG,SALES & MARKETING
E00232,TREVEN,1006,LJUBLJANA,SALES & MARKETING
E00234,LAANTI,1013,HELSINKI,FINANCE & IT
E00253,LAHANE,1043,SYDNEY,AIRPORT OPERATIONS
E00266,TRAN,1075,SYDNEY,FLIGHT OPERATIONS
E00293,GUNDHUS,1007,OSLO,SALES & MARKETING
E00320,COOPMANS,1003,BRUSSELS,SALES & MARKETING
E00326,OSBORNE,1019,WELLINGTON,HUMAN RESOURCES & FACILITIES
E00335,RAICE,1063,SYDNEY,AIRPORT OPERATIONS
E00346,NICHOLSON,1017,WELLINGTON,HUMAN RESOURCES & FACILITIES
E00368,JONES,1040,SYDNEY,AIRPORT OPERATIONS
E00382,FORSTER,1023,SYDNEY,HUMAN RESOURCES & FACILITIES
E00389,LY,1003,HONG KONG,SALES & MARKETING
E00436,TAHTCHIEV,1028,OSLO,HUMAN RESOURCES & FACILITIES
E00449,SIU,1070,SYDNEY,FLIGHT OPERATIONS
E00450,MUSAKKA,1016,HELSINKI,FINANCE & IT
;;;;
run;

data sasuser.newrtnum;
   attrib FlightId length=$7 label='Flight Number';
   attrib RouteId length=$7 label='Route Number';
   attrib Origin length=$3 label='Start Point';
   attrib Dest length=$3 label='Destination';

   infile datalines dsd;
   input
      FlightId
      RouteId
      Origin
      Dest
   ;
datalines4;
IA00100,0000101,RDU,LHR
IA00400,0000400,FRA,RDU
IA00500,0000035,RDU,JFK
IA02000,0000080,BOS,RDU
IA02900,0000777,SFO,HNL
IA03500,0000145,RDU,BNA
IA05000,0000120,BRU,LHR
;;;;
run;

data sasuser.newsals;
   attrib EmpID length=$6 label='Employee Identification Number' format=$6. informat=$6.;
   attrib Salary length=8 label='Employee Salary' format=DOLLAR10. informat=DOLLAR10.;
   attrib NewSalary length=8 format=DOLLAR12.2;

   infile datalines dsd;
   input
      EmpID:$6.
      Salary:BEST32.
      NewSalary
   ;
datalines4;
E00001,25000,27420.0410151016
E00002,27000,31153.9798367554
E00003,120000,143789.802722535
E00004,42000,43695.1374104689
E00005,19000,20757.6761023875
E00006,31000,33753.704908748
E00007,29000,34072.764121123
E00008,85000,93811.783130193
E00009,34000,35501.1223235638
E00010,29000,33191.6531110143
E00011,27000,32141.8592883003
E00012,33000,38481.4395958005
E00013,22000,23243.7926877493
E00014,19000,20434.7787695167
E00015,41000,45394.1965766224
E00017,36000,36241.6429494701
E00018,33000,35947.7980943153
E00019,29000,29245.7566922743
E00020,21000,23002.9286173185
E00021,43000,43386.395015468
E00022,27000,27530.6518091497
E00023,31000,36835.7816173861
E00024,21000,21213.8790901815
E00025,23000,25673.5695526346
E00026,24000,25148.0644052606
E00027,31000,35579.2171682134
E00028,38000,45588.6103922448
E00029,17000,20032.2862008736
E00030,38000,41055.0544006075
E00031,28000,29262.9594235042
E00032,24000,28775.8130796141
E00033,35000,39960.4778531754
E00034,28000,29982.1037178775
E00035,26000,26996.9095651977
E00036,20000,23984.5195468443
E00037,19000,19598.1043910598
E00038,20000,22341.7671221968
E00039,38000,38249.2603668241
E00040,32000,33157.45576674
E00041,45000,53399.5842386035
E00042,32000,38023.9573357738
E00043,17000,19045.684455077
E00044,25000,26748.1620780882
E00045,21000,24501.8760602464
E00046,44000,51730.2554986114
E00047,40000,44104.0854882933
E00048,19000,21886.1529935552
E00049,29000,32892.8710132338
E00050,95000,109644.449530935
E00051,19000,21812.7622021421
;;;;
run;

data sasuser.newtimes;
   attrib flight length=$7 label='Flight Number';
   attrib date length=8 label='Scheduled Date of Flight' format=DATE9.;
   attrib TimeDiff length=8;

   infile datalines dsd;
   input
      flight
      date
      TimeDiff
   ;
datalines4;
IA10800,14787,15
IA10800,14788,15
IA10800,14789,15
IA10800,14790,15
IA10800,14791,15
IA10801,14787,30
IA10801,14788,30
IA10801,14789,30
IA10801,14790,30
IA10801,14791,30
IA10802,14787,45
IA10802,14788,45
IA10802,14789,45
IA10802,14790,45
IA10802,14791,45
IA10803,14787,60
IA10803,14788,60
IA10803,14789,60
IA10803,14790,60
IA10803,14791,60
IA10804,14787,75
IA10804,14788,75
IA10804,14789,75
IA10804,14790,75
IA10804,14791,75
IA10805,14787,90
IA10805,14788,90
IA10805,14789,90
IA10805,14790,90
IA10805,14791,90
IS10800,14787,65
;;;;
run;

data sasuser.pilotemp;
   attrib Division length=$30 label='Division' format=$30. informat=$30.;
   attrib HireDate length=8 label='Employee Hire Date' format=DATE9. informat=DATE9.;
   attrib LastName length=$32 label='Employee Last Name' format=$32. informat=$32.;
   attrib FirstName length=$32 label='Employee First Name' format=$32. informat=$32.;
   attrib Country length=$25 label='Employee Country of Residence' format=$25. informat=$25.;
   attrib Location length=$16 label='Employee Office Location' format=$16. informat=$16.;
   attrib Phone length=$8 label='Employee Extension Number' format=$8. informat=$8.;
   attrib EmpID length=$6 label='Employee Identification Number' format=$6. informat=$6.;
   attrib JobCode length=$6 label='Job Code' format=$6. informat=$6.;
   attrib Salary length=8 label='Employee Salary' format=DOLLAR10. informat=DOLLAR10.;

   infile datalines dsd;
   input
      Division:$30.
      HireDate:BEST32.
      LastName:$32.
      FirstName:$32.
      Country:$25.
      Location:$16.
      Phone:$8.
      EmpID:$6.
      JobCode:$6.
      Salary:BEST32.
   ;
datalines4;
FLIGHT OPERATIONS,8556,GOLDENBERG,DESIREE,USA,CARY,1741,E00031,PILOT3,28000
FLIGHT OPERATIONS,8138,WIELENGA,NORMA JEAN,USA,CARY,3146,E00043,PILOT3,17000
FLIGHT OPERATIONS,11246,WHITE JR.,ANNE,USA,CARY,3140,E00055,PILOT3,25000
FLIGHT OPERATIONS,8593,MCGWIER-WATTS,CHRISTINA,USA,CARY,2332,E00082,PILOT1,61000
FLIGHT OPERATIONS,10051,CAULKINS,LUIS,USA,CARY,1340,E00098,PILOT3,33000
FLIGHT OPERATIONS,8034,PERRY,DEBRA C.,USA,CARY,2546,E00144,PILOT3,44000
FLIGHT OPERATIONS,11972,KRAMER,ALISSA W.,USA,CARY,2131,E00145,PILOT1,61000
FLIGHT OPERATIONS,9617,BENINATE,CARL L.,USA,CARY,1143,E00147,PILOT3,16000
FLIGHT OPERATIONS,10529,KRUEGER,KYOKO U.,USA,CARY,2136,E00205,PILOT2,41000
FLIGHT OPERATIONS,8742,VANCE,MICHAEL,USA,CARY,1532,E00225,PILOT1,64000
FLIGHT OPERATIONS,8371,DODGE,CARRIE D.,USA,CARY,1137,E00247,PILOT2,45000
FLIGHT OPERATIONS,9415,WEISS,MARY E.,USA,CARY,1547,E00262,PILOT3,36000
FLIGHT OPERATIONS,10650,DREWRY,SUSAN,USA,CARY,1143,E00286,PILOT3,28000
FLIGHT OPERATIONS,7762,TAYLOR,CHRISTINA J.,USA,CARY,2945,E00316,PILOT3,45000
FLIGHT OPERATIONS,9265,DOWN,EDWARD,USA,CARY,1542,E00334,PILOT3,45000
FLIGHT OPERATIONS,10187,BELL,THOMAS B.,USA,CARY,1140,E00355,PILOT3,42000
FLIGHT OPERATIONS,8729,DIXON,CAROL H.,USA,CARY,1135,E00361,PILOT2,45000
FLIGHT OPERATIONS,7714,GLENN,MARTHA S.,USA,CARY,1733,E00366,PILOT1,62000
FLIGHT OPERATIONS,9266,SZCZEPANSKI,DONALD T.,USA,CARY,2933,E00377,PILOT1,65000
FLIGHT OPERATIONS,7822,MCKLVEEN,LARNELL,USA,CARY,2339,E00384,PILOT2,41000
FLIGHT OPERATIONS,10063,HOLMAN,GREGORY A.,USA,CARY,1938,E00385,PILOT2,45000
FLIGHT OPERATIONS,12284,GOODLING,DAVID,USA,CARY,1745,E00402,PILOT3,28000
FLIGHT OPERATIONS,8917,WEATHERSPOON,FIORE A.,USA,CARY,1544,E00480,PILOT3,41000
FLIGHT OPERATIONS,9081,HOLMES,LORETTA L.,USA,CARY,1939,E00485,PILOT2,41000
FLIGHT OPERATIONS,8931,KUNKEL,LARRY,USA,CARY,2146,E00486,PILOT3,44000
FLIGHT OPERATIONS,8147,SNELLING,CHRIS,UNITED KINGDOM,LONDON,1138,E00221,PILOT2,42000
FLIGHT OPERATIONS,12333,SHINYA,CHRIS,UNITED KINGDOM,LONDON,1133,E00235,PILOT1,65000
FLIGHT OPERATIONS,10058,TORRES,JAN,EUROPEAN HQ,FRANKFURT,1144,E00294,PILOT3,20000
FLIGHT OPERATIONS,7939,SHEPHARD,CAROLYN,UNITED KINGDOM,LONDON,1132,E00407,PILOT1,61000
FLIGHT OPERATIONS,7934,SMITH,KATE,UNITED KINGDOM,LONDON,1137,E00434,PILOT2,45000
FLIGHT OPERATIONS,10697,TIERIE,ALI IMRAN,EUROPEAN HQ,FRANKFURT,1139,E00446,PILOT2,41000
;;;;
run;

data sasuser.quarter2;
   attrib Date length=8 format=DATE9.;
   attrib CrgoRev1 length=8 format=DOLLAR12.;
   attrib CrgoRev2 length=8 format=DOLLAR12.;
   attrib CrgoRev3 length=8 format=DOLLAR12.;
   attrib CrgoRev4 length=8 format=DOLLAR12.;
   attrib CrgoRev5 length=8 format=DOLLAR12.;
   attrib CrgoRev6 length=8 format=DOLLAR12.;
   attrib comment length=$25;

   infile datalines dsd;
   input
      Date
      CrgoRev1
      CrgoRev2
      CrgoRev3
      CrgoRev4
      CrgoRev5
      CrgoRev6
      comment
   ;
datalines4;
14701,3360224,560116,2361846,1845832,222980,950321,Lots of Cargo/Heavy Load
14702,3222492,571166,2140953,1801966,225088,980593,Medium Filled
14703,3290158,562068,1893226,1828742,219478,961781,Light Load
14704,3329256,550838,2156947,1818490,231204,990915,Lots of Cargo/Heavy Load
14705,3303818,535984,2364056,1849634,228828,987061,Lots of Cargo/Heavy Load
14706,3343278,578444,2113087,1851190,216468,962811,Lots of Cargo/Heavy Load
14707,3307558,530094,2130893,1799830,218580,1190912,Lots of Cargo/Heavy Load
14708,3294386,546394,2324474,1794090,215946,983759,Lots of Cargo/Heavy Load
14709,3312514,566612,2124797,1786608,224168,983065,Medium Filled
14710,3334438,558276,1916504,1740686,220564,980903,Light Load
14711,3246212,554160,2115663,1835040,220414,942427,Medium Filled
14712,3299584,559020,2324546,1826890,218514,990955,Lots of Cargo/Heavy Load
14713,3233178,568428,2145419,1819352,229708,973789,Medium Filled
14714,3339964,546348,2133755,1816434,235424,1241964,Lots of Cargo/Heavy Load
14715,3275138,578946,2358002,1842628,226276,981989,Lots of Cargo/Heavy Load
14716,3341368,536186,2140997,1852846,220084,959279,Lots of Cargo/Heavy Load
14717,3324722,551820,1908640,1825610,223868,1012759,Medium Filled
14718,3275894,544790,2135871,1802274,221208,949587,Medium Filled
14719,3264274,558732,2387136,1824802,212922,980465,Lots of Cargo/Heavy Load
14720,3295010,556194,2136315,1813862,223224,972671,Medium Filled
14721,3308552,540152,2121337,1825912,219946,1217640,Lots of Cargo/Heavy Load
14722,3388212,563512,2392312,1782792,224578,980029,Lots of Cargo/Heavy Load
14723,3330304,546190,2112063,1791574,226744,984121,Medium Filled
14724,3329632,537120,1921726,1815108,212316,956381,Light Load
14725,3237914,528594,2117147,1847620,223260,983225,Medium Filled
14726,3284756,532430,2417392,1844152,222764,954931,Lots of Cargo/Heavy Load
14727,3271062,558044,2157237,1826116,226104,964701,Lots of Cargo/Heavy Load
14728,3238500,553750,2170311,1759838,224720,1205986,Lots of Cargo/Heavy Load
14729,3235346,578112,2365258,1803372,218506,984571,Lots of Cargo/Heavy Load
14730,3311064,534444,2122037,1809606,222718,954511,Medium Filled
14731,3229514,551888,1904656,1849978,227454,972647,Light Load
14732,3272850,544808,2107035,1838976,223212,976429,Medium Filled
14733,3269774,561480,2374542,1831298,209868,983447,Lots of Cargo/Heavy Load
14734,3292314,555378,2158739,1814864,223660,961875,Lots of Cargo/Heavy Load
14735,3326730,574512,2148089,1793260,227066,1212328,Lots of Cargo/Heavy Load
14736,3249412,541478,2388830,1769608,226912,965997,Lots of Cargo/Heavy Load
14737,3285008,558928,2106137,1830150,215926,986757,Medium Filled
14738,3271868,556990,1913048,1817210,212786,951585,Light Load
14739,3357446,563644,2140145,1831722,211804,954249,Lots of Cargo/Heavy Load
14740,3348252,520838,2385036,1788626,225016,976045,Lots of Cargo/Heavy Load
14741,3302526,519428,2132153,1832716,221854,973693,Medium Filled
14742,3278118,541314,2115447,1811696,214876,1191730,Lots of Cargo/Heavy Load
14743,3327144,535710,2358718,1779630,206386,995103,Lots of Cargo/Heavy Load
14744,3240632,544654,2112995,1854220,229700,934957,Medium Filled
14745,3291044,535108,1859902,1790766,226694,980771,Light Load
14746,3304360,550760,2178401,1823896,209204,961959,Lots of Cargo/Heavy Load
14747,3261096,529196,2342872,1797366,228622,953965,Lots of Cargo/Heavy Load
14748,3332748,556600,2141107,1856094,225280,961401,Lots of Cargo/Heavy Load
14749,3298184,527618,2149885,1786572,211614,1195118,Lots of Cargo/Heavy Load
14750,3343522,527130,2412840,1798094,220050,973553,Lots of Cargo/Heavy Load
;;;;
run;

data sasuser.quarter3;
   attrib Date length=8 format=DATE9.;
   attrib CrgoRev1 length=8 format=DOLLAR12.;
   attrib CrgoRev2 length=8 format=DOLLAR12.;
   attrib CrgoRev3 length=8 format=DOLLAR12.;
   attrib CrgoRev4 length=8 format=DOLLAR12.;
   attrib CrgoRev5 length=8 format=DOLLAR12.;
   attrib CrgoRev6 length=8 format=DOLLAR12.;
   attrib comment length=$25;

   infile datalines dsd;
   input
      Date
      CrgoRev1
      CrgoRev2
      CrgoRev3
      CrgoRev4
      CrgoRev5
      CrgoRev6
      comment
   ;
datalines4;
14792,3258898,551402,2400724,1829546,218590,993593,Lots of Cargo/Heavy Load
14793,3286050,579636,2147585,1807888,227278,954135,Lots of Cargo/Heavy Load
14794,3272890,557722,1878600,1796486,228862,981241,Light Load
14795,3363010,551034,2141029,1848434,219516,948911,Lots of Cargo/Heavy Load
14796,3256306,563050,2369946,1796212,214158,985859,Lots of Cargo/Heavy Load
14797,3316106,557490,2115111,1804652,211036,965495,Medium Filled
14798,3357054,559516,2141423,1793796,224850,1195140,Lots of Cargo/Heavy Load
14799,3305808,539930,2387712,1833422,219492,980501,Lots of Cargo/Heavy Load
14800,3354582,559692,2137037,1823876,206562,968995,Lots of Cargo/Heavy Load
14801,3268076,574602,1917296,1799002,212542,982111,Light Load
14802,3224190,546618,2149247,1826238,205144,963125,Medium Filled
14803,3330806,554724,2423034,1800666,206180,952145,Lots of Cargo/Heavy Load
14804,3252534,550348,2121495,1810678,217842,946195,Medium Filled
14805,3336030,550588,2117315,1828572,217230,1201326,Lots of Cargo/Heavy Load
14806,3300790,565532,2366654,1827638,221772,968861,Lots of Cargo/Heavy Load
14807,3251502,546418,2146995,1833744,219036,976887,Medium Filled
14808,3200634,540508,1867742,1814670,211142,971349,Light Load
14809,3322896,563392,2155217,1840244,222408,954661,Lots of Cargo/Heavy Load
14810,3378214,568762,2376550,1811378,221894,996867,Lots of Cargo/Heavy Load
14811,3340818,560804,2148393,1818536,219746,941423,Lots of Cargo/Heavy Load
14812,3263486,547948,2101847,1794742,231536,1241246,Lots of Cargo/Heavy Load
14813,3327554,555098,2336454,1820428,227300,968879,Lots of Cargo/Heavy Load
14814,3295876,552886,2143881,1792168,214264,944455,Medium Filled
14815,3248190,551760,1897484,1815300,211078,966705,Light Load
14816,3313730,525692,2106315,1800304,227016,962203,Medium Filled
14817,3342110,558248,2374382,1826962,225250,961257,Lots of Cargo/Heavy Load
14818,3275846,561052,2128407,1817482,231928,955923,Medium Filled
14819,3291040,567892,2136345,1808080,206932,1194146,Lots of Cargo/Heavy Load
14820,3276874,564598,2417662,1810264,210620,987195,Lots of Cargo/Heavy Load
14821,3366164,571562,2112473,1797006,236460,975061,Lots of Cargo/Heavy Load
14822,3306308,542840,1882254,1817514,209038,968773,Light Load
14823,3301036,563394,2126651,1798814,216610,992909,Medium Filled
14824,3312572,560070,2388922,1779268,225984,1009815,Lots of Cargo/Heavy Load
14825,3348728,564396,2170847,1818496,219806,964573,Lots of Cargo/Heavy Load
14826,3380926,562366,2158631,1830690,220344,1207844,Lots of Cargo/Heavy Load
14827,3311666,537812,2403742,1814592,219872,957265,Lots of Cargo/Heavy Load
14828,3321184,574060,2118327,1847488,221418,961725,Lots of Cargo/Heavy Load
14829,3297992,550628,1891920,1824990,231956,944247,Light Load
14830,3285852,535770,2122593,1793306,217758,950459,Medium Filled
14831,3315946,540846,2332730,1793674,228218,944899,Lots of Cargo/Heavy Load
14832,3347556,569762,2182317,1805750,222342,983317,Lots of Cargo/Heavy Load
14833,3307390,566696,2149565,1798612,221356,1221334,Lots of Cargo/Heavy Load
14834,3376024,544620,2357240,1823032,218098,1012981,Lots of Cargo/Heavy Load
14835,3262464,570860,2121329,1830422,232968,965101,Medium Filled
14836,3333116,557380,1873312,1789498,226436,981149,Light Load
14837,3296450,552048,2091485,1811960,217676,975281,Medium Filled
14838,3299364,561780,2352684,1802214,223720,970171,Lots of Cargo/Heavy Load
14839,3325102,552392,2137763,1807336,228562,970721,Lots of Cargo/Heavy Load
14840,3363434,538614,2154337,1831824,213686,1213956,Lots of Cargo/Heavy Load
14841,3297952,555452,2371542,1851708,229326,958305,Lots of Cargo/Heavy Load
;;;;
run;

data sasuser.quarter4;
   attrib Date length=8 format=DATE9.;
   attrib CrgoRev1 length=8 format=DOLLAR12.;
   attrib CrgoRev2 length=8 format=DOLLAR12.;
   attrib CrgoRev3 length=8 format=DOLLAR12.;
   attrib CrgoRev4 length=8 format=DOLLAR12.;
   attrib CrgoRev5 length=8 format=DOLLAR12.;
   attrib CrgoRev6 length=8 format=DOLLAR12.;
   attrib comment length=$25;

   infile datalines dsd;
   input
      Date
      CrgoRev1
      CrgoRev2
      CrgoRev3
      CrgoRev4
      CrgoRev5
      CrgoRev6
      comment
   ;
datalines4;
14884,3287060,549280,2132679,1817324,219792,972585,Medium Filled
14885,3281134,555670,1917524,1769740,225944,984625,Light Load
14886,3270620,572136,2102609,1775210,215386,981231,Medium Filled
14887,3296466,592800,2352088,1797826,216650,941179,Lots of Cargo/Heavy Load
14888,3299664,542860,2102151,1846074,217364,980101,Medium Filled
14889,3283118,538246,2135697,1795390,225754,1211148,Lots of Cargo/Heavy Load
14890,3212646,528154,2403092,1800462,213560,969143,Lots of Cargo/Heavy Load
14891,3260434,550776,2149597,1844084,221652,965521,Medium Filled
14892,3225356,551062,1860924,1823826,219502,984505,Light Load
14893,3330342,569882,2110459,1780934,217750,953733,Medium Filled
14894,3267774,552768,2351668,1807418,227650,980529,Lots of Cargo/Heavy Load
14895,3300552,567694,2168887,1856700,212440,940129,Lots of Cargo/Heavy Load
14896,3373320,540198,2111767,1834088,223964,1192606,Lots of Cargo/Heavy Load
14897,3255594,550096,2387668,1840510,220450,973807,Lots of Cargo/Heavy Load
14898,3340492,578620,2107837,1810396,222700,977783,Lots of Cargo/Heavy Load
14899,3227026,559466,1886218,1851592,221660,1006151,Light Load
14900,3266782,543720,2122517,1817240,219552,971727,Medium Filled
14901,3329296,563994,2354342,1781554,230456,965201,Lots of Cargo/Heavy Load
14902,3292238,522408,2145273,1815746,221438,975241,Medium Filled
14903,3263422,544884,2124455,1804456,221036,1180538,Lots of Cargo/Heavy Load
14904,3252906,560634,2367660,1753918,227826,963951,Lots of Cargo/Heavy Load
14905,3329252,556800,2155129,1810396,222202,977421,Lots of Cargo/Heavy Load
14906,3267002,576588,1937832,1839802,219610,968681,Medium Filled
14907,3344620,577620,2154489,1781600,227384,958425,Lots of Cargo/Heavy Load
14908,3273510,541126,2345586,1831700,226608,963505,Lots of Cargo/Heavy Load
14909,3305612,526982,2167463,1829378,211390,979379,Lots of Cargo/Heavy Load
14910,3318192,541418,2131631,1851616,221396,1188172,Lots of Cargo/Heavy Load
14911,3266638,561310,2362850,1827372,221302,978881,Lots of Cargo/Heavy Load
14912,3305798,548742,2150099,1839046,230268,935921,Lots of Cargo/Heavy Load
14913,3264338,570664,1920314,1779308,228182,983431,Light Load
14914,3359634,535528,2167825,1816656,213420,988787,Lots of Cargo/Heavy Load
14915,3286310,548530,2372942,1823354,223110,983789,Lots of Cargo/Heavy Load
14916,3299148,530556,2123243,1820300,229202,967285,Medium Filled
14917,3268910,561174,2114055,1832040,223640,1187542,Lots of Cargo/Heavy Load
14918,3246018,588180,2399640,1787208,213742,958953,Lots of Cargo/Heavy Load
14919,3407330,569240,2158777,1853628,222986,947883,Lots of Cargo/Heavy Load
14920,3290424,565018,1904822,1824436,210222,980789,Light Load
14921,3330824,548500,2130395,1821004,224058,933339,Medium Filled
14922,3303636,565352,2329336,1831384,213154,954811,Lots of Cargo/Heavy Load
14923,3258406,548810,2119427,1872624,222046,970981,Medium Filled
14924,3286536,545946,2133527,1811802,229538,1209156,Lots of Cargo/Heavy Load
14925,3327572,557238,2382878,1813148,220642,967685,Lots of Cargo/Heavy Load
14926,3310878,581058,2157591,1813898,221052,973549,Lots of Cargo/Heavy Load
14927,3335282,569340,1890374,1836948,224074,976003,Medium Filled
14928,3355106,529926,2103859,1840226,203498,953463,Medium Filled
14929,3314856,552332,2387350,1812210,217544,990425,Lots of Cargo/Heavy Load
14930,3276108,561968,2161341,1815060,223564,961925,Medium Filled
14931,3302802,574416,2194289,1781674,213366,1245222,Lots of Cargo/Heavy Load
14932,3318456,553136,2331820,1814620,214876,999581,Lots of Cargo/Heavy Load
14933,3268078,571504,2133749,1809214,218230,974397,Medium Filled
;;;;
run;

data sasuser.revenue;
   attrib Origin length=$3;
   attrib Dest length=$3;
   attrib FlightID length=$7;
   attrib Date length=8 format=DATE9.;
   attrib Rev1st length=8;
   attrib RevBusiness length=8;
   attrib RevEcon length=8;

   infile datalines dsd;
   input
      Origin
      Dest
      FlightID
      Date
      Rev1st
      RevBusiness
      RevEcon
   ;
datalines4;
ANC,RDU,IA03400,14580,15829,28420,68688
ANC,RDU,IA03400,14592,20146,26460,72981
ANC,RDU,IA03400,14604,20146,23520,59625
ANC,RDU,IA03401,14587,15829,22540,58671
ANC,RDU,IA03401,14599,20146,22540,65826
CBR,WLG,IA10500,14582,15496,16687,28710
CBR,WLG,IA10500,14594,13708,19943,26928
CBR,WLG,IA10500,14606,16092,21164,27324
CBR,WLG,IA10501,14589,13112,16280,23760
CBR,WLG,IA10501,14601,16092,18722,30888
CCU,HKG,IA09900,14584,18306,19866,34875
CCU,HKG,IA09900,14596,18306,21252,27900
CCU,HKG,IA09900,14608,14916,21252,32400
CCU,HKG,IA09901,14591,16272,20790,32400
CCU,HKG,IA09901,14603,16272,19404,27225
CCU,PEK,IA09700,14586,19992,27832,36010
CCU,PEK,IA09700,14598,19992,23288,42381
CCU,PEK,IA09701,14581,19992,27832,39057
CCU,PEK,IA09701,14593,23324,28968,34902
CCU,PEK,IA09701,14605,18326,24992,42658
CCU,SIN,IA09300,14588,19318,23322,34086
CCU,SIN,IA09300,14600,18575,25350,29393
CCU,SIN,IA09301,14583,20061,21801,33592
CCU,SIN,IA09301,14595,19318,25857,32357
CCU,SIN,IA09301,14607,17089,25857,38285
CPT,FRA,IA08601,14591,40936,70563,107865
DEL,JRS,IA09000,14586,12372,19684,43092
DEL,JRS,IA09000,14598,12372,17575,52668
DEL,JRS,IA09001,14581,13403,18981,46854
DEL,JRS,IA09001,14593,14434,21090,50274
DEL,JRS,IA09001,14605,14434,16169,42066
DXB,FRA,IA07800,14588,18630,37224,59328
DXB,FRA,IA07800,14600,18630,40608,53148
DXB,FRA,IA07801,14583,19872,37224,60976
DXB,FRA,IA07801,14595,21114,43992,51912
DXB,FRA,IA07801,14607,18630,38070,63448
FRA,CPT,IA08501,14592,43344,86973,105468
FRA,DXB,IA07700,14587,19872,47376,58092
FRA,DXB,IA07700,14599,22356,43992,55620
FRA,DXB,IA07701,14582,23598,46530,62624
FRA,DXB,IA07701,14594,22356,41454,53972
FRA,DXB,IA07701,14606,19872,38070,60564
FRA,NBO,IA08700,14589,22694,30940,70478
FRA,NBO,IA08700,14601,21073,27625,68864
FRA,RDU,IA00400,14584,21132,30025,93015
FRA,RDU,IA00400,14596,22893,28824,87750
FRA,RDU,IA00400,14608,24654,30025,75465
FRA,RDU,IA00401,14591,19371,32427,76050
FRA,RDU,IA00401,14603,21132,28824,85410
HKG,CCU,IA10000,14586,18306,19404,32175
HKG,CCU,IA10000,14598,18984,23100,32400
HKG,CCU,IA10001,14581,17628,19404,33525
HKG,CCU,IA10001,14593,18984,23100,33975
HKG,CCU,IA10001,14605,18984,20328,30600
HKG,HND,IA10900,14588,19980,21672,36900
HKG,HND,IA10900,14600,19240,23184,33948
HKG,HND,IA10901,14583,17760,20160,32718
HKG,HND,IA10901,14595,19240,22176,36408
HKG,HND,IA10901,14607,19980,24192,30750
HKG,SYD,IA10100,14590,34074,41280,114478
HKG,SYD,IA10100,14602,34074,39990,101898
HKG,SYD,IA10101,14585,32181,39990,97495
HKG,SYD,IA10101,14597,32181,43860,107559
HND,HKG,IA11000,14580,19240,22680,34932
HND,HKG,IA11000,14592,17760,21168,36654
HND,HKG,IA11000,14604,18500,24696,30012
HND,HKG,IA11001,14587,20720,24192,32472
HND,HKG,IA11001,14599,19980,20160,34440
HND,SFO,IA11100,14582,33968,40516,107160
HND,SFO,IA11100,14594,33968,41963,137475
HND,SFO,IA11100,14606,31845,46304,121260
HND,SFO,IA11101,14589,38214,46304,118440
HND,SFO,IA11101,14601,40337,46304,133245
HNL,SFO,IA03000,14584,11856,16152,47888
HNL,SFO,IA03000,14596,10868,17498,51168
HNL,SFO,IA03000,14608,10868,16825,46248
HNL,SFO,IA03001,14591,10868,18171,48544
HNL,SFO,IA03001,14603,11856,19517,52808
JED,LHR,IA08200,14586,23161,44820,51435
JED,LHR,IA08200,14598,18285,44820,59535
JED,LHR,IA08201,14581,18285,44820,61560
JED,LHR,IA08201,14593,21942,35690,66015
JED,LHR,IA08201,14605,21942,43160,64800
JNB,LHR,IA08401,14586,34950,76224,121518
JRS,DEL,IA08900,14585,11341,18278,48564
JRS,DEL,IA08900,14597,13403,21090,43776
JRS,DEL,IA08901,14580,14434,16872,51300
JRS,DEL,IA08901,14592,11341,16169,54720
JRS,DEL,IA08901,14604,11341,21090,54378
LHR,JED,IA08100,14587,20723,40670,54270
LHR,JED,IA08100,14599,21942,42330,63990
LHR,JED,IA08101,14582,19504,37350,50625
LHR,JED,IA08101,14594,23161,46480,59535
LHR,JED,IA08101,14606,23161,38180,66015
LHR,JNB,IA08301,14587,41940,76224,111456
LHR,RDU,IA00200,14585,20800,30520,79650
LHR,RDU,IA00200,14597,19200,29430,80712
LHR,RDU,IA00201,14580,19200,26160,71154
LHR,RDU,IA00201,14592,19200,26160,73809
LHR,RDU,IA00201,14604,17600,26160,84429
NBO,FRA,IA08800,14587,19452,26520,73706
NBO,FRA,IA08800,14599,19452,32045,84466
PEK,CCU,IA09800,14582,20825,25560,41273
PEK,CCU,IA09800,14594,20825,22720,35456
PEK,CCU,IA09800,14606,23324,24424,38226
PEK,CCU,IA09801,14589,23324,27264,37949
PEK,CCU,IA09801,14601,23324,27264,40442
RDU,ANC,IA03300,14584,15829,24500,69165
RDU,ANC,IA03300,14596,18707,22540,72981
RDU,ANC,IA03300,14608,17268,29400,58671
RDU,ANC,IA03301,14591,17268,25480,76797
RDU,ANC,IA03301,14603,20146,29400,73458
RDU,FRA,IA00300,14586,21132,31226,94185
RDU,FRA,IA00300,14598,24654,30025,75465
RDU,FRA,IA00301,14581,24654,31226,72540
RDU,FRA,IA00301,14593,19371,34829,90090
RDU,FRA,IA00301,14605,21132,27623,80145
RDU,LHR,IA00100,14588,20800,32700,67968
RDU,LHR,IA00100,14600,22400,31610,77526
RDU,LHR,IA00101,14583,19200,30520,65313
RDU,LHR,IA00101,14595,17600,30520,79119
RDU,LHR,IA00101,14607,20800,25070,75933
SFO,HND,IA11200,14590,40337,49198,113505
SFO,HND,IA11200,14602,38214,50645,140295
SFO,HND,IA11201,14585,40337,47751,141000
SFO,HND,IA11201,14597,40337,46304,130425
SFO,HNL,IA02900,14580,13832,20190,42640
SFO,HNL,IA02900,14592,12844,16825,45592
SFO,HNL,IA02900,14604,11856,16152,48216
SFO,HNL,IA02901,14587,12844,16825,42640
SFO,HNL,IA02901,14599,13832,16825,45264
SIN,CCU,IA09400,14582,20804,24336,38038
SIN,CCU,IA09400,14594,16346,22308,37544
SIN,CCU,IA09400,14606,17832,25350,30628
SIN,CCU,IA09401,14589,17089,20787,38779
SIN,CCU,IA09401,14601,20061,24843,36556
SYD,HKG,IA10200,14584,34074,42570,108817
SYD,HKG,IA10200,14596,28395,38700,120768
SYD,HKG,IA10200,14608,35967,34830,123284
SYD,HKG,IA10201,14591,32181,39990,111333
SYD,HKG,IA10201,14603,34074,37410,107559
WLG,CBR,IA10600,14586,15496,17908,29106
;;;;
run;

data sasuser.salcomps;
   attrib EmpID length=$6;
   attrib LastName length=$32;
   attrib Phone length=$8;
   attrib Location length=$25;
   attrib Division length=$30;
   attrib HireDate length=8 format=DATE9.;
   attrib JobCode length=$6;
   attrib Salary length=8;

   infile datalines dsd;
   input
      EmpID
      LastName
      Phone
      Location
      Division
      HireDate
      JobCode
      Salary
   ;
datalines4;
E00001,MILLS,2380,CARY,FLIGHT OPERATIONS,11758,FLTAT3,25000
E00002,BOWER,1214,CARY,FINANCE & IT,8753,FINCLK,27000
E00003,READING,1428,CARY,HUMAN RESOURCES & FACILITIES,9202,VICEPR,120000
E00004,JUDD,2061,CARY,HUMAN RESOURCES & FACILITIES,10881,FACMNT,42000
E00006,ANDERSON,1007,CARY,SALES & MARKETING,11439,MKTCLK,31000
E00007,MASSENGILL,2290,CARY,FLIGHT OPERATIONS,8440,MECH01,29000
E00008,BADINE,1000,TORONTO,CORPORATE OPERATIONS,11733,OFFMGR,85000
E00009,DEMENT,1506,CARY,FINANCE & IT,9887,ITPROG,34000
E00010,FOSKEY,1666,CARY,AIRPORT OPERATIONS,11284,GRCREW,29000
E00011,POOLE,2594,CARY,FLIGHT OPERATIONS,11270,FLTAT3,27000
E00012,LEWIS,2207,CARY,SALES & MARKETING,12612,MKTCLK,33000
E00013,DBAIBO,1002,BOSTON,HUMAN RESOURCES & FACILITIES,11585,RECEPT,22000
E00014,KEARNEY,2075,CARY,FLIGHT OPERATIONS,8852,MECH02,19000
E00015,BROWN,1263,CARY,AIRPORT OPERATIONS,12484,GRCSUP,41000
E00017,SIMPSON,2821,CARY,HUMAN RESOURCES & FACILITIES,12066,RESCLK,36000
E00018,CROSS,1459,CARY,HUMAN RESOURCES & FACILITIES,9447,FACMNT,33000
E00020,JOHNSON,1256,CARY,HUMAN RESOURCES & FACILITIES,11710,FACCLK,21000
E00021,BAKER JR.,1001,HOUSTON,SALES & MARKETING,12152,SALMGR,43000
E00022,JOHNSON,1255,CARY,HUMAN RESOURCES & FACILITIES,7885,FACCLK,27000
E00023,FORT,1172,CARY,FLIGHT OPERATIONS,8011,FLTAT2,31000
E00024,COCKERHAM,1395,CARY,FLIGHT OPERATIONS,12602,FLTAT3,21000
E00025,BROCKLEBANK,1248,CARY,AIRPORT OPERATIONS,11339,BAGCLK,23000
E00026,THOMPSON,1516,CARY,FINANCE & IT,9567,ITSUPT,24000
E00027,BOWMAN,1215,CARY,FINANCE & IT,10998,FINACT,31000
E00029,MAROON,1325,CARY,AIRPORT OPERATIONS,9520,FLSCHD,17000
E00030,BREWER,1009,AUSTIN,SALES & MARKETING,8922,MKTCLK,38000
E00031,GOLDENBERG,1741,CARY,FLIGHT OPERATIONS,8556,PILOT3,28000
E00032,COUCH,1104,CARY,FINANCE & IT,11921,ITPROG,24000
E00033,FISHER,1166,CARY,FLIGHT OPERATIONS,10705,FLTAT2,35000
E00034,TOMPKINS,2997,CARY,FLIGHT OPERATIONS,8980,FLTAT3,28000
E00035,WEBB,3115,CARY,FINANCE & IT,9647,ITSUPT,26000
E00038,SMITH,2853,CARY,HUMAN RESOURCES & FACILITIES,7826,FACCLK,20000
E00039,MCKINNON,1053,TORONTO,HUMAN RESOURCES & FACILITIES,8244,FACCLK,38000
E00040,WILLIAMS,3157,CARY,FLIGHT OPERATIONS,11730,FLTAT1,32000
E00041,BRUTON,1008,TORONTO,SALES & MARKETING,9362,MKTCLK,45000
E00042,ANDERSON,1045,CARY,AIRPORT OPERATIONS,7724,BAGCLK,32000
E00043,WIELENGA,3146,CARY,FLIGHT OPERATIONS,8138,PILOT3,17000
E00044,HALL,1804,CARY,SALES & MARKETING,12492,SALCLK,25000
E00046,GOODYEAR,1754,CARY,FLIGHT OPERATIONS,9000,FLTAT1,44000
E00047,ECKHAUSEN,1581,CARY,FLIGHT OPERATIONS,9397,FLTAT3,40000
E00048,MOELL,2392,CARY,FLIGHT OPERATIONS,11724,FLTAT3,19000
E00049,CHASE JR.,1355,CARY,FLIGHT OPERATIONS,7758,FLTAT1,29000
E00050,DEXTER,1000,PHOENIX,CORPORATE OPERATIONS,9434,OFFMGR,95000
E00051,LIVELY,1307,CARY,FINANCE & IT,12435,ITPROG,19000
E00052,MELTON,2364,CARY,FLIGHT OPERATIONS,8803,FLTAT2,44000
E00053,CURTIS,1468,CARY,AIRPORT OPERATIONS,9258,GRCREW,39000
E00054,AGARWAL,1015,CARY,FINANCE & IT,9514,FINACT,26000
E00055,WHITE JR.,3140,CARY,FLIGHT OPERATIONS,11246,PILOT3,25000
E00056,POOLE,1068,TORONTO,AIRPORT OPERATIONS,11267,GRCREW,29000
E00058,BOOZER,1204,CARY,SALES & MARKETING,9205,SALCLK,41000
;;;;
run;

data sasuser.sale2000;
   attrib FlightID length=$7;
   attrib RouteID length=$7;
   attrib Origin length=$3;
   attrib Dest length=$3;
   attrib Cap1st length=8;
   attrib CapBusiness length=8;
   attrib CapEcon length=8;
   attrib CapTotal length=8;
   attrib CapCargo length=8;
   attrib Date length=8 format=DATE9.;
   attrib Psgr1st length=8;
   attrib PsgrBusiness length=8;
   attrib PsgrEcon length=8;
   attrib Rev1st length=8;
   attrib RevBusiness length=8;
   attrib RevEcon length=8;
   attrib SaleMon length=$7;
   attrib CargoWgt length=8;
   attrib RevCargo length=8;

   infile sale2000 dsd;
   input
      FlightID
      RouteID
      Origin
      Dest
      Cap1st
      CapBusiness
      CapEcon
      CapTotal
      CapCargo
      Date
      Psgr1st
      PsgrBusiness
      PsgrEcon
      Rev1st
      RevBusiness
      RevEcon
      SaleMon
      CargoWgt
      RevCargo
   ;
run;

data sasuser.target;
   attrib Year length=8;
   attrib RevType length=$9 label='Revenue Type';
   attrib Jan length=8;
   attrib Feb length=8;
   attrib Mar length=8;
   attrib Apr length=8;
   attrib May length=8;
   attrib Jun length=8;
   attrib Jul length=8;
   attrib Aug length=8;
   attrib Sep length=8;
   attrib Oct length=8;
   attrib Nov length=8;
   attrib Dec length=8;

   infile datalines dsd;
   input
      Year
      RevType
      Jan
      Feb
      Mar
      Apr
      May
      Jun
      Jul
      Aug
      Sep
      Oct
      Nov
      Dec
   ;
datalines4;
1997,cargo,192284420,86376721,28526103,260386468,109975326,102833104,196728648,236996122,112413744,125401565,72551855,136042505
1997,passenger,211052672,309991890,123302226,47862099,128810605,212378496,319499539,34004244,206472552,50706092,298545086,213838302
1998,cargo,108645734,147656369,202158055,41160707,264294440,267135485,208694865,83456868,286846554,275721406,230488351,24901752
1998,passenger,167270825,105489944,77437835,333474626,92904623,412429160,240654274,406504195,226480968,173100004,377287496,106533277
1999,cargo,85730444,74168740,39955768,312654811,318149340,187270927,123394421,34273985,151565752,141528519,178043261,181668256
1999,passenger,175035360,140625851,66436824,442134756,458812748,184286073,97120463,438102259,483757203,436676381,78296870,14306308
;;;;
run;

data sasuser.vcrsales;
   input Salesrep $ Type $ UnitSold Net $ Commission;
   
datalines;
TFB VCR 12 1270.00 63.50
MDC VCR 22 2385.00 119.00
WKK VCR 14 1388.00 69.00
;

data sasuser.wchill;
   attrib TmpNeg10 length=8;
   attrib TempNeg5 length=8;
   attrib Temp0 length=8;
   attrib Temp5 length=8;
   attrib Temp10 length=8;
   attrib Temp15 length=8;
   attrib Temp20 length=8;
   attrib Temp25 length=8;
   attrib Temp30 length=8;

   infile datalines dsd;
   input
      TmpNeg10
      TempNeg5
      Temp0
      Temp5
      Temp10
      Temp15
      Temp20
      Temp25
      Temp30
   ;
datalines4;
-22,-16,-11,-5,1,7,13,19,25
-28,-22,-16,-10,-4,3,9,15,21
-32,-26,-19,-13,-7,0,6,13,19
-35,-29,-22,-15,-9,-2,4,11,17
-37,-31,-24,-17,-11,-4,3,9,16
-39,-33,-26,-19,-12,-5,1,8,15
-41,-34,-27,-21,-14,-7,0,7,14
-43,-36,-29,-22,-15,-8,-1,6,13
;;;;
run;

data sasuser.westaust;
   attrib Code length=$3 label='Airport Code';
   attrib City length=$50 label='City Where Airport is Located';
   attrib Country length=$40 label='Country Where Airport is Located';
   attrib Name length=$50 label='Airport Name';

   infile datalines dsd;
   input
      Code
      City
      Country
      Name
   ;
datalines4;
AGY,"Argyle Downs, Western Australia",Australia,
ALH,"Albany, Western Australia",Australia,
BBE,"Big Bell, Western Australia",Australia,
BDW,"Bedford Downs, Western Australia",Australia,
BEE,"Beagle Bay, Western Australia",Australia,
BIW,"Billiluna Station, Western Australia",Australia,
BME,"Broome, Western Australia",Australia,
BQW,"Balgo Hills, Western Australia", Australia,
BUY,"Bunbury, Western Australia",Australia,
BVZ,"Beverley Springs, Western Australia",Australia,
BWB,"Barrow Island, Western Australia",Australia,
CBC,"Cherrabun, Western Australia",Australia,
CIE,"Collie, Western Australia",Australia,
COY,"Coolawanyah, Western Australia",Australia,
CRY,"Carlton Hill, Western Australia",Australia,
CUY,"Cue, Western Australia",Australia,
CVQ,"Carnarvon, Western Australia",Australia,
CXQ,"Christmas Creek, Western Australia",Australia,
DNM,"Denham, Western Australia",Australia,
DOX,"Dongara, Western Australia",Australia,
DRB,"Derby, Western Australia",Australia,
ENB,"Eneabba, Western Australia",Australia,
EPR,"Esperance, Western Australia",Australia,
EUC,"Eucla, Western Australia",Australia,
FIZ,"Fitzroy Crossing, Western Australia",Australia,
FOS,"Forrest, Western Australia",Australia,
FSL,"Fossil Downs, Western Australia",Australia,
GBV,"Gibb River, Western Australia",Australia,
GDD,"Gordon Downs, Western Australia",Australia,
GET,"Geraldton, Western Australia",Australia,
GLY,"Mt. Goldworthy, Western Australia",Australia,
GSC,"Gascoyne Junction, Western Australia",Australia,
HCQ,"Halls Creek, Western Australia",Australia,
HLL,"Hillside, Western Australia",Australia,
JAD,"Jandakot, Western Australia",Australia,
JFM,"Fremantle, Western Australia",Australia,
JUR,"Jurien Bay, Western Australia",Australia,
KAX,"Kalbarri, Western Australia",Australia,
KBD,"Kimberly Downs, Western Australia",Australia,
KDB,"Kambalda, Western Australia",Australia,
KGI,"Kalgoorlie, Western Australia",Australia,
KNI,"Katanning, Western Australia",Australia,
KNX,"Kununurra, Western Australia",Australia,
KTA,"Dampier, Western Australia",Australia,Karratha,
LDW,"Lansdowne Station, Western Australia",Australia,
LEA,"Learmouth (Exmouth), Western Australia",Australia,
LER,"Leinster, Western Australia",Australia,
LLL,"Lissadel, Western Australia",Australia,
LNO,"Leonora, Western Australia",Australia,
LVO,"Laverton, Western Australia",Australia,
;;;;
run;

data sasuser.year2000;
   attrib CrgoRev1 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib CrgoRev2 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib CrgoRev3 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib CrgoRev4 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib CrgoRev5 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib CrgoRev6 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib Date length=8 format=DATE9.;

   infile datalines dsd;
   input
      CrgoRev1:BEST32.
      CrgoRev2:BEST32.
      CrgoRev3:BEST32.
      CrgoRev4:BEST32.
      CrgoRev5:BEST32.
      CrgoRev6:BEST32.
      Date
   ;
datalines4;
3280638,561692,2128545,1817984,223134,,14610
3275164,534184,1878010,1860242,214236,969241,14611
3258884,552088,2123491,1840034,213864,942459,14612
3330580,552294,2357934,1812278,226276,958295,14613
3301534,564340,2145639,1819898,227258,982329,14614
3326138,576790,2131639,1833088,220462,1163366,14615
3246350,533278,2377156,1844822,222436,,14616
3298714,547340,2156809,1820122,220312,950041,14617
3285232,544116,1952562,1807724,218156,976357,14618
3280508,555252,2142039,1804266,217604,983877,14619
3302822,555976,2345564,1754802,217096,976635,14620
3296096,538238,2179523,1853246,233602,992769,14621
3277750,545314,2138169,1829864,233022,1194362,14622
3251002,575892,2394990,1804538,212506,1002203,14623
3174884,531338,2133343,1819038,216170,968085,14624
3288652,544672,1919772,1844646,222704,975887,14625
3260738,550964,2145919,1812130,222432,991983,14626
3274348,559958,2374968,1851186,213960,991305,14627
3282268,542468,2133125,1788534,221484,972089,14628
3294096,554112,2134321,1804248,216378,1229680,14629
3243954,547662,2381392,1818468,225012,967821,14630
3280594,563576,2142919,1803972,217964,959081,14631
3262340,549798,1881386,1836536,233660,1014203,14632
3255528,553584,2146533,1814862,220534,966601,14633
3267038,545388,2403800,1835198,220852,956101,14634
3303738,567878,2123831,1793326,235094,944491,14635
3268326,542698,2182065,1815280,224856,1226332,14636
3284084,571718,2358722,1808794,219890,974831,14637
3327854,572018,2158691,1825878,222080,958813,14638
3307636,561666,1925206,1808194,226580,967365,14639
3255910,574910,2173915,1824302,211996,984757,14640
3328102,555384,2364748,1824852,224498,,14641
3292932,544076,2137565,1840184,226250,979235,14642
3338714,525632,2113297,1827320,211408,1208500,14643
3245030,563174,2381010,1811068,212392,961259,14644
3267144,573684,2146139,1782962,223140,991177,14645
3240818,560500,1894364,1798092,223622,997019,14646

3346294,538166,2128185,1823758,216060,,14647
3352818,534260,2414922,1825212,228234,973609,14648
3310860,563324,2106187,1812616,221168,982501,14649
3300922,552190,2111893,1811210,211024,1211612,14650
3252588,548828,2362816,1833956,229524,978729,14651
3327042,553442,2165963,1803776,220986,957237,14652
3310622,560232,1931890,1842744,228368,1007761,14653
3258514,542394,2142133,1845282,208562,972783,14654
3302296,527542,2405888,1832452,212620,1016703,14655
3246594,546400,2161355,1795086,213706,980637,14656
3303448,561796,2136535,1775106,222704,1231706,14657
3277900,541010,2385242,1785704,209802,975377,14658
3351716,567132,2122955,1862210,216012,968433,14659
;;;;
run;

data sasuser.y2000;
   attrib CrgoRev1 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib CrgoRev2 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib CrgoRev3 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib CrgoRev4 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib CrgoRev5 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib CrgoRev6 length=8 format=DOLLAR12. informat=COMMA12.;
   attrib Date length=8 format=DATE9.;

   infile datalines dsd;
   input
      CrgoRev1:BEST32.
      CrgoRev2:BEST32.
      CrgoRev3:BEST32.
      CrgoRev4:BEST32.
      CrgoRev5:BEST32.
      CrgoRev6:BEST32.
      Date
   ;
datalines4;
3280638,561692,2128545,1817984,223134,,14610
3275164,534184,1878010,1860242,214236,969241,14611
3258884,552088,2123491,1840034,213864,942459,14612
3330580,552294,2357934,1812278,226276,958295,14613
3301534,564340,2145639,1819898,227258,982329,14614
3326138,576790,2131639,1833088,220462,1163366,14615
3246350,533278,2377156,1844822,222436,,14616
3298714,547340,2156809,1820122,220312,950041,14617
3285232,544116,1952562,1807724,218156,976357,14618
3280508,555252,2142039,1804266,217604,983877,14619
3302822,555976,2345564,1754802,217096,976635,14620
3296096,538238,2179523,1853246,233602,992769,14621
3277750,545314,2138169,1829864,233022,1194362,14622
3251002,575892,2394990,1804538,212506,1002203,14623
3174884,531338,2133343,1819038,216170,968085,14624
3288652,544672,1919772,1844646,222704,975887,14625
3260738,550964,2145919,1812130,222432,991983,14626
3274348,559958,2374968,1851186,213960,991305,14627
3282268,542468,2133125,1788534,221484,972089,14628
3294096,554112,2134321,1804248,216378,1229680,14629
3243954,547662,2381392,1818468,225012,967821,14630
3280594,563576,2142919,1803972,217964,959081,14631
3262340,549798,1881386,1836536,233660,1014203,14632
3255528,553584,2146533,1814862,220534,966601,14633
3267038,545388,2403800,1835198,220852,956101,14634
3303738,567878,2123831,1793326,235094,944491,14635
3268326,542698,2182065,1815280,224856,1226332,14636
3284084,571718,2358722,1808794,219890,974831,14637
3327854,572018,2158691,1825878,222080,958813,14638
3307636,561666,1925206,1808194,226580,967365,14639
3255910,574910,2173915,1824302,211996,984757,14640
3328102,555384,2364748,1824852,224498,,14641
3292932,544076,2137565,1840184,226250,979235,14642
3338714,525632,2113297,1827320,211408,1208500,14643
3245030,563174,2381010,1811068,212392,961259,14644
3267144,573684,2146139,1782962,223140,991177,14645
3240818,560500,1894364,1798092,223622,997019,14646
3346294,538166,2128185,1823758,216060,,14647
3352818,534260,2414922,1825212,228234,973609,14648
3310860,563324,2106187,1812616,221168,982501,14649
3300922,552190,2111893,1811210,211024,1211612,14650
3252588,548828,2362816,1833956,229524,978729,14651
3327042,553442,2165963,1803776,220986,957237,14652
3310622,560232,1931890,1842744,228368,1007761,14653
3258514,542394,2142133,1845282,208562,972783,14654
3302296,527542,2405888,1832452,212620,1016703,14655
3246594,546400,2161355,1795086,213706,980637,14656
3303448,561796,2136535,1775106,222704,1231706,14657
3277900,541010,2385242,1785704,209802,975377,14658
3351716,567132,2122955,1862210,216012,968433,14659
;;;;
run;

data sasuser.y200061;
   attrib LastName length=$25;
   attrib Job1 length=$6;
   attrib Job2 length=$6;
   attrib Job3 length=$6;

   infile datalines dsd;
   input
      LastName
      Job1
      Job2
      Job3
   ;
datalines4;
POOLE,FLTAT2,FLTAT3,
BROCKLEBANK,BAGCLK,,
THOMPSON,ITSUPT,,
BOWMAN,FINACT,,
LICHTENSTEIN,ITCLK,,
MAROON,FLSCHD,,
BREWER,MKTCLK,,
GOLDENBERG,PILOT2,PILOT3,
;;;;
run;

data sasuser.y200062;
   attrib LastName length=$25;
   attrib Job1 length=$6;
   attrib Job2 length=$6;
   attrib Job3 length=$6;

   infile datalines dsd;
   input
      LastName
      Job1
      Job2
      Job3
   ;
datalines4;
OJEDA,GRCREW,,
PENDERGRASS,FACMNT,,
STEWART,JR.,GRCREW,
TENGESDAL,RESCLK,,
PERRY,FLTAT1,,
LE,ROY,BAGCLK,
ADCOCK,FINCLK,,
WARD,MECH03,,
LEITCH,FLTAT3,,
ALLEN,RESMGR,,
TRACEY,FSVCLK,,
STEVENSON,GRCREW,,
STONE,GRCREW,,
BAGGETT,GRCREW,,
ZARKOSKI,MKTCLK,,
MCGWIER-WATTS,PILOT1,,
LACOSTE,CHKCLK,,
LACK,FLTAT1,,
POITRAS,FLTAT3,,
LYLE,FSVCLK,,
BUCHNER,HRCLK,,
HARPER,FACCLK,,
STICKLE,ITPROG,,
;;;;
run;


***** data for macro course *******************************;


data sasuser.students;
   input Student_Name $ 1-25 Student_Company $ 29-68 City_State $ 71-90;
   label student_name = 'Student Name'
         student_company = 'Company'
         city_state = 'City,State';
   datalines4;
Abramson, Ms. Andrea        Eastman Developers                        Deerfield, IL
Alamutu, Ms. Julie          Reston Railway                            Chicago, IL
Albritton, Mr. Bryan        Special Services                          Oak Brook, IL
Allen, Ms. Denise           Department of Defense                     Bethesda, MD
Amigo, Mr. Bill             Assoc. of Realtors                        Chicago, IL
Avakian, Mr. Don            Reston Railway                            Chicago, IL
Babbitt, Mr. Bill           National Credit Corp.                     Chicago, IL
Baker, Mr. Vincent          Snowing Petroleum                         New Orleans, LA
Bates, Ms. Ellen            Reston Railway                            Chicago, IL
Belles, Ms. Vicki           Jost Hardware Inc.                        Toledo, OH
Benincasa, Ms. Elizabeth    Hospital Nurses Association               Naperville, IL
Bills, Ms. Paulette         Reston Railway                            Chicago, IL
Blair, Mr. Paul             Federal Lankmarks                         Washington, DC
Blayney, Ms. Vivian         Southern Gas Co.                          Los Angeles, CA
Boyd, Ms. Leah              United Shoes Co.                          Brea, CA
Brown, Mr. Michael          Swain Diagnostics Inc.                    Columbia, MD
Burns, Ms. Karen            Califonics Inc.                           Sacramento, CA
Carty, Mr. Howard           Hearit Telecommunications                 Washington, DC
Chan, Mr. John              California Lawyers Assn.                  Sacramento, CA
Chavez, Ms. Louise          US Express Corp.                          Fort Lauderdale, FL
Chevarley, Ms. Arlene       Motor Communications                      Chicago, IL
Chodnoff, Mr. Norman        NBA Insurance                             Chicago, IL
Chow, Ms. Sylvia            Bostic Amplifier Inc.                     Harrisburg, PA
Cichocki, Ms. Elizabeth     Valley Community College                  Palos Hill, IL
Clark, Mr. Rich             Assoc. of Realtors                        Chicago, IL
Clough, Ms. Patti           Reston Railway                            Chicago, IL
Coley, Mr. John             California Dept. of Insurance             Los Angeles, CA
Connick, Ms. Pat            Central Container Corporation             Chicago, IL
Conron, Ms. Karen B.        L&H Research                              Cincinnati, OH
Cookson, Ms. Michelle       Log Chemical                              Columbus, OH
Crace, Mr. Ron              Von Crump Seafood                         San Diego, CA
Davies, Ms. Leah            International Education Association       Washington, DC
Davis, Mr. Bruce            Semi;Conductor                            Oakland, CA
Dellmonache, Ms. Susan      US Express Corp.                          Fort Lauderdale, FL
Divjak, Ms. Theresa         US Weather Services                       Portland, ME
Dixon, Mr. Matt             Southern Edison                           Sacramento, CA
Dixon, Ms. Julie            Townsend Services                         Englewood, CO
Droddy, Mr. Steve           Allied Wood Corporation                   Nashville, TN
Dyer, Ms. Debra             Cetadyne Technologies                     Los Angeles, CA
Eckman, Mr. David           Grimm R&D                                 San Diego, CA
Edmonds, Mr. Neil           Montague Pharmaceuticals                  Summit, NJ
Edwards, Mr. Charles        Gorman Tire Corp.                         Akron, OH
Edwards, Ms. Kathy          Allied Wood Corporation                   Nashville, TN
Edwards, Ms. Sonia          Animal Hospital                           San Diego, CA
Elsins, Ms. Marisa F.       SSS Inc.                                  Annapolis, MD
Ferraro, Mr. Mark           Quantum Corporation                       Dallas, TX
Fink, Mr. Anthony           ACDD                                      St. Louis, MO
Fletcher, Mr. Nick          Pepson Manufacturing                      Albany, NY
Gandy, Dr. David            Paralegal Assoc.                          Austin, TX
Garrett, Mr. Tom            Reston Railway                            Chicago, IL
Garza, Ms. Cheryl           Admiral Research & Development Co.        Irvine, CA
Gash, Ms. Hedy              QA Information Systems Center             San Francisco, CA
Geatz, Mr. Patrick D.       San Juan Gas and Electric                 San Juan, PR
Gemelos, Mr. Jerry          Atlantic Airways, Inc.                    Atlanta, GA
Goyette, Mr. Lawrence       Headstrong Tire Corp.                     Torrington, CT
Graf, Ms. Margaret          Wood Surfaces Inc.                        Richmond, VA
Green, Mr. Pat              K&P Products                              Oakland, CA
Greep, Ms. Jennifer         K&P Products                              Oakland, CA
Griffin, Mr. Jim            Housers S&L                               Salinas, CA
Griffin, Mr. Lantz          Quantum Corporation                       Dallas, TX
Guay, Ms. Suzanne           U.S. Foreign Trade Assoc.                 Washington, DC
Hall, Ms. Sharon            Cetadyne Technologies                     Los Angeles, CA
Hamilton, Mr. Paul          Imperial Steel                            San Diego, CA
Hamilton, Ms. Alicia        Security Trust Corp.                      San Francisco, CA
Hamlet, Ms. Mary Ellen      First Bank of the Midwest                 Chicago, IL
Harrell, Mr. Ken            Information Mart                          Chicago, IL
Haubold, Ms. Ann            Reston Railway                            Chicago, IL
Hause, Mr. Manuel           Facsimile Holography                      Milwaukee, WI
Hickel, Mr. Douglas         Towncorp Savings of Illinois              Chicago, IL
Higgins, Ms. Anne           San Juan Gas and Electric                 San Juan, PR
Hill, Mr. Paul              Log Chemical                              Columbus, OH
Hipps, Mr. Rich             Assoc. of Realtors                        Chicago, IL
Hodge, Ms. Rita             Wilbur Wright Air Force Base              Mansfield, OH
Holbrook, Ms. Amy           Wooster Chemical                          Midland, MI
Howell, Mr. Jody            Reston Railway                            Chicago, IL
Hudock, Ms. Cathy           So. Cal. Medical Center                   San Diego, CA
Huels, Ms. Mary Frances     Basic Home Services                       Tarrytown, NY
Hurt, Ms. Kristen           Federated Bank                            Chicago, IL
Jacklin, Mr. Lantz          Quantum Corporation                       Dallas, TX
James, Ms. Anne             San Juan Gas and Electric                 San Juan, PR
Johnson, Mr. Todd           K&P Products                              Oakland, CA
Keever, Ms. Linda           Crossbow of California                    Oakland, CA
Kelley, Ms. Gail            Crossbow of California                    Oakland, CA
Kelly, Ms. Tamara           Cetadyne Technologies                     Los Angeles, CA
Kempster, Mr. Bob           Ronalds Corp.                             Oak Brook, IL
Kendig, Mr. James           Rocks International                       Phoenix, AZ
Kendig, Ms. Linda           Crossbow of California                    Oakland, CA
Kimble, Mr. John            Alforone Chemical                         St. Louis, MO
Kimpel, Ms. Janet           Roll Packaged Foods                       San Jose, CA
Kiraly, Mr. Bill            Washington International Corp.            Fort Wayne, IN
Kling, Mr. Kelly            NBA Insurance Co.                         Chicago, IL
Knight, Ms. Susan           K&P Products                              Oakland, CA
Kochen, Mr. Dennis          Reston Railway                            Chicago, IL
Koleff, Mr. Jim             Emulate Research                          Costa Mesa, CA
Kroeger, Ms. Beulah         Contractual Arbitrators                   Sacramento, CA
Kukenis, Ms. Valerie        USRRB                                     Chicago, IL
Laiken, Mr. Jim             Lorus Toy Co.                             Chicago, IL
Langballe, Mr. Ron          Dunnely Consultants                       Hamilton, ON
Larocque, Mr. Bret          Physicians IPA                            Phoenix, AZ
Lawee, Mr. Jackie           Special Services                          Oak Brook, IL
Ledford, Mr. Craig          Emulate Research                          Costa Mesa, CA
Lehmeyer, Ms. Jean          K&P Products                              Oakland, CA
Leon, Mr. Quinton           Dept. of Defense                          Washington, DC
Lewanwowski, Mr. Dale R.    US Forest Service                         Portland, OR
Licht, Mr. Bryan            SII                                       Edwardsville, IL
Liermann, Ms. Virginia      Metric Corp.                              Elkhart, IN
Lochbihler Mr. Mark         K&P Products                              Oakland, CA
Love, Mr. Michael           HIASIA                                    Houston, TX
Love, Ms. Cora              Polysteel Inc.                            Ogden, UT
Maurus, Mr. John            Howard Aircraft                           Buena Park, CA
McCoy, Mr. Phil             Donnelly Corp.                            Allentown, PA
McCoy, Ms. Gail             Crossbow of California                    Oakland, CA
McGillivray, Ms. Kathy      Allied Wood Corporation                   Nashville, TN
McKnight, Ms. Maureen E.    Federated Bank                            Chicago, IL
McLaughlin, Ms. Amy         Wooster Chemical                          Midland, MI
Merenstein, Mr. W.          Dunnely Consultants                       Hamilton, ON
Micheaux, Mr. John          Emulate Research                          Costa Mesa, CA
Mietlinski, Mr. Rich        Farmers Equity Assn.                      Omaha, NE
Mikles, Ms. Wendy           Southern Gas Co.                          Los Angeles, CA
Montgomery, Mr. Jeff        Bonstell Electronics                      Indianapolis, IN
Moore, Mr. John             California Dept. of Insurance             Los Angeles, CA
Moorman, Mr. Christopher    Facsimile Holography                      Milwaukee, WI
Morgan, Mr. Tommy           Autoloading Corp                          San Ramon, CA
Morgan, Ms. Kathy           Animal Hospital                           San Diego, CA
Muir, Mr. Anthony           NRCA-Central Region Office                St. Louis, MO
Myers, Mr. Fred             K&P Products                              Oakland, CA
Nandy, Ms. Brenda           K&P Products                              Oakland, CA
Newell, Mr. Paul            Log Chemical                              Columbus, OH
Ng, Mr. John                Board of Contractors                      Atlanta, GA
Nicholson, Ms. Elizabeth    Silver, Sachs & Co.                       New York, NY
Norton, Ms. Suzanne M.      Glimmer Cosmetics                         El Segundo, CA
O'Manique, Mr. Jon          International Cologen Res. Ctr.           Fort Collins, CO
O'Savio, Mr. Arnold Paul    K&P Products                              Oakland, CA
Owens, Mr. David            K&P Products                              Oakland, CA
Page, Mr. Scott             Applied Technologies                      Waukesha, WI
Pancoast, Ms. Jane          Chase Information Technology              Detroit, MI
Parker, Mr. Robert          SMASH Hardware Inc.                       Bozeman, MT
Paterson, Mr. Mark          Trader's Clearing House                   Chicago, IL
Patterson, Mr. Greg         Park Health Management                    Park Ridge, IL
Peavey, Ms. Judith          Facsimile Holography                      Milwaukee, WI
Peterson, Ms. Julie         Chase Information Technology              Detroit, MI
Pickens, Mr. Phillip        Ketchum Water and Power                   San Francisco, CA
Pickens, Ms. Margaret       Semi;Conductor                            Oakland, CA
Pilkenton, Ms. Sandra       US Treasury                               Washington, DC
Pledger, Ms. Terri          Candide Corporation                       Los Angeles, CA
Pressnall, Ms. Rona         Hearit Telecommunications                 Washington, DC
Principe, Mr. Ed            K&P Products                              Oakland, CA
Purvis, Mr. Michael         Roam Publishers                           Philadelphia, PA
Ramsey, Ms. Kathleen        Pacific Solid State Corp.                 Seattle, WA
Ray, Ms. Mary Frances       Basic Home Services                       Tarrytown, NY
Right, Ms. Tina             Olivier National Labs.                    Raleigh, NC
Ross, Ms. Cathy             So. Cal. Medical Center                   San Diego, CA
Rubin, Mr. Jimmie           National Immunology Laboratory            Birmingham, AL
Rubin, Ms. Naree            Paragon Pharmaceuticals                   Princeton, NJ
Rusnak, Ms. Mona            Rhodan Protection                         Des Plaines, IL
Sanders, Ms. Julie          Snowing Petroleum Services                New Orleans, LA
Sankey, Mr. Ken             NBA Insurance Co.                         Chicago, IL
Scannell, Ms. Robin         Amberly Corp.                             Fullerton, CA
Schier, Ms. Joan            Olivier National Labs.                    Raleigh, NC
Schwoebel, Mr. Roger        WAVCOMP                                   Pensacola, FL
Seitz, Mr. Adam             Lomax Services                            Chicago, IL
Shere, Mr. Brian            Trader's Clearing House                   Chicago, IL
Sheridan, Ms. Debra         Genetics Pharmaceuticals                  San Diego, CA
Shew, Ms. Marguerite        SSS Inc.                                  Annapolis, MD
Shipman, Ms. Jan            Southern Edison Co.                       Sacramento, CA
Short, Ms. Nancy            ABC, Inc.                                 Santa Clara, CA
Simon, Mr. David            Log Chemical                              Columbus, OH
Smith, Mr. Anthony          Candide Corporation                       Los Angeles, CA
Smith, Mr. Jack             Reston Railway                            Chicago, IL
Smith, Ms. Donna            Trader's Clearing House                   Chicago, IL
Smith, Ms. Jan              Reston Railway                            Chicago, IL
Snell, Dr. William J.       US Treasury                               Washington, DC
Stackhouse, Ms. Loretta     Donnelly Corp.                            Allentown, PA
Stebel, Mr. Thomas C.       Roam Publishers                           Philadelphia, PA
Stewart, Ms. Lora           Sandlot Enterprises                       San Diego, CA
Strah, Ms. Sonia            California Dept. of Insurance             Los Angeles, CA
Stromness, Ms. Mary         Housers S&L                               Salinas, CA
Sukumoljan, Mr. Robert      San Juan Gas and Electric                 San Juan, PR
Sulzbach, Mr. Bill          Sailbest Ships                            San Diego, CA
Sumner, Mr. Kenneth         NBAInsurance                              Chicago, IL
Swayze, Mr. Rodney          Reston Railway                            Chicago, IL
Taylor, Mr. Greg            Smash Consulting                          Decatur, IL
Trager, Ms. Pat             Family Support International              Washington, DC
Trice, Mr. Mike             Coastal Steel                             Chicago, IN
Truell, Ms. Joleen          Reston Railway                            Chicago, IL
Turner, Ms. Barbara         Gravely Finance Center                    Cleveland, OH
Upchurch, Ms. Holly         Sun Marketing                             Philadelphia, PA
Valeri, Mr. Marshall        SMASH Hardware Inc.                       Bozeman, MT
Vandenberg, Mr. Kurt        Northern Aircraft Division                Hawthorne, CA
Vandenberg, Ms. Susan       Paxson Autos                              Cupertino, CA
Varmha, Mr. Peter           Power Corporation                         Madison, WI
Visniski, Ms. Tracy         Washington Transit Authority              Washington, DC
Voboril, Mr. Jim            SMASH Hardware Inc.                       Bozeman, MT
Wallace, Mr. Jules          Reston Railway                            Chicago, IL
Walls, Mr. Curtis           Southern Edison Co.                       Sacramento, CA
Wang, Mr. David             Log Chemical                              Columbus, OH
Washington, Mr. Robert      Federal Lankmarks                         Washington, DC
Watts, Ms. Norma            Coastal Steel                             Chicago, IN
Wells, Mr. Roy              Gravy Finance Center                      Cleveland, OH
Williams, Mr. Gene          Snowing Petroleum                         New Orleans, LA
Williams, Mr. Gregory       US Treasury                               Washington, DC
Wilson, Mr. Vic             Gothambank                                New York, NY
Wingo, Mr. Jim              Rush Transit Comp.                        Chicago, IL
Woods, Mr. Joseph           Federal Landmarks                         Washington, DC
Wurzelbacher, Mr. Phil      Al's Discount Clothing                    Washington, DC
Young, Ms. Hedy             QA Information Systems Center             San Francisco, CA
Ziegler, Mr. David          US Express Corp.                          Fort Lauderdale, FL
;;;;
run;

data sasuser.schedule;
   input Course_Number 1-2 Course_Code $ 4-7 Location $ 9-15
         @17 Begin_Date date9. Teacher $ 27-47;
   format course_number 2. begin_date date9. location 15.;
   label course_code = 'Course Code'
         course_number = 'Course Number'
         begin_date = 'Begin'
         location = 'Location'
         teacher = 'Instructor';
   datalines;
 1 C001 Seattle 23OCT2000 Hallis, Dr. George
 2 C002 Dallas  04DEC2000 Wickam, Dr. Alice
 3 C003 Boston  08JAN2001 Forest, Mr. Peter
 4 C004 Seattle 22JAN2001 Tally, Ms. Julia
 5 C005 Dallas  26FEB2001 Hallis, Dr. George
 6 C006 Boston  02APR2001 Berthan, Ms. Judy
 7 C001 Dallas  21MAY2001 Hallis, Dr. George
 8 C002 Boston  11JUN2001 Wickam, Dr. Alice
 9 C003 Seattle 16JUL2001 Forest, Mr. Peter
10 C004 Dallas  13AUG2001 Tally, Ms. Julia
11 C005 Boston  17SEP2001 Tally, Ms. Julia
12 C006 Seattle 01OCT2001 Berthan, Ms. Judy
13 C001 Boston  12NOV2001 Hallis, Dr. George
14 C002 Seattle 03DEC2001 Wickam, Dr. Alice
15 C003 Dallas  07JAN2002 Forest, Mr. Peter
16 C004 Boston  21JAN2002 Tally, Ms. Julia
17 C005 Seattle 25FEB2002 Hallis, Dr. George
18 C006 Dallas  25MAR2002 Berthan, Ms. Judy
;
run;


data sasuser.courses;
   input Course_Code $ 1-4 Course_Title $ 6-30 Days 32 Fee 34-37;
   format fee dollar5. days 1.;
   label course_code = 'Course Code'
         course_title = 'Description'
         days = 'Course Length'
         fee = 'Course Fee';
   datalines;
C001 Basic Telecommunications  3  795
C002 Structured Query Language 4 1150
C003 Local Area Networks       3  650
C004 Database Design           2  375
C005 Artificial Intelligence   2  400
C006 Computer Aided Design     5 1600
;
run;


data sasuser.register;
   input Student_Name $ 1-25 Course_Number 31-32 Paid $ 41;
   format course_number 2.;
   label course_number = 'Course Number'
         paid = 'Paid Status'
         student_name = 'Student Name';
   datalines;
Albritton, Mr. Bryan           1        Y
Amigo, Mr. Bill                1        N
Chodnoff, Mr. Norman           1        Y
Clark, Mr. Rich                1        Y
Crace, Mr. Ron                 1        Y
Dellmonache, Ms. Susan         1        Y
Dixon, Mr. Matt                1        Y
Edwards, Mr. Charles           1        N
Edwards, Ms. Sonia             1        Y
Elsins, Ms. Marisa F.          1        Y
Griffin, Mr. Lantz             1        Y
Hall, Ms. Sharon               1        Y
Haubold, Ms. Ann               1        N
Hodge, Ms. Rita                1        N
Knight, Ms. Susan              1        Y
Koleff, Mr. Jim                1        Y
Laiken, Mr. Jim                1        Y
McGillivray, Ms. Kathy         1        N
Merenstein, Mr. W.             1        Y
Pancoast, Ms. Jane             1        N
Sumner, Mr. Kenneth            1        Y
Washington, Mr. Robert         1        Y
Wurzelbacher, Mr. Phil         1        Y
Amigo, Mr. Bill                2        Y
Benincasa, Ms. Elizabeth       2        Y
Brown, Mr. Michael             2        Y
Divjak, Ms. Theresa            2        N
Edwards, Ms. Kathy             2        Y
Gandy, Dr. David               2        N
Hamilton, Ms. Alicia           2        Y
Harrell, Mr. Ken               2        N
Hill, Mr. Paul                 2        N
Holbrook, Ms. Amy              2        Y
James, Ms. Anne                2        Y
Kelly, Ms. Tamara              2        Y
Kling, Mr. Kelly               2        Y
Langballe, Mr. Ron             2        Y
Lewanwowski, Mr. Dale R.       2        N
Liermann, Ms. Virginia         2        Y
Nandy, Ms. Brenda              2        N
Ng, Mr. John                   2        N
Owens, Mr. David               2        Y
Shere, Mr. Brian               2        Y
Smith, Mr. Anthony             2        Y
Valeri, Mr. Marshall           2        Y
Watts, Ms. Norma               2        Y
Williams, Mr. Gene             2        N
Bills, Ms. Paulette            3        Y
Chevarley, Ms. Arlene          3        N
Clough, Ms. Patti              3        N
Crace, Mr. Ron                 3        Y
Davis, Mr. Bruce               3        Y
Elsins, Ms. Marisa F.          3        N
Gandy, Dr. David               3        Y
Gash, Ms. Hedy                 3        Y
Haubold, Ms. Ann               3        Y
Hudock, Ms. Cathy              3        Y
Kimble, Mr. John               3        N
Kochen, Mr. Dennis             3        Y
Larocque, Mr. Bret             3        Y
Licht, Mr. Bryan               3        Y
McKnight, Ms. Maureen E.       3        Y
Scannell, Ms. Robin            3        N
Seitz, Mr. Adam                3        Y
Smith, Ms. Jan                 3        N
Sulzbach, Mr. Bill             3        Y
Williams, Mr. Gene             3        Y
Bates, Ms. Ellen               4        Y
Boyd, Ms. Leah                 4        Y
Chan, Mr. John                 4        Y
Chevarley, Ms. Arlene          4        Y
Chow, Ms. Sylvia               4        N
Crace, Mr. Ron                 4        Y
Edwards, Mr. Charles           4        N
Garza, Ms. Cheryl              4        Y
Geatz, Mr. Patrick D.          4        Y
Keever, Ms. Linda              4        Y
Kelley, Ms. Gail               4        Y
Kendig, Mr. James              4        Y
Kimble, Mr. John               4        Y
Koleff, Mr. Jim                4        N
Montgomery, Mr. Jeff           4        N
Moore, Mr. John                4        Y
Page, Mr. Scott                4        Y
Parker, Mr. Robert             4        Y
Pledger, Ms. Terri             4        N
Snell, Dr. William J.          4        Y
Stackhouse, Ms. Loretta        4        Y
Sulzbach, Mr. Bill             4        Y
Swayze, Mr. Rodney             4        Y
Varmha, Mr. Peter              4        N
Visniski, Ms. Tracy            4        Y
Voboril, Mr. Jim               4        N
Ziegler, Mr. David             4        Y
Albritton, Mr. Bryan           5        Y
Babbitt, Mr. Bill              5        Y
Blayney, Ms. Vivian            5        N
Chavez, Ms. Louise             5        Y
Connick, Ms. Pat               5        Y
Davies, Ms. Leah               5        Y
Davis, Mr. Bruce               5        N
Edwards, Mr. Charles           5        Y
Edwards, Ms. Kathy             5        Y
Griffin, Mr. Jim               5        Y
Hickel, Mr. Douglas            5        N
Higgins, Ms. Anne              5        Y
Kiraly, Mr. Bill               5        Y
Lehmeyer, Ms. Jean             5        N
Lochbihler Mr. Mark            5        Y
Micheaux, Mr. John             5        Y
Montgomery, Mr. Jeff           5        N
Patterson, Mr. Greg            5        Y
Peterson, Ms. Julie            5        N
Rubin, Mr. Jimmie              5        N
Shipman, Ms. Jan               5        N
Short, Ms. Nancy               5        Y
Stewart, Ms. Lora              5        N
Sukumoljan, Mr. Robert         5        Y
Wang, Mr. David                5        Y
Abramson, Ms. Andrea           6        N
Brown, Mr. Michael             6        N
Crace, Mr. Ron                 6        N
Davis, Mr. Bruce               6        Y
Dixon, Ms. Julie               6        N
Droddy, Mr. Steve              6        N
Edmonds, Mr. Neil              6        Y
James, Ms. Anne                6        Y
Keever, Ms. Linda              6        N
Kiraly, Mr. Bill               6        Y
Kochen, Mr. Dennis             6        N
Lawee, Mr. Jackie              6        N
Ledford, Mr. Craig             6        Y
Leon, Mr. Quinton              6        Y
McGillivray, Ms. Kathy         6        Y
McLaughlin, Ms. Amy            6        Y
O'Savio, Mr. Arnold Paul       6        Y
Owens, Mr. David               6        Y
Rubin, Mr. Jimmie              6        Y
Rusnak, Ms. Mona               6        N
Seitz, Mr. Adam                6        Y
Smith, Mr. Jack                6        Y
Smith, Ms. Donna               6        Y
Trice, Mr. Mike                6        N
Voboril, Mr. Jim               6        Y
Washington, Mr. Robert         6        Y
Wells, Mr. Roy                 6        Y
Avakian, Mr. Don               7        Y
Babbitt, Mr. Bill              7        N
Bates, Ms. Ellen               7        Y
Burns, Ms. Karen               7        Y
Chan, Mr. John                 7        Y
Coley, Mr. John                7        N
Davies, Ms. Leah               7        Y
Gemelos, Mr. Jerry             7        Y
Keever, Ms. Linda              7        Y
Lawee, Mr. Jackie              7        Y
Leon, Mr. Quinton              7        Y
Montgomery, Mr. Jeff           7        Y
Paterson, Mr. Mark             7        Y
Peavey, Ms. Judith             7        Y
Sanders, Ms. Julie             7        N
Truell, Ms. Joleen             7        Y
Vandenberg, Mr. Kurt           7        N
Wilson, Mr. Vic                7        Y
Baker, Mr. Vincent             8        Y
Blayney, Ms. Vivian            8        Y
Boyd, Ms. Leah                 8        Y
Chevarley, Ms. Arlene          8        Y
Coley, Mr. John                8        Y
Crace, Mr. Ron                 8        Y
Garza, Ms. Cheryl              8        Y
Hamilton, Mr. Paul             8        Y
Huels, Ms. Mary Frances        8        Y
Kendig, Ms. Linda              8        N
Knight, Ms. Susan              8        Y
Koleff, Mr. Jim                8        Y
Leon, Mr. Quinton              8        N
Lochbihler Mr. Mark            8        Y
Nicholson, Ms. Elizabeth       8        Y
Purvis, Mr. Michael            8        N
Ramsey, Ms. Kathleen           8        N
Shipman, Ms. Jan               8        Y
Sulzbach, Mr. Bill             8        Y
Woods, Mr. Joseph              8        N
Divjak, Ms. Theresa            9        Y
Edwards, Mr. Charles           9        Y
Ferraro, Mr. Mark              9        Y
Garrett, Mr. Tom               9        N
Graf, Ms. Margaret             9        Y
Greep, Ms. Jennifer            9        Y
Griffin, Mr. Lantz             9        Y
Hamilton, Mr. Paul             9        Y
Hodge, Ms. Rita                9        Y
Holbrook, Ms. Amy              9        Y
Howell, Mr. Jody               9        N
James, Ms. Anne                9        Y
Koleff, Mr. Jim                9        Y
Kroeger, Ms. Beulah            9        N
Ledford, Mr. Craig             9        Y
Love, Ms. Cora                 9        Y
Maurus, Mr. John               9        Y
Micheaux, Mr. John             9        Y
Montgomery, Mr. Jeff           9        Y
Nandy, Ms. Brenda              9        Y
O'Savio, Mr. Arnold Paul       9        Y
Peterson, Ms. Julie            9        Y
Pilkenton, Ms. Sandra          9        N
Pressnall, Ms. Rona            9        Y
Sumner, Mr. Kenneth            9        N
Valeri, Mr. Marshall           9        Y
Wang, Mr. David                9        Y
Woods, Mr. Joseph              9        Y
Wurzelbacher, Mr. Phil         9        Y
Young, Ms. Hedy                9        Y
Abramson, Ms. Andrea          10        Y
Amigo, Mr. Bill               10        Y
Benincasa, Ms. Elizabeth      10        Y
Carty, Mr. Howard             10        Y
Coley, Mr. John               10        Y
Davis, Mr. Bruce              10        Y
Divjak, Ms. Theresa           10        Y
Gandy, Dr. David              10        Y
Gash, Ms. Hedy                10        Y
Greep, Ms. Jennifer           10        N
Harrell, Mr. Ken              10        Y
Hickel, Mr. Douglas           10        Y
Lochbihler Mr. Mark           10        Y
Love, Mr. Michael             10        Y
McCoy, Ms. Gail               10        Y
Muir, Mr. Anthony             10        Y
Peterson, Ms. Julie           10        Y
Ramsey, Ms. Kathleen          10        Y
Sankey, Mr. Ken               10        Y
Schwoebel, Mr. Roger          10        Y
Smith, Mr. Anthony            10        Y
Stewart, Ms. Lora             10        Y
Upchurch, Ms. Holly           10        N
Belles, Ms. Vicki             11        Y
Bills, Ms. Paulette           11        Y
Carty, Mr. Howard             11        Y
Cookson, Ms. Michelle         11        Y
Elsins, Ms. Marisa F.         11        Y
Garza, Ms. Cheryl             11        N
Greep, Ms. Jennifer           11        Y
Hause, Mr. Manuel             11        Y
Hudock, Ms. Cathy             11        Y
Kelly, Ms. Tamara             11        Y
Love, Mr. Michael             11        Y
Love, Ms. Cora                11        Y
McCoy, Mr. Phil               11        Y
Moorman, Mr. Christopher      11        N
Ng, Mr. John                  11        Y
Pickens, Ms. Margaret         11        N
Right, Ms. Tina               11        N
Rubin, Ms. Naree              11        Y
Sheridan, Ms. Debra           11        Y
Shew, Ms. Marguerite          11        N
Sumner, Mr. Kenneth           11        Y
Swayze, Mr. Rodney            11        N
Truell, Ms. Joleen            11        N
Upchurch, Ms. Holly           11        N
Vandenberg, Ms. Susan         11        Y
Washington, Mr. Robert        11        Y
Williams, Mr. Gregory         11        Y
Wingo, Mr. Jim                11        N
Blayney, Ms. Vivian           12        Y
Dellmonache, Ms. Susan        12        Y
Edwards, Mr. Charles          12        N
Ferraro, Mr. Mark             12        Y
Gemelos, Mr. Jerry            12        Y
Goyette, Mr. Lawrence         12        N
Griffin, Mr. Lantz            12        Y
Hickel, Mr. Douglas           12        Y
Hurt, Ms. Kristen             12        Y
Larocque, Mr. Bret            12        Y
Liermann, Ms. Virginia        12        Y
Lochbihler Mr. Mark           12        Y
Love, Ms. Cora                12        N
Nandy, Ms. Brenda             12        Y
Pickens, Mr. Phillip          12        Y
Ramsey, Ms. Kathleen          12        Y
Rubin, Ms. Naree              12        Y
Short, Ms. Nancy              12        Y
Williams, Mr. Gregory         12        Y
Woods, Mr. Joseph             12        Y
Allen, Ms. Denise             13        Y
Blayney, Ms. Vivian           13        Y
Brown, Mr. Michael            13        Y
Chavez, Ms. Louise            13        N
Cichocki, Ms. Elizabeth       13        Y
Conron, Ms. Karen B.          13        Y
Ferraro, Mr. Mark             13        Y
Fink, Mr. Anthony             13        Y
Gash, Ms. Hedy                13        Y
Graf, Ms. Margaret            13        Y
Green, Mr. Pat                13        Y
Hamilton, Mr. Paul            13        Y
Holbrook, Ms. Amy             13        Y
Johnson, Mr. Todd             13        Y
Kelly, Ms. Tamara             13        Y
Parker, Mr. Robert            13        Y
Purvis, Mr. Michael           13        Y
Ross, Ms. Cathy               13        Y
Schwoebel, Mr. Roger          13        Y
Shew, Ms. Marguerite          13        N
Smith, Mr. Anthony            13        Y
Stromness, Ms. Mary           13        N
Swayze, Mr. Rodney            13        Y
Taylor, Mr. Greg              13        Y
Trager, Ms. Pat               13        Y
Valeri, Mr. Marshall          13        Y
Williams, Mr. Gene            13        N
Wingo, Mr. Jim                13        Y
Alamutu, Ms. Julie            14        N
Avakian, Mr. Don              14        N
Chow, Ms. Sylvia              14        Y
Eckman, Mr. David             14        Y
Fletcher, Mr. Nick            14        N
Garrett, Mr. Tom              14        Y
Gemelos, Mr. Jerry            14        Y
Griffin, Mr. Jim              14        Y
Hall, Ms. Sharon              14        N
Hamlet, Ms. Mary Ellen        14        Y
Jacklin, Mr. Lantz            14        Y
Kendig, Mr. James             14        Y
Kimpel, Ms. Janet             14        Y
Kiraly, Mr. Bill              14        Y
Laiken, Mr. Jim               14        Y
McCoy, Ms. Gail               14        Y
Merenstein, Mr. W.            14        Y
Micheaux, Mr. John            14        Y
Mietlinski, Mr. Rich          14        Y
Moore, Mr. John               14        Y
Newell, Mr. Paul              14        Y
O'Manique, Mr. Jon            14        Y
O'Savio, Mr. Arnold Paul      14        Y
Pickens, Ms. Margaret         14        Y
Ray, Ms. Mary Frances         14        Y
Scannell, Ms. Robin           14        Y
Short, Ms. Nancy              14        Y
Smith, Ms. Donna              14        Y
Swayze, Mr. Rodney            14        N
Turner, Ms. Barbara           14        N
Vandenberg, Ms. Susan         14        Y
Voboril, Mr. Jim              14        Y
Wurzelbacher, Mr. Phil        14        N
Chavez, Ms. Louise            15        Y
Edwards, Ms. Kathy            15        Y
Garza, Ms. Cheryl             15        Y
Gemelos, Mr. Jerry            15        Y
Green, Mr. Pat                15        N
Hipps, Mr. Rich               15        N
Kiraly, Mr. Bill              15        Y
Knight, Ms. Susan             15        Y
Leon, Mr. Quinton             15        N
Lewanwowski, Mr. Dale R.      15        Y
McCoy, Mr. Phil               15        Y
Mikles, Ms. Wendy             15        N
Morgan, Ms. Kathy             15        N
Norton, Ms. Suzanne M.        15        Y
Ray, Ms. Mary Frances         15        Y
Right, Ms. Tina               15        N
Schier, Ms. Joan              15        Y
Smith, Mr. Anthony            15        Y
Smith, Ms. Donna              15        Y
Stebel, Mr. Thomas C.         15        Y
Voboril, Mr. Jim              15        Y
Wallace, Mr. Jules            15        Y
Williams, Mr. Gregory         15        N
Ziegler, Mr. David            15        N
Brown, Mr. Michael            16        Y
Clough, Ms. Patti             16        Y
Droddy, Mr. Steve             16        Y
Ferraro, Mr. Mark             16        Y
Garrett, Mr. Tom              16        N
Green, Mr. Pat                16        Y
Hodge, Ms. Rita               16        Y
Huels, Ms. Mary Frances       16        Y
James, Ms. Anne               16        Y
Kempster, Mr. Bob             16        Y
Kukenis, Ms. Valerie          16        Y
Lehmeyer, Ms. Jean            16        N
Lewanwowski, Mr. Dale R.      16        Y
Morgan, Mr. Tommy             16        N
Myers, Mr. Fred               16        Y
Ng, Mr. John                  16        Y
Owens, Mr. David              16        Y
Patterson, Mr. Greg           16        Y
Shere, Mr. Brian              16        N
Shew, Ms. Marguerite          16        Y
Simon, Mr. David              16        Y
Taylor, Mr. Greg              16        Y
Trager, Ms. Pat               16        Y
Truell, Ms. Joleen            16        N
Walls, Mr. Curtis             16        N
Wang, Mr. David               16        N
Woods, Mr. Joseph             16        N
Dyer, Ms. Debra               17        N
Fletcher, Mr. Nick            17        Y
Hamilton, Mr. Paul            17        N
Haubold, Ms. Ann              17        N
Holbrook, Ms. Amy             17        N
Kendig, Mr. James             17        N
Laiken, Mr. Jim               17        N
Leon, Mr. Quinton             17        Y
McGillivray, Ms. Kathy        17        Y
McLaughlin, Ms. Amy           17        Y
Moore, Mr. John               17        Y
Nandy, Ms. Brenda             17        Y
Principe, Mr. Ed              17        Y
Ray, Ms. Mary Frances         17        Y
Scannell, Ms. Robin           17        Y
Smith, Mr. Jack               17        Y
Sulzbach, Mr. Bill            17        Y
Williams, Mr. Gene            17        Y
Amigo, Mr. Bill               18        Y
Babbitt, Mr. Bill             18        Y
Bates, Ms. Ellen              18        Y
Benincasa, Ms. Elizabeth      18        Y
Blair, Mr. Paul               18        Y
Cookson, Ms. Michelle         18        Y
Dyer, Ms. Debra               18        Y
Elsins, Ms. Marisa F.         18        Y
Guay, Ms. Suzanne             18        Y
Huels, Ms. Mary Frances       18        Y
McCoy, Ms. Gail               18        Y
Parker, Mr. Robert            18        Y
Pickens, Ms. Margaret         18        Y
Ross, Ms. Cathy               18        Y
Stebel, Mr. Thomas C.         18        Y
Strah, Ms. Sonia              18        Y
Turner, Ms. Barbara           18        Y
Walls, Mr. Curtis             18        Y
Ziegler, Mr. David            18        Y
;
run;


proc sql;
   create view sasuser.all as
      select students.student_name,
             schedule.course_number,
             paid, courses.course_code,
             location, begin_date,
             teacher, course_title, days, fee,
             student_company, city_state
         from sasuser.schedule, sasuser.students,
              sasuser.register, sasuser.courses
         where schedule.course_code =
               courses.course_code and
               schedule.course_number =
               register.course_number and
               students.student_name =
               register.student_name
         order by students.student_name,
                  courses.course_code;
quit;


%let text1=%str( Sample data sets and files are ready.);
%put;
%put &text1;
%put;

options source notes;