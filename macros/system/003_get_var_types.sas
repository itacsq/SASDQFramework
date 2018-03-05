/* It gets the type (num or char) and the format of a var in a dataset */
%macro getVarType(lib=, ds=, varname=);
    %global vartype varformat varlength;
    %let vartype=;
    %let varformat=;
    %let varlength=;

    proc sql noprint;
        select 
            case 
                when type eq 1 then 'N'
                when type eq 2 then 'C'
                else ''
            end
        as tp,
        case
            when type eq 1 and format ne '' then strip(format)||strip(put(formatl,8.))||"."
            when type eq 1 then "commax20.5"
            when type eq 2 then '$'||strip(put(length, 8.))||"."
            else "." /* questo caso non deve verificarsi mai! */
        end
        as fmt,
        length
            into 
                :vartype,
                :varformat,
                :varlength
                from info
                    where
                        upcase(libname) eq upcase("&lib.")
                        and upcase(memname) eq upcase("&ds.")
                        and upcase(name) eq upcase("&varname.")
            ;
    quit;

    %let vartype=&vartype.;
    %let varformat= &varformat.;
    %let varlength= &varlength.;
%mend;
