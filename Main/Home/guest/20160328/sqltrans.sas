data A;
    length player $4 itemtype $13;
    input region player $ itemtype $ itemcount itemamount;
    cards;
1 Jack ProOther      4  184
1 Jack ProOther      2   84
1 Jack ProGameCredit 4  100
1 Jack FnB           2  106
1 Jack FnB           1   86
1 Dick ProGameCredit 1 2310
1 Dick ProGameCredit 1  210
2 Mary ProOther      2   43
2 Jack FnB           1  522
3 Jack FnB           1   88
3 Jack ProGameCredit 3 1036
3 Mary FnB           1 4578
;
run;

%macro do_work;

    %local i next_name;

    %do i=1 %to %sysfunc(countw(&itlist));

        %let next_name = %scan(&itlist, &i);

        create table a_&next_name as
            select region, player, 
                   sum(itemcount) as &next_name._itemcount, 
                   sum(itemamount) as &next_name._itemamount 
            from a
            where itemtype eq "&next_name"
            group by region, player, itemtype;

        create table t as
            select * from b left join a_&next_name
            on (b.region = a_&next_name..region and b.player eq a_&next_name..player);

        drop table b;

        create table b as select * from t;

        drop table t;

    %end;

%mend do_work;

proc sql;

select distinct itemtype into :itlist separated by ' ' from a order by itemtype;

create table b as select distinct region, player from a;

%do_work;

select * from b;

quit;