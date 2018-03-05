/* ******************************************************************* 
*	MACRO:			m_f_cnt_obs (data)
*	DESCRIPTION:	macro to count the number of observation in a 
*					dataset without reading it completely
*
*	IN PAR:			
*					data = full dataset name
*	OUT PAR:		
*					$1: macro print observation number as default
*	USAGE:
*					%let ds = sashelp.air;
*					%m_f_cnt_obs(data=&ds.);
*
* ****************************************************************** */


%macro m_f_cnt_obs(data=_last_);
	%local dsid anobs whstmt counted rc;
	%let DSID = %sysfunc(open(&DATA., IS));
	
	%if &DSID = 0 %then %do;
		%put %sysfunc(sysmsg());
		%let counted = .;
		%goto mexit;
	%end;
	%else %do;
		%let anobs = %sysfunc(attrn(&DSID, ANOBS));
		%let whstmt = %sysfunc(attrn(&DSID, WHSTMT));
	%end;
	
	%if &anobs=1& &whstmt = 0 %then %let counted = %sysfunc(attrn(&DSID, NLOBS));
	%else %do;
		%if %sysfunc(getoption(msglevel)) = I %then %put INFO: Observations in "&DATA." must be counted by iteration.;
		%let counted = 0;
		%do %while (%sysfunc(fetch(&DSID)) = 0);
			%let counted = %eval(&counted. + 1);
		%end;
	%end;
	%let rc = %sysfunc(close(&DSID));
%MEXIT:
&COUNTED.

%mend m_f_cnt_obs;
