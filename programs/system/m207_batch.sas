%let sassw=/sas9.3/sas/sasperm/meta5/Lev1/SASApp/BatchServer/sasbatch.sh;
%let saspgm=/sasdatacrms/data5/projects/a502_IFRS9/lev1/gdo/programs/dq_framework/progs/test.sas;
%let saslog=/sasdatacrms/data5/projects/a502_IFRS9/lev1/gdo/programs/dq_framework/logs/nohup/aalog.log;

%let flgs=0#0#1;
proc printto;run;
options mprint notes;
%let cmd=nohup bash &sassw. -batch -noterminal -sysin &saspgm. -sysparm &flgs. -log &saslog. %nrstr(&);
%put &cmd.;
filename batchpgm pipe "&cmd.";

data _null_;
    infile batchpgm pad lrecl=500;
    input @1 output $500.;
	put output;
run;
