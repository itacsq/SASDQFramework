/* S3: Numeric Distribution.
	If the control applies, a table reporting the distribution analysis is created, including:
	o Median and Mean
	o Minimum and Maximum
	o Percentile 1, 10, 25, 75, 90, 99
	Records included in the analysis: not missing, within the where and
	the numeric distribution exclusions conditions.
	If m_check_num_group_by is populated, we perform analysis also grouping by this parameter */





%macro checkS3(S3tblIn=);

	

	%put NOTE: Flag S3=[&m_check_var_s3_flg.];
	%if &m_check_var_s3_flg. ne %then %do;
		%put NOTE: Starting S3 Check for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];
		%printToLog(mex= [FLOW_CHECK] - SYNTHETIC CHECK S3 , debug=0);
			proc univariate data=&S3tblIn. noprint;
				var &m_check_var_nm.;
				output out=s3_tmp
						n=n_
						mean=mean_
						median=median_
						min=min_
						max=max_
						p1=p1_
						p10=p10_
						p25=p25_
						p75=p75_
						p90=p90_
						p99=p99_
						;
				%macro printNumExcl(cond=);
					%if %length(&cond.) ne 0 %then %do;
						and &cond.
					%end;
				%mend;
				where checkW eq 1 and checkM eq 1 %printNumExcl(cond=&m_check_var_cond_numexclus.);
			run;

			%macro ifUnivariateExist(tableName=, tableCheck=);
				%if %sysfunc(exist(&tableCheck.))%then %do;
					data &tableName.;
						length 
							n_
							mean_
							median_
							min_
							max_
							p1_
							p10_
							p25_
							p75_
							p90_
							p99_ 8.
						;
						set &tableCheck.;
						rename 
							n_=n
							mean_=mean 
							median_=median 
							min_=min
							max_=max
							p1_=p1
							p10_=p10
							p25_=q1
							p75_=q3
							p90_=p90
							p99_=p99
							;
						label 
							n_="N Obs"
							mean_="Mean"
							median_="Median"
							min_="Min"
							max_="Max"
							p1_="1-Percentile"
							p10_="10-Percentile"
							p25_="1-Quartile"
							p75_="3-Quartile"
							p90_="90-Percentile"
							p99_="99-Percentile"
							;
							format mean_ median_ min_ max_ p1_ p10_ p25_ p75_ p90_ p99_  &m_check_var_format.;
					run;
					proc delete data=&tableCheck.;
					run;
				%end;
				%else %do;
					data &tableName.;
						length 
							n_
							mean_
							median_
							min_
							max_
							p1_
							p10_
							p25_
							p75_
							p90_
							p99_ 8.
							%if &m_check_num_group_by. ne %then %do;
							&m_check_num_group_by. $ 200
							%end;
						;
						stop;
					run;
				%end;
			%mend;

			%ifUnivariateExist(tableName=S3_totale, tableCheck=s3_tmp);
			
						/* proc univariate class (numeric group by) */
			%if &m_check_num_group_by. ne %then %do;

				proc univariate data=&S3tblIn. noprint;
					var &m_check_var_nm.;
					output out=s3_tmp_class
							n=n_
							mean=mean_
							median=median_
							min=min_
							max=max_
							p1=p1_
							p10=p10_
							p25=p25_
							p75=p75_
							p90=p90_
							p99=p99_
							;
					where checkW eq 1 and checkM eq 1 %printNumExcl(cond=&m_check_var_cond_numexclus.);
					class &m_check_num_group_by.;
				run;
			%end;

			%ifUnivariateExist(tableName=S3_class, tableCheck=s3_tmp_class);

			%if %m_f_cnt_obs(data=S3_class) > 0 %then %do;
				data  datawrk.S3_&m_check_var_pos. (drop=
						%let index=1;
						%do %while(%scan( &m_check_num_group_by., &index., %str( ) ) ne );
							%let singleByVar=%scan( &m_check_num_group_by., &index., %str( ) );
							_tmp_&index.
							%let index=%eval(&index.+1);
						%end;
					);
					length &m_check_num_group_by. $ 200;
					set S3_class  (
						rename = (
						%let index=1;
						%do %while(%scan( &m_check_num_group_by., &index., %str( ) ) ne );
							%let singleByVar=%scan( &m_check_num_group_by., &index., %str( ) );
							&singleByVar.=_tmp_&index.
							%let index=%eval(&index.+1);
						%end;
						)
					)
						S3_totale (in=second);
						%let index=1;
						%do %while(%scan( &m_check_num_group_by., &index., %str( ) ) ne );
							%let singleByVar=%scan( &m_check_num_group_by., &index., %str( ) );
							&singleByVar. = _tmp_&index.;
							%let index=%eval(&index.+1);
						%end;

					if second then do;

						%let index=1;
						%do %while(%scan( &m_check_num_group_by., &index., %str( ) ) ne );
							%let singleByVar=%scan( &m_check_num_group_by., &index., %str( ) );
							&singleByVar. = "Total";
							%let index=%eval(&index.+1);
						%end;


					end;
				run;
			%end;
			%else %do;
				data datawrk.S3_&m_check_var_pos.;
					set S3_totale;
				run;
				
			%end;
			
		%put NOTE: Closing S3 Check for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];

	%end;
	%else %do;
		%put NOTE: &m_check_var_nm. does not require any S3 check;
	%end;
%mend;
