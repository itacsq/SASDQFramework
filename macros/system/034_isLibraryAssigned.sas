%macro isLibAssigned(lib=);
	%global isLibAssigned_rc;
	%let isLibAssigned_rc=0;
	proc sql noprint;
		select count(*) into : isLibAssigned_rc
		from sashelp.vslib
		where strip(upcase(libname)) eq "%upcase(&lib.)"
		;
	quit;
	
	%let isLibAssigned_rc=&isLibAssigned_rc.;
%mend;

/* Testing 
%let lib=datawrk;
%put Is Library Assigned? [&isLibAssigned_rc];
*/
