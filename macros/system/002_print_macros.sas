/* If debug ne 0, it prints macrovars whose names contain the pattern */
%macro printMacros(pattern=, debug=0);
	proc sql 
		%if &debug. eq 0 %then %do;
			noprint
		%end;
		;
		select name, value into :dbg_macro_lst_nm separated by "#", :dbg_macro_lst_val separated by "#"
		from sashelp.vmacro
		where upcase(name) ? upcase("&pattern")
		order by name
		;
	quit;
	
	/*
	%put _user_;
	%let index=1;
	%do %while(%scan(&dbg_macro_lst_nm., &index., #) ne );
		%let var1=%scan(&dbg_macro_lst_nm., &index., #);
		%let var2=%scan(&dbg_macro_lst_val., &index., #);
		%put NOTE: &var1.=[&var2.];
		%let index=%eval(&index.+1);
	%end;
	*/
%mend;

