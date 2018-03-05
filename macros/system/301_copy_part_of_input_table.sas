/* Let  &m_check_var_nm. be the variable to check.
	This macro creates a copy of the table which contains that variable,
	keeping the columns of ID,the column of the variable and
	all the columns needed for the checks and adding new columns for checks.
	The copy is called G_&m_check_var_nm.*/

%macro cpInput(tblIn=, libOut=);



	%put NOTE: macro=[3.1 cpInput];
	%put NOTE: Starting Copying Part of the Table for [&tblIn.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];

	%global m_tbl_input_nobs;
	%let m_tbl_input_nobs=;

	%put NOTE: tblIn=[&tblIn.] libOut=[&libOut.];


	data &libOut..G_&m_check_var_pos.;
			length numobs 8.; *checkM checkW checkD checkLagM checkLagW checkLagD 8.;
			set &tblIn. (keep=&m_tbl_input_id. &m_check_var_nm. &m_check_var_keep_vars.);
			numobs=_n_;
		%if %bquote(&m_check_var_where_filter.) ne %then %do;
			where &m_check_var_where_filter.;
		%end;
	run;

	%let m_tbl_input_nobs=%m_f_cnt_obs(data=&tblIn.);
	%put NOTE: # of Obs of &tblIn. :=[&m_tbl_input_nobs.];
	%put NOTE: Closing Copying Table for [&tblIn.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];


%mend;
