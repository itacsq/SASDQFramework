/* ************************************************************************************************************** 
*
*	MACRO:			getHTMLTableStyle
*	DESCRIPTION:	this macro defines style to print a table in a HTML page
*
* ************************************************************************************************************** */

%macro getHTMLTableStyle();

     put '<style type="text/css">';

     put 'div.section {';
     put '  margin: 100px;';
     put '}';

     put 'p {';
     put "  font-family: century gothic, sans-serif;";
     put '  font-size: 16px;';
     put '  font-weight: 400;';
     put '}';
     put 'p.missing {';
     put "  border: solid 1px red;";
     put "  padding: 10px;";
     put "  color: red;";
     put "  font-style: italic;";
     put '}';

     put 'div.table-title {';
     put '   display: block;';
     put '  margin: auto;';
     put '  max-width: 600px;';
     put '  padding:5px;';
     put '  width: 100%;';
     put '}';

     put '.table-title h3 {';
     put '   color: #fafafa;';
     put '   font-size: 30px;';
     put '   font-weight: 400;';
     put '   font-style:normal;';
     put '   text-shadow: -1px -1px 1px rgba(0, 0, 0, 0.1);';
     put '   text-transform:uppercase;';
     put '}';


     put '/*** Table Styles **/';

     put '.table-fill {';
     put '  background: white;';
     put '  border-radius:3px;';
     put '  border-collapse: collapse;';
     put '  margin: auto;';
     put '  max-width: 600px;';
     put '  padding:5px;';
     put '  width: 100%;';
     put '  box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);';
     put '  animation: float 5s infinite;';
     put '}';
     put ' ';
     put 'th {';
     put '  color:#D5DDE5;;';
     put '  background:#1b1e24;';
     put '  border-bottom:4px solid #9ea7af;';
     put '  border-right: 1px solid #343a45;';
     put '  font-size:23px;';
     put '  font-weight: 100;';
     put '  padding:24px;';
     put '  text-align:left;';
     put '  text-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);';
     put '  vertical-align:middle;';
	 put '  word-wrap: break-word;';
     put '}';

     put 'th:first-child {';
     put '  border-top-left-radius:3px;';
     put '}';
     put ' ';
     put 'th:last-child {';
     put '  border-top-right-radius:3px;';
     put '  border-right:none;';
     put '}';
     put '  ';
     put 'tr {';
     put '  border-top: 1px solid #C1C3D1;';
     put '  border-bottom-: 1px solid #C1C3D1;';
     put '  color:#666B85;';
     put '  font-size:16px;';
     put '  font-weight:normal;';
     put '  text-shadow: 0 1px 1px rgba(256, 256, 256, 0.1);';
     put '}';
     put ' ';
     put 'tr:hover td {';
     put '  background:#E66405;';
     put '  color:#FFFFFF;';
     put '  border-top: 1px solid #22262e;';
     put '  border-bottom: 1px solid #22262e;';
     put '}';
     put ' ';
     put 'tr:first-child {';
     put '  border-top:none;';
     put '}';

     put 'tr:last-child {';
     put '  border-bottom:none;';
     put '}';
     put ' ';
     put 'tr:nth-child(odd) td {';
     put '  background:#EBEBEB;';
     put '}';
     put ' ';
     put 'tr:nth-child(odd):hover td {';
     put '  background:#E66405;';
     put '}';

     put 'tr:last-child td:first-child {';
     put '  border-bottom-left-radius:3px;';
     put '}';
     put ' ';
     put 'tr:last-child td:last-child {';
     put '  border-bottom-right-radius:3px;';
     put '}';
     put ' ';
     put 'td {';
     put '  background:#FFFFFF;';
     put '  padding:20px;';
     put '  text-align:left;';
     put '  vertical-align:middle;';
     put '  font-weight:300;';
     put '  font-size:18px;';
     put '  text-shadow: -1px -1px 1px rgba(0, 0, 0, 0.1);';
     put '  border-right: 1px solid #C1C3D1;';
     put '  word-wrap: break-word;';
     put '}';



	 put 'tr:nth-child(4n+1) td.doppiaentrata{';
     put '  background:#FFFFFF !important;';
     put '}';
     put ' ';
	 put 'tr:nth-child(4n+2) td.doppiaentrata{';
     put '  background:#FFFFFF !important;';
     put '}';
     put ' ';
	 put 'tr:nth-child(4n+3) td.doppiaentrata{';
     put '  background:#EBEBEB !important;';
     put '}';
     put ' ';
	 put 'tr:nth-child(4n+4) td.doppiaentrata{';
     put '  background:#EBEBEB !important;';
     put '}';
	 put 'tr:hover td.doppiaentrata {';
     put '  background:#E66405 !important;';
     put '  color:#FFFFFF !important;';
     put '  border-top: 1px solid #22262e;';
     put '  border-bottom: 1px solid #22262e;';
     put '}';
	 

     put 'td:last-child {';
     put '  border-right: 0px;';
     put '}';

     put 'th.text-left {';
     put '  text-align: left;';
     put '}';

     put 'th.text-center {';
     put '  text-align: center;';
     put '}';

     put 'th.text-right {';
     put '  text-align: right;';
     put '}';

     put 'td.text-left {';
     put '  text-align: left;';
     put '}';

     put 'td.text-center {';
     put '  text-align: center;';
     put '}';

     put 'td.text-right {';
     put '  text-align: right;';
     put '}';

     put 'h1{';
     put '  font-size: 30px;';
     put '  text-transform: uppercase;';
     put '  font-weight: 300;';
     put '  text-align: center;';
     put '  margin-bottom: 15px;';
     put '}';
     put 'h2{';
     put '  font-size: 20px;';
     put '  text-transform: uppercase;';
     put '  font-weight: 300;';
     put '  font-style: italic;';
     put '  text-align: right;';
     put '  margin-bottom: 15px;';
     put '}';
     put 'h3{';
     put '  font-size: 20px;';
     put '  text-transform: uppercase;';
     put '  font-weight: bold;';
     put '  text-align: left;';
     put '  text-align: left;';
     put '  margin-bottom: 15px;';
     put '}';
     put 'table{';
     put '  font-family:Century Gothic;';
     put '  width:100%;';
     put '  table-layout: fixed;';
     put '}';
     put '.tbl-header{';
     put '  background-color: rgba(255,255,255,0.3);';
     put ' }';
     put '.tbl-content{';
     put '  overflow-x:auto;';
     put '  margin-top: 0px;';
     put '  border: 1px solid rgba(255,255,255,0.3);';
     put '}';
     put 'th{';
     put '  padding: 20px 15px;';
     put '  text-align: left;';
     put '  font-weight: 500;';
     put '  font-size: 12px;';
     put '  color: #fff;';
     put '  text-transform: uppercase;';
     put '}';
     put 'td{';
     put '  padding: 15px;';
     put '  text-align: left;';
     put '  vertical-align:middle;';
     put '  font-weight: 300;';
     put '  font-size: 12px;';
     put '  color: black;';
     put '  border-bottom: solid 1px rgba(255,255,255,0.1);';
     put '}';
     put 'p.conditions{'
     put '  font-family: monospace;';
     put '  font-size: 11px;';
     put '}';
     put 'span{'
     put '  font-weigth: bold;';
     put '  color: red;';
     put '}';


     put 'body{';
     put "  font-family: century gothic, sans-serif;";
     put '}';
     put 'section{';
     put '  margin: 50px;';
     put '}';

     put '</style>';


