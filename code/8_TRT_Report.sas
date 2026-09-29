%macro TRT_REPORT(TRT=,report1=report1,report2=report2,report3=report3,odsfile=);
ods results off;
    %let trtfile = %sysfunc(compress(&TRT., %str( )));

    ods rtf file="&odsfile./FINAL_REPORT_&TRT..rtf"
        style=journal
        bodytitle;

    title "不良事件汇总报表 - 治疗组：&TRT.";
    footnote '注：发生率 = 受试者数 / 该组受试者总数 × 100%';

    /* ---------- 表1：直接读已汇总好的数据集 ---------- */
    title "表1 总体 AE 汇总 - 治疗组：&TRT.";
    proc report data=&report1. nowd
	    style(report)=[width=100% borderwidth=1px bordercolor=black]
    style(header)=[background=#D9E1F2 font_weight=bold font_size=10pt color=black]
    style(column)=[font_size=10pt];
        where TRT01A = "&TRT.";
        column TRT01A TOTAL_SUBJ AE_EVENT_CNT AE_SUBJ_CNT SER_EVENT_CNT SER_SUBJ_CNT SAE_RATE;
        define TRT01A     / display "治疗组";
        define TOTAL_SUBJ     / display "受试者总数";
        define AE_EVENT_CNT      / analysis "AE事件数";
        define AE_SUBJ_CNT  / analysis "发生AE受试者数";
        define SER_EVENT_CNT  / display "严重AE事件数";
        define SER_SUBJ_CNT / display "严重AE受试者数";
        define SAE_RATE    / display "严重AE发生率(%)" format=8.1;
    run;

    /* ---------- 表2：直接读已汇总好的数据集 ---------- */
    title "表2 按 SOC/PT 汇总 - 治疗组：&TRT.";
    proc report data=&report2. nowd
	    style(report)=[width=100% borderwidth=1px bordercolor=black]
    style(header)=[background=#D9E1F2 font_weight=bold font_size=10pt color=black]
    style(column)=[font_size=10pt];
        where TRT01A = "&TRT.";
        column AEBODSYS AEDECOD AE_EVENT_CNT AE_SUB_CNT AE_OCC_RATE;
        define AEBODSYS / group "SOC" order=formatted;
        define AEDECOD / group "PT" order=formatted;
        define AE_EVENT_CNT    / analysis "事件数" format=8.;
        define AE_SUB_CNT   / analysis "受试者数" format=8.;
        define AE_OCC_RATE      / analysis "发生率(%)" format=8.1;
    run;

    /* ---------- 表3：直接读已汇总好的数据集 ---------- */
    title "表3 严重程度分布 - 治疗组：&TRT.";
    proc report data=&report3. nowd
	    style(report)=[width=100% borderwidth=1px bordercolor=black]
    style(header)=[background=#D9E1F2 font_weight=bold font_size=10pt color=black]
    style(column)=[font_size=10pt];
        where TRT01A = "&TRT.";
        column AESEV AE_CONT AE_RATE;
        define AESEV / display "严重程度";
        define AE_CONT / display "事件数" format=8.;
        define AE_RATE   / display "百分比(%)" format=8.1;
    run;

    ods rtf close;
ods results on;
%mend TRT_REPORT;



