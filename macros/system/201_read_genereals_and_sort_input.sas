/* It creates a ds XINFO which contains informations about all datasets listed in the Excel file
	(library, table_name, key, sort_condition, date) and
	it sorts the Input Datasets  */
%macro readAndSort();


	%global
			m_general_tbl_lib_lst
			m_general_tbl_lst
			m_general_input_id_lst
			m_general_input_sortcond
			m_general_input_orderdt
	;

	%let m_general_tbl_lib_lst=;
	%let m_general_tbl_lst=;
	%let m_general_input_id_lst=;
	%let m_general_input_sortcond=;
	%let m_general_input_orderdt=;
	
	proc sql noprint;
		select 
				distinct
				strip(table_library),
				strip(table_name),
				strip(table_key),
				strip(sort_condition),
				strip(order_dt)
		into 
			:m_general_tbl_lib_lst separated by "#",
			:m_general_tbl_lst separated by "#",
			:m_general_input_id_lst separated by "#",
			:m_general_input_sortcond separated by "#",
			:m_general_input_orderdt separated by "#"
		from &m_tbl_xls_check.
		%if &m_prompt_reduce_mode. eq 1 %then %do;
			(firstobs=&m_prompt_init_var. obs=&m_prompt_final_var. )
		%end;
		;

		create table datawrk.xgeninfo as 
		select 
				distinct
				strip(table_library) as table_library,
				strip(table_name) as table_name,
				strip(table_key) as table_key,
				strip(sort_condition) as sort_condition, 
				strip(order_dt) as order_dt
		from &m_tbl_xls_check.
		%if &m_prompt_reduce_mode. eq 1 %then %do;
			(firstobs=&m_prompt_init_var. obs=&m_prompt_final_var. )
		%end;
		;
		
		select count(*) into :m_general_tbl_count
		from datawrk.xgeninfo
		;
	quit;

	
	%let m_general_tbl_count=&m_general_tbl_count.;
	%let i=1;
	%let lib=;
	%let tbl=;
	%let id=;
	%let sort=;
	%let dt=;

	%do i=1 %to &m_general_tbl_count.;
		%let lib=%scan(&m_general_tbl_lib_lst., &i., #);
		%let tbl=%scan(&m_general_tbl_lst., &i., #);
		%let id=%scan(&m_general_input_id_lst., &i., #);
		%let sort=%scan(&m_general_input_sortcond., &i., #);
		%let dt=%scan(&m_general_input_orderdt., &i., #);
		%put Sorting Lib=[&lib.] Tbl=[&tbl.] Sort=[&sort.] Dt=[&dt.];
		proc sort data=&lib..&tbl. out=datasort.&tbl.;
			by &sort. &dt.;
		run;	
	%end;
	
		
%mend;
/*
%readAndSort();
*/



