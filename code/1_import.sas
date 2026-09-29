%macro import(file=,out=,dbms=csv);
proc import datafile="&file"
out=&out
dbms=&dbms;
getnames=yes;
guessingrows=max;
run;
%mend import;
