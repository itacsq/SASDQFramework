
%macro getLock(member=,timeout=10,retry=1);
	%local starttime;
	%let starttime = %sysfunc(datetime());
	%do %until(&syslckrc <= 0 or %sysevalf(%sysfunc(datetime()) > (&starttime + &timeout)));
		%put Locking [&member.] ...;
		data _null_;
			dsid = 0;
			do until (dsid > 0 or datetime() > (&starttime + &timeout));
				dsid = open("&member");
				if (dsid = 0) then rc = sleep(&retry);
			end;
			if (dsid > 0) then rc = close(dsid);
		run;
		lock &member;
	%end;
	%put ... granted!;
%mend getLock;
