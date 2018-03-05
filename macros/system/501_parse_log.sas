/* ******************************************************************* 
*	MACRO:			getLastOpenStatusTbl ( fld_prj )
*	DESCRIPTION:	macro to scan a log looking for special tags which 
*					identify program status.
*					Output is stored within 3 table:
*					dashboard0: general table
*					dashboard1: detailed table
*					TODO: dashboard2: error table
*
*	NOTE:			
*					a. Logs has to be stored under &fld_prj./logs folder
*					b. Tags have to start with spcial patterns (FLOW_*)
*					c. OS is AIX but it works also on linux base systems
*	IN PAR:			
*					1. fld_prj: project folder
*	OUT PAR:		
*					1. getLastOpenStatusTbl_rc0: general table
*					2. getLastOpenStatusTbl_rc1: detailed table
*					3. getLastOpenStatusTbl_rc2: error table
* ****************************************************************** */


%macro getLastOpenStatusTbl(fld_prj=);
	%global getLastOpenStatusTbl_rc0 getLastOpenStatusTbl_rc1 getLastOpenStatusTbl_rc2;
	%let getLastOpenStatusTbl_rc0=dashboard0;
	%let getLastOpenStatusTbl_rc1=dashboard1;
	%let getLastOpenStatusTbl_rc2=dashboard2;

	%let cmd=cat &fld_prj./logs/"$(ls -1 &fld_prj./logs | grep log | tail -n1)" | grep "FLOW_";
	%put %bquote(&cmd.);
	%put ciao!;
	filename cmdlist pipe "%bquote(&cmd.)";
	data tmp;
		length token key step var per bo ela st $32. k j i s 8.;
	    infile cmdlist pad lrecl=500 end=last;
	    input @1 output $500.;
	    j=_n_;
	    token = scan(output, 1, " ");
	   	step = scan(output, 3, " ");
	   	
	   	if strip(token) eq "[FLOW_STEP_BEG]" then do;
			s=0;
	   		i=0;
	   		key = step;
			st = scan(output, 4, " ");
	   		retain key i s st;
	   	end;
		s=s+1;
	   	i=i+1;	 
	   	
	   	if strip(token) eq "[FLOW_STEP_END]" then do;
			ela = scan(output, 6, " ");
		end;


	   	if strip(token) eq "[FLOW_BO]" then do;
	   		k=0;
			bo = scan(output, 5, " ");
	   		retain k bo;
	   	end;
	   	k=k+1;

	   	
	   	if strip(token) eq "[FLOW_NAME]" or strip(token) eq "[FLOW_STEP_BEG]" then do;
	   		var = scan(output, 4, " ");
	   		per = scan(output, 6, " ");
	   		
	   	end;

	   	
	   	if strip(token) eq "[FLOW_NAME]" then do;
	   		i=1;
	   		retain var per;
	   	end;
	   	
	   	
		drop output;
	run;
	
	proc sql noprint;
	
		create table tmp2 as
		select key, var, max(i) as i
		from tmp
		group by key, var
		;

		create table tmp10 as 
		select key, max(s) as s
		from tmp
		group by key
		;
	quit;
	
	proc sql noprint;
		create table &getLastOpenStatusTbl_rc0. as 
		select t1.key as STEP,
				"Started: " || strip(t1.st) as NOTES,
				"Elapsed: " || strip(ela) || " sec" as TIME
		from tmp as t1 inner join tmp10 as t2 on
			t1.key=t2.key and t1.s=t2.s
		order by j
		;

		create table &getLastOpenStatusTbl_rc1. as 
		select t1.key as STEP,
				case
					when not missing(t1.per) then 
						case 
							when strip(upcase(t1.step)) eq "VARIABLE" then "Var: " || strip(t1.var) || " Perc: [" || strip(t1.per) || "]"
							when t1.key ne t1.step then "Var: " || strip(t1.var) || " Step: [" || strip(t1.step) || "] Perc: [" || strip(t1.per) || "]"
							else "Started: " || strip(t1.st)
						end 
					else 
						case 
							when strip(upcase(t1.step)) eq "VARIABLE" or strip(upcase(t1.step)) eq "REPORT" then "Var: " || strip(t1.var) || " BusinessOwner: [" || strip(t1.bo) || "]"
							when t1.key ne t1.step then "Var: " || strip(t1.var) || " Step: [" || strip(t1.step) || "]"
							else "Started: " || strip(t1.st)
						end 
				end as NOTES,
				case 
					when t1.key eq t1.step and not missing(t1.ela) then "Elapsed: "|| strip(t1.ela) || " sec"
				end as TIME
		from tmp as t1 inner join tmp2 as t2 on
			t1.key=t2.key and t1.var=t2.var and t1.i=t2.i
		order by j desc
		;
		
	quit;
	
	proc delete data=tmp;
	run;
	
	proc delete data=tmp2;
	run;
	proc delete data=tmp10;
	run;
	
%mend;
