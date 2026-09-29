*使用前请修改文件地址*;
dm 'clear log';
dm 'odsresults;clear;';
filename mylog "E:\sasdata\ae-safety-report\log\run.log" encoding="utf-8";

proc printto log=mylog new;
run;

proc datasets library=work kill nodetails nolist;
run;
quit;


%put NOTE: ================================;
%put NOTE: 项目开始,数据读取中;
%put NOTE: ================================;
*读取宏文件*;
%include 'E:\sasdata\ae-safety-report\code\1_import.sas';
%include 'E:\sasdata\ae-safety-report\code\2_check.sas';
%include 'E:\sasdata\ae-safety-report\code\3_clean.sas';
%include 'E:\sasdata\ae-safety-report\code\4_merge.sas';
%include 'E:\sasdata\ae-safety-report\code\5_report1.sas';
%include 'E:\sasdata\ae-safety-report\code\6_report2.sas';
%include 'E:\sasdata\ae-safety-report\code\7_report3.sas';
%include 'E:\sasdata\ae-safety-report\code\8_trt_report.sas';
%include 'E:\sasdata\ae-safety-report\code\9_loop.sas';
%include 'E:\sasdata\ae-safety-report\code\10_chisq.sas';

*读取数据*;
%import(file='E:\sasdata\ae-safety-report\data\ae.csv',out=ae);
%import(file='E:\sasdata\ae-safety-report\data\dm.csv',out=dm);

*数据质量检查,display=1表示显示具体细则，=0则表示只显示结果*;
%check(dataAE=ae,dataDM=dm,display=1);

*清洗和去重*;
%clean(data=ae,out=AE_CLEAN);

*合并数据*;
%merge(data1=AE_CLEAN,data2=dm,out=AE_ADSL);

*汇总分析*;
%report1(dataSet=AE_ADSL,out=report1);
%report2(dataSet=AE_ADSL,out=report2);
%report3(dataSet=AE_ADSL,out=report3);
*%TRT_report(trt=Drug A,odsfile='E:\sasdata\ae-safety-report\output')*;
*上述为根据治疗组输出报表的宏，可手动调用*;

*根据治疗组循环生成报表*;
%loop;

*卡方检验,如需要可调用*;
%chisq(dataset=AE_ADSL);

proc printto log=log;
run;
