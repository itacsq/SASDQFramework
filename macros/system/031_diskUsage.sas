%macro getDiskUsage(disk=);
	%global getDiskUsage_rc;
	%let getDiskUsage_rc=;

	filename dirlist pipe "df -h | grep '&disk.' | cut -c 35-37";
	data _null_;
	    infile dirlist pad lrecl=500;
	    input @1 filename $500.;
		call symputx("getDiskUsage_rc", filename);
	run;


%mend;
/*
%getDiskUsage(disk=/mnt/hgfs/sf_myfolders);
%put NOTE: [&getDiskUsage_rc.];
*/