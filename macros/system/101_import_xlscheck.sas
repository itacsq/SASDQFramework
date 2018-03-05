/* Import Excel and counts number of observation */

%macro importXLSCheck();
	%put NOTE: macro=[ImportXLSCheck];
	
	filename tmp "&fld_excel_check./&xls_check.";
	proc import 
			file=tmp
			out=&m_tbl_xls_check.
			dbms=csv replace;
	*	getnames=yes;
	run;
	
	%let m_tbl_xlscheck_nobs=%m_f_cnt_obs(data=&m_tbl_xls_check.);
	%put NOTE: # of Var to Check of &m_tbl_xls_check. :=[&m_tbl_xlscheck_nobs.];
%mend;
