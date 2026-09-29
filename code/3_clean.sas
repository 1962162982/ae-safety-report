%macro clean(data=,out=);
*Êý¾ÝÇåÏ´*;
proc sort data=&data nodupkey out=clean_temp1;
	by USUBJID AETERM AESTDTC;
run; 

data clean_temp2;
set clean_temp1;
where missing(USUBJID)=0;
run;

data &out;
    set clean_temp2;

    *AESTDTC_N = input(AESTDTC, yymmdd10.);*
    AEENDTC_N = input(AEENDTC, yymmdd10.);*

    format AESTDTC_N AEENDTC_N yymmdd10.;*

    drop AESTDTC AEENDTC;*
    rename AESTDTC_N = AESTDTC
           AEENDTC_N = AEENDTC*;
	if missing(AEENDTC) then do;
		AE_DUR = .;
		AE_ONGOING='Y';
	end;
	else do;
		AE_DUR = AEENDTC - AESTDTC + 1;
		AE_ONGOING='N';
	end;
	AESER_FL = (AESER = 'Y');
run;

%mend clean;

