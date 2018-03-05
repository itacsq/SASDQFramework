/* It prints all synthetic tables for a fixed variable */

%macro printReport(varindex=, html=htmlall);

     %getInfoVar(givindex=&varindex.);

     %printHTMLSection(file=&html., varnm=&m_report_var_nm., vartbl=%bquote(&m_report_var_tbl. - &m_report_var_filter.), vardesc=%bquote(&m_report_var_desc.), 
                varBO=&m_report_var_business_owner., varDT=&m_report_var_rundt. );

     %let tit1=Check Domain - [G1];
     %let tit2=Historical Check - [G2];
     %let tit3=Where-not Check - [G3];
     %let tit4=Data Completition - [G4];
     
     /* Granularity Controls */
     %do i=1 %to 4;
          %if &&m_report_var_g&i._flg ne  %then %do;
              /*mda    %replaceLookup(tbl=g&i._&m_report_var_pos.);*/
                %printHTMLTable(tbl=DATAWRK.g&i._&m_report_var_pos., file=&html., tblTitle=&&tit&i, num=G&i.);
          %end;
     %end;

     %let tit1=Top20 - [S1];
     %let tit2=Domain Distribution - [S2];
     %let tit2M=Missing Distribution - [S2 - Missing];
     %let tit3=Numeric Distribution - [S3];
     %let tit4=Reconciliation - [S4];
     
     /* Synthetic Controls */ 
     %do i=1 %to 4;
          %if &&m_report_var_s&i._flg ne  %then %do;
                 /*mda  %replaceLookup(tbl=datawrk.s&i._&m_report_var_pos.); */
                %if &i. eq 2 %then %do;
                    %printHTMLTable(tbl=datawrk.s&i._M_&m_report_var_pos., file=&html., tblTitle=&tit2M., num=S2M);    
                %end;
                %printHTMLTable(tbl=datawrk.s&i._&m_report_var_pos., file=&html., tblTitle=&&tit&i, num=S&i.);
          %end;
     %end;

     %if &m_report_var_spec. gt 0 %then %do;
        %let tit=Specific Controls;
        %do i=1 %to &m_report_var_spec.;
            %let des=%scan(%bquote(&m_report_var_spec_control.),&i.,#);
            /*mda %replaceLookup(tbl=datawrk.sp_&m_report_var_pos._&i.); */
            %printHTMLTable(tbl=datawrk.sp_&m_report_var_pos._&i., file=&html., tblTitle=&tit., tblDesc=%bquote(&des.) );
        %end; 
     %end;
     
%mend;

