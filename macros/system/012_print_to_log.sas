/* It prints a NOTE To the Log, with given message */
%macro printToLog(mex=, debug=&m_prompt_debug_flg.);
	%if &debug. eq 1 %then %do;
		%setLogLevel(level=1);
		%put NOTE: &mex.;	
		%setLogLevel(level=0);
	%end;
	%else %do;
		%put &mex.;
	%end;
%mend;
