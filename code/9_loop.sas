%macro loop(dataDM=dm);
proc sql noprint;
select 
	distinct TRT01A
	into : TRT_LIST separated by '丨'
	from &dataDM;
quit;

%let n_trt = %sysfunc(countw(&trt_list., %str(丨)));

    %do i = 1 %to &n_trt.;
        %let trt = %scan(&trt_list., &i., %str(丨));
        %put NOTE: 正在生成报表：&trt.;
        %TRT_REPORT(TRT=&trt.);
    %end;

%mend loop;
