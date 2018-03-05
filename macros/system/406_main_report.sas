/* It creates the report */

%macro createReport();

	%listCheckedVars();

	%printToLog(mex= [FLOW_BO] - Report for ALL_FIELDS, debug=0);	

	filename htmlall "&m_report_fullpath._ALL.html";
	%if %sysfunc(exist(datawrk.xzdash)) %then %do;
		proc delete data=datawrk.xzdash;
		run;
	%end;
	%initHTML(file=htmlall);

	%let crindex=1;
	%do %while(%scan(&var_info_list., &crindex., #) ne );
		%getInfoVar(givindex=&crindex.);
		/* 
		%printMacros(pattern=m_report, debug=1);
		*/

		%printToLog(mex= [FLOW_NAME] - Variable [&m_report_var_nm.] - &crindex./&m_tbl_xlschecked_nobs., debug=0);	
		%printReport(varindex=&crindex., html=htmlall);

		%getDashBordInfo();
		%printToLog(mex= [FLOW_DASH] - Insert Information into SAS Dashboard, debug=0);		
		%updateDashSAS();

		%let crindex=%eval(&crindex.+1);
	%end;

	%closeHTML(file=htmlall);

	%let crindex=1;
	%do %while(%scan(&m_report_owners_lst., &crindex., #) ne );
		%let bo=%reduceVar(var=%scan(&m_report_owners_lst., &crindex., #));

		%printToLog(mex= [FLOW_BO] - Report for &bo. , debug=0);	

		filename fn&crindex. "&m_report_fullpath._&bo..html";
		%initHTML(file=fn&crindex.);

		%let crjndex=1;
		%do %while(%scan(&var_info_list., &crjndex., #) ne );

			%getInfoVar(givindex=&crjndex.);
			%if %reduceVar(var=&m_report_var_business_owner.) eq &bo. %then %do;
			%printToLog(mex= [FLOW_NAME] - Variable [&m_report_var_nm.], debug=0);	
			%printReport(varindex=&crjndex., html=fn&crindex.);
		%end;
	%let crjndex=%eval(&crjndex.+1);
	%end;

	%closeHTML(file=fn&crindex.);

	%let crindex=%eval(&crindex.+1);
	%end;
     

%mend;
