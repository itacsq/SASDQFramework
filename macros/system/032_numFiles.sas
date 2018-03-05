

%macro getNumFile(fld=, filter=*);
	%global getNumFile_rc;
	%let getNumFile_rc=;

	filename dirlist pipe "ls -1 &fld. | grep &filter. | wc -l";
	data _null_;
	    infile dirlist pad lrecl=500;
	    input @1 filename $500.;
		call symputx("getNumFile_rc", filename);
	run;


%mend;
/*
%getNumFile(fld=/data);
%put NOTE: [&getNumFile_rc.];
*/