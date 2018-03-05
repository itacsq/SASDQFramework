/* ************************************************************************************************************** 
*
*	MACRO:			zipFile
*	DESCRIPTION:	Compress files and create a compressed package.
*					This macro uses the ods package to compress file: potentially
*					it works on any OS. Consider, though, that the list of file to be
*					included are passed via ls (linux command): to use it under WINOS
*					be carefull to replace with dir.
*
*	NOTE:			usage based on OS AIX
*	PARAMETERS:		path = full path of the folder where you want to save zipped files
*					fn = pattern name to search and zip
*	OUTPUT:			zipFile_rc: package name
*
* ************************************************************************************************************** */


%macro zipFile(path=, fn=);
	%global zipFile_rc;
	%let zipFile_rc=reports.zip;
	%put &path./&fn.;

	ods package(vary) open nopf;
		
	filename dirlist pipe "ls -d &path./&fn.";
	data _null_;
	    infile dirlist pad lrecl=500;
	    input @1 filename $500.;
		x='add file="'||compress(strip(filename))||'";';
		call execute (catx (' ', 'ods package(vary)', x ) );
		%put quote(strip(filename));
	run;
	
	ods package(vary) publish archive 
	  properties(
	   archive_name="&zipFile_rc." 
	   archive_path="&path."
	  );
	ods package(vary) close;

%mend;
