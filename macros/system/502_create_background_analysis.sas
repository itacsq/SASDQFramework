/* ******************************************************************* 
*	MACRO:			Create Dashboards [multiple macros]
*	DESCRIPTION:	set of macros to create an HTML dashboard based on
*					a specific CSS (defined within printHTMLDashHead ). 
*					To use:
*					a. define an html filename
*					b. set up the header part with printHTMLDashHead
*					c. print a table with printHTMLDashTbl
*					d. close the html with printHTMLDashFoot
*
*	NOTE:			
*					It is possibile to choose to print label or id
*					
*	IN PAR:			
*					1. fn: html filename
*					2. tbl: table to be printed out
*					3. label [0,1]: print name (0) or label (1)
*	USAGE:
*					filename ht "/sas/file.html";
*					%printHTMLDashHead(fn=ht);
*					%printHTMLDashTbl(tbl=SOME_TABLE, fn=ht, label=0);
*					%printHTMLDashFoot(fn=ht);
* ****************************************************************** */


%macro printCSSDash(fn=);
	put '	@charset "UTF-8";';
	put '	body {';
	put '	  font-family: Century Gothic, sans-serif;';
	put '	  font-weight: 300;';
	put '	  line-height: 1.42em;';
	put '	  color:#A7A1AE;';
	put '	  background-color:#1F2739;';
	put '	}';
	put '	h1 {';
	put '	  font-size:3em; ';
	put '	  font-weight: 300;';
	put '	  line-height:1em;';
	put '	  text-align: center;';
	put '	  color: #4DC3FA;';
	put '	}';
	put '	h2 {';
	put '	  font-size:1em; ';
	put '	  font-weight: 300;';
	put '	  text-align: center;';
	put '	  display: block;';
	put '	  line-height:1em;';
	put '	  padding-bottom: 2em;';
	put '	  color: #FB667A;';
	put '	}';
	put '	h2 a {';
	put '	  font-weight: 700;';
	put '	  text-transform: uppercase;';
	put '	  color: #FB667A;';
	put '	  text-decoration: none;';
	put '	}';
	put '	.blue { color: #185875; }';
	put '	.yellow { color: #FFF842; }';
	put '	.container th h1 {';
	put '		  font-weight: bold;';
	put '		  font-size: 1em;';
	put '	  text-align: left;';
	put '	  color: #185875;';
	put '	}';
	put '	.container td {';
	put '		  font-weight: normal;';
	put '		  font-size: 1em;';
	put '	  -webkit-box-shadow: 0 2px 2px -2px #0E1119;';
	put '		   -moz-box-shadow: 0 2px 2px -2px #0E1119;';
	put '		        box-shadow: 0 2px 2px -2px #0E1119;';
	put '	}';
	put '	.container {';
	put '		  text-align: left;';
	put '		  overflow: hidden;';
	put '		  width: 80%;';
	put '		  margin: 0 auto;';
	put '	  display: table;';
	put '	  padding: 0 0 8em 0;';
	put '	}';
	put '	.container td, .container th {';
	put '		  padding-bottom: 2%;';
	put '		  padding-top: 2%;';
	put '	  padding-left:2%;  ';
	put '	}';
	put '	/* Background-color of the odd rows */';
	put '	.container tr:nth-child(odd) {';
	put '		  background-color: #323C50;';
	put '	}';
	put '	/* Background-color of the even rows */';
	put '	.container tr:nth-child(even) {';
	put '		  background-color: #2C3446;';
	put '	}';
	put '	.container th {';
	put '		  background-color: #1F2739;';
	put '	}';
	put '	.container td:first-child { color: #FB667A; }';
	put '	.container tr:hover {';
	put '	   background-color: #464A52;';
	put '	-webkit-box-shadow: 0 6px 6px -6px #0E1119;';
	put '		   -moz-box-shadow: 0 6px 6px -6px #0E1119;';
	put '		        box-shadow: 0 6px 6px -6px #0E1119;';
	put '	}';
	put '	.container td:hover {';
	put '	  background-color: #FFF842;';
	put '	  color: #403E10;';
	put '	  font-weight: bold;';
	put '	  ';
	put '	  box-shadow: #7F7C21 -1px 1px, #7F7C21 -2px 2px, #7F7C21 -3px 3px, #7F7C21 -4px 4px, #7F7C21 -5px 5px, #7F7C21 -6px 6px;';
	put '	  transform: translate3d(6px, -6px, 0);';
	put '	  ';
	put '	  transition-delay: 0s;';
	put '		  transition-duration: 0.4s;';
	put '		  transition-property: all;';
	put '	  transition-timing-function: line;';
	put '	}';
	put '	@media (max-width: 800px) {';
	put '	.container td:nth-child(4),';
	put '	.container th:nth-child(4) { display: none; }';
	put '	}';

%mend;


%macro printHTMLDashHead(fn=);
	data _null_;
		file &fn.;
		put '<html>';
		put '<head>';
		put '	<style>';
		
		%printCSSDash(fn=&fn.);
		
		put '	</style>';
		put '</head>';
		put '<body>';
		put '	<h1><span class="blue">&lt;</span>Control<span class="blue">&gt;</span> <span class="yellow">Dashboard</pan></h1>';
	run;
%mend;


%macro printHTMLDashFoot(fn=);
	
	data _null_;
		file &fn. mod;
		put '</body>';
		put '</html>';
	run;

%mend;


%macro printHTMLDashTbl(tbl=, fn=, label=0);

	proc contents data=&tbl. nodetails noprint out=phinfo;
	run;
	proc sql noprint;
	     select 
		 	name,
			case 
				when missing(label) then name 
				else label 
			end as label
	               into 
	                     :lst_nm separated by "#",
						 :lst_lbl separated by "#"
	     from phinfo
	     order by varnum
	     ;
	quit;
	proc delete data=phinfo;
	run;
	
	
	data _null_;
		file &fn. mod;
		put '<table class="container">';
		put '	<thead>';
		put '		<tr>';
		
		%let phtindex=1;
		%do %while(%scan(&lst_nm, &phtindex., #) ne );
			%if &label. %then %do;
				%let nm=%scan(&lst_lbl., &phtindex., #); 
			%end;
			%else %do;
				%let nm=%scan(&lst_nm, &phtindex., #);
			%end;
			put "      <th>&nm.</th>";
			%let phtindex=%eval(&phtindex.+1);
		%end;
		
		put '		</tr>';
		put '	</thead>';
		put '	<tbody>';
	run;

	data _null_;
		file &fn. mod;
		set &tbl.;
		put '		<tr>';
		%let phtindex=1;
		%do %while(%scan(&lst_nm, &phtindex., #) ne );
			%let nm=%scan(&lst_nm, &phtindex., #);
			put "      <td>" &nm. "</td>";
			%let phtindex=%eval(&phtindex.+1);
		%end;
		put '		</tr>';
	run;

	data _null_;
		file &fn. mod;
		put '	</tbody>';
		put '</table>';
	run;


%mend;


