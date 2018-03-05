%macro mkdir(path=, fld=);
	
	filename dirlist pipe "cd &path. ; mkdir &fld.";
	data _null_;
	    infile dirlist pad lrecl=150;
	    input @1 filename $150.;
		put filename;
	run;

%mend;


/* Testing 
%let path=/sas9.3/sas/home/env/PROJECTS/projects_93/a068_DQ_LMI/GDO/output;
%let fld=test;
%mkdir(path=&path., fld=&fld.);
*/
