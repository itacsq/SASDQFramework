/* ************************************************************************************************************** 
*
*	MACRO:			checkS1
*	DESCRIPTION:	this macro saves the result of proc univariate in a table,
*					in order to create a dataset of top20
*	PARAMETERS:		S1tblIn = input dataset
*
* ************************************************************************************************************** */

/* S1: Top 20.
	If the control applies, a table reporting the list of top 20 is created
	(sorting var specified by TOP 20 BASE parameter, where condition applied) */


%macro checkS1(S1tblIn=);
	%put NOTE: Flag S1=[&m_check_var_s1_flg.];
	%if &m_check_var_s1_flg. ne %then %do;
		%put NOTE: Starting S1 Check for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];
		%printToLog(mex= [FLOW_CHECK] - SYNTHETIC CHECK S1 , debug=0);
		/* %printMacros(pattern=m_check, debug=1); */
		%local flg_same_var;
		%let flg_same_var=0;
		%if %length(&m_check_var_cond_top20.) eq 0 %then %do;
			%let m_check_var_cond_top20=&m_check_var_nm.;
		%end;
		%if &m_check_var_cond_top20. eq &m_check_var_nm. %then %do;
			%let flg_same_var=1;
		%end;

		proc sql noprint;
			create table tmpS1 as 
			select 
				%if &flg_same_var. ne 1 %then %do;
					&m_check_var_cond_top20. ,
				%end;
				&m_check_var_nm.,
				count(*) as count
			from &S1tblIn.(where=(checkM eq 1))
			group by &m_check_var_cond_top20.
			order by &m_check_var_cond_top20. desc;
		quit;


		%let numFreq=%m_f_cnt_obs(data=tmpS1);


		%if &numFreq. gt 0 %then %do;

			%let numObs=0;
			proc sql noprint;
				select count(*) into :numObs
				from &S1tblIn
				where checkM eq 1 
				;
			run;
			
			proc sql noprint;
				create table tmpS1TOP as 
				select 
					"Top Values" as type label="Type" length=15,
					%if &flg_same_var. ne 1 %then %do;
						&m_check_var_cond_top20. ,
					%end;
					&m_check_var_nm.,
					count format=commax10. label="Count",
					count/&numObs. as perc format=percent10.5 label="Percent (without Missing)"
				from tmpS1(obs=&m_report_s1_threshold.)
				;

			quit;




			proc sql noprint;
				
				/* In case where |values| are less then threshold no table is printed */


				/* Base: cutoff=nObs in Freq Table - Threshold */
				%let cutoff=%eval(&numFreq.-&m_report_s1_threshold.);
				/* If nObs Freq < Threshold*2  ... */
				%if &numFreq. le %eval(&m_report_s1_threshold.*2) %then %do;
					/* ... and nObs Freq - Threshold > 0 => cutoff = Threshold + 1*/
					%if &cutoff. gt 0 %then %do;
						%let cutoff=%eval(&m_report_s1_threshold.+1);					
					%end;
				%end;
				
				%if &cutoff. gt 0 %then %do;
					create table tmpS1BOTTOM as 
					select 
						"Bottom Values" as type label="Type" length=15,
						%if &flg_same_var. ne 1 %then %do;
							&m_check_var_cond_top20. ,
						%end;
						&m_check_var_nm.,
						count format=commax10. label="Count",
						count/&numObs. as perc format=percent10.5 label="Percent (without Missing)"
					from tmpS1(firstobs=&cutoff. obs=&numFreq.);
				%end;
				%else %do;
					data tmpS1TOP;
						set tmpS1TOP;
						type = "All Values";
					run;
				%end;

			quit;
			proc sql noprint;
				create table datawrk.S1_&m_check_var_pos. like tmpS1TOP;
			quit;


			proc append base=datawrk.S1_&m_check_var_pos. data=tmpS1TOP;
			run;

			/* Check if there are more values then threshold */ 
			%if %sysfunc(exist(tmpS1BOTTOM)) %then %do;
				proc append base=datawrk.S1_&m_check_var_pos. data=tmpS1BOTTOM;
				run;
				proc delete data=tmpS1BOTTOM;
				run;
			%end;

			proc delete data=tmpS1TOP;
			run;
			proc delete data=tmpS1;
			run;

		%end;
		%else %do;
			proc sql noprint;
				create table datawrk.S1_&m_check_var_pos.
				(nocolumn char)
				;
			quit;
		%end;

		%put NOTE: Closing S1 Check for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];
	%end;
	%else %do;
		%put NOTE: &m_check_var_nm. does not require any S1 check;
	%end;
%mend;

