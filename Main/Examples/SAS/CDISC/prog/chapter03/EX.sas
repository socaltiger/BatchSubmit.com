*---------------------------------------------------------------*;
* EX.sas creates the SDTM EX dataset and saves it
* as a permanent SAS datasets to the target libref.
*---------------------------------------------------------------*;
%include 'common.sas';
 
%common 

**** CREATE EMPTY EX DATASET CALLED EMPTY_EX;
%include 'make_empty_dataset.sas';

%make_empty_dataset(metadatafile=..\appendix_b\SDTM_METADATA.xlsx,dataset=EX)
 
%include 'make_dtc_date.sas';

**** DERIVE THE MAJORITY OF SDTM EX VARIABLES;
options missing = ' ';
data ex;
  set EMPTY_EX
      source.dosing;

    studyid = 'XYZ123';
    domain = 'EX';
    usubjid = left(uniqueid);
    exdose = dailydose;
    exdostot = dailydose;
    exdosu = 'mg';
    exdosfrm = 'TABLET, COATED';
    %make_dtc_date(dtcdate=exstdtc, year=startyy, month=startmm, day=startdd)
    %make_dtc_date(dtcdate=exendtc, year=endyy, month=endmm, day=enddd)
run;
 
proc sort
  data=ex;
    by usubjid;
run;

**** CREATE SDTM STUDYDAY VARIABLES AND INSERT EXTRT;
%include 'make_sdtm_dy.sas';

data ex;
  merge ex(in=inex) target.dm(keep=usubjid rfstdtc arm);
    by usubjid;

    if inex;

    %make_sdtm_dy(date=exstdtc); 
    %make_sdtm_dy(date=exendtc); 

    **** in this simplistic case all subjects received the treatment they were randomized to;
    extrt = arm;
run;


**** CREATE SEQ VARIABLE;
proc sort
  data=ex;
    by studyid usubjid extrt exstdtc;
run;

data ex;
  retain &EXKEEPSTRING;
  set ex(drop=exseq);
    by studyid usubjid extrt exstdtc;

    if not (first.exstdtc and last.exstdtc) then
      put "WARN" "ING: key variables do not define an unique record. " usubjid=;

    retain exseq;
    if first.usubjid then
      exseq = 1;
    else
      exseq = exseq + 1;
		
    label exseq = "Sequence Number";
run;


**** SORT EX ACCORDING TO METADATA AND SAVE PERMANENT DATASET;
%include 'make_sort_order.sas';

%make_sort_order(metadatafile=..\appendix_b\SDTM_METADATA.xlsx,dataset=EX)

proc sort
  data=ex(keep = &EXKEEPSTRING)
  out=target.ex;
    by &EXSORTSTRING;
run;
