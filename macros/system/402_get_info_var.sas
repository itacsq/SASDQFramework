/* It takes info about checked variable (called &m_report_var_nm.)
	from INFO_&m_report_var_nm. */

%macro getInfoVar(givindex=1);

	%global 
		m_report_var_nm
		m_report_var_tbl		
		m_report_var_tbl_lib
		m_report_var_order_dt
		m_report_var_business_owner
		m_report_var_filter
		m_report_var_pos
		m_report_var_rundt
		m_report_var_G1_flg
		m_report_var_G2_flg
		m_report_var_G3_flg
		m_report_var_G4_flg
		m_report_var_S1_flg
		m_report_var_S2_flg
		m_report_var_S3_flg
		m_report_var_S4_flg
		m_report_var_type
		m_report_var_length
		m_report_var_format
		m_report_var_desc
		m_report_var_lookup_tbl
		m_report_var_spec
		m_report_var_spec_control
		m_report_tt1
		m_report_tt2
		m_report_tt3
		m_report_where_cond
		m_report_missing_cond
		m_report_domain_cond
		;

	%let m_report_var_nm=;
	%let m_report_var_tbl=;
	%let m_report_var_tbl_lib=;
	%let m_report_var_order_dt=;
	%let m_report_var_business_owner=;
	%let m_report_var_filter=;
	%let m_report_var_pos=;
	%let m_report_var_rundt=;
	%let m_report_var_G1_flg=;
	%let m_report_var_G2_flg=;
	%let m_report_var_G3_flg=;
	%let m_report_var_G4_flg=;
	%let m_report_var_S1_flg=;
	%let m_report_var_S2_flg=;
	%let m_report_var_S3_flg=;
	%let m_report_var_S4_flg=;
	%let m_report_var_type=;
	%let m_report_var_length=;
	%let m_report_var_format=;
	%let m_report_var_desc=;
	%let m_report_var_lookup_tbl=;
	%let m_report_var_spec=;
	%let m_report_var_spec_control=;
	%let m_report_tt1=;
	%let m_report_tt2=;
	%let m_report_tt3=;
	%let m_report_where_cond=;
	%let m_report_missing_cond=;
	%let m_report_domain_cond=;
	

		proc sql noprint;
			select
				varname,
				tbl,
				lib,
				order_dt,
				tranwrd(strip(business_owner)," ", "_"),
				filter,
				varpos,
				rundt,
				G1_flag,
				G2_flag,
				G3_flag,
				G4_flag,
				S1_flag,
				S2_flag,
				S3_flag,
				S4_flag,
				type,
				length,
				varformat,
				var_lookup,
				description,
 				spec,
				spec_control,
				coalescec(where_cond, "No where condition defined") length=1024,
				coalescec(missing_cond, "Using default condition: (.) for numeric, (' ') for string") length=1024,
				coalescec(domain_cond, "No domain condition defined") length=1024
			into
				:m_report_var_nm,
				:m_report_var_tbl,
				:m_report_var_tbl_lib,
				:m_report_var_order_dt,
				:m_report_var_business_owner,
				:m_report_var_filter,
				:m_report_var_pos,
				:m_report_var_rundt,
				:m_report_var_G1_flg,
				:m_report_var_G2_flg,
				:m_report_var_G3_flg,
				:m_report_var_G4_flg,
				:m_report_var_S1_flg,
				:m_report_var_S2_flg,
				:m_report_var_S3_flg,
				:m_report_var_S4_flg,
				:m_report_var_type,
				:m_report_var_length,
				:m_report_var_format,
				:m_report_var_lookup_tbl,
				:m_report_var_desc,
				:m_report_var_spec,
				:m_report_var_spec_control,
				:m_report_where_cond,
				:m_report_missing_cond,
				:m_report_domain_cond
			from datawrk.%scan(&var_info_list., &givindex., #)
			;
		quit;

		%let m_report_var_nm=&m_report_var_nm.;
		%let m_report_var_tbl=&m_report_var_tbl.;
		%let m_report_var_tbl_lib=&m_report_var_tbl_lib.;
		%let m_report_var_order_dt=&m_report_var_order_dt.;
		%let m_report_var_business_owner=&m_report_var_business_owner.;
		%let m_report_var_filter=&m_report_var_filter.;
		%let m_report_var_pos=&m_report_var_pos.;
		%let m_report_var_rundt=&m_report_var_rundt.;
		%let m_report_var_G1_flg=&m_report_var_G1_flg.;
		%let m_report_var_G2_flg=&m_report_var_G2_flg.;
		%let m_report_var_G3_flg=&m_report_var_G3_flg.;
		%let m_report_var_G4_flg=&m_report_var_G4_flg.;
		%let m_report_var_S1_flg=&m_report_var_S1_flg.;
		%let m_report_var_S2_flg=&m_report_var_S2_flg.;
		%let m_report_var_S3_flg=&m_report_var_S3_flg.;
		%let m_report_var_S4_flg=&m_report_var_S4_flg.;
		%let m_report_var_type=&m_report_var_type.;
		%let m_report_var_length=&m_report_var_length.;
		%let m_report_var_format=&m_report_var_format.;
		%let m_report_var_lookup_tbl=&m_report_var_lookup_tbl.;
		%let m_report_var_desc=&m_report_var_desc.;
		%let m_report_var_spec=&m_report_var_spec.;
		%let m_report_var_spec_control=&m_report_var_spec_control.;

		%let m_report_tt1=Field: &m_report_var_nm.;
		%let m_report_tt2=Table: &m_report_var_tbl_lib..&m_report_var_tbl.;
		%let m_report_tt3=Date: &m_report_var_rundt.;

		%let m_report_where_cond=&m_report_where_cond.;
		%let m_report_missing_cond=&m_report_missing_cond.;
		%let m_report_domain_cond=&m_report_domain_cond.;

		%printMacros(pattern=m_report, debug=0);

		

%mend;
