%macro merge(data1=,data2=,out=);
data &out;
merge &data1 &data2;
by USUBJID;
run;

%mend merge;
