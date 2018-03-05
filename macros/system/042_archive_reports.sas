



%macro archiveReports(fld_prj=, filter=);
	%let tarnm=%getTime()_reports_&filter..tar;
	filename dirlist pipe "cd &fld_prj./reports ; tar -cvf &tarnm. %str(*)&filter.%str(*)html ; mv &tarnm. &fld_prj./reports/archive ";
	data _null_;
	    infile dirlist pad lrecl=250;
	    input @1 filename $250.;
		put filename;
	run;

%mend;
/*
%let filter=DUMMY;
%archiveReports(fld_prj=&fld_prj. , filter=&filter.);
*/
