

%macro getUsageInfo(fld=/sasdatacrms/data2/projects/a068_DQ_LMI/GDO);


	filename dirlist pipe "cd &fld. ; du -g . ";
	data usage;
	    infile dirlist pad lrecl=250;
	    input @1 filename $250.;
		size=input(scan(filename, 1, "	"), 8.);
		folder=scan(filename, -1, "	");
		drop filename;
	run;

	proc sort data=usage;
		by descending size;
	run;

%mend;
/*
%getUsageInfo();
*/
