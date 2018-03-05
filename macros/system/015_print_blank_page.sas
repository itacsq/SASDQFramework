/* It prints Blank New Page with titles in the destination */
%macro printBlankNewPage(t1=, t2=, t3=, odsnm=all);

	*ods pdf(&odsnm.) notoc startpage=no;

	title1 justify=left "&t1.";
	title2 justify=left "&t2.";
	title3 justify=left "&t3.";
	
	data tt;
		length _ $1024.;
		_="";
	run;

	*ods pdf(&odsnm.) startpage=now;

	proc print data=tt noobs  split="" heading=vertical  /*nosumlabel*/
			style(header)=[background=white BORDERCOLOR=white COLOR=white]
			style(table)=[BORDERCOLOR=white]
			style(table)=[color=white]
	;
	run;
%mend;
