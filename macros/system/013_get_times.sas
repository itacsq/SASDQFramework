/* It prints current date and time, with format yymmdd_hh-mm-ss. */
%macro getTime();
	%let yr=%sysfunc(year(%sysfunc(date())));
	%let mt=%sysfunc(month(%sysfunc(date())));
	%let mt=%sysfunc(putn(&mt, z2.));
	%let dd=%sysfunc(day(%sysfunc(date())));
	%let dd=%sysfunc(putn(&dd, z2.));
	%let hh=%sysfunc(hour(%sysfunc(time())));
	%let hh=%sysfunc(putn(&hh, z2.));
	%let mm=%sysfunc(minute(%sysfunc(time())));
	%let mm=%sysfunc(putn(&mm, z2.));
	%let ss=%sysfunc(second(%sysfunc(time())));
	%let ss=%sysfunc(putn(&ss, z2.));
	&yr.&mt.&dd._&hh.-&mm.-&ss.
%mend;
