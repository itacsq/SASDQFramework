

%macro getFolderSize(fld=);
	%global getFolderSize_rc;
	%let getFolderSize_rc=;

	filename dirlist pipe "du -h &fld. | cut -c 1-3";
	data _null_;
	    infile dirlist pad lrecl=500;
	    input @1 filename $500.;
		call symputx("getFolderSize_rc", filename);
	run;


%mend;
/*
%getFolderSize(fld=/data);
%put NOTE: [&getFolderSize_rc.];
*/