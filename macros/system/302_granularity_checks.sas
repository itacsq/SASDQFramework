/* G1: Check Domain.
	If this control applies, a column G1_<number of the field> is added to the table, reporting
	Y if the record is within the domain (i.e. domain rule respected, not missing, within the where condition),
	N if the record is not within the domain domain (i.e. domain rule NOT respected, not missing, within the where condition)*/

%macro checkG1();
	%put NOTE: Flag G1=[&m_check_var_g1_flg.];
	%if &m_check_var_g1_flg. ne %then %do;
		length g1_&m_check_var_pos. $1.;
		g1_&m_check_var_pos. = "";
		if checkD eq 1 then g1_&m_check_var_pos. = "Y";
		else if checkD eq 0 and checkW eq 1 and checkM eq 1 then g1_&m_check_var_pos. = "N";
	%end;
	%else %do;
		%put NOTE: &m_check_var_nm. does not require any G1 check;
	%end;
%mend;

/* G2: Historical trend.
	If this control applies, a column G2_<number of the field> is added to the table, reporting,
	if the records are within the where condition and are non missing in both reference times,
	o % of variation if the var is numerical and 
	o 0 if no variation happened or 1 if variation happened if it refers to a string field */

%macro checkG2();
	%put NOTE: Flag G2=[&m_check_var_g2_flg.];
	%if &m_check_var_g2_flg. ne %then %do;
		length g2_&m_check_var_pos. 8.;
		
		if first.&m_tbl_input_sortcond_last. then do;
			g2_&m_check_var_pos. = .;
		end;
		else do;
			if checkW eq 1 and checkLagW eq 1 and checkM eq 1 and checkLagM eq 1 then do;
				%if &m_check_var_type. eq N %then %do;
					if abs(prec) gt 0.00001 then g2_&m_check_var_pos. = sum(act,-prec)/prec;
					 else g2_&m_check_var_pos. = .;
				%end;
				%else %do;
					if act eq prec then g2_&m_check_var_pos. = 0;
					else g2_&m_check_var_pos. = 1;
				%end;
			end;
		end;
	%end;
	%else %do;
		%put NOTE: &m_check_var_nm. does not require any G2 check;
	%end;
%mend;


/*G3: Where-not check.
	If this control applies, a column G3_<number of the field> is added to the table, reporting
	Y if the record is NOT within the where condition and it is missing (according to the missing definition)
	N if the record is NOT within the where condition and it is NOT missing (according to the missing definition) */

%macro checkG3();
	%put NOTE: Flag G3=[&m_check_var_g3_flg.];
	%if &m_check_var_g3_flg. ne %then %do;
		length g3_&m_check_var_pos. $1.;
		g3_&m_check_var_pos. = "";
		if checkW eq 0 and checkM eq 0 then g3_&m_check_var_pos. = "Y";
		else if checkW eq 0 and checkM eq 1 then g3_&m_check_var_pos. = "N";
	%end;
	%else %do;
		%put NOTE: &m_check_var_nm. does not require any G3 check;
	%end;
%mend;


/* G4: Data Completion.
	If this control applies, a column G4_<number of the field> is added to the table, reporting
	Y if the record is not missing (i.e. not missing and within the where condition),
	N if the record is missing (i.e. missing and within the where condition) */

%macro checkG4();
	%put NOTE: Flag G4=[&m_check_var_g4_flg.];
	%if &m_check_var_g4_flg. ne %then %do;
		length g4_&m_check_var_pos. $1.;
		g4_&m_check_var_pos. = "";
		if checkM eq 1 and checkW eq 1 then g4_&m_check_var_pos. = "Y";
		else if checkM eq 0 and checkW eq 1 then g4_&m_check_var_pos. = "N";
	%end;
	%else %do;
		%put NOTE: &m_check_var_nm. does not require any G3 check;
	%end;
%mend;



/* It performs granular checks for a fixed variable, creating new columns for granular checks */
%macro checkGranularity(tblIn=, tblOut=, debug=);

	%put NOTE: -----------------------------------------------------------------------------------------------;
	%put NOTE: macro=[CheckGranularity];
	%put NOTE: Starting Granularity Checks for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];
	%put NOTE: tblIn=[&tblIn.] tblOut=[&tblOut.];

	data &tblOut.;
		
		length 
			checkM checkW checkD  			/* Check for current observation */
			checkLagM checkLagW checkLagD 	/* Check for previous observation */
				8.;
		set &tblIn.; *(drop=check:);
		by &m_tbl_input_sortcond.;
		
		retain checkLagM checkLagW checkLagD;

		act=&m_check_var_nm.; /* Current value of the var */
		prec=lag(&m_check_var_nm.); /* Previous value of the var */
		if first.&m_tbl_input_sortcond_last. then do;
			prec = .;
		end;

		* 1. Check: Missing										;
		%macro printMissing(cond=);
			%if %length(&cond.) ne 0 %then %do;
				or &cond. 
			%end;
		%mend;

		checkM=1;
		if missing(&m_check_var_nm.) 
		/* 2. Not standard missing check (from Excel)		*/
		%printMissing(cond=&m_check_var_cond_missing.)
		then checkM=0;

		
		* 3. WHERE conditions					;
		%macro printWhere(cond=);
			%if %length(&cond.) ne 0 %then %do;
				if not(&cond.) then checkW=0;
			%end;
		%mend;

		checkW=1;
		%printWhere(cond=&m_check_var_cond_where.)

		checkD=0;
		* 4. DOMAIN conditions						;
		if checkW eq 1 and checkM eq 1 then do;
			checkD=1;
			%macro printDomain(cond=);
				%if %length(&cond.) ne 0 %then %do;
					if not(&cond.) then checkD=0;
				%end;
			%mend;
			%printDomain(cond=&m_check_var_cond_domain.)
		end;
		
		/* Checks for previous observation of the by group */
		if first.&m_tbl_input_sortcond_last. then do;
			checkLagM =.;
			checkLagW =.;
			checkLagD =.;
		end;
		else do;
			checkLagM = checkM;
			checkLagW = checkW;
			checkLagD = checkD;

		end;


		%checkG1();
		%checkG2();
		%checkG3();
		%checkG4();
		

		drop act prec;

	run;

	%put NOTE: Closing Granularity Checks for [&m_check_var_nm.] - [%sysfunc(date(),date9.) - %sysfunc(time(),time8.0)];

%mend;

/* %checkGranularity(tblIn=datawrk.g_3, tblOut=datawrk.g_3_out, debug=1); */
