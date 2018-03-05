/* It counts in the table the number of:
	- total observations
	- relevant record for a check (G1 or G3 or G4)
	- passed observations (Y)  for a check (G1 or G3 or G4)
	- not passed observations (N)  for a check (G1 or G3 or G4)
	It creates a synthetic table reporting these totals */

%macro countYN(Gcheck=, flag=);

	%if &flag. ne %then %do;
		proc sql;
		create table datawrk.g&Gcheck._&m_check_var_pos. as
			select
					g&Gcheck._&m_check_var_pos.,
					count(*) format=best20. as Total
			from datawrk.G_&m_check_var_pos.
			group by g&Gcheck._&m_check_var_pos.
			;
		quit;


		%let m_TotY=0;
		%let m_TotN=0;
		%let m_TotRel=0;
		%let m_TotEmpty=0;
		%let m_Tot=0;


		proc sql noprint;
			select Total format=best20. into :m_TotY
			from datawrk.g&Gcheck._&m_check_var_pos.
			where g&Gcheck._&m_check_var_pos.="Y"
			;
		quit;

		proc sql noprint;
			select Total format=best20. into :m_TotN
			from datawrk.g&Gcheck._&m_check_var_pos.
			where g&Gcheck._&m_check_var_pos.="N"
			;
		quit;

		proc sql noprint;
			select Total format=best20. into :m_TotEmpty
			from datawrk.g&Gcheck._&m_check_var_pos.
			where g&Gcheck._&m_check_var_pos.=""
			;
		quit;

		%let m_TotRel=%eval(&&m_TotY. + &&m_TotN.);

		%let m_Tot=%eval(&&m_TotRel. + &&m_TotEmpty.);

		proc delete data= datawrk.g&Gcheck._&m_check_var_pos.;
		run;

		data datawrk.g&Gcheck._&m_check_var_pos. ;
		length _ $35.;
			_="Total_Record (Y+N+Missing)";
			Count= &m_Tot.;
			Frequency= .;
			output;
			_="Relevant_Record (Y+N)";
			Count=&m_TotRel.;
			Frequency= &m_TotRel./&m_Tot.;
			output;
			_="Passed (Y)";
			Count= &m_TotY.;
			if &m_TotRel. ne 0 then
				Frequency=&m_TotY./&m_TotRel.;
				else Frequency=.;
			output;
			_="Not_Passed (N)";
			Count=&m_TotN.;
			if &m_TotRel. ne 0 then
				Frequency= &m_TotN. /&m_TotRel.;
			else Frequency=.;
			output;
			format Frequency percent12.2;
		run;


	%end;

%mend;
