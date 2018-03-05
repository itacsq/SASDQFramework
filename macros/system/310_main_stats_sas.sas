/* It performs Synthetic checks for a fixed variable */
%macro createStats();
	%put NOTE: macro=[7.1 checkSynthetic];
	%put NOTE: -----------------------------------------------------------------------------------------------;
	%put NOTE: Creating Statistics for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];

	%countYN(Gcheck=1, flag=&m_check_var_g1_flg.);
	%checkG2synt(flag=&m_check_var_g2_flg.);
	%countYN(Gcheck=3, flag=&m_check_var_g3_flg.);
	%countYN(Gcheck=4, flag=&m_check_var_g4_flg.);
	
	%put NOTE: Closing Statistics Checks for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];

%mend;