%mend;


/* ************************************************************************************************************** 
*
*	MACRO:			initHTML
*	DESCRIPTION:	this macro write html code in a file
*	PARAMETERS:		file = file to use
*
* ************************************************************************************************************** */

%macro initHTML(file=fn);

     data _null_; 
          file &file.;
          put '<html>';
          put '<head>';
		  put '<meta charset="UTF-8">';
          %getHTMLTableStyle();
          put '</head>';
          put '<body>';
     run;

%mend;

/* ************************************************************************************************************** 
*
*	MACRO:			closeHTML
*	DESCRIPTION:	this macro write html code in a file
*	PARAMETERS:		file = file to use
*
* ************************************************************************************************************** */

%macro closeHTML(file=fn);

     data _null_;
          file &file. mod;
          put '  </body>';
          put '</html>';
     run;

%mend;




%macro printHTMLSectionEasy(file=fn, varnm=, vartbl=, vardesc=, varBO=, varDT=);
    data _null_;
        file &file. mod;
        put '<div class="section">';
        put "<h1>Name: &varnm.</h2>  ";
        put "<h1>Table: &vartbl.</h2>  ";
        put "<h2>&varBO.</h2>  ";
        put "<h2>&varDT.</h2>  ";
        put "<p>Variable Description: &vardesc.</p>  ";
        put '</div>';
    run;
%mend;



%macro printHTMLSection(file=fn, varnm=, vartbl=, vardesc=, varBO=, varDT= );
    data _null_;
        file &file. mod;
        put '<div class="section">';
        put "<h1>Name: &varnm.</h2>  ";
        put "<h1>Table: &vartbl.</h2>  ";
        put "<h2>&varBO.</h2>  ";
        put "<h2>&varDT.</h2>  ";
        put "<p>Variable Description: &vardesc.</p>  ";
        put "<p>";
        put "   <ul>";
        put "       <li><span>Missing Condition</span>: [&m_report_missing_cond.] </li>";
        put "       <li><span>Domain</span>: [&m_report_domain_cond.] </li>";
        put "       <li><span>Where Condition</span>: [&m_report_where_cond.] </li>";
        put "   </ul>";
        put "</p>";
        put '</div>';
    run;
%mend;

%macro printConditions(file=);
    data _null_;
        file &file. mod;
        put "<p>";
        put "<ul>";
        put "<li><span>Missing Condition</span>: [&m_report_missing_cond.] </li>";
        put "<li><span>Domain</span>: [&m_report_domain_cond.] </li>";
        put "<li><span>Where Condition</span>: [&m_report_where_cond.] </li>";
        put "</ul>";
        put "</p>";
    run;
%mend;

