

%macro updateDashSAS();




/* Macro List
	m_dash_&m_report_var_pos._max_val		:	Max Value
	m_dash_&m_report_var_pos._min_val		:	Min Value
	m_dash_&m_report_var_pos._count_dist	: 	Count Distinct
	m_dash_&m_report_var_pos._count_all		:	Count All



	------ Control BIBLE -------

	m_g1_TotY			:	Number of ( CheckW eq 1 CheckM eq 1 CheckD eq 1) || Everything OK
	m_g1_TotN			:	Number of ( CheckW eq 1 CheckM eq 1 CheckD eq 0) || Not within Domain but not missing and where ok
	m_g1_TotRel			:	Sum( CheckW eq 1 and CheckM eq 1 ) || Within Where and not Missing
	m_g1_TotEmpty		:	Sum( CheckW eq 0 or CheckM eq 0 ) 


	m_g3_TotY			:	Number of ( CheckW eq 0 and CheckM eq 0  ) for G3 || Not under where then missing !
	m_g3_TotN			:	Number of ( CheckW eq 0 and CheckM eq 1  ) for G3 || Not under where but not missing !
	m_g3_TotRel			:	Sum( CheckW eq 0 ) for G3 || Not under where
	m_g3_TotEmpty		:	Sum( CheckW eq 1 ) || All under where


	m_g4_TotY			:	Number of ( CheckM eq 1 and CheckW eq 1 ) || Not missing within Where Condition
	m_g4_TotN			:	Number of ( CheckM eq 0 and CheckW eq 1 ) || Missing within Where Condition
	m_g4_TotRel			:	Sum( CheckW eq 1 ) || All under where (without where => everything)
	m_g4_TotEmpty		:	Sum( CheckW eq 0 ) || Not under where (without where => none )
	
	--------------------------------

	m_report_var_nm							:	Field Name
	m_report_var_desc						:	Field Description
	m_report_var_tbl						:	Source qualified by GRM
	m_report_var_tbl_lib					:	Source Library
	m_report_var_type						:	Field Type
	m_report_var_format						:	Field Format
	m_report_var_length						:	Field Length

	m_report_where_cond						:	Field Where Condition
	m_report_missing_cond					:	Field Missing Condition
	m_report_domain_cond					:	Field Domain Condition

	m_report_var_G1_flg						:	Flag Check Domain
	m_report_var_G2_flg						:	Flag Check Historical Trend 
	m_report_var_G3_flg						:	Flag Check Where-Not
	m_report_var_G4_flg						:	Flag Check Data Completition
	m_report_var_S1_flg						:	Flag Check Top20
	m_report_var_S2_flg						:	Flag Check Domain Distribution
	m_report_var_S3_flg						:	Flag Check Numeric Distribution
	m_report_var_S4_flg						:	Flag Check Reconciliation

*/

	%if %sysfunc(exist(datawrk.xzDASH)) eq 0 %then %do;
		proc sql noprint;
			create table datawrk.xzDASH( compress=CHAR  bufsize=49152 )(
				key							char(64)	label="Key",
				varpos						char(32)	label="ID Variable",
				field_name 					char(32)	label="Field Name",
				source 						char(32) 	label="Source",
				source_filter				char(32000)	label="Filter on Source",
				description					char(32000) 	label="Description",
				flg_check_domain 			char(1)		label="Check Domain",
				flg_hist_check				char(1)		label="Historical Check",
				flg_where_not_check 		char(1)		label="Where-Not",
				flg_data_completition 		char(1)		label="Data Completition",
				flg_top20 					char(1)		label="Top 20",
				flg_domain_distribution 	char(1)		label="Domain Distribution",
				flg_numeric_distribution 	char(1)		label="Numeric Distribution",
				flg_reconciliation 			char(1)		label="Riconciliation",
				flg_special					char(2)		label="Functional",
				field_length 				num			label="Field Length",
				field_format 				char(32)	label="Field Format",
				missing_condition			char(32000)	label="Missing Condition",
				where_not_condition 		char(32000)	label="Where Not Condition",
				check_domain_condition 		char(32000)	label="Domain Condition",
				num_records 				num			label="Num. of Records",
				num_records_distinct 		num			label="Num. of Distinct Values",
				num_check_domain_kos 		num			label="Num. of Domain KOs",
				num_relevant_records 		char(250)	label="Num. of Relevant Records",
				mean_variation				char(250)	label="Weighted Average Variation",
				min_val						char(250)	label="Min Value",
				p10							char(250)	label="10-Percentile",
				median						char(250)	label="Median",
				p75							char(250)	label="75-Percentile",
				p95							char(250)	label="95-Percentile",
				p98							char(250)	label="98-Percentile",
				p99							char(250)	label="99-Percentile",
				max_val						char(250)	label="Max Value",
				num_changed_records 		char(250)	label="Num. of Changed Records",
				num_where_not_check_kos 	num			label="Num. of Where-Not KOs",
				num_data_completition_kos 	num			label="Num. of Data Completition KOs",
				field_min_value 			char(250)	label="Minimum Value",
				field_max_value 			char(250)	label="Maximum Value",
				reconciliation_kos 			num			label="Num. of Reconciliation KOs"
				
			);
		quit;
	%end;


	
	%let totG1N=.;
	%if %length(&m_report_var_G1_flg.) ne 0 %then %do;
		%let totG1N=&&m_g1_&m_report_var_pos._TotN.;
	%end;
	%let totG3N=.;
	%if %length(&m_report_var_G3_flg.) ne 0 %then %do;
		%let totG3N=&&m_g3_&m_report_var_pos._TotN.;
	%end;
	%let totG4N=.;
	%if %length(&m_report_var_G4_flg.) ne 0 %then %do;
		%let totG4N=&&m_g4_&m_report_var_pos._TotN.;
	%end;
	%let specFlg=;
	%if &m_report_var_spec. eq 0 %then %do;
		%let specFlg=;
	%end;
	



	proc sql noprint;
		insert into datawrk.xzDASH 
							(	key, 
								varpos, 
								field_name,
								source,
								source_filter,
								description,
								flg_check_domain,
								flg_hist_check,
								flg_where_not_check,
								flg_data_completition,
								flg_top20,
								flg_domain_distribution,
								flg_numeric_distribution,
								flg_reconciliation,
								flg_special,
								field_length,
								field_format,
								missing_condition,
								where_not_condition,
								check_domain_condition,
								num_records,
								num_records_distinct,
								num_check_domain_kos,
								num_relevant_records,
								mean_variation,
								min_val,
								p10,
								median,
								p75,
								p95,
								p98,
								p99,
								max_val,
								num_changed_records,
								num_where_not_check_kos,
								num_data_completition_kos,
								field_min_value,
								field_max_value,
								reconciliation_kos
								)
		values(
			"%upcase(&m_report_var_tbl.).%upcase(&m_report_var_nm.)"
			,"%sysfunc(putn(&m_report_var_pos., z5.))"
			,"%upcase(&m_report_var_nm.)"
			,"%upcase(&m_report_var_tbl.)"
			,"%bquote(&m_report_var_filter.)"
			,"%bquote(&m_report_var_desc.)"
			,"%lowcase(&m_report_var_G1_flg.)"
			,"%lowcase(&m_report_var_G2_flg.)"
			,"%lowcase(&m_report_var_G3_flg.)"
			,"%lowcase(&m_report_var_G4_flg.)"
			,"%lowcase(&m_report_var_S1_flg.)"
			,"%lowcase(&m_report_var_S2_flg.)"
			,"%lowcase(&m_report_var_S3_flg.)"
			,"%lowcase(&m_report_var_S4_flg.)"
			,"&specFlg."
			,&m_report_var_length.
			,"&m_report_var_format."
			,"%bquote(&m_report_missing_cond.)"
			,"%bquote(&m_report_where_cond.)"
			,"%bquote(&m_report_domain_cond.)"
			,&&m_dash_&m_report_var_pos._count_all.
			,&&m_dash_&m_report_var_pos._count_dist.
			,&totG1N.
			,"%bquote(&&m_hist_&m_report_var_pos._count_rel.)"
			,"%bquote(&&m_hist_&m_report_var_pos._mean.)"
			,"%bquote(&&m_hist_&m_report_var_pos._min.)"			
			,"%bquote(&&m_hist_&m_report_var_pos._p10.)"
			,"%bquote(&&m_hist_&m_report_var_pos._median.)"
			,"%bquote(&&m_hist_&m_report_var_pos._p75.)"
			,"%bquote(&&m_hist_&m_report_var_pos._p95.)"
			,"%bquote(&&m_hist_&m_report_var_pos._p98.)"
			,"%bquote(&&m_hist_&m_report_var_pos._p99.)"
			,"%bquote(&&m_hist_&m_report_var_pos._max.)"
			,"%bquote(&&m_hist_&m_report_var_pos._changed.)"
			,&totG3N.
			,&totG4N.
			,"%bquote(&&m_dash_&m_report_var_pos._min_val.)"
			,"%bquote(&&m_dash_&m_report_var_pos._max_val.)"
			,.
		);
	quit;



%mend;

