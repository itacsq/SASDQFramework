


/* ******************************************************************
	printDic( lib=LIBRARY )
	Crea una tabelle contenente le informazioni presenti nelle viste
	ed un tabella riassuntiva contenente tutte le tabelle visibili
	nelle librerie

	itacsq - 20170224
******************************************************************	*/
%macro printDic(lib=);
	proc contents data=&lib.._all_ out=info_&lib. noprint;
	quit;
	proc sort data=info_&lib.(keep=libname memname) out=info_&lib._tbls nodupkey;
		by libname memname;
	quit;
	%if %sysfunc(exist(all_tbl)) eq 0 %then %do;
		proc sql noprint;
			create table all_tbl like info_&lib._tbls;
		quit;
	%end;
	%if %sysfunc(exist(all_vars)) eq 0 %then %do;
		proc sql noprint;
			create table all_vars like info_&lib.;
		quit;
	%end;
	proc append base=all_tbl data=info_&lib._tbls;
	run;
	proc append base=all_vars data=info_&lib.;
	run;



%mend;



/* 

proc delete data=all_vars;
run;
proc delete data=all_tbl;
run;


%printDic(lib=out157);
%printDic(lib=out123);
%printDic(lib=out205);
%printDic(lib=out209);
%printDic(lib=out214);
%printDic(lib=outrni);
%printDic(lib=outbv);
%printDic(lib=inparprd);
%printDic(lib=outime);
%printDic(lib=out214C1);
%printDic(lib=out214FD);

*/