%macro printHTMLDescription(file=, num=);
    data _null_;
        file &file. mod;
        put "<p>";
        %if &num. eq G1 %then %do;

            put "Check if the record is within the expected domain. List of modalities can be defined for qualitative fields. For quantitative ones, intervals can be defined.";
            put "<br>Table below shows how many records fall within its variable domain:";
            put "<br>- <span>Total Record</span>: it counts table records (Y+N+Missing)";
            put "<br>- <span>Relevant Record</span>: it counts non missing record and within its <span>where condition</span>(Y+N)";
            put "<br>- <span>Passed Record</span>: it counts how many <span>relevant</span> records pass domain condition (Y)";
            put "<br>- <span>Non Passed Record</span>: it counts how many <span>relevant</span> records do not pass domain condition (N)";
            put "<br>";
            put "<br>For this control:";
            put "<br>- <span>Y</span>: if the record is within its domain (i.e. domain rule respected, not missing, within where condition)";
            put "<br>- <span>N</span>: if the record is not within its domain (i.e. domain rule NOT respected, not missing, within where condition)";
            put "<br>";

        %end;
        %else %if &num. eq G2 %then %do;

            put "Check the variation of the field among a time series. For qualitative fields this control verifies the stability of the variable. The percentage of variation is reported for quantitative ones.";
            put "<br>Table below shows records that follow where condition and are not missing in both reference times.";
            put "<br>";
            put "<br>For numerical fields:";
            put "<br>- <span>Relevant Record</span>: it counts how many records are within where condition and not missing";
			put "<br>- <span>Mean Variation</span>: it shows Weighted Average Variation";
			put "<br>- <span>Statistics</span>: it shows statistics on variation";
            put "<br>For string fields:";
            put "<br>- <span>Relevant Record</span>: it counts how many records are within where condition and not missing";
			put "<br>- <span>Changed Record</span>: it counts how many records change";
			put "<br>- <span>Stable Record</span>: it counts how many records <span>do not</span> change";
            put "<br>";


        %end;
        %else %if &num. eq G3 %then %do;

            put "This control verifies if a record is expected to be missing in specific conditions, correlated to other variables.";
            put "<br>Table below shows records that follow reporting:";
            put "<br>- <span>Total Record</span>: it counts table records (Y+N+Missing)";
            put "<br>- <span>Relevant Record</span>: it counts how many record are not within <span>where condition</span> (Y+N)";
            put "<br>- <span>Passed Record</span>: it counts how many <span>relevant</span> records are not within where condition but are missing (Y)";
            put "<br>- <span>Non Passed Record</span>: it counts how many <span>relevant</span> records are not within where condition and are <span>NOT missing</span> (N)";
            put "<br>";
            put "<br>For this control:";
            put "<br>- <span>Y</span>: record <span>is NOT</span> within <span>the where condition</span> and it <span>is missing</span> (according to the missing definition)";
            put "<br>- <span>N</span>: record <span>is NOT</span> within <span>the where condition</span> and it <span>is NOT missing</span> (according to the missing definition)";
            put "<br>";

        %end;
        %else %if &num. eq G4 %then %do;

            put "Percentage of non-missing records. Both missing values and a where condition can be defined.";
            put "<br> Table below shows how many records are not missing <span>within its where condition</span>:"
            put "<br>- <span>Total Record</span>: it counts table records (Y+N+Missing)";
            put "<br>- <span>Relevant Record</span>: it counts how many record are within where condition (Y+N)";
            put "<br>- <span>Passed Record</span>: it counts how many <span>relevant</span> records are <span>not missing</span> (Y)";
            put "<br>- <span>Non Passed Record</span>: it counts how many <span>relevant</span> record are missing (N)";
            put "<br>";
            put "<br>For this control:";
            put "<br>- <span>Y</span>: record is not missing";
            put "<br>- <span>N</span>: record is missing (i.e. missing and within the where condition)";
            put "<br>";

        %end;
        %else %if &num. eq S1 %then %do;
            put "Up to Top 10 Highest values and up to top 10 bottom  lowest values extracted from input table (net of missing condition, within its domain and within  where conditions).";
			put "A variable for sorting could be defined in order to perform a different sorting condition (e.g. exposure).";
			put "<br>Note: reported percentage values are calculated on the overall considered sample (net of missing condition, within its domain and within  where conditions).";
        %end;
        %else %if &num. eq S2 %then %do;
            put "Frequency of each possible modality is reported. The control is applied to qualitative fields or discrete numeric fields.";
        %end;
        %else %if &num. eq S2M %then %do;
            put "Frequency of each possible <span>missing value</span> on the overall missing sample. The control is applied to qualitative fields or discrete numeric fields.";
        %end;
        %else %if &num. eq S3 %then %do;
            put "Analysis of median mean maximum minimum quartiles and percentiles of variable distribution net of missing condition, within its domain and within  where conditions.";
			put "It should be applied only to quantitative fields.";
        %end;
        %else %if &num. eq S4 %then %do;
            put "Sum of all records respecting a where condition. Sum can be grouped according to other columns (e.g. credit segment).";
        %end;


        put "</p>";
    run;
%mend;




/* ************************************************************************************************************** 
*
*	MACRO:			printHTMLTable
*	DESCRIPTION:	this macro write html code in a file to print a table
*	PARAMETERS:		tbl = table name
*					file = file to use
*					tblTitle = table title to print
*					tblDesc = descriptionof the table
*
* ************************************************************************************************************** */


