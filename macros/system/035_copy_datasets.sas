

%macro cpDatasets(fld=, fldOut=, filter=sas);
	%put Move [&filter.] => cmd=[mv %bquote(&fld.%str(/)*.&filter.* &fldOut.)];
	
	filename dirlist pipe "mv &fld./*.&filter.* &fldOut.";
	data _null_;
	    infile dirlist pad lrecl=150;
	    input @1 filename $150.;
	    put filename;
	run;

%mend;

/* Testing 
* StandAlone testing ; 
%let m_prompt_area=LGD;
%let m_running_time=20170302_12-57-06;


* Process Testing ;
%let fld=&fld_prj./staging/datawrk/&m_prompt_area._&m_running_time.;
%let fldOut=&fld_prj./output/&m_prompt_area._&m_running_time.;
%put fld =[&fld.];
%put fld out=[&fldOut.];
%let filter=sas;
%cpDatasets(fld=&fld. , fldOut=&fldOut., filter=sas)
*/

