%macro setFormats();

	/* Var Type Formats */	
	proc format lib=WORK;
	     value FMTVARTYPE  
	          0="Numeric"
	          1="Character";
	run;


%mend;
