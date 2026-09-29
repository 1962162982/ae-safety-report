%macro chisq(dataset=);
   %local chisq_ae;

proc sql noprint;
create table chisq_ae as
select
	distinct USUBJID as USUBJID,
	TRT01A ,
	AESER_FL
	from &dataset;
quit;

proc freq data=chisq_ae;
    tables TRT01A * AESER_FL / chisq expected cellchi2;
	title "严重 AE 与治疗组的卡方检验";
run;
title;

%mend chisq;
