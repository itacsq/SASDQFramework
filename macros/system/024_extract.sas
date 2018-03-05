/* Let date be yymm and let le be the legal entity,
	it extracts partition from tbl*/

%macro ExtractPartition(tbl=,dates=,le=, lib=datatmp);

	%let m_partition_code=;
	proc sql noprint;
		select aramis into :m_partition_code separated by '","'
		from datawrk.xpartitions
		where date2 in (&dates.) and le eq "&le."
		;
	quit;

	
	%if %length(%bquote(&m_partition_code)) ne 0 %then %do;
		data &lib..partition_&le._ALL;
			set &tbl.;
			where partition_field in ("&m_partition_code.");
		run;
	%end;
	%else %do;
		%put ERROR: No partition selected for dates=[&dates.] le=[&le.];
		%let syscc=8;
	%end;

%mend;
