/* It creates a list of checked variables, a dataset with info about all of them.
	It export an Excel file with this info */
%macro ListCheckedVars();

	%global var_info_list;
	%let var_info_list=;

	%global m_report_owners_lst;
	%let m_report_owners_lst=;

	proc contents data=datawrk._all_ out=info noprint nodetails;
	run;

	proc sql noprint;
		select distinct memname into :var_info_list separated by "#"
		from info
		where memname like 'INFO_%'
		order by memname 
		;
	quit;

	
	/* It creates a dataset with info about all variables which were analysed */
	data datawrk.XINFO;
		set 
			%let index=1;
			%do %while(%scan(&var_info_list., &index., #) ne );
				%let ds=%scan(&var_info_list., &index., #);
				datawrk.&ds. 
				%let index=%eval(&index.+1);
			%end;
			;
	run;
	
	%global m_tbl_xlschecked_nobs;
	%let m_tbl_xlschecked_nobs=%m_f_cnt_obs(data=datawrk.xinfo);


	/* It creates a list of business owners of checked variables */
	proc sql noprint;
		select distinct tranwrd(strip(business_owner), " ","_")
			into : m_report_owners_lst separated by "#"
		from datawrk.XINFO
		where not missing(business_owner)
		;
	quit;
	%put NOTE: [&m_report_owners_lst.];

%mend;
