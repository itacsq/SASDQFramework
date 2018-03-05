
%macro addLogInfo(step=-1, name=DUMMY, status=END);

	%let ts=%sysfunc(putn(%sysfunc(datetime()), datetime20.));
	
	%if %sysfunc(exist(&m_tbl_log.)) eq 0 %then %do;
		proc sql noprint;
		
			create table &m_tbl_log.( compress=CHAR  bufsize=32768 )(
				username 		char(50)						,
				timestamp 		num 		format=DATETIME20.	,
				host_name 		char(50)						,
				process_id 		char(32)						,
				step_num 		num								,
				step_name		char(50)						,
				num_of_vars 	char(10)						,
				area 			char(32)						,
				fld_staging 	char(250)						,
				fld_report 		char(250)						,
				status			char(32)
			);

		quit;
	%end;

	/* 720 = 1minute */ 
	%getLock(member=&m_tbl_log., timeout=720, retry=10);
	proc sql noprint;
		delete *
		from &m_tbl_log. 
		where strip(process_id) eq strip("&SYSJOBID.")
		;
	quit;
	
	%let pathStg=%sysfunc(pathname(datawrk));
	proc sql noprint;
		insert into &m_tbl_log. (
				username, 
				timestamp, 
				host_name,
				process_id,
				step_num,
				step_name,
				num_of_vars,
				area,
				fld_staging,
				fld_report,
				status
		)
		values(
				"&SYSUSERID.",
				"&ts."dt,
				"&SYSTCPIPHOSTNAME.",
				"&SYSJOBID.",
				&step.,
				"&name.",
				"&m_tbl_xlscheck_nobs.", 
				"&m_prompt_area.",
				"&pathStg.",
				"&m_report_fullpath.",
				"&status."
		);
	quit;

	lock &m_tbl_log. clear;

	


%mend;
