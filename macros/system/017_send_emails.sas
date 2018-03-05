/* ************************************************************************************************************** 
*
*	MACRO:			sendTerminatingMail
*	DESCRIPTION:	this macro sends an email, explaining errors if status=0,
*					attaching files if status=1
*	PARAMETERS:		status = 
*						- status=0 means there was an error and the mex explains the error
*						- status=1 means everything run correctly and
*					  			   a summary of the results can be found in the attached files
*					mex = message of the email
*					to = addressee of the email
*
* ************************************************************************************************************** */

%macro sendTerminatingMail(status=, mex=, to=);
	%let subject=[UCI] DQ Framework System - Status [&status.];
	%let atc1=;
	%let atc2=;
	%let atc3=;
	%if %symexist(m_report_var_tbl) %then %do;
		%let atc1=%sysfunc(fileexist(&fld_excel_check./&xls_check.));
		%let atc2=%sysfunc(fileexist(&xls_output_full_path._&m_report_var_tbl..xlsx));
		%let atc3=%sysfunc(fileexist(&fld_prj./reports/&m_prompt_area.*.html));
	%end;
	%if &atc3. %then %do;
		%zipFile(path=&fld_prj./reports, fn=&m_prompt_area.*.html);
	%end;

	data _null_;
		%if &status %then %do;
			%let atc=;
			%if &atc1. %then %do;
				%let atc="&fld_excel_check./&xls_check." content_type="application/xlsx" ;
			%end;
			%if &atc2. %then %do;
				%let atc=&atc. "&xls_output_full_path._&m_report_var_tbl..xlsx" content_type="application/xlsx" ;
			%end;
			%if &atc3. %then %do;
				%let atc=&atc. "&fld_prj./reports/&zipFile_rc." content_type="application/zip" ;
			%end;

			file mailbox attach=( &atc. )
				to="&to." subject="&subject.";
			put "Dear User, ";
			put "you can find in attach the file with the Matrix Checks.";
		%end;

		%else %do;
			file mailbox to="&to." subject="&subject.";
			put "Dear User, ";
			put "There was an error: ";
			put "&mex.";

		%end;
		put " ";
		put "Regards,";
		put "DQ system";
	run;
	

%mend;
