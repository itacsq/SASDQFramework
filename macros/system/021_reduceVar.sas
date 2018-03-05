%macro reduceVar(var=);
     %if %length(&var.) le 32 %then %do;
          &var.
     %end;
     %else %do;
          %substr(&var., 1, 32)
     %end;
%mend;
