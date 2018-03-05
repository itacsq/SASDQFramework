%macro checkInfo();

	data datawrk.info_&m_check_var_pos.;
		length varname tbl lib  $200.
			varformat var_lookup	business_owner filter  description spec_control 
				order_dt where_cond missing_cond domain_cond	$32000.
				varpos rundt spec 8.
				G1_flag G2_flag G3_flag G4_flag S1_flag S2_flag S3_flag S4_flag type $1. length 8.
				;
		format rundt date9.;
		label tbl="Table Name" varname="Var Name" varpos="Original Position" rundt="Run Date"
				spec="N Specific Controls Performed" spec_control="Specific Controls";

		varname="&m_check_var_nm.";
		tbl="&m_check_var_tbl.";
		lib="&m_check_var_tbl_lib.";
		order_dt="&m_check_var_order_dt.";
		varpos=&m_check_var_pos.;
		type="&m_check_var_type";
		length=&m_check_var_length.;
		varformat="&m_check_var_format";
		business_owner="&m_check_var_business_owner.";
		filter="&m_check_var_where_filter.";
		description="%bquote(&m_check_var_desc.)";
		var_lookup="&m_check_var_lookup_tbl.";
		where_cond="&m_check_var_cond_where.";
		missing_cond="&m_check_var_cond_missing.";
		domain_cond="&m_check_var_cond_domain.";
		G1_flag="&m_check_var_g1_flg.";
		G2_flag="&m_check_var_g2_flg.";
		G3_flag="&m_check_var_g3_flg.";
		G4_flag="&m_check_var_g4_flg.";
		S1_flag="&m_check_var_s1_flg.";
		S2_flag="&m_check_var_s2_flg.";
		S3_flag="&m_check_var_s3_flg.";
		S4_flag="&m_check_var_s4_flg.";
		spec=&m_check_var_spec.;
		spec_control="%bquote(%str(&m_check_var_spec_control.))";
		rundt=today();
	run;

%mend;
