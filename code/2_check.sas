%macro check(dataAE=,dataDM=,display=0);
*检查AE完全重复*;
footnote;
%local nobsAE;
proc sort data=&dataAE nodup
	out=temp1_nodup 
	dupout=temp1_dups;
    	by _all_;
run;

proc sql noprint;
    select count(*) into :nobsAE
    from temp1_dups;
quit;


*检查DM完全重复*;
%local nobsDM;
proc sort data=&dataDM nodup
	out=temp2_nodup 
	dupout=temp2_dups;
    	by _all_;
run;

proc sql noprint;
    select count(*) into :nobsDM
    from temp2_dups;
quit;

*检查USUBJID、TRT01A、AETERM、AESTDTC 是否有缺失*;
%local AE_check_temp;
data AE_check_temp;
set &dataAE;
where not missing(AETERM);
run;
	
%local n1 n2 n3 n4;
proc sql noprint;
select 
coalesce(sum(missing(USUBJID)),0),
coalesce(sum(missing(TRT01A)),0),
coalesce(sum(missing(AETERM)),0),
coalesce(sum(missing(AESTDTC)),0)
into :n1,:n2,:n3,:n4
from AE_check_temp;
quit;

data temp1_lack;
set AE_check_temp;
where missing(USUBJID) or missing(TRT01A) or missing(AETERM) or missing(AESTDTC);
run;

*检查 AE.TRT01A 与 DM.TRT01A 是否一致*;
    %local n_total n_ae_no_dm n_dm_no_ae n_missing n_mismatch n_bad;

    proc sort data=&dataAE.(keep=USUBJID TRT01A) nodupkey out=ae_trt;
        by USUBJID TRT01A;
    run;

    proc sort data=&dataDM.(keep=USUBJID TRT01A) nodupkey out=dm_trt;
        by USUBJID;
    run;

    data check_trt;
        merge ae_trt(in=a) dm_trt(in=b rename=(TRT01A=DM_TRT));
        by USUBJID;

        length CHECK_RESULT $30;

		if missing(USUBJID) then CHECK_RESULT = '存在缺失';
		else if missing(TRT01A) and missing(DM_TRT) then CHECK_RESULT = '存在缺失';
        else if a and not b then CHECK_RESULT = 'AE中有但DM中无';
        else if not a and b then CHECK_RESULT = 'DM中有但AE中无';
        else if upcase(strip(TRT01A)) ne upcase(strip(DM_TRT)) then CHECK_RESULT = '不一致';
        else CHECK_RESULT = '一致';
    run;


    proc sql noprint;
        select count(USUBJID) into :n_total     from check_trt;
        select count(*) into :n_ae_no_dm  from check_trt where CHECK_RESULT = 'AE中有但DM中无';
        select count(*) into :n_dm_no_ae  from check_trt where CHECK_RESULT = 'DM中有但AE中无';
        select count(*) into :n_missing   from check_trt where CHECK_RESULT = '存在缺失';
        select count(*) into :n_mismatch  from check_trt where CHECK_RESULT = '不一致';
    quit;

    %let n_bad = %eval(&n_ae_no_dm. + &n_dm_no_ae. + &n_missing. + &n_mismatch.);

    %put ============================================;
    %put 治疗组一致性检查结果;
    %put --------------------------------------------;
    %put 总受试者数            : &n_total.;
    %put AE中有但DM中无        : &n_ae_no_dm.;
    %put DM中有但AE中无        : &n_dm_no_ae.;
    %put 存在缺失              : &n_missing.;
    %put 治疗组不一致          : &n_mismatch.;
    %put --------------------------------------------;
    %if &n_bad. = 0 %then %do;
        %put 结论: AE 与 DM 的 TRT01A 完全一致;
    %end;
    %else %do;
        %put 结论: 发现 &n_bad. 条异常记录，请查看 check_trt 数据集;
    %end;

	%if &nobsAE. = 0 %then %do;
	%put -------------------------------------;
	%put AE无完全重复数据;
%end;
%else %do;
	%put -------------------------------------;
	%put AE有完全重复数据,重复记录数为&nobsAE.;
%end;
%if &nobsDM. = 0 %then %do;

	%put -------------------------------------;
	%put DM无完全重复数据;
%end;
%else %do;
	%put -------------------------------------;
	%put DM有完全重复数据,重复记录数为&nobsDM.;
%end;

	%put ------------------------------------------;
	%put USUBJID缺失数         : &n1.;
    %put TRT01A缺失数          : &n2.;
    %put AETERM缺失数          : &n3.;
    %put AESTDTC缺失数         : &n4.;	
	%put ------------------------------------------;


    %put ============================================;

	%if &display.=1  %then %do;
	ods listing;
	title 'AE完全重复内容';
	proc print data=temp1_dups;
	run;

	title 'DM完全重复内容';
	proc print data=temp2_dups;
	run;

	title 'USUBJID、TRT01A、AETERM、AESTDTC缺失数据';
	proc print data=temp1_lack;
	run;
	%end;
%mend check;

