**** %common defines common librefs and SAS options.;
%macro common;
	libname source  ".";
	libname library ".";
	libname target  "..\..\sdtm";
	options ls=256 nocenter;
%mend common;
