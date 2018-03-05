/* ************************************************************************************************************** 
*
*	MACRO:			backupPrj
*	DESCRIPTION:	this macro saves a backup of the main folders of the project
*					(macros,progs, eguide, vbs)
*	NOTE:			usage based on OS AIX
*	PARAMETERS:		fld = folder where the project is saved
*
* ************************************************************************************************************** */

%macro backupPrj(fld=/sasdatacrms/data2/projects/a068_DQ_LMI/GDO/programs, to=christian.scquizzato@bidcompany.it);

	%let nm_zip=bkp_prg_%getTime();
	%put &nm_zip;
	filename dirlist pipe "cd &fld. ; tar -cvf &nm_zip..tar macros programs guide ; gzip &nm_zip..tar ; mv &nm_zip..tar.gz abackup ";
	data _null_;
	    infile dirlist pad lrecl=150;
	    input @1 filename $150.;
		put filename;
	run;

	

	%let atc="&fld_prj./abackup/&nm_zip..tar.gz" content_type="application/zip" ;
	%let to=&to;
	%let subject=[DQ-FRAMEWORK] Backup Project;
	%let from=christian.scquizzato@bidcompany.it;


	filename mailbox email from="&from." ; 
	data _null_;
		file mailbox attach=( &atc. )
			to="&to." subject="&subject.";
		put "Dear User, ";
		put "you can find in attach a backup of the whole macros and programs.";

		put " ";
		put "Regards,";
		put "DQ system";
	run;

%mend;
/* 
	%backupPrj(to=christian.scquizzato@bidcompany.it); 
*/
