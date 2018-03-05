/*macro to delete granular tables*/

%macro delete_granular_tables();

	proc contents data=datawrk._all_ out=info noprint;
	run;

	%let lst_tbl=;
	proc sql noprint;
		select distinct "datawrk."||strip(memname) as fullname into : lst_tbl separated by " "
		from info
		where substr(memname,1,2) eq 'G_'
		order by fullname;
	quit;

	proc delete data=&lst_tbl. info;
	run;

%mend;


