%macro checkExistTbls (lib=, pattern=);

	%global checkExistTbls_rc;
	%let checkExistTbls_rc=;

	%let var_info_list=;

	proc contents data=&lib.._all_ out=info noprint nodetails;
	run;

	proc sql noprint;
		select distinct memname into :var_info_list separated by "#"
		from info
		where memname ? "&pattern."
		;
	quit;

	%if &var_info_list. ne %then %do;
		%let checkExistTbls_rc=1;
	%end;
	%else %do;
		%let checkExistTbls_rc=0;
	%end;

%mend;
