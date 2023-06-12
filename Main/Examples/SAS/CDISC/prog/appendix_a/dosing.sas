**** define common SAS setings;
%include 'common.sas';

%common

**** INPUT SAMPLE DOSING DATA;
data source.dosing;
label subject  = "Subject Number"
      startdt  = "Dosing start date"
      enddt    = "Dosing end date"
      dailydose= "Daily dose taken (pills)"
      uniqueid = "Company Wide Subject ID"
      startmm  = "Month of Start Dose"
      startdd  = "Day of Start Dose"
      startyy  = "Year of Start Dose"
      endmm    = "Month of End Dose"
      enddd    = "Day of End Dose"
      endyy    = "Year of End Dose";
input subject 1-3 startmm 5-6 startdd 8-9 startyy 11-14
      endmm 16-17 enddd 19-20 endyy 22-25 dailydose 27;
uniqueid = 'UNI' || put(subject,3.);
startdt = mdy(startmm, startdd , startyy);
enddt = mdy(endmm, enddd, endyy);
format startdt enddt mmddyy10.;
datalines;
101 04/02/2010 07/26/2010 2
101 07/31/2010 10/10/2010 3
102 02/13/2010 03/20/2010 2
102 03/25/2010 08/10/2010 1
103 05/16/2010 11/14/2010 1
104 01/02/2010 01/10/2010 2
104 01/15/2010 05/25/2010 1
104 05/26/2010 07/04/2010 2
105 04/20/2010 07/20/2010 2
105 07/21/2010 10/19/2010 1
106 04/01/2010 10/10/2010 2
201 06/11/2010 12/11/2010 1
202 02/23/2010 05/19/2010 2
203 06/10/2010 06/20/2010 1
204 02/03/2010 05/04/2010 2
204 05/05/2010 08/03/2010 2
205 04/13/2010 10/10/2010 1
206 07/01/2010 10/01/2010 2
206 10/02/2010 12/27/2010 2
301 02/20/2010 05/17/2010 2
301 05/19/2010 08/22/2010 3
302 05/12/2010 08/12/2010 2
302 08/13/2010 11/15/2010 3
303 02/19/2010 08/17/2010 2
304 05/19/2010 11/19/2010 1
305 06/10/2010 12/11/2010 2
306 05/23/2010 08/19/2010 2
306 08/20/2010 11/18/2010 1
401 06/13/2010 12/09/2010 2
402 01/02/2010 01/05/2010 3
402 01/06/2010 04/02/2010 2
402 04/03/2010 07/10/2010 1
403 03/03/2010 09/04/2010 2
404 04/24/2010 10/25/2010 3
405 03/01/2010 08/28/2010 2
406 06/12/2010 12/09/2010 3
501 02/23/2010 08/17/2010 2
502 05/28/2010 08/25/2010 2
502 08/29/2010 11/20/2010 1
503 01/21/2010 07/19/2010 2
504 06/19/2010 12/20/2010 2
505 03/13/2010 06/15/2010 2
505 06/16/2010 06/20/2010 1
506 01/20/2010 07/20/2010 2
507 04/06/2010 10/05/2010 2
508 02/04/2010 08/11/2010 2
509 05/16/2010 11/15/2010 2
510 01/12/2010 07/14/2010 2
511 04/10/2010 10/12/2010 3
512 04/03/2010 10/01/2010 3
601 06/04/2010 12/09/2010 2
602 02/28/2010 03/24/2010 3
602 03/25/2010 06/22/2010 2
603 01/12/2010 04/12/2010 2
603 04/13/2010 07/10/2010 1
604 03/13/2010 09/15/2010 2
605 04/23/2010 10/26/2010 3
606 02/22/2010 05/25/2010 3
606 05/26/2010 08/23/2010 2
607 06/10/2010 12/09/2010 3
608 02/20/2010 05/20/2010 2
608 05/21/2010 08/17/2010 1
609 05/22/2010 11/23/2010 2
610 01/09/2010 07/12/2010 2
611 06/19/2010 09/21/2010 3
611 09/22/2010 12/20/2010 2
612 03/12/2010 06/15/2010 3
612 06/17/2010 09/16/2010 1
701 05/12/2010 08/10/2010 3
701 08/11/2010 11/05/2010 1
702 02/10/2010 08/12/2010 3
703 05/20/2010 11/20/2010 2
704 06/01/2010 12/10/2010 3
705 05/24/2010 11/19/2010 2
706 06/12/2010 09/11/2010 3
706 09/12/2010 12/10/2010 1
707 01/12/2010 04/11/2010 3
707 04/12/2010 07/10/2010 1
708 03/13/2010 09/15/2010 3
709 04/23/2010 10/23/2010 2
710 03/16/2010 09/16/2010 2
711 04/24/2010 09/20/2010 3
712   /  /2010 09/09/2010 3
712 09/10/2010 12/  /2010 2
;
run; 

proc contents;
run;