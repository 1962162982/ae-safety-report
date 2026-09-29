%macro report2(dataset=,out=);
proc sql noprint;
create table temp_report2 as
select
	TRT01A,
	count(USUBJID) as total_SUBJ
from &dataset
group by TRT01A;
quit;


proc sql noprint;
create table &out as
	select
		a.TRT01A as TRT01A,
		a.AEBODSYS as AEBODSYS,
		a.AEDECOD as AEDECOD,
		count(*) as AE_EVENT_CNT,
		count(distinct a.USUBJID) as AE_SUB_CNT,
		calculated AE_SUB_CNT / d.TOTAL_SUBJ *100  as AE_OCC_RATE format=8.2


	from temp_report2 as d
	right join &dataset as a
	on a.TRT01A =d.TRT01A
	group by a.TRT01A, a.AEDECOD, a.AEBODSYS, d.TOTAL_SUBJ
	order by a.TRT01A, a.AEDECOD, a.AEBODSYS; 
quit;

%mend report2;
