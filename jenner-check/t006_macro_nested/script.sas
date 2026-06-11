%macro nested;

    %let a=b;
    %let b=c;
    %let c=d;

    data temp;

        layer = 1;
        temp="&a";
        output;

        layer = 2;
        temp="&&a";
        output;

        layer = 3;
        temp="&&&a";
        output;

        layer = 4;
        temp="&&&&a";
        output;

        layer = 5;
        temp="&&&&&a";
        output;

        layer = 6;
        temp="&&&&&&a";
        output;

        layer = 7;
        temp="&&&&&&&a";
        output;

        layer = 8;
        temp="&&&&&&&&a";
        output;
    run;

    proc print; run;

%mend;

%nested

