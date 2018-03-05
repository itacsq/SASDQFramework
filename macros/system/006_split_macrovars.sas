/* ******************************************************************* 
*	MACRO:			split_macrovalue (data)
*	DESCRIPTION:	this macro is used to split a list saved in a macro variable and
*					return series of macro variables
*
*	IN PAR:			
*					macvar = input macro var
*                   prefix = prefix of the macro vars created in sequence order
*                   splitcnt = name of the macro vars to store the length of the macro variable
*                   dlm = delimiter in the string (default is comma i.e. , )
*	OUT PAR:		
*					&splitcnt: splitcount
*					&prefix&num: created var for each num from 1 to splitcnt
*	USAGE:
*					%split_macrovalue(&LIST, VAR_, COUNT, DLM=#); 
*
* ****************************************************************** */



%macro split_macrovalue(macvar,prefix,splitcnt,dlm=comma,printvalue=N);
	/* %put Start macro split_macrovalue(&macvar,&prefix,&splitcnt,&dlm); */

	%if %upcase(&dlm) eq COMMA %then %do;
		%let dlm=,;
	%end;
	%else %if %upcase(&dlm) eq PIPE %then %do;
		%let dlm=|;
	%end;
	%else %if %upcase(&dlm) eq SPACE %then %do;
		%let dlm=%str( );
	%end;

	%global &splitcnt; /*create the global variable for storing the splitcount*/
	%let num=1; /*initialize a counter variable*/  

	%global &prefix&num; /*create the global variable for storing the first split*/
	%let &prefix&num=%scan(%superq(macvar),%superq(num),%superq(dlm)); /*Scan the first value*/
	/* %put Value here is &&&prefix#*/

     %if %index(%superq(macvar),%superq(dlm)) gt 0 %then %do;

		%do %while(%length(&&&prefix&num) gt 0);
			%let &splitcnt=&num; /*Store the split count to the macro variable reqd*/            
          	%let num=%eval(&num + 1);/*increment the counter*/        
	          %global &prefix&num; /*create the global variable*/
	          %let &prefix&num=%scan(%superq(macvar),%superq(num),%superq(dlm)); /*scan the next value*/
			/* %put The next value is &prefix&num=&&&prefix# */
		%end;
     %end;
     %else %do; 
     	%let &splitcnt=&num.; /*Store the split count to the macro variable reqd*/ 
     %end;  

     /* %put The number of values are &&&splitcnt; */

      %if &printvalue=Y %then %do;
		%do j=1 %to &&&splitcnt;
			/* %put &prefix&j = &&&prefix&j; */
		%end;  
      %end;

	/* %put End macro split_macrovalue; */

%mend split_macrovalue; 
