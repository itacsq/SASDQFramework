/* TODOs */


/* 
	TableName: datawrk.g_&m_report_var_pos.
*/


%macro getGnInfo(Gcheck=, flag=);
	%if &flag. ne %then %do;
		
		%global
				m_g&Gcheck._TotY
				m_g&Gcheck._TotN
				m_g&Gcheck._TotRel
				m_g&Gcheck._TotEmpty
				m_g&Gcheck._Tot;

		%let m_g&Gcheck._TotY=0;
		%let m_g&Gcheck._TotN=0;
		%let m_g&Gcheck._TotRel=0;
		%let m_g&Gcheck._TotEmpty=0;
		%let m_g&Gcheck._Tot=0;


		proc sql noprint;
			select Total into :m_g&Gcheck._TotY
			from g&Gcheck._&m_report_var_pos.
			where g&Gcheck._&m_report_var_pos.="Y"
			;
		quit;
		%let m_g&Gcheck._TotY=&&m_g&Gcheck._TotY.;

		proc sql noprint;
			select Total into :m_g&Gcheck._TotN
			from g&Gcheck._&m_report_var_pos.
			where g&Gcheck._&m_report_var_pos.="N"
			;
		quit;
		%let m_g&Gcheck._TotN=&&m_g&Gcheck._TotN.;

		proc sql noprint;
			select Total into :m_g&Gcheck._TotEmpty
			from g&Gcheck._&m_report_var_pos.
			where g&Gcheck._&m_report_var_pos.=""
			;
		quit;
		%let m_g&Gcheck._TotEmpty=&&m_g&Gcheck._TotEmpty.;

		%let m_g&Gcheck._TotRel=%eval(&&m_g&Gcheck._TotY. + &&m_g&Gcheck._TotN.);
		%let m_g&Gcheck._Tot=%eval(&&m_g&Gcheck._TotRel. + &&m_g&Gcheck._TotEmpty.);

	%end;
%mend;






%macro getG2Info(flag=);

	%global 
		m_g2_count_rel
		m_g2_mean
		m_g2_min
		m_g2_p10
		m_g2_median
		m_g2_p75
		m_g2_p95
		m_g2_p98
		m_g2_p99
		m_g2_max
		m_g2_changed
	;

	%let m_g2_count_rel=.;
	%let m_g2_mean=.;
	%let m_g2_min=.;
	%let m_g2_p10=.;
	%let m_g2_median=.;
	%let m_g2_p75=.;
	%let m_g2_p95=.;
	%let m_g2_p98=.;
	%let m_g2_p99=.;
	%let m_g2_max=.;
	%let m_g2_changed=.;



	%if &flag. ne %then %do;
		/* Get G2 Information */
		%if %sysfunc(exist(datawrk.g_&m_report_var_pos.)) %then %do;

			%if &m_report_var_type. eq C %then %do;

				proc sql noprint;
					select count 
						into :m_g2_count_rel
					from datawrk.g2_&m_report_var_pos.
					where _ contains 'Relevant' 
					;
				quit;
				proc sql noprint;
					select Frequency format=percent12.2 
						into :m_g2_changed
					from datawrk.g2_&m_report_var_pos.
					where _ eq 'Changed_Record' 
					;
				quit;

			%end;
			%else %if &m_report_var_type. eq N %then %do;

				proc sql noprint;
					select Relevant_Record,
							Mean_Variation,
							min,
							p10,
							median,
							p75,
							p95,
							p98,
							p99,
							max
						into :m_g2_count_rel,
								:m_g2_mean,
								:m_g2_min,
								:m_g2_p10,
								:m_g2_median,
								:m_g2_p75,
								:m_g2_p95,
								:m_g2_p98,
								:m_g2_p99,
								:m_g2_max

					from datawrk.g2_&m_report_var_pos.
					;
				quit;

			%end;
		%end;

		%let m_dash_count_all=%m_f_cnt_obs(data=datawrk.g_&m_report_var_pos.);
		
		%let  m_dash_max_val=%bquote(&m_dash_max_val.);
		%let  m_dash_min_val=%bquote(&m_dash_min_val.);
		%let  m_dash_count_dist=&m_dash_count_dist.;

		%let m_g2_count_rel=%bquote(&m_g2_count_rel.);
		%let m_g2_mean=%bquote(&m_g2_mean.);
		%let m_g2_min=%bquote(&m_g2_min.);
		%let m_g2_p10=%bquote(&m_g2_p10.);
		%let m_g2_median=%bquote(&m_g2_median.);
		%let m_g2_p75=%bquote(&m_g2_p75.);
		%let m_g2_p95=%bquote(&m_g2_p95.);
		%let m_g2_p98=%bquote(&m_g2_p98.);
		%let m_g2_p99=%bquote(&m_g2_p99.);
		%let m_g2_max=%bquote(&m_g2_max.);

		%let m_g2_changed=%bquote(&m_g2_changed.);
	%end;
%mend;





%macro getDashBordInfo();


	%global 
		m_dash_max_val
		m_dash_min_val
		m_dash_count_dist
		m_dash_count_all
				
		
		;
	%let m_dash_max_val=;
	%let m_dash_min_val=;
	%let m_dash_count_dist=.;
	%let m_dash_count_all=.;
	

	
	
	



%mend;

