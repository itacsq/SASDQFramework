/* It performs Synthetic checks for a fixed variable */
%macro checkSynthetic(tblIn=);
	%put NOTE: macro=[5.1 checkSynthetic];
	%put NOTE: -----------------------------------------------------------------------------------------------;
	%put NOTE: Starting Synthetic Checks for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];
	
	%checkS1(S1tblIn=&tblIn.);
	%checkS2(S2tblIn=&tblIn.);
	%checkS3(S3tblIn=&tblIn.);
	%checkS4(S4tblIn=&tblIn.);
	
	%put NOTE: Closing Synthetic Checks for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];

%mend;


