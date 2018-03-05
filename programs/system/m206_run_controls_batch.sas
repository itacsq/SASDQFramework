
%let path_project=/sas9.3/sas/home/env/PROJECTS_5/IFRS9/lev1/gdo/programs/dq_framework;

proc printto log="&path_project./logs/log_nohup.log";
run;

%let m_prompt_debug_flg=1;
%let m_prompt_cleanwrk_flg=0;
%let m_prompt_force_exec=0;

%if &m_prompt_batch_extract. %then %do;
	%let m_prompt_dates=1512;
	%let m_prompt_input_tbl=GDO_DATA.MV_IFRS9_TL_EAD_PD_UNR;
	%let m_prompt_le_anal=E1166;
	%include "&path_project./progs/Prog0_import_vars.sas";
	%include "&path_project./progs/m101_extract.sas";
%end;

%if &m_prompt_batch_sort. %then %do;
	%let m_prompt_sorted_flg=0;
	%include "&path_project./progs/Prog0_import_vars.sas";
	%include "&path_project./progs/m203_sort_input.sas";
%end;

%if &m_prompt_batch_controls. %then %do;
	%let m_prompt_sorted_flg=1;
	%let m_prompt_reduce_mode=0;
	%let m_prompt_init_var=1;
	%let m_prompt_final_var=90;
	%include "&path_project./progs/Prog0_import_vars.sas";
	%include "&path_project./progs/m203_sort_input.sas";
	%include "&path_project./progs/m204_run_controls.sas";
	%include "&path_project./progs/m205_reporting.sas";
%end;
