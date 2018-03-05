/* S4: Reconciliation.
	If the control applies, the sum of all values respecting the where condition is calculated
	(possibly grouped by reconciliation class);*/
%macro checkS4(S4tblIn=);
	%put NOTE: Flag S4=[&m_check_var_s4_flg.];
	%if &m_check_var_s4_flg. ne %then %do;
		%put NOTE: Starting S4 Check for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];
		%printToLog(mex= [FLOW_CHECK] - SYNTHETIC CHECK S4 , debug=0);

		proc sql noprint;
			create table datawrk.S4_&m_check_var_pos. as
				select 
					%macro printReconcClass(cond=);
						%if %length(&cond.) ne 0 %then %do;
							&cond. ,
						%end;
					%mend;
					%printReconcClass(cond=&m_check_var_cond_reconc.)
					sum(&m_check_var_nm.) as Sum label="Sum of &m_check_var_nm." 
					%if %length(&m_check_var_format.) ge 4 %then %do;
						format &m_check_var_format.
					%end;
					%else %do;
						%if &m_check_var_type ne C %then %do;
							format commax20.2
						%end;
					%end;
				from &S4tblIn.
				where checkW eq 1
				%macro printGroupbyReconcClass(cond=);
					%if %length(&cond.) ne 0 %then %do;
						group by &cond.
					%end;
				%mend;
				%printGroupbyReconcClass(cond=&m_check_var_cond_reconc.)
				;
		quit;

		%if %sysfunc(exist(datawrk.S4_&m_check_var_pos.)) ne 1 %then %do;
			data datawrk.S4_&m_check_var_pos.;
				length nocontrol 8.;
			run;
		%end;
		%put NOTE: Closing S4 Check for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];

	%end;
	%else %do;
		%put NOTE: &m_check_var_nm. does not require any S4 check;
	%end;
%mend;
