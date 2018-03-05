/* Options for printing in the Log */
%macro setLogLevel(level=);
	%if &level eq 0 %then %do;
		options nomprint nomlogic nosymbolgen nonotes nosource;
	%end;
	%else %if &level eq 1 %then %do;
		options nomprint nomlogic nosymbolgen notes source;
	%end;
	%else %do;
		options mprint mlogic symbolgen notes source;
	%end;
%mend;
