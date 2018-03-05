/* ************************************************************************************************************** 
*
*	MACRO:			putInfoIntoLog
*	DESCRIPTION:	this macro writes in the Log the name of the machine, pid, so and work path
*
* ************************************************************************************************************** */
%macro putInfoIntoLog();
	%put HOSTNAME=&SYSTCPIPHOSTNAME;
	%put -> PID     =&SYSJOBID;
	%put -> OS      =&SYSSCP &SYSSCPL;
	%put -> WORK    =%SYSFUNC(pathname(work));
%mend;
