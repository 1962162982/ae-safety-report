%macro report1(dataset=,out=);
proc sql noprint;
create table &out as
select 
	TRT01A,
	count(distinct USUBJID) as TOTAL_SUBJ,
	count(USUBJID) as AE_EVENT_CNT,
	count(distinct USUBJID) as AE_SUBJ_CNT,
	sum(AESER_FL) as SER_EVENT_CNT ,
	count(distinct case when AESER_FL=1 then USUBJID end) as SER_SUBJ_CNT,
	calculated SER_SUBJ_CNT / calculated TOTAL_SUBJ *100 as SAE_RATE format 8.2

	from &dataset
	group by TRT01A;
	quit;

%mend report1;
