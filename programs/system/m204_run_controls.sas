
%macro mainControls(prev=1);
    /* Reset automatic variable to avoid fake errors */
    %let syscc=0;

    proc sql noprint;
    quit; /* reset syserr*/

    %let macroname=mainControls;

    %if &prev eq 1 or (&m_prompt_debug_flg. eq 1 and &m_prompt_force_exec. eq 1) %then %do;

            proc sql noprint;
            quit;

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

			%addLogInfo(step=2, name=Checking, status=BEGIN);
            /* ------------- */
            /* >> BODY START */
            /* ------------- */

            %let m_tbl_xlscheck_nobs=%m_f_cnt_obs(data=&m_tbl_xls_check.);


            %if &m_prompt_debug_flg. eq 1 %then %do;
                %if &m_prompt_reduce_mode. eq 1 %then %do;
                    %let loopInit=&m_prompt_init_var.;
                    %let loopEnd=&m_prompt_final_var.;
                %end;
                %else %do;
                    %let loopInit=1;
                    %let loopEnd=&m_tbl_xlscheck_nobs.;
                %end;
                %end;
            %else %do;
                %let loopInit=1;
                %let loopEnd=&m_tbl_xlscheck_nobs.;
            %end;

            %printToLog(mex= Starting Loop);


            %let n_pos=49;
            %do n_pos=&loopInit. %to &loopEnd. %by 1;
                %printToLog(mex=***** Starting Loop at %getTime() *******);

                /* 1. Set Up Checks */
                %printToLog(mex= Set Up Check Var - Position [&n_pos.]);
                %setUpXLSVars(n_check=&n_pos.);
				/*
				%printMacros(pattern=m_check, debug=1);
				%printMacros(pattern=m_tbl, debug=1);
				*/
                %printToLog(mex= [FLOW_NAME] - Variable [&m_check_var_nm.] - %eval(&n_pos.-&loopInit.+1)/%eval(&loopEnd.-&loopInit. +1 ), debug=0);

                %if &sqlrc>4 or &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &sqlrc=0 and &syslibrc=0)
                %then %do;
                        %put WARNING: Error during execution of setUpXLSVars;
                        %put sqlrc=&sqlrc - syserr=&syserr - syslibrc=&syslibrc - syscc=&syscc;
                        %let errMex=%superq(syserrortext);
                        %goto errLbl;
                %end;

                %if &m_prompt_debug_flg. eq 0 or
                    (&m_prompt_debug_flg. eq 1 and &m_check_var_tbl_exist. eq 1
                    and &m_check_var_exist. eq 1 and &m_check_keepvar_exist. eq 1) %then %do;
                    
                    /* 2. Copy Part of the Input Table */
                    %printToLog(mex= Copy Table [&m_check_var_nm.] - Position [&n_pos.]);
                    %printToLog(mex= [FLOW_CHECK] - COPYING INPUT TABLE , debug=0);
                    %cpInput(tblIn=datasort.&m_check_var_tbl., libOut=datawrk);

                    %if &sqlrc>4 or &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &sqlrc=0 and &syslibrc=0)
                    %then %do;
                        %put WARNING: Error during execution of cpInput;
                        %put sqlrc=&sqlrc - syserr=&syserr - syslibrc=&syslibrc - syscc=&syscc;
                        %let errMex=%superq(syserrortext);
                        %goto errLbl;
                    %end;

                    /* 3. Granularity Check */
                    %printToLog(mex= Check Granularity [&m_check_var_nm.] - Position [&n_pos.]);
                    %printToLog(mex= Starting Job:  Granular Controls);
                    %printToLog(mex= [FLOW_CHECK] - GRANULARITY CHECKS , debug=0);
                    %checkGranularity(tblIn=datawrk.G_&m_check_var_pos., tblOut=datawrk.G_&m_check_var_pos., debug=&m_prompt_debug_flg.);

                    %if &sqlrc>4 or &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &sqlrc=0 and &syslibrc=0)
                    %then %do;
                            %put WARNING: Error during execution of checkGranularity;
                            %put sqlrc=&sqlrc - syserr=&syserr - syslibrc=&syslibrc - syscc=&syscc;
                            %let errMex=%superq(syserrortext);
                            %goto errLbl;
                    %end;
                    %printToLog(mex= Closing Job:  Granular Controls );

                    /* 4. Synthetic Check */
                    %printToLog(mex= Check Synthetics [&m_check_var_nm.] - Position [&n_pos.]);
                    %printToLog(mex= Starting Job:  Synthetic Controls );
                   
                    %checkSynthetic(tblIn=datawrk.G_&m_check_var_pos.);

                    %if &sqlrc>4 or &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &sqlrc=0 and &syslibrc=0)
                    %then %do;
                            %put WARNING: Error during execution of checkSynthetics;
                            %put sqlrc=&sqlrc - syserr=&syserr - syslibrc=&syslibrc - syscc=&syscc;
                            %let errMex=%superq(syserrortext);
                            %goto errLbl;
                    %end;
                    %printToLog(mex= Closing Job:  Synthetic Controls );

                    /* 4. Special Controls */
                    %printToLog(mex= Special Controls [&m_check_var_nm.] - Position [&n_pos.]);
                    %printToLog(mex= Starting Job:  Special Controls );
                    %printToLog(mex= [FLOW_CHECK] - SPECIAL CONTROLS , debug=0);
                    %specialControl(var=&m_check_var_nm., tbl=datawrk.G_&m_check_var_pos., tblIn=&m_check_var_tbl.);
                    %let m_check_var_spec=&specialControl_rc.;

                    %if &sqlrc>4 or &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &sqlrc=0 and &syslibrc=0)
                    %then %do;
                            %put WARNING: Error during execution of SpecialControls;
                            %put sqlrc=&sqlrc - syserr=&syserr - syslibrc=&syslibrc - syscc=&syscc;
                            %let errMex=%superq(syserrortext);
                            %goto errLbl;
                    %end;
                    %printToLog(mex= Closing Job:  Special Controls );

                    /* Table of information about checked variable */
                    %printToLog(mex= Table of information about [&m_check_var_nm.] - Position [&n_pos.]);
                    %printToLog(mex= Starting Job:  Table of information );
                    %printToLog(mex= [FLOW_CHECK] - CHECK INFO , debug=0);

					/* 5. Create Statistics on Gn */
					%createStats();

					%if &sqlrc>4 or &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &sqlrc=0 and &syslibrc=0)
                    %then %do;
                            %put WARNING: Error during creation of Statistics;
                            %put sqlrc=&sqlrc - syserr=&syserr - syslibrc=&syslibrc - syscc=&syscc;
                            %let errMex=%superq(syserrortext);
                            %goto errLbl;
                    %end;
                    %printToLog(mex= Closing Job:  Create Statistics  );


                    %checkInfo(); 
                    %if &sqlrc>4 or &syserr>4 or &syslibrc^=0 or (&syscc^=0 and &syscc^=4 and &syserr=0 and &sqlrc=0 and &syslibrc=0)
                    %then %do;
                            %put WARNING: Error during execution of CheckInfo;
                            %put sqlrc=&sqlrc - syserr=&syserr - syslibrc=&syslibrc - syscc=&syscc;
                            %let errMex=%superq(syserrortext);
                            %goto errLbl;
                    %end;
                    %printToLog(mex= Closing Job:  Table of information );


                %end;

                %else %do;
                    %if &m_check_var_tbl_exist. eq 0 %then %do;
                        %put WARNING: Table [&m_check_var_tbl_lib..&m_check_var_tbl.] does not exist!!;
                    %end;
                    %else %if &m_check_var_exist. eq 0 %then %do;
                        %put WARNING: Var [&m_check_var_nm] is not included within input table [&m_check_var_tbl_lib..&m_check_var_tbl.];
                    %end;
                    %else %if &m_check_keepvar_exist. eq 0 %then %do;
                        %put WARNING: Variables to keep are not included within input table [&m_check_var_tbl_lib..&m_check_var_tbl.];
                    %end;
                %end;

            %end;

            /* ------------- */
            /* >> BODY END   */
            /* ------------- */
			%addLogInfo(step=2, name=Checking, status=END);

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

    proc sql noprint;
    quit;

%mend;

%mainControls(prev=&mainSort_rc.);
