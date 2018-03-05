%macro CheckExcel();

	%global Import_Sort_ok;

	%let loopInit=1;
	%let loopEnd=&m_tbl_xlscheck_nobs.;

	%do n_pos=&loopInit. %to &loopEnd. %by 1;
		
		%setUpXLSVars(n_check=&n_pos.);	

		%if &m_check_var_tbl_exist. eq 0 %then %do;
			%put WARNING: Table [&m_check_var_tbl_lib..&m_check_var_tbl.] does not exist!! ;
			%goto errLbl;
		%end;

		%if &m_check_var_exist. eq 0 %then %do;
			%put WARNING: Var [&m_check_var_nm] is not included within input table [&m_check_var_tbl_lib..&m_check_var_tbl.];
			%goto errLbl;
		%end;

		%if &m_check_keepvar_exist. eq 0 %then %do;
			%put WARNING: Variables to keep are not included within input table [&m_check_var_tbl_lib..&m_check_var_tbl.];
			%goto errLbl;
		%end;

	%end;

	%goto theEndLbl;
	%errLbl:
		%put ERROR: Excel not correctly set . Review configuration file . ;
	%theEndLbl:

	%let syscc=0; /* Reset automatic variable to avoid more errors */

%mend;
