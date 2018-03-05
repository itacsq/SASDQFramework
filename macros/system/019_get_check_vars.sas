/* It takes info about variable to check from Excel File */
%macro setUpXLSVars(n_check=&n_pos_check., debug=0);
	%put NOTE: macro=[2.1 setUpCheckVars];

	%global 
			m_check_var_pos
			m_check_var_nm
			m_check_var_tbl_lib
			m_check_var_tbl
			m_tbl_input_id
			m_tbl_input_sortcond
			m_check_var_order_dt
			m_check_var_keep_vars
			m_check_var_business_owner
			m_check_var_where_filter
			m_check_var_cond_where
			m_check_var_cond_missing
			m_check_var_cond_domain
			m_check_var_cond_reconc
			m_check_var_cond_numexclus
			m_check_var_cond_top20
			m_check_num_group_by
			m_check_var_g1_flg
			m_check_var_g2_flg
			m_check_var_g3_flg
			m_check_var_g4_flg
			m_check_var_s1_flg
			m_check_var_s2_flg
			m_check_var_s3_flg
			m_check_var_s4_flg
			m_check_var_spec_control
			m_check_var_type
			m_check_var_length
			m_check_var_format
			m_check_var_tbl_exist
			m_check_var_exist
			m_check_keepvar_exist
			m_check_var_desc
			m_tbl_input_sortcond_last
			m_check_var_lookup_tbl
			m_check_var_spec
	;

	%let m_check_var_pos=;
	%let m_check_var_nm=;
	%let m_check_var_tbl_lib=;
	%let m_check_var_tbl=;
	%let m_tbl_input_id=;
	%let m_tbl_input_sortcond=;
	%let m_check_var_order_dt=;
	%let m_check_var_keep_vars=;
	%let m_check_var_business_owner=;
	%let m_check_var_where_filter=;
	%let m_check_var_cond_where=;
	%let m_check_var_cond_missing=;
	%let m_check_var_cond_domain=;
	%let m_check_var_cond_reconc=;
	%let m_check_var_cond_numexclus=;
	%let m_check_var_cond_top20=;
	%let m_check_num_group_by=;
	%let m_check_var_g1_flg=;
	%let m_check_var_g2_flg=;
	%let m_check_var_g3_flg=;
	%let m_check_var_g4_flg=;
	%let m_check_var_s1_flg=;
	%let m_check_var_s2_flg=;
	%let m_check_var_s3_flg=;
	%let m_check_var_s4_flg=;
	%let m_check_var_spec_control=;
	%let m_check_var_type=;
	%let m_check_var_length=;
	%let m_check_var_format=;
	%let m_check_var_tbl_exist=;
	%let m_check_var_exist=;
	%let m_check_keepvar_exist=;
	%let m_check_var_desc=;
	%let m_tbl_input_sortcond_last=;
	%let m_check_var_lookup_tbl=;
	%let m_check_var_spec=;


	proc sql noprint;
		select 
				num,
				field_name, 
				table_library, 
				table_name,
				table_key,
				sort_condition,
				order_dt,
				keep_vars,
				tranwrd(business_owner, '&', 'n'),
				where_filter,
				where_condition,
				missing_condition,
				domain,
				reconciliation_class,
				numeric_distribution_exclusions, 
				top_20_base,
				numeric_group_by,
				G1_check_domain,
				G2_historical_trend,
				G3_where_not_check,
				G4_data_completition,
				s1_top_20,
				s2_domain_distribution,
				s3_numeric_distribution, 
				s4_reconciliation,
				specific_controls,
				var_lookup,
				tranwrd(tranwrd(description, "'", " "), '&', 'n')
		into 
			:m_check_var_pos,
			:m_check_var_nm,
			:m_check_var_tbl_lib,
			:m_check_var_tbl,
			:m_tbl_input_id,
			:m_tbl_input_sortcond,
			:m_check_var_order_dt,
			:m_check_var_keep_vars,
			:m_check_var_business_owner,
			:m_check_var_where_filter,
			:m_check_var_cond_where,
			:m_check_var_cond_missing,
			:m_check_var_cond_domain,
			:m_check_var_cond_reconc,
			:m_check_var_cond_numexclus,
			:m_check_var_cond_top20,
			:m_check_num_group_by,
			:m_check_var_g1_flg,
			:m_check_var_g2_flg,
			:m_check_var_g3_flg,
			:m_check_var_g4_flg,
			:m_check_var_s1_flg,
			:m_check_var_s2_flg,
			:m_check_var_s3_flg,
			:m_check_var_s4_flg,
			:m_check_var_spec_control,
			:m_check_var_lookup_tbl,
			:m_check_var_desc
		from &m_tbl_xls_check.(obs=&n_check. firstobs=&n_check.)
		;
	quit;


	%let m_check_var_pos=&m_check_var_pos.;
	%let m_check_var_nm=&m_check_var_nm.;
	%let m_check_var_tbl_lib=&m_check_var_tbl_lib.;
	%let m_check_var_tbl=&m_check_var_tbl.;
	%let m_tbl_input_id=&m_tbl_input_id.;
	%let m_tbl_input_sortcond=&m_tbl_input_sortcond.;
	%let m_check_var_order_dt=&m_check_var_order_dt.;
	%let m_check_var_keep_vars=&m_check_var_keep_vars.;
	%let m_check_var_business_owner=&m_check_var_business_owner.;
	%let m_check_var_where_filter=&m_check_var_where_filter.;
	%let m_check_var_cond_where=&m_check_var_cond_where.;
	%let m_check_var_cond_missing=&m_check_var_cond_missing.;
	%let m_check_var_cond_domain=&m_check_var_cond_domain.;
	%let m_check_var_cond_reconc=&m_check_var_cond_reconc.;
	%let m_check_var_cond_numexclus=&m_check_var_cond_numexclus.;
	%let m_check_var_cond_top20=&m_check_var_cond_top20.;
	%let m_check_num_group_by=&m_check_num_group_by.;
	%let m_check_var_g1_flg=&m_check_var_g1_flg.;
	%let m_check_var_g2_flg=&m_check_var_g2_flg.;
	%let m_check_var_g3_flg=&m_check_var_g3_flg.;
	%let m_check_var_g4_flg=&m_check_var_g4_flg.;
	%let m_check_var_s1_flg=&m_check_var_s1_flg.;
	%let m_check_var_s2_flg=&m_check_var_s2_flg.;
	%let m_check_var_s3_flg=&m_check_var_s3_flg.;
	%let m_check_var_s4_flg=&m_check_var_s4_flg.;
	%let m_check_var_spec_control=&m_check_var_spec_control.;
	%let m_check_var_lookup_tbl=&m_check_var_lookup_tbl.;
	%let m_check_var_desc=&m_check_var_desc.;

	%global m_tbl_input_sortcond_sql;
	%replaceBlankWComma(instr=&m_tbl_input_sortcond.);
	%let m_tbl_input_sortcond_sql=&replaceChar_rc.; 

	%global m_tbl_input_id_sql;
	%replaceBlankWComma(instr=&m_tbl_input_id.);
	%let m_tbl_input_id_sql=&replaceChar_rc.; 

	%global m_tbl_input_sortcond_last;
	%let m_tbl_input_sortcond_last=%scan(&m_tbl_input_sortcond,-1); 


	%if &m_prompt_sorted_flg. eq 1 %then %do;
		%let m_check_var_tbl_lib =datasort;
	%end;


	/* Check Table Existence */
	%put NOTE: Checking Table Existence;
	%let m_check_var_tbl_exist=%sysfunc(exist(&m_check_var_tbl_lib..&m_check_var_tbl.));

	/* Check Existence in the Table of the Variable which is analysed and of the List of Variables to keep */
	%put NOTE: Checking Variable Existence;
	%checkVarExist(&m_check_var_nm., &m_check_var_tbl_lib..&m_check_var_tbl., &m_check_var_keep_vars.);
	%let m_check_var_exist=&checkVarExist_rc.;
	%let m_check_keepvar_exist =&checkKeepVarExist_rc.;

	%if &m_check_var_tbl_exist. ne 1 or &m_check_var_exist. ne 1 %then %do;
		%put WARNING: Table [&m_check_var_tbl.] or Var [&m_check_var_nm.] does not exist!!;
	%end;
	%else %do;
		/* It gets Var Type: N=num; C=char*/
		%getVarType(lib=&m_check_var_tbl_lib., ds=&m_check_var_tbl., varname=&m_check_var_nm.);
		%let m_check_var_type=%upcase(%substr(&vartype.,1,1); 
		%let m_check_var_format=&varformat.;
		%let m_check_var_length=&varlength.;
	%end;
	
	%printMacros(pattern=m_check_var, debug=&debug.);
	%printMacros(pattern=m_tbl, debug=&debug.);

	
%mend;
