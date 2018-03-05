/* ************************************************************************************************************** 
*
*	MACRO:			resetMacro
*	DESCRIPTION:	this macro re-initializes (to missing) macrovariables
*					whose names contain the pattern
*	PARAMETERS:		pattern = pattern to find in the names of macrovariables
*
* ************************************************************************************************************** */

%macro resetMacro(pattern=);

	%let var_list=;
		
	proc sql noprint;
		select name into : var_list separated by "#"
		from sashelp.vmacro
		where upcase(name) ? upcase("&pattern.");

	quit;

	%put NOTE: Re-initialize macro variables which contains [&pattern.]: list=[&var_list.];


	%let index=1;
	%do %while(%scan(&var_list., &index., #) ne );
		%let mname=%scan(&var_list., &index., #);
		%put NOTE:Macro variable [&mname];
		%global &mname;
		%let &mname=;
		%let index=%eval(&index.+1);
	%end;



%mend;
