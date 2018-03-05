

%macro specialControl(var=, tbl=, tblIn=WORK);

	/* 
	%let var=&m_check_var_nm.;
	%let tblIn=&m_check_var_tbl.;
	%let tbl=datawrk.G_&m_check_var_pos.;
	%put var=[&var.] tbl=[&tbl.] tblIn=[&tblIn.];


	*/



    %global specialControl_rc;
    %let specialControl_rc=0;
    %let varch=%upcase(&var.);
    %let tblch=%upcase(&tblIn.);
	%put var=[&varch.] tbl=[&tbl.] tblIn=[&tblch.];
	%setFormats();

	%if %bquote(&m_check_var_spec_control.) ne %then %do;
		%put NOTE: &m_check_var_nm. required any Specific Control;
		%if 
			/* IMM_MAT_NETTE */
			&varch. eq IMM_MAT_NETTE and &tblch. eq BILANCI_SOFF_ALL_201612  
			or /* TOT_ATTIVO */
				&varch. eq TOT_ATTIVO and &tblch. eq BILANCI_SOFF_ALL_201612  
			%then %do;
			/*
			Naming Convention:
			- TableName: datawrk.SP_&m_check_var_pos._{nTable}
			- # of Special Tables: specialControl_rc
			*/

			proc freq data=&tbl. noprint;
				tables &m_check_num_group_by. * &m_check_var_nm. /out=tmpSP1(rename=(percent=percent_ count=count_)) missing; 
				where checkM ne 1 or checkD ne 1 or &m_check_var_nm. eq 0;
			run;

			proc sort data=tmpSP1;
				by descending percent_;
			run;

			data datawrk.SP_&m_check_var_pos._1;
				set tmpSP1;
				length percent cumperc count 8.;
				format cumperc percent percent10.2 count commax10.;
				retain cumperc;
				percent=percent_/100;
				count=count_;
				cumperc=sum(cumperc, percent);
				label 
					percent ="Percent of Total Frequency" 
					count="Frequency Count"
					cumperc="Cumulated Percent of Total Frequency";
				drop percent_ count_;
			run;

			proc delete data=tmpSP1;
			run;
				

			%let specialControl_rc=1;
		%end;
		%else %if 
				/* DATA_RIF and DATA_CENSIMENTO */ 
				&varch. eq DATA_RIF and &tblch. eq C0_EGAAANE_201612
			
				%then %do;


				proc means data=&tbl. median min max p1 p10 p25 p75 p90 p99 noprint;
				     var &m_check_var_nm. ;
				     output 
				          out=tmpSP1
				          min=_min
				          max=_max
				          median=_median
				          p1=_p1
				          p10=_p10
				          p25=_p25
				          p75=_p75
				          p90=_p90
				          p99=_p99
				          ;
						where checkM eq 1 ;
				run;

				data datawrk.SP_&m_check_var_pos._1;
				     set tmpSP1(rename=(
							_p1=p1 
							_p10=p10
							_p25=p25
							_p75=p75
							_p90=p90
							_p99=p99
							_min=min
							_max=max
							_median=median
							_type_=type
							) drop=_freq_ );
				     format type FMTVARTYPE.;
					 label 
						type="Type"
						p1="p1"
						p10="p10"
						p25="p25"
						p75="p75"
						p90="p90"
						p99="p99"
						median="Median"
						min="Minimum Value"
						max="Maximum Value"
						;
				run;
				proc delete data=tmpSP1;
				run;


				%let specialControl_rc=1;
		%end;
		%else %if 
				/* SEGMENTO CREDITIZIO NUMERICO  */ 
				&varch. eq SEGMENTO_CREDITIZIO_NUMERICO and &tblch. eq SEGMENTO_CRED_UBIS
				
				%then %do;
				/* 
					Variabili: 
					- Tabella di INPUT &tbl.
					- Nome Variabile &m_check_var_nm.
					- Tabella di Output datawrk.SP_&m_check_var_pos._1
				*/

				proc freq data=&tbl. noprint;
					tables TIPO_RATING_DI_EROGAZIONE * &m_check_var_nm. /out=tmpSP1(rename=(percent=percent_ count=count_)) missing; 
					where checkM eq 1 or checkD eq 1;
				run;

				
				proc sort data=tmpSP1;
					by descending percent_;
				run;

				data datawrk.SP_&m_check_var_pos._1;
					set tmpSP1;
					length percent cumperc count 8.;
					format cumperc percent percent10.2 count commax10.3;
					retain cumperc;
					percent=percent_/100;
					count=count_;
					cumperc=sum(cumperc, percent);
					label 
						percent ="Percent of Total Frequency" 
						count="Frequency Count"
						cumperc="Cumulated Percent of Total Frequency";
					drop percent_ count_;
				run;

				proc delete data=tmpSP1;
				run;



				%let specialControl_rc=1;
		%end;
	%end;
	%else %do;
		%put NOTE: &m_check_var_nm. does not require any Specific Control;
	%end;

%mend;
