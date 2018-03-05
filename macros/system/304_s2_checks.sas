/* S2: Domain Distribution.
	If the control applies (for string fields or numeric discrete fields),
	a table reporting the frequency of each possible value of the var is created; */
%macro checkS2(S2tblIn=);

	%put NOTE: Flag S2=[&m_check_var_s2_flg.];
	%if &m_check_var_s2_flg. ne %then %do;
		%put NOTE: Starting S2 Check for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];
		%printToLog(mex= [FLOW_CHECK] - SYNTHETIC CHECK S2 , debug=0);


			proc freq data=&S2tblIn. noprint;
				tables &m_check_var_nm. /out=datawrk.S2_M_&m_check_var_pos. missing ; 
				where checkM eq 0 or checkW eq 0 ;
				format &m_check_var_nm. &m_check_var_format.;
			run;


			proc freq data= &S2tblIn. noprint;
				tables &m_check_var_nm. /out=datawrk.S2_&m_check_var_pos. ;
				where checkM eq 1 and checkW eq 1;
				format &m_check_var_nm. &m_check_var_format.;
			run;


			/* DS WITHOUT missing values */
			%if %sysfunc(exist(datawrk.S2_&m_check_var_pos. ))%then %do;
				%let nObs=%m_f_cnt_obs(data=datawrk.S2_&m_check_var_pos.);
			
				proc sort data=datawrk.S2_&m_check_var_pos.;
					by descending percent;
				run;

				data datawrk.S2_&m_check_var_pos.;
					set datawrk.S2_&m_check_var_pos.;
					format percent percent12.2 cumperc percent12.2;
					label cumperc="Cumulated Percentage";
					retain cumperc;
					percent=percent/100;
					cumperc=sum(cumperc, percent);
					%if &nObs. gt &m_report_s2_threshold. %then %do;
						if cumperc gt 0.99 or percent < 0.001  or _n_ gt &m_report_s2_threshold.  then delete;
					%end;
				run;
			%end;
			%else %do;
				data datawrk.S2_&m_check_var_pos.;
					length nocontrol 8.;
				run;
			%end;


			/* DS WITH missing values */
			%if %sysfunc(exist(datawrk.S2_M_&m_check_var_pos. ))%then %do;
				proc sort data=datawrk.S2_M_&m_check_var_pos.;
					by descending percent;
				run;

				data datawrk.S2_M_&m_check_var_pos.;
					set datawrk.S2_M_&m_check_var_pos.;
					format percent percent12.2 cumperc percent12.2;
					label cumperc="Cumulated Percentage";
					retain cumperc;
					percent=percent/100;
					cumperc=sum(cumperc, percent);
				run;
			%end;
			%else %do;
				data datawrk.S2_M_&m_check_var_pos.;
					length nocontrol 8.;
				run;
			%end;

		%put NOTE: Closing S2 Check for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];
	%end;
	%else %do;
		%put NOTE: &m_check_var_nm. does not require any S2 check;
	%end;
%mend;
