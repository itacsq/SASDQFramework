%macro checkFormat(fmtNm=, fmtTp=, lib=);
	%global checkFormat_rc;
	%let checkFormat_rc=;
	%let search=&lib..formats.&fmtNm..format;
	%if &fmtTp. eq C or &fmtTp. eq 1 %then %do;
		%let search=&search.C;
	%end;
	data _null_;
		call symputx("checkFormat_rc", cexist("&search."));
	run;

%mend;
