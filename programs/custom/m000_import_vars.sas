%macro setupVars();
	%put NOTE: macro=[SetupVars];
	options compress=yes;

	%global fld_prj; /* Folder */ 
	%global fld_stg; /* Staging Folder */
	%global fld_excel; /* Excel Folder */
	%global fld_output; /* Output Folder */

	%global m_report_time; /* Time */
	%global fld_excel_check;
	%global xls_check; /* Input Excel */
	%global m_tbl_xls_check; /* Input Tbl with Checks */
	%global m_tbl_log; /* Log Table */
	%global m_tbl_xlscheck_nobs;     /* N° of vars to check ; */
	%global xls_output_full_path; /* Output Excel */
	%global m_log_path; /* Logs */
	%global m_report_fullpath; /* Report */
	%global m_mail_to m_mail_from m_mail_subject; /* Mailing */
	%global m_report_s1_threshold;
	%global m_report_s2_threshold;
	%global m_running_time;
	
	

	/* ------------------------------------------ EDIT ---------------------------------------------------- */
	%let fld_prj=/sasdatacrms/data2/projects/a063_CRAI_NPL/lev1/staging/DQF_v2;
	%let m_mail_to=christian.scquizzato@bidcompany.it;
	%let m_mail_from=christian.scquizzato@bidcompany.it;
	%let m_mail_subject=[DQF] DQ Framework;
	/* ------------------------------------------ EDIT ---------------------------------------------------- */


	/* Create Folders */
	%if %symexist(m_prompt_area) eq 0 %then %do;
		%let m_prompt_area=DUMMY;
	%end;
	%if %length(&m_prompt_area) eq 0 %then %do;
		%let m_prompt_area=DUMMY;
	%end;
	

	/* System Macros :: DO NOT TOUCH    */
	%include "&fld_prj./macros/system/*.sas";
	/* Custom Macros :: Edit on Purpose */
	%include "&fld_prj./macros/custom/*.sas";

	%let m_report_time=%getTime(); /* Time */
	%let fld_excel_check=&fld_prj./excel; /* Excel Folder */
	%let xls_check=File_SAS.xlsx;   /* File Excel Input*/
	%let m_tbl_xls_check=dataxls.xlscheck; /* Input Tbl with Checks */
	%let m_tbl_log=datalog.log_tbl; /* Log Table */
	%let m_tbl_xlscheck_nobs=;
	%let xls_output_full_path=&fld_prj./excel/&m_report_time.;  /* Output Excel */
	%let m_log_path=&fld_prj./logs/&m_report_time._DQ.log; /* Logs */
	
	%let m_report_s1_threshold=10;
	%let m_report_s2_threshold=23;
	%let m_running_time=%getTime();

	filename mailbox email from="&m_mail_from." subject="&m_mail_subject."; /* Mailing */
	filename ht "&fld_prj./reports/info.html" ; /* Dashboarding */



	/* Reports */
	%mkdir(path=&fld_prj./reports, fld=&m_prompt_area._&m_running_time.);
	%let m_report_fullpath=&fld_prj./reports/&m_prompt_area._&m_report_time/&m_prompt_area._&m_report_time; /*   Report */

	/* Libraries */
	%isLibAssigned(lib=datawrk);
	%if &isLibAssigned_rc. eq 0 %then %do;
		%let fld_stg=&fld_prj./staging/datawrk/&m_prompt_area._&m_running_time.;
		%mkdir(path=&fld_prj./staging/datawrk, fld=%scan(&fld_stg., -1 , %str(/) ));
		libname datawrk base "&fld_stg.";  /* Work Library   ; */
	%end;
	/* OUTPUT Program
	%isLibAssigned(lib=outifrs9);
	%if &isLibAssigned_rc. eq 0 %then %do;
		%let fld_output=&fld_prj./output/&m_prompt_area._&m_running_time.;
		%mkdir(path=&fld_prj./output, fld=%scan(&fld_output., -1 , %str(/) ));
		libname outifrs9 base "&fld_output"; * Output Library ;
	%end;
	*/

	%isLibAssigned(lib=dataxls);
	%if &isLibAssigned_rc. eq 0 %then %do;
		%let fld_excel=&fld_prj./excel/&m_prompt_area._&m_running_time.;
		%mkdir(path=&fld_prj./excel, fld=%scan(&fld_excel., -1 , %str(/) ));
		libname dataxls base "&fld_excel."; /* Guide Excel Library ; */
	%end;
	
	/* In case of Staging DATA */
    libname datain base "&fld_prj./staging/datainput";  /* Input GDO_DATA Library ; */
	libname datasort base "&fld_prj./staging/datasorted"; /* Copy-Input Dataset Library   ; */

	/* Process Logs */
	libname datalog base "&fld_prj./logs"; /* Log Process */


%mend;

 
%macro mainGeneral(libInput=);

	/* Reset automatic variable to avoid fake errors */
	%let syscc=0; 
	proc sql noprint;quit;

	%let macroname=mainGeneral;

	%put Debug [&m_prompt_debug_flg.];

	%global &macroname._rc;
	%let &macroname._rc=1;

	/* ------------- */
	/* >> BODY START */
	/* ------------- */

	%setupVars();

	%if &m_prompt_print_log. eq 0 %then %do;
		proc printto log="&m_log_path" new;
		run;
	  %setLogLevel(level=0);
	%end;
	%else %do;
	  	proc printto;
	  	run;
		%setLogLevel(level=1);
	%end; 

	/* ------------------------------------------------------------------------------------------------------- */
	%LET _SDTM = %SYSFUNC(datetime());
	%printToLog(mex=  Start Job [&macroname.] ) ;
	%printToLog(mex= [FLOW_STEP_BEG] Step &macroname. %sysfunc(putn(&_SDTM.,datetime20.)), debug=0);
	/* ------------------------------------------------------------------------------------------------------- */


	%if &m_prompt_cleanwrk_flg. eq 1 %then %do;
		proc datasets lib= datawrk kill nodetails nolist;
		run;
		proc datasets lib= work kill nodetails nolist;
		run;
	%end;


	/* -> Error Checking */
	%if &sqlrc>4 or &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &sqlrc=0 and &syslibrc=0)
	%then %do;
		%let errMex=%superq(syserrortext);
		%goto errLbl;
	%end;


	/* ------------- */
	/* >> BODY END   */
	/* ------------- */


	/* >> Closing */
	%goto theEndLbl;

	%errLbl:
	%put ERROR: error code=[&errMex.];
	%printToLog(mex= This step does not work correctly);
	%let &macroname._rc=0;
	%sendTerminatingMail(status=&&&macroname._rc, mex= [&errMex.] - during execution of [&macroname], to=&m_mail_to.);

	%theEndLbl:
	%let _EDTM  =%SYSFUNC(datetime()); /* Time at the end of execution */
	%let _RUNTM =%SYSFUNC(putn(&_EDTM. - &_SDTM., 12.4)); /* Time spent for execution */
	%printToLog(mex= This Job takes &_RUNTM. seconds to execute);  
	

	/* ------------------------------------------------------------------------------------------------------- */
	%printToLog(mex=End Job: [&&&macroname._rc.]) ;
	%printToLog(mex=[FLOW_STEP_END] Step &macroname. - Elapsed_time: &_RUNTM. sec. - Status: [&&&macroname._rc.], debug=0);
	/* ------------------------------------------------------------------------------------------------------- */


	/* Reset automatic variable to avoid fake errors */
	%let syscc=0; 
	proc sql noprint;quit;

%mend;


%mainGeneral();



