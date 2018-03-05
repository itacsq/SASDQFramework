/* ************************************************************************************************************** 
*
*	MACRO:			checkVarExist
*	DESCRIPTION:	this macro checks the existence of a variable and
*					a set of variables in a dataset
*	PARAMETERS:		var = variable name
*					tbl = dataset
*					keepvars = list of variables space-separated
*
* ************************************************************************************************************** */

%macro checkVarExist(var, tbl, keepvars);
	%global checkVarExist_rc checkKeepVarExist_rc;
	%let checkVarExist_rc=;
	%let checkKeepVarExist_rc=1;

	proc contents data=&tbl. out=info noprint nodetails;
	run;

	proc sql noprint;
		select count(*) into :checkVarExist_rc
		from info 
		where upcase(name) eq upcase("&var")
		;
	quit;
	%let checkVarExist_rc=&checkVarExist_rc.;

	%if %sysevalf(%superq(keepvars)=,boolean) = 0 %then %do; 
		%checkKeepVarExist(&keepvars., &var.);
	%end;
	%let checkKeepVarExist_rc=&checkKeepVarExist_rc.;

	EXIT:
	
%mend;

/* It checks the existence of a list of variables in a dataset */
%macro checkKeepVarExist(keepvars, var);

	%split_macrovalue(&keepvars.,pre,cnt,dlm=SPACE);
	
	%do I=1 %to &cnt.;
		%let checkKeepVarExist_&I._rc=;
		
		proc sql noprint;
			select count(*) into :checkKeepVarExist_&I._rc
			from info 
			where upcase(name) eq upcase("&&pre&I.")
			;
		quit;
		
		%let checkKeepVarExist_&I._rc = &&checkKeepVarExist_&I._rc;
		
		%if &&checkKeepVarExist_&I._rc ne 1 %then %do;
			%put WARNING: Var [&&pre&I.] used in the condition for var [&var.] does not exist in the input dataset!!;
			%let checkKeepVarExist_rc=0;
		%end;
	%end;
	
%mend;