%macro printHTMLTable(tbl=, file=fn, tblTitle=, tblConds=, tblDesc=, num=);


     %if %sysfunc(exist(&tbl.)) %then %do;



          data _null_;
                file &file. mod;
                put '<div class="section">';
                put "<h3>&tblTitle.</h3>  ";
          run;

          %if %length(&tblDesc.) eq 0 %then %do;
              /* Specific to DQFramework */
              %printHTMLDescription(file=&file., num=&num.);
              %printConditions(file=&file.);
          %end;
          %else %do;
            data _null_;
                file &file. mod;
                put "<p>&tblDesc.</p>  ";
          %end;


          %let cnt=%m_f_cnt_obs(data=&tbl.);
          %if &cnt. ne 0 %then %do;
                     

                proc contents data=&tbl. nodetails noprint out=info;
                run;
                proc sql noprint;
                     select 
                          name, format, type, 
							case 
								when missing(label) then name 
								else tranwrd(label, "-", " ")
							end

                               into 
                                     :lst_nm separated by "#",
                                     :lst_fmt separated by "#",
                                     :lst_tp separated by "#",
									 :lst_lbl separated by "#"
                     from info
                     order by varnum
                     ;
                quit;
                proc delete data=info;
                run;

                data _null_;
                     file &file. mod;
                     put '<div  class="tbl-header">';
                     put '<table cellpadding="0" cellspacing="0" border="0">';
                     put '  <thead>';

                     /* Variable Names */
                     put '    <tr>';
                     
                     %let phtindex=1;
                     %do %while(%scan(&lst_nm., &phtindex., #) ne );
                          %let nm=%scan(&lst_nm, &phtindex., #);
                          %let fmt=%scan(&lst_fmt, &phtindex., #);
                          %let tp=%scan(&lst_tp, &phtindex., #);
						  %let label=%scan(&lst_lbl, &phtindex., #);
                          put "      <th>&label.</th>"; 
                          %let phtindex=%eval(&phtindex.+1);
                     %end;

                     
                     put '    </tr>';


                     put '  </thead>';
                     put '</table>';
                     put '</div>';
                     put '<div  class="tbl-content">';
                     put '<table cellpadding="0" cellspacing="0" border="0">';
                     put '  <tbody>';

                     /* Contents */
                     
                run;

                data _null_;
                     file &file. mod;
                     set &tbl.;
                     put '    <tr>';
                     %let phtindex=1;
                     %do %while(%scan(&lst_nm, &phtindex., #) ne );
                          %let nm=%scan(&lst_nm, &phtindex., #);
                          %let fmt=%scan(&lst_fmt, &phtindex., #);
                          %let tp=%scan(&lst_tp, &phtindex., #);
						  %let label=%scan(&lst_lbl, &phtindex., #);
						  %if (%sysfunc(find(&tblDesc., doppia entrata, i)) gt 0 or
								%sysfunc(find(&tblDesc., 2-way, i)) gt 0) %then %do;
								put "      <td class='doppiaentrata'>" &nm. "</td>";
						  %end; 
						  %else %do;
                          		put "      <td>" &nm. "</td>";
						  %end;
                          %let phtindex=%eval(&phtindex.+1);
                     %end;
                     put '    </tr>';
                run;

                data _null_;
                     file &file. mod;
                     
                     put '  </tbody>';
                     put '</table>';
                     put '</div>';
                run;

          %end;
          %else %do;
                data _null_;
                     file &file. mod;
                     put '<p class="missing">There are no values available for this control.</p>  ';
                run;
                
          %end;

          data _null_;
                file &file. mod;
                put '</div>';
          run;

     %end;
     %else %do;
          %put WARNING: Table=[&tbl.] does not exist!;
     %end;


%mend;
