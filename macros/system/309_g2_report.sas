/* It counts in the table the number of:
	- total observations
	- relevant record for check G2
	Moreover, if the checked variable is numeric, it evaluates the mean variation (the mean of the column G2),
	while, if the checked variable is character, it counts the number of
	- changed record (marked as 1)
	- stable record (marked as 0)
	It creates a synthetic table reporting these totals and statistics */

%macro checkG2synt (flag=);

	%global checkG2synt_rc;

	%global 
		m_count_rel
		m_mean
		m_min
		m_p10
		m_median
		m_p75
		m_p95
		m_p98
		m_p99
		m_max
		m_changed
		;

	%let checkG2synt_rc=;
	%let m_count_rel=;
	%let m_mean=;
	%let m_min=;
	%let m_p10=;
	%let m_median=;
	%let m_p75=;
	%let m_p95=;
	%let m_p98=;
	%let m_p99=;
	%let m_max=;
	%let m_changed=;

	%put NOTE: [&flag.];
	%if &flag. ne %then %do;

		%let m_TotRel=0;
		%let m_TotEmpty=0;
		%let m_Tot=0;
		%let m_min_order_dt=;

		%if &m_report_var_type eq N %then %do;

			%let m_mean=0;

			proc sql noprint;
				select count(*) format=best20. into :m_TotRel
				from datawrk.G_&m_check_var_pos.
				where g2_&m_check_var_pos. ne .
				;
			quit;

			proc sql noprint;
				select min(&m_check_var_order_dt.) into :m_min_order_dt_&m_check_var_pos.
				from datawrk.G_&m_check_var_pos.
				;
			quit;

			proc sql noprint;
				select sum(&m_report_var_nm.) into :m_sum_&m_check_var_pos.
				from datawrk.G_&m_check_var_pos.
				where &m_check_var_order_dt. eq &&m_min_order_dt_&m_check_var_pos.
				;
			quit;

			proc sql noprint;
				select sum((&m_report_var_nm. * g2_&m_check_var_pos.) / &&m_sum_&m_check_var_pos.)
					into :m_mean
				from datawrk.G_&m_check_var_pos.
				where g2_&m_check_var_pos. ne .
				;
			quit;		

			%if &&m_TotRel. ne 0 %then %do;

				data datawrk.G_&m_check_var_pos.;
					set datawrk.G_&m_check_var_pos.;
					abs_g2=abs(g2_&m_check_var_pos.);
				run;

				proc univariate data=datawrk.G_&m_check_var_pos. noprint;
					var abs_g2;
					output out=g2_tmp
						min=min_
						max=max_
						median=median_
						pctlpts=10,75,95,98,99
						pctlpre=p					
						;
				where g2_&m_check_var_pos. ne .;
				run;
			
				data datawrk.g2_&m_check_var_pos.;
					length 
						Relevant_Record
						Mean_Variation
						min_
						p10
						median_
						p75
						p95
						p98
						p99
						max_ 8.
					;
					set g2_tmp;
					rename 
						min_=min
						max_=max
						median_=median 
						;
					label 
						Relevant_Record="Relevant Records"
						Mean_Variation="Weighted Average Variation"
						min_="Min"
						max_="Max"
						p10="10-Percentile"
						median_="Median"
						p75="75-Percentile"
						p95="95-Percentile"
						p98="98-Percentile"
						p99="99-Percentile"
						;
						format Mean_Variation median_ min_ max_ p10 p75 p95 p98 p99  commax20.2;
						Relevant_Record=&m_TotRel.;
						Mean_Variation=&m_mean. ;
				run;




				proc delete data=g2_tmp;
				run;
			%end;

			%let checkG2synt_rc=g2_&m_check_var_pos.;

		%end;
		%else %do;

			%let m_Tot0=0;
			%let m_Tot1=0;

			proc sql noprint;
				create table g2_&m_check_var_pos. as
				select g2_&m_check_var_pos., count(*) format=best20. as Total
				from datawrk.G_&m_check_var_pos.
				group by g2_&m_check_var_pos.
				;
			quit;


			proc sql noprint;
				select Total format=best20. into :m_TotEmpty
				from g2_&m_check_var_pos.
				where g2_&m_check_var_pos. eq .
				;
			quit;

			proc sql noprint;
				select Total format=best20. into :m_Tot0
				from g2_&m_check_var_pos.
				where g2_&m_check_var_pos. eq 0
				;
			quit;

			proc sql noprint;
				select Total format=best20. into :m_Tot1
				from g2_&m_check_var_pos.
				where g2_&m_check_var_pos. eq 1
				;
			quit;

			%let m_TotRel= %eval(&&m_Tot0 + &&m_Tot1);
			%let m_Tot= %eval(&&m_TotRel. + &&m_TotEmpty.);


			

			data datawrk.g2_&m_check_var_pos.;
			length _ $45.;
				_="Relevant_Record (Changed + Stable )";
				Count=&m_TotRel.;
				Frequency=&m_TotRel./&m_Tot.;
				output;
				_="Changed_Record";
				Count=&m_Tot1.;
				if &&m_TotRel ne 0 then Frequency=&m_Tot1./&m_TotRel.;
				else Frequency=.;
				output;
				_="Stable_Record";
				Count= &&m_Tot0.;
				if &&m_TotRel ne 0 then Frequency= &&m_Tot0./&&m_TotRel.;
				else Frequency=.;
				output;
				format Frequency percent12.2;
			run;

			%let checkG2synt_rc=g2_&m_check_var_pos.;

		%end;
		
		%if &&m_TotRel. eq 0 %then %do;
			%if %sysfunc(exist(g2_&m_check_var_pos.)) %then %do;
				data g2_&m_check_var_pos.;
					set g2_&m_check_var_pos.(obs=0);
				run;
			%end;
		%end;
	%end;
%mend;


