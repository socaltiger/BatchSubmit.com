&#24490;&#29615;&#36825;&#26679;&#20889;

%local i next_name; %let i=1; %do %while (%scan(&name_list, &i) ne ); %let next_name = %scan(&name_list, &i); %** DO whatever needs to be done for &NEXT_NAME; %let i = %eval(&i + 1); %end;

&#25110;&#32773;

%local i next_name; %do i=1 %to %sysfunc(countw(&name_list)); %let next_name = %scan(&name_list, &i); %** DO whatever needs to be done for &NEXT_NAME; %end;