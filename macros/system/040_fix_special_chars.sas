/* ************************************************************************************************************** 
*
*	MACRO:			fixSpecialChar
*	DESCRIPTION:	this macro deletes special characters from values in a dataset
*	PARAMETERS:		tblIn  = dataset to change
*					name_lst = list of variables to change, separated by #
*	OUTPUT:			tblOut = dataset with changes
*
* ************************************************************************************************************** */


%macro fixSpecialChar(tblIn=, name_lst=, tblOut=);

	%let name_lst=&name_lst.;

	data &tblOut.;
		set &tblIn.;
		%let index=1;
		%do %while( %scan(&name_lst., &index., #) ne );
			%let var=%scan(&name_lst., &index., #);
				&var. = compress(&var.,' abcdefghijklmnopqrstuvwxyz0123456789.,-+/\=_#&*','KU'); 
			%let index=%eval(&index.+1);
		%end;
	run;

%mend;

