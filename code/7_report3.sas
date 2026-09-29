%macro report3(dataset=,out=);
proc sql noprint;
	create table temp_report3 as
	select 
		TRT01A,
		count(USUBJID) as TOTAL_CONT
	from &dataset
	group by TRT01A;
quit;


proc sql noprint;
create table &out as
select
	a.TRT01A,
	a.AESEV,
	count(*)as AE_CONT,
	count(*) / d.TOTAL_CONT *100  as AE_RATE format=8.2


from &dataset as a
left join temp_report3 as d
on a.TRT01A=d.TRT01A

group by a.TRT01A,a.AESEV,d.TOTAL_CONT
order by a.TRT01A,a.AESEV;
quit;

%mend report3;

