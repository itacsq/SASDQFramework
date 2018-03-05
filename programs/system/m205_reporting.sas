%macro mainReport(prev=1);

	/* Reset automatic variable to avoid fake errors */
	%let syscc=0; 
	proc sql noprint;quit; /* reset syserr*/

	%let macroname=mainReport;

	%checkExistTbls(lib=datawrk, pattern=G_);

	%if &prev eq 1 or (&m_prompt_debug_flg. eq 1 and &m_prompt_force_exec. eq 1 and &checkExistTbls_rc. eq 1) %then %do;


		/* ------------------------------------------------------------------------------------------------------- */
		%LET _SDTM = %SYSFUNC(datetime());
		%printToLog(mex=Start Job: [&macroname] ) ;
		%printToLog(mex=[FLOW_STEP_BEG] Step &macroname. %sysfunc(putn(&_SDTM.,datetime20.)) , debug=0);

		/* >> Log InfoS */
		%putInfoIntoLog();

		%if &prev. ne 1 %then %do;
			%put WARNING: You are forcing execution of this Job;
		%end;
		/* ------------------------------------------------------------------------------------------------------- */


		%global &macroname._rc;
		%let &macroname._rc=1;

		%addLogInfo(step=3, name=Reporting, status=BEGIN);
		/* ------------- */
		/* >> BODY START */
		/* ------------- */
		%createReport();

		%if &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &syslibrc=0) %then %do;
			%let errMex=%superq(syserrortext);
			%goto errLbl;
		%end;

		
		/*delete Granular Tables, if requested*/
		%if &m_prompt_delete_granular ne 0 %then %do;
		    %put Clean Granular Tables;
			%delete_granular_tables();
		%end;
		%if &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &syslibrc=0) %then %do;
			%let errMex=%superq(syserrortext);
			%goto errLbl;
		%end;

		/* ------------- */
		/* >> BODY END   */
		/* ------------- */
		%addLogInfo(step=3, name=Reporting, status=END);
        

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
		%sendTerminatingMail(status=1, to=&m_mail_to.);


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

%mainReport(prev=&mainControls_rc.);
