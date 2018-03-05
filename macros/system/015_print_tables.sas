/* In presence of a flag, it prints table with titles in the destination specified */
%macro printTbl(flag=, tbl=, tblTitle=, npage=0, t1=, t2=, t3=, odsnm=all);
	%if &flag. ne %then %do;
		%if %length(&tbl) ne 0 %then %do;

			* ods pdf(&odsnm.) notoc startpage=no;

			title1 justify=left "&t1.";
			title2 justify=left "&t2.";
			title3 justify=left "&t3.";
			
			/*It creates a table with the title */
			data tt;
				length _ $1024.;
				_="&tblTitle.";
			run;

			%if &npage. %then %do;
				* ods pdf(&odsnm.) startpage=now; /* if npage=1, it prints in a new page */
			%end;

			/* It prints the table with the tile, without borderline */
			proc print data=tt noobs /* nosumlabel split="" heading=vertical 
					style(header)=[background=white BORDERCOLOR=white COLOR=white]
					style(table)=[BORDERCOLOR=white]*/
			;
			run;

			%put NOTE: Printing table [&tbl.], destination [&odsnm.];

			%checkVarExist(var=&m_report_var_nm., tbl=&tbl.);
			proc print data=&tbl. noobs label;
				%if &checkVarExist_rc. eq 1 %then %do;
					%if %length(&m_report_var_format.) ge 4 %then %do;
						format &m_report_var_nm. &m_report_var_format.;
					%end;
					%else %do;
						%if &m_report_var_type ne C %then %do;
							format &m_report_var_nm. commax20.2 ;
						%end;
					%end;

				%end;
			run;
		%end;
		%else %do;
			%put WARNING: Table=[&tbl.] missing;
		%end;
	%end;
%mend;
