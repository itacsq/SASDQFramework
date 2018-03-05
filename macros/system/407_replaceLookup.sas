/* ******************************************************************* 
*	MACRO:			replaceLookup ( tbl )
*	DESCRIPTION:	macro to replace each variable to whom a domain is 
*					connected via excel parameter to its domains values.
*					In case of no values it leaves the prev value.
*
*	NOTE:			To work it need datasort.dom_par table where the related
*					domain table is defined.
*	IN PAR:			
*					1. tbl: table for which the process check for domain
*						substitution
*	OUT PAR:		
*					1. replaceLookup_rc: output table name
* ****************************************************************** */

%macro search(var=, lst1=, lst2=);
%global search_rc0 search_rc1;
%let search_rc0=;
%let search_rc1=;
%let sindex=1;
%do %while(%scan(&lst1., &sindex., #) ne );
	%let vl=%scan(&lst1., &sindex., #);
	%if &var. eq &vl. %then %do;
		%let search_rc0=1;
		%let search_rc1=%scan(&lst2., &sindex., #);
	%end;
	%let sindex=%eval(&sindex.+1);
%end;
%mend;



%macro replaceLookup(tbl=);
	%global replaceLookup_rc;
	%if %sysfunc(exist(&tbl.)) %then %do;
		%let replaceLookup_rc=replaceLookupTbl;

		proc contents data=&tbl. out=dinfo noprint nodetails;
		run;

		proc sql noprint;
			select upcase(name) into :lst_nm separated by "#"
			from dinfo
			;
			select 
				upcase(var), dom  
				into 
					:lst_var_dom separated by "#", :lst_var_dom_val separated by "#"
			from datain.dom_par
			where not missing(dom)
			;
		quit;

		proc delete data=dinfo;
		run;

		data replaceLookupTbl;
			set &tbl.;
		run;

		%let lkindex=1;
		/* Per ogni variabile */
		%do %while(%scan(&lst_nm., &lkindex., #) ne );
			%let var=%scan(&lst_nm., &lkindex., #);		
			%search(var=&var., lst1=&lst_var_dom., lst2=&lst_var_dom_val.);
			%if &search_rc0. eq 1 %then %do;
				proc sql noprint;
					create table cp1 as 
					select coalescec(t2.desc, &var) as &var._lk, 
						t1.*
					from replaceLookupTbl as t1 left join datasort.&search_rc1. as t2
						on t1.&var. = t2.code
					;
				quit;
				data replaceLookupTbl;
					set cp1(drop=&var rename=(&var._lk=&var.));
				run;
				proc delete data=cp1;
				run;
			%end;
			%let lkindex=%eval(&lkindex.+1);
		%end;

	%end;
	%else %do;
		%let replaceLookup_rc=&tbl.;
	%end;

%mend;
/* 
%replaceLookup(tbl=g2_100);
*/
