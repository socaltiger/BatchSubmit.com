**** define common SAS setings;
%include 'common.sas';

%common

**** INPUT SAMPLE LABORATORY DATA;
data source.labs;
label subject      = "Subject Number"
      month        = "Month: 0=baseline, 1=3 months, 2 =6 months"
      labcat       = "Category for Lab Test"
      labtest      = "Laboratory Test"
      colunits     = "Collected Units"
      nresult      = "Numeric Result"
      lownorm      = "Normal Range Lower Limit"
      highnorm     = "Normal Range Upper Limit"
      labdate      = "Date of Lab Test"
      uniqueid = "Company Wide Subject ID";
format labdate mmddyy10.;
input subject 1-3 month 6 labcat $ 9-18 labtest $ 20-30
      colunits $ 32-36 nresult 38-41 lownorm 45-48 highnorm 52-55 +1 labdate mmddyy10.;
uniqueid = 'UNI' || put(subject,3.);
datalines;
101  0  HEMATOLOGY HEMATOCRIT  %     31     35     49   04/02/2010
101  1  HEMATOLOGY HEMATOCRIT  %     39     35     49   07/03/2010
101  2  HEMATOLOGY HEMATOCRIT  %     44     35     49   10/10/2010
101  0  HEMATOLOGY HEMOGLOBIN  g/dL  11.5   11.7   15.9 04/02/2010
101  1  HEMATOLOGY HEMOGLOBIN  g/dL  13.2   11.7   15.9 07/03/2010
101  2  HEMATOLOGY HEMOGLOBIN  g/dL  14.3   11.7   15.9 10/10/2010
101  0  CHEMISTRY  AST (SGOT)  IU/L  12     10     34   04/02/2010
101  1  CHEMISTRY  AST (SGOT)  IU/L  40     10     34   07/03/2010
101  2  CHEMISTRY  AST (SGOT)  IU/L  44     10     34   10/10/2010
101  0  CHEMISTRY  ALT (SGPT)  IU/L  10     5      35   04/02/2010
101  1  CHEMISTRY  ALT (SGPT)  IU/L  22     5      35   07/03/2010
101  2  CHEMISTRY  ALT (SGPT)  IU/L  33     5      35   10/10/2010
101  0  CHEMISTRY  ALK. PHOS.  IU/L  33     20     140  04/02/2010
101  1  CHEMISTRY  ALK. PHOS.  IU/L  49     20     140  07/03/2010
101  2  CHEMISTRY  ALK. PHOS.  IU/L  200    20     140  10/10/2010
101  0  CHEMISTRY  GGTP        IU/L  5      0      51   04/02/2010
101  1  CHEMISTRY  GGTP        IU/L  15     0      51   07/03/2010
101  2  CHEMISTRY  GGTP        IU/L  15     0      51   10/10/2010
101  0  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  04/02/2010
101  1  CHEMISTRY  DIRECT BILI mg/dL 0.2    0      0.3  07/03/2010
101  2  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  10/10/2010
101  0  CHEMISTRY  TOTAL BILI  mg/dL 1.0    0.3    1.9  04/02/2010
101  1  CHEMISTRY  TOTAL BILI  mg/dL 0.5    0.3    1.9  07/03/2010
101  2  CHEMISTRY  TOTAL BILI  mg/dL 2.5    0.3    1.9  10/10/2010
101  0  CHEMISTRY  ALBUMIN     g/dL  3.3    3.4    5.4  04/02/2010
101  1  CHEMISTRY  ALBUMIN     g/dL  4.1    3.4    5.4  07/03/2010
101  2  CHEMISTRY  ALBUMIN     g/dL  5.5    3.4    5.4  10/10/2010
101  0  CHEMISTRY  TOTAL PROT  g/dL  6.4    6.0    8.3  04/02/2010
101  1  CHEMISTRY  TOTAL PROT  g/dL  7.0    6.0    8.3  07/03/2010
101  2  CHEMISTRY  TOTAL PROT  g/dL  8.2    6.0    8.3  10/10/2010
102  0  HEMATOLOGY HEMATOCRIT  %     39     35     49   02/13/2010
102  1  HEMATOLOGY HEMATOCRIT  %     39     35     49   05/10/2010
102  2  HEMATOLOGY HEMATOCRIT  %     44     35     49   08/11/2010
102  0  HEMATOLOGY HEMOGLOBIN  g/dL  11.5   11.7   15.9 02/13/2010
102  1  HEMATOLOGY HEMOGLOBIN  g/dL  13.2   11.7   15.9 05/10/2010
102  2  HEMATOLOGY HEMOGLOBIN  g/dL  18.3   11.7   15.9 08/11/2010
102  0  CHEMISTRY  AST (SGOT)  IU/L  14     10     34   02/13/2010
102  1  CHEMISTRY  AST (SGOT)  IU/L  45     10     34   05/10/2010
102  2  CHEMISTRY  AST (SGOT)  IU/L  34     10     34   08/11/2010
102  0  CHEMISTRY  ALT (SGPT)  IU/L  10     5      35   02/13/2010
102  1  CHEMISTRY  ALT (SGPT)  IU/L  22     5      35   05/10/2010
102  2  CHEMISTRY  ALT (SGPT)  IU/L  36     5      35   08/11/2010
102  0  CHEMISTRY  ALK. PHOS.  IU/L  33     20     140  02/13/2010
102  1  CHEMISTRY  ALK. PHOS.  IU/L  55     20     140  05/10/2010
102  2  CHEMISTRY  ALK. PHOS.  IU/L  150    20     140  08/11/2010
102  0  CHEMISTRY  GGTP        IU/L  20     0      51   02/13/2010
102  1  CHEMISTRY  GGTP        IU/L  25     0      51   05/10/2010
102  2  CHEMISTRY  GGTP        IU/L  25     0      51   08/11/2010
102  0  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  02/13/2010
102  1  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  05/10/2010
102  2  CHEMISTRY  DIRECT BILI mg/dL 0.4    0      0.3  08/11/2010
102  0  CHEMISTRY  TOTAL BILI  mg/dL 1.1    0.3    1.9  02/13/2010
102  1  CHEMISTRY  TOTAL BILI  mg/dL 1.5    0.3    1.9  05/10/2010
102  2  CHEMISTRY  TOTAL BILI  mg/dL 2.5    0.3    1.9  08/11/2010
102  0  CHEMISTRY  ALBUMIN     g/dL  3.3    3.4    5.4  02/13/2010
102  1  CHEMISTRY  ALBUMIN     g/dL  4.1    3.4    5.4  05/10/2010
102  2  CHEMISTRY  ALBUMIN     g/dL  5.2    3.4    5.4  08/11/2010
102  0  CHEMISTRY  TOTAL PROT  g/dL  6.3    6.0    8.3  02/13/2010
102  1  CHEMISTRY  TOTAL PROT  g/dL  7.1    6.0    8.3  05/10/2010
102  2  CHEMISTRY  TOTAL PROT  g/dL  8.3    6.0    8.3  08/11/2010
103  0  HEMATOLOGY HEMATOCRIT  %     54     35     49   05/15/2010
103  1  HEMATOLOGY HEMATOCRIT  %     33     35     49   08/15/2010
103  2  HEMATOLOGY HEMATOCRIT  %     52     35     49   11/15/2010
103  0  HEMATOLOGY HEMOGLOBIN  g/dL  12.5   11.7   15.9 05/15/2010
103  1  HEMATOLOGY HEMOGLOBIN  g/dL  12.2   11.7   15.9 08/15/2010
103  2  HEMATOLOGY HEMOGLOBIN  g/dL  14.3   11.7   15.9 11/15/2010
103  0  CHEMISTRY  AST (SGOT)  IU/L  19     10     34   05/15/2010
103  1  CHEMISTRY  AST (SGOT)  IU/L  41     10     34   08/15/2010
103  2  CHEMISTRY  AST (SGOT)  IU/L  34     10     34   11/15/2010
103  0  CHEMISTRY  ALT (SGPT)  IU/L  13     5      35   05/15/2010
103  1  CHEMISTRY  ALT (SGPT)  IU/L  22     5      35   08/15/2010
103  2  CHEMISTRY  ALT (SGPT)  IU/L  34     5      35   11/15/2010
103  0  CHEMISTRY  ALK. PHOS.  IU/L  33     20     140  05/15/2010
103  1  CHEMISTRY  ALK. PHOS.  IU/L  120    20     140  08/15/2010
103  2  CHEMISTRY  ALK. PHOS.  IU/L  110    20     140  11/15/2010
103  0  CHEMISTRY  GGTP        IU/L  5      0      51   05/15/2010
103  1  CHEMISTRY  GGTP        IU/L  25     0      51   08/15/2010
103  2  CHEMISTRY  GGTP        IU/L  33     0      51   11/15/2010
103  0  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  05/15/2010
103  1  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  08/15/2010
103  2  CHEMISTRY  DIRECT BILI mg/dL 0.2    0      0.3  11/15/2010
103  0  CHEMISTRY  TOTAL BILI  mg/dL 1.1    0.3    1.9  05/15/2010
103  1  CHEMISTRY  TOTAL BILI  mg/dL 1.5    0.3    1.9  08/15/2010
103  2  CHEMISTRY  TOTAL BILI  mg/dL 2.7    0.3    1.9  11/15/2010
103  0  CHEMISTRY  ALBUMIN     g/dL  3.3    3.4    5.4  05/15/2010
103  1  CHEMISTRY  ALBUMIN     g/dL  4.2    3.4    5.4  08/15/2010
103  2  CHEMISTRY  ALBUMIN     g/dL  5.3    3.4    5.4  11/15/2010
103  0  CHEMISTRY  TOTAL PROT  g/dL  6.2    6.0    8.3  05/15/2010
103  1  CHEMISTRY  TOTAL PROT  g/dL  7.1    6.0    8.3  08/15/2010
103  2  CHEMISTRY  TOTAL PROT  g/dL  8.4    6.0    8.3  11/15/2010
104  0  HEMATOLOGY HEMATOCRIT  %     50     35     49   01/02/2010
104  1  HEMATOLOGY HEMATOCRIT  %     42     35     49   04/03/2010
104  2  HEMATOLOGY HEMATOCRIT  %     42     35     49   07/04/2010
104  0  HEMATOLOGY HEMOGLOBIN  g/dL  13.0   11.7   15.9 01/02/2010
104  1  HEMATOLOGY HEMOGLOBIN  g/dL  13.3   11.7   15.9 04/03/2010
104  2  HEMATOLOGY HEMOGLOBIN  g/dL  12.8   11.7   15.9 07/04/2010
104  0  CHEMISTRY  AST (SGOT)  IU/L  22     10     34   01/02/2010
104  1  CHEMISTRY  AST (SGOT)  IU/L  23     10     34   04/03/2010
104  2  CHEMISTRY  AST (SGOT)  IU/L  22     10     34   07/04/2010
104  0  CHEMISTRY  ALT (SGPT)  IU/L  12     5      35   01/02/2010
104  1  CHEMISTRY  ALT (SGPT)  IU/L  22     5      35   04/03/2010
104  2  CHEMISTRY  ALT (SGPT)  IU/L  23     5      35   07/04/2010
104  0  CHEMISTRY  ALK. PHOS.  IU/L  30     20     140  01/02/2010
104  1  CHEMISTRY  ALK. PHOS.  IU/L  37     20     140  04/03/2010
104  2  CHEMISTRY  ALK. PHOS.  IU/L  100    20     140  07/04/2010
104  0  CHEMISTRY  GGTP        IU/L  34     0      51   01/02/2010
104  1  CHEMISTRY  GGTP        IU/L  22     0      51   04/03/2010
104  2  CHEMISTRY  GGTP        IU/L  34     0      51   07/04/2010
104  0  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  01/02/2010
104  1  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  04/03/2010
104  2  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  07/04/2010
104  0  CHEMISTRY  TOTAL BILI  mg/dL 1.3    0.3    1.9  01/02/2010
104  1  CHEMISTRY  TOTAL BILI  mg/dL 1.5    0.3    1.9  04/03/2010
104  2  CHEMISTRY  TOTAL BILI  mg/dL 1.8    0.3    1.9  07/04/2010
104  0  CHEMISTRY  ALBUMIN     g/dL  3.6    3.4    5.4  01/02/2010
104  1  CHEMISTRY  ALBUMIN     g/dL  4.3    3.4    5.4  04/03/2010
104  2  CHEMISTRY  ALBUMIN     g/dL  5.3    3.4    5.4  07/04/2010
104  0  CHEMISTRY  TOTAL PROT  g/dL  6.2    6.0    8.3  01/02/2010
104  1  CHEMISTRY  TOTAL PROT  g/dL  7.2    6.0    8.3  04/03/2010
104  2  CHEMISTRY  TOTAL PROT  g/dL  8.3    6.0    8.3  07/04/2010
105  0  HEMATOLOGY HEMATOCRIT  %     39     35     49   04/20/2010
105  1  HEMATOLOGY HEMATOCRIT  %     35     35     49   07/20/2010
105  2  HEMATOLOGY HEMATOCRIT  %     37     35     49   10/19/2010
105  0  HEMATOLOGY HEMOGLOBIN  g/dL  13.0   11.7   15.9 04/20/2010
105  1  HEMATOLOGY HEMOGLOBIN  g/dL  14.2   11.7   15.9 07/20/2010
105  2  HEMATOLOGY HEMOGLOBIN  g/dL  14.6   11.7   15.9 10/19/2010
105  0  CHEMISTRY  AST (SGOT)  IU/L  22     10     34   04/20/2010
105  1  CHEMISTRY  AST (SGOT)  IU/L  23     10     34   07/20/2010
105  2  CHEMISTRY  AST (SGOT)  IU/L  22     10     34   10/19/2010
105  0  CHEMISTRY  ALT (SGPT)  IU/L  12     5      35   04/20/2010
105  1  CHEMISTRY  ALT (SGPT)  IU/L  22     5      35   07/20/2010
105  2  CHEMISTRY  ALT (SGPT)  IU/L  23     5      35   10/19/2010
105  0  CHEMISTRY  ALK. PHOS.  IU/L  30     20     140  04/20/2010
105  1  CHEMISTRY  ALK. PHOS.  IU/L  37     20     140  07/20/2010
105  2  CHEMISTRY  ALK. PHOS.  IU/L  100    20     140  10/19/2010
105  0  CHEMISTRY  GGTP        IU/L  34     0      51   04/20/2010
105  1  CHEMISTRY  GGTP        IU/L  22     0      51   07/20/2010
105  2  CHEMISTRY  GGTP        IU/L  34     0      51   10/19/2010
105  0  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  04/20/2010
105  1  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  07/20/2010
105  2  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  10/19/2010
105  0  CHEMISTRY  TOTAL BILI  mg/dL 1.3    0.3    1.9  04/20/2010
105  1  CHEMISTRY  TOTAL BILI  mg/dL 1.5    0.3    1.9  07/20/2010
105  2  CHEMISTRY  TOTAL BILI  mg/dL 1.8    0.3    1.9  10/19/2010
105  0  CHEMISTRY  ALBUMIN     g/dL  3.6    3.4    5.4  04/20/2010
105  1  CHEMISTRY  ALBUMIN     g/dL  4.3    3.4    5.4  07/20/2010
105  2  CHEMISTRY  ALBUMIN     g/dL  5.3    3.4    5.4  10/19/2010
105  0  CHEMISTRY  TOTAL PROT  g/dL  6.2    6.0    8.3  04/20/2010
105  1  CHEMISTRY  TOTAL PROT  g/dL  7.2    6.0    8.3  07/20/2010
105  2  CHEMISTRY  TOTAL PROT  g/dL  8.3    6.0    8.3  10/19/2010
106  0  HEMATOLOGY HEMATOCRIT  %     53     35     49   04/01/2010
106  1  HEMATOLOGY HEMATOCRIT  %     50     35     49   07/05/2010
106  2  HEMATOLOGY HEMATOCRIT  %     53     35     49   10/10/2010
106  0  HEMATOLOGY HEMOGLOBIN  g/dL  17.0   11.7   15.9 04/01/2010
106  1  HEMATOLOGY HEMOGLOBIN  g/dL  12.3   11.7   15.9 07/05/2010
106  2  HEMATOLOGY HEMOGLOBIN  g/dL  12.9   11.7   15.9 10/10/2010
106  0  CHEMISTRY  AST (SGOT)  IU/L  22     10     34   04/01/2010
106  1  CHEMISTRY  AST (SGOT)  IU/L  33     10     34   07/05/2010
106  2  CHEMISTRY  AST (SGOT)  IU/L  36     10     34   10/10/2010
106  0  CHEMISTRY  ALT (SGPT)  IU/L  13     5      35   04/01/2010
106  1  CHEMISTRY  ALT (SGPT)  IU/L  24     5      35   07/05/2010
106  2  CHEMISTRY  ALT (SGPT)  IU/L  29     5      35   10/10/2010
106  0  CHEMISTRY  ALK. PHOS.  IU/L  30     20     140  04/01/2010
106  1  CHEMISTRY  ALK. PHOS.  IU/L  50     20     140  07/05/2010
106  2  CHEMISTRY  ALK. PHOS.  IU/L  90     20     140  10/10/2010
106  0  CHEMISTRY  GGTP        IU/L  33     0      51   04/01/2010
106  1  CHEMISTRY  GGTP        IU/L  66     0      51   07/05/2010
106  2  CHEMISTRY  GGTP        IU/L  60     0      51   10/10/2010
106  0  CHEMISTRY  DIRECT BILI mg/dL 0.2    0      0.3  04/01/2010
106  1  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  07/05/2010
106  2  CHEMISTRY  DIRECT BILI mg/dL 0.2    0      0.3  10/10/2010
106  0  CHEMISTRY  TOTAL BILI  mg/dL 1.4    0.3    1.9  04/01/2010
106  1  CHEMISTRY  TOTAL BILI  mg/dL 1.6    0.3    1.9  07/05/2010
106  2  CHEMISTRY  TOTAL BILI  mg/dL 1.7    0.3    1.9  10/10/2010
106  0  CHEMISTRY  ALBUMIN     g/dL  3.9    3.4    5.4  04/01/2010
106  1  CHEMISTRY  ALBUMIN     g/dL  4.4    3.4    5.4  07/05/2010
106  2  CHEMISTRY  ALBUMIN     g/dL  5.5    3.4    5.4  10/10/2010
106  0  CHEMISTRY  TOTAL PROT  g/dL  6.0    6.0    8.3  04/01/2010
106  1  CHEMISTRY  TOTAL PROT  g/dL  7.1    6.0    8.3  07/05/2010
106  2  CHEMISTRY  TOTAL PROT  g/dL  8.8    6.0    8.3  10/10/2010
201  0  HEMATOLOGY HEMATOCRIT  %     48     35     49   06/10/2010
201  1  HEMATOLOGY HEMATOCRIT  %     59     35     49   09/09/2010
201  2  HEMATOLOGY HEMATOCRIT  %     60     35     49   12/12/2010
201  0  HEMATOLOGY HEMOGLOBIN  g/dL  15.0   11.7   15.9 06/10/2010
201  1  HEMATOLOGY HEMOGLOBIN  g/dL  14.3   11.7   15.9 09/09/2010
201  2  HEMATOLOGY HEMOGLOBIN  g/dL  19.1   11.7   15.9 12/12/2010
201  0  CHEMISTRY  AST (SGOT)  IU/L  20     10     34   06/10/2010
201  1  CHEMISTRY  AST (SGOT)  IU/L  21     10     34   09/09/2010
201  2  CHEMISTRY  AST (SGOT)  IU/L  20     10     34   12/12/2010
201  0  CHEMISTRY  ALT (SGPT)  IU/L  13     5      35   06/10/2010
201  1  CHEMISTRY  ALT (SGPT)  IU/L  20     5      35   09/09/2010
201  2  CHEMISTRY  ALT (SGPT)  IU/L  39     5      35   12/12/2010
201  0  CHEMISTRY  ALK. PHOS.  IU/L  32     20     140  06/10/2010
201  1  CHEMISTRY  ALK. PHOS.  IU/L  33     20     140  09/09/2010
201  2  CHEMISTRY  ALK. PHOS.  IU/L  111    20     140  12/12/2010
201  0  CHEMISTRY  GGTP        IU/L  32     0      51   06/10/2010
201  1  CHEMISTRY  GGTP        IU/L  23     0      51   09/09/2010
201  2  CHEMISTRY  GGTP        IU/L  39     0      51   12/12/2010
201  0  CHEMISTRY  DIRECT BILI mg/dL 0.09   0      0.3  06/10/2010
201  1  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  09/09/2010
201  2  CHEMISTRY  DIRECT BILI mg/dL 0.2    0      0.3  12/12/2010
201  0  CHEMISTRY  TOTAL BILI  mg/dL 1.4    0.3    1.9  06/10/2010
201  1  CHEMISTRY  TOTAL BILI  mg/dL 1.7    0.3    1.9  09/09/2010
201  2  CHEMISTRY  TOTAL BILI  mg/dL 1.3    0.3    1.9  12/12/2010
201  0  CHEMISTRY  ALBUMIN     g/dL  3.3    3.4    5.4  06/10/2010
201  1  CHEMISTRY  ALBUMIN     g/dL  4.9    3.4    5.4  09/09/2010
201  2  CHEMISTRY  ALBUMIN     g/dL  5.2    3.4    5.4  12/12/2010
201  0  CHEMISTRY  TOTAL PROT  g/dL  6.3    6.0    8.3  06/10/2010
201  1  CHEMISTRY  TOTAL PROT  g/dL  7.4    6.0    8.3  09/09/2010
201  2  CHEMISTRY  TOTAL PROT  g/dL  8.9    6.0    8.3  12/12/2010
202  0  HEMATOLOGY HEMATOCRIT  %     41     35     49   01/23/2010
202  1  HEMATOLOGY HEMATOCRIT  %     52     35     49   04/20/2010
202  2  HEMATOLOGY HEMATOCRIT  %     48     35     49   07/20/2010
202  0  HEMATOLOGY HEMOGLOBIN  g/dL  15.1   11.7   15.9 01/23/2010
202  1  HEMATOLOGY HEMOGLOBIN  g/dL  18.2   11.7   15.9 04/20/2010
202  2  HEMATOLOGY HEMOGLOBIN  g/dL  17.7   11.7   15.9 07/20/2010
202  0  CHEMISTRY  AST (SGOT)  IU/L  22     10     34   01/23/2010
202  1  CHEMISTRY  AST (SGOT)  IU/L  23     10     34   04/20/2010
202  2  CHEMISTRY  AST (SGOT)  IU/L  22     10     34   07/20/2010
202  0  CHEMISTRY  ALT (SGPT)  IU/L  12     5      35   01/23/2010
202  1  CHEMISTRY  ALT (SGPT)  IU/L  22     5      35   04/20/2010
202  2  CHEMISTRY  ALT (SGPT)  IU/L  23     5      35   07/20/2010
202  0  CHEMISTRY  ALK. PHOS.  IU/L  30     20     140  01/23/2010
202  1  CHEMISTRY  ALK. PHOS.  IU/L  37     20     140  04/20/2010
202  2  CHEMISTRY  ALK. PHOS.  IU/L  100    20     140  07/20/2010
202  0  CHEMISTRY  GGTP        IU/L  34     0      51   01/23/2010
202  1  CHEMISTRY  GGTP        IU/L  22     0      51   04/20/2010
202  2  CHEMISTRY  GGTP        IU/L  34     0      51   07/20/2010
202  0  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  01/23/2010
202  1  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  04/20/2010
202  2  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  07/20/2010
202  0  CHEMISTRY  TOTAL BILI  mg/dL 1.3    0.3    1.9  01/23/2010
202  1  CHEMISTRY  TOTAL BILI  mg/dL 1.5    0.3    1.9  04/20/2010
202  2  CHEMISTRY  TOTAL BILI  mg/dL 1.8    0.3    1.9  07/20/2010
202  0  CHEMISTRY  ALBUMIN     g/dL  3.6    3.4    5.4  01/23/2010
202  1  CHEMISTRY  ALBUMIN     g/dL  4.3    3.4    5.4  04/20/2010
202  2  CHEMISTRY  ALBUMIN     g/dL  5.3    3.4    5.4  07/20/2010
202  0  CHEMISTRY  TOTAL PROT  g/dL  6.2    6.0    8.3  01/23/2010
202  1  CHEMISTRY  TOTAL PROT  g/dL  7.2    6.0    8.3  04/20/2010
202  2  CHEMISTRY  TOTAL PROT  g/dL  8.3    6.0    8.3  07/20/2010
203  0  HEMATOLOGY HEMATOCRIT  %     39     35     49   06/10/2010
203  1  HEMATOLOGY HEMATOCRIT  %     53     35     49   09/01/2010
203  2  HEMATOLOGY HEMATOCRIT  %     57     35     49   11/28/2010
203  0  HEMATOLOGY HEMOGLOBIN  g/dL  13.0   11.7   15.9 06/10/2010
203  1  HEMATOLOGY HEMOGLOBIN  g/dL  17.3   11.7   15.9 09/01/2010
203  2  HEMATOLOGY HEMOGLOBIN  g/dL  17.3   11.7   15.9 11/28/2010
203  0  CHEMISTRY  AST (SGOT)  IU/L  17     10     34   06/10/2010
203  1  CHEMISTRY  AST (SGOT)  IU/L  20     10     34   09/01/2010
203  2  CHEMISTRY  AST (SGOT)  IU/L  33     10     34   11/28/2010
203  0  CHEMISTRY  ALT (SGPT)  IU/L  8      5      35   06/10/2010
203  1  CHEMISTRY  ALT (SGPT)  IU/L  12     5      35   09/01/2010
203  2  CHEMISTRY  ALT (SGPT)  IU/L  22     5      35   11/28/2010
203  0  CHEMISTRY  ALK. PHOS.  IU/L  22     20     140  06/10/2010
203  1  CHEMISTRY  ALK. PHOS.  IU/L  33     20     140  09/01/2010
203  2  CHEMISTRY  ALK. PHOS.  IU/L  56     20     140  11/28/2010
203  0  CHEMISTRY  GGTP        IU/L  12     0      51   06/10/2010
203  1  CHEMISTRY  GGTP        IU/L  33     0      51   09/01/2010
203  2  CHEMISTRY  GGTP        IU/L  29     0      51   11/28/2010
203  0  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  06/10/2010
203  1  CHEMISTRY  DIRECT BILI mg/dL 0.2    0      0.3  09/01/2010
203  2  CHEMISTRY  DIRECT BILI mg/dL 0.3    0      0.3  11/28/2010
203  0  CHEMISTRY  TOTAL BILI  mg/dL 1.0    0.3    1.9  06/10/2010
203  1  CHEMISTRY  TOTAL BILI  mg/dL 0.4    0.3    1.9  09/01/2010
203  2  CHEMISTRY  TOTAL BILI  mg/dL 1.2    0.3    1.9  11/28/2010
203  0  CHEMISTRY  ALBUMIN     g/dL  3.6    3.4    5.4  06/10/2010
203  1  CHEMISTRY  ALBUMIN     g/dL  4.8    3.4    5.4  09/01/2010
203  2  CHEMISTRY  ALBUMIN     g/dL  5.4    3.4    5.4  11/28/2010
203  0  CHEMISTRY  TOTAL PROT  g/dL  6.3    6.0    8.3  06/10/2010
203  1  CHEMISTRY  TOTAL PROT  g/dL  7.4    6.0    8.3  09/01/2010
203  2  CHEMISTRY  TOTAL PROT  g/dL  8.4    6.0    8.3  11/28/2010
204  0  HEMATOLOGY HEMATOCRIT  %     38     35     49   02/03/2010
204  1  HEMATOLOGY HEMATOCRIT  %     40     35     49   05/04/2010
204  2  HEMATOLOGY HEMATOCRIT  %     44     35     49   08/05/2010
204  0  HEMATOLOGY HEMOGLOBIN  g/dL  11.2   11.7   15.9 02/03/2010
204  1  HEMATOLOGY HEMOGLOBIN  g/dL  12.2   11.7   15.9 05/04/2010
204  2  HEMATOLOGY HEMOGLOBIN  g/dL  17.3   11.7   15.9 08/05/2010
204  0  CHEMISTRY  AST (SGOT)  IU/L  20     10     34   02/03/2010
204  1  CHEMISTRY  AST (SGOT)  IU/L  33     10     34   05/04/2010
204  2  CHEMISTRY  AST (SGOT)  IU/L  45     10     34   08/05/2010
204  0  CHEMISTRY  ALT (SGPT)  IU/L  10     5      35   02/03/2010
204  1  CHEMISTRY  ALT (SGPT)  IU/L  20     5      35   05/04/2010
204  2  CHEMISTRY  ALT (SGPT)  IU/L  40     5      35   08/05/2010
204  0  CHEMISTRY  ALK. PHOS.  IU/L  32     20     140  02/03/2010
204  1  CHEMISTRY  ALK. PHOS.  IU/L  33     20     140  05/04/2010
204  2  CHEMISTRY  ALK. PHOS.  IU/L  160    20     140  08/05/2010
204  0  CHEMISTRY  GGTP        IU/L  32     0      51   02/03/2010
204  1  CHEMISTRY  GGTP        IU/L  21     0      51   05/04/2010
204  2  CHEMISTRY  GGTP        IU/L  33     0      51   08/05/2010
204  0  CHEMISTRY  DIRECT BILI mg/dL 0.2    0      0.3  02/03/2010
204  1  CHEMISTRY  DIRECT BILI mg/dL 0.1    0      0.3  05/04/2010
204  2  CHEMISTRY  DIRECT BILI mg/dL 0.2    0      0.3  08/05/2010
204  0  CHEMISTRY  TOTAL BILI  mg/dL 1.6    0.3    1.9  02/03/2010
204  1  CHEMISTRY  TOTAL BILI  mg/dL 1.2    0.3    1.9  05/04/2010
204  2  CHEMISTRY  TOTAL BILI  mg/dL 1.8    0.3    1.9  08/05/2010
204  0  CHEMISTRY  ALBUMIN     g/dL  3.6    3.4    5.4  02/03/2010
204  1  CHEMISTRY  ALBUMIN     g/dL  4.2    3.4    5.4  05/04/2010
204  2  CHEMISTRY  ALBUMIN     g/dL  5.1    3.4    5.4  08/05/2010
204  0  CHEMISTRY  TOTAL PROT  g/dL  6.3    6.0    8.3  02/03/2010
204  1  CHEMISTRY  TOTAL PROT  g/dL  7.4    6.0    8.3  05/04/2010
204  2  CHEMISTRY  TOTAL PROT  g/dL  8.2    6.0    8.3  08/05/2010
;
run; 
