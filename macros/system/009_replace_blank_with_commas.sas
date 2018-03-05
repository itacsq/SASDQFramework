/* ************************************************************************************************************** 
*
*	MACRO:			replaceBlankWComma
*	DESCRIPTION:	this macro replaces Blank with Comma in a string
*	PARAMETERS:		instr = string where you want to replace blanks
*	OUT: 			replaceChar_rc: replaced string
*
* ************************************************************************************************************** */

%macro replaceBlankWComma(instr=);
	%global replaceChar_rc;
	%let replaceChar_rc=;
	data _null_;
		call symputx("replaceChar_rc", tranwrd("&instr.", " ", ","));
	run;
%mend;
