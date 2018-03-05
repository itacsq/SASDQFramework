/* It writes to a File, appending */

%macro write2File(fpath=, line=, append=, crflag=, lineLength=1024);
	filename fout "&fpath." ;
	data _null_;
		length x $ &lineLength. ;
		file fout 
		%if &append. %then %do;
			mod
		%end;
		;
		x=&line.;
		%if &crflag. %then %do;
			x=tranwrd(x, ";", ";"||'0D'x);
		%end;
		
		put x;
	run;
%mend;
