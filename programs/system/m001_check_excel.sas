%macro mainCheckExcel(prev=1);

	/* Reset automatic variable to avoid fake errors */
	%let syscc=0; 
	proc sql noprint;quit; /* reset syserr*/

	%let macroname=mainCheckExcel;
	%if &prev eq 1 %then %do;

		/* ------------------------------------------------------------------------------------------------------- */
		%LET _SDTM = %SYSFUNC(datetime());
		%printToLog(mex=Start Job: [&macroname] ) ;
		%printToLog(mex=[FLOW_STEP_BEG] Step &macroname. %sysfunc(putn(&_SDTM.,datetime20.)) , debug=0);

		/* >> Log InfoS */
		%putInfoIntoLog();

		/* ------------------------------------------------------------------------------------------------------- */
	
		%global &macroname._rc;
		%let &macroname._rc=1;


		/* ------------- */
		/* >> BODY START */
		/* ------------- */
		
		%let m_tbl_xlscheck_nobs=%m_f_cnt_obs(data=&m_tbl_xls_check.);
		%put NOTE: # of Var to Check of &m_tbl_xls_check. :=[&m_tbl_xlscheck_nobs.];

		%if &m_prompt_debug_flg. ne 1 %then %do;
			%CheckExcel();
		%end;

		/* -> Error Checking */
		%if &sqlrc>4 or &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &sqlrc=0 and &syslibrc=0)
		%then %do;
			%let errMex=%superq(syserrortext) - Checking;
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


	%end; 
	%else %do;
		%printToLog(mex= Previous step did not work correctly);
	%end;

	/* Reset automatic variable to avoid fake errors */
	%let syscc=0; 
	proc sql noprint;quit; /* reset syserr*/
%mend;


%mainCheckExcel(prev=&mainGeneral_rc.);
