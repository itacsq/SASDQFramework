/* ************************************************************************************************************** 
*
*	MACRO:			freq_trasp
*	DESCRIPTION:	this macro creates a 2-ways frequency table.
*					Steps are:
*					1. proc freq on both var1 and var2 to get distinct values
*					2. stores both values on two macro lists
*					3. creates one column for each distinct value of var2 
*					4. fill table values with values from freq (freq and percent) and group to 
*					remove blanks
*					
*	PARAMETERS:		tblIn = input table to analyze
*					var1 = first variable to insert in 2-ways table
*					var2 = second variable to insert in 2-ways table
*					tblOut = name of the output table
*	OUTPUT:			tblOut = name of the output table
*
* ************************************************************************************************************** */
%macro freq_trasp(tblIn=, var1=, var2=, tblOut=);

    %let var2_type=;

	proc contents data=&tblIn. out=info_tmp noprint nodetails;
	run;
    proc sql noprint;
            select 
                    case 
                    	when type eq 1 then 'N'
                        when type eq 2 then 'C'
                        else ''
                    end
            into :var2_type
            from info_tmp
            where upcase(name) eq upcase("&var2.")
            ;
    quit;

    /* 2-ways frequency table */
    proc freq data=&tblIn. noprint;
            tables &var1.*&var2./out=freq;
    run;

    /* List of distinct value of vars */
    proc sql noprint;
         select distinct &var2. into : var2_lst separated by "#"
         from freq;
         select distinct &var1. into : var1_lst separated by "#"
         from freq;
    quit;

    %put NOTE: var1_lst [&var1_lst.];
    %put NOTE: var2_lst [&var2_lst.];

    data ft_tmp;
         set freq;
         %let index = 1;
         %do %while(%length(%scan(&var2_lst., &index., #)) ne 0);

               %let var = %scan(&var2_lst., &index., #);
               label &var2.&index. = "&var2. &var.";

               %if &var2_type. eq C %then %do;
                	if &var2. eq "&var." then do;
               %end;
               %else %do;
                    if &var2. eq &var. then do;
               %end;
	                    lbl="frequency";
	                    &var2.&index. = count;
	                    output;
	                    lbl="percent";
	                    &var2.&index. = percent;
	                    output;
                     end;

               %let index=%eval(&index.+1);
         %end;

         drop &var2. percent count;
    run;

    proc sql noprint;
         create table &tblOut. as 
         select &var1., lbl label "_", sum(
               %let var=%scan(&var2_lst., 1, #);
               &var2.1  ) as &var2.1 label "&var2. &var."
               %let index=2;
               %do %while(%scan(&var2_lst., &index., #) ne );
                    %let var=%scan(&var2_lst., &index., #);
                         , sum(&var2.&index.  ) as &var2.&index. label "&var2. &var."
                    %let index=%eval(&index.+1);
               %end;
         from ft_tmp
         group by &var1., lbl
          ;
    quit;

    proc delete data= ft_tmp;
    run;
    proc delete data= freq;
    run;
	
	proc delete data= info_tmp;
    run;
	

%mend;
