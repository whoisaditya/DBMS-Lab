\sql
\connect root@localhost

create database lab_da_5;
use lab_da_5;

create table employee (
    eid varchar(255) resultmary key,
    name varchar(255),
    gender varchar(255),
    city varchar(255),
    age int,
    doj date,
    salary float,
    cid varchar(255)
);

insert into employee values
("e01", "archi", "female", "delhi", 45, "2021-02-15", 60000.8, "CallingProcedures20"),
("e02", "sumon", "male", "chennai", 35, "2021-02-10", 50000.1, "CallingProcedures21"),
("e03", "ruchi", "female", "mumbai", 40, "2021-02-18", 55000.8, "CallingProcedures22"),
("e04", "sameer", "male", "delhi", 42, "2021-02-17", 51000, "CallingProcedures20"),
("e05", "prasun", "male", "chennai", 39, "2021-02-25", 65000, "CallingProcedures21"),
("e06", "resulttam", "male", "mumbai", 38, "2021-02-26", 62000, "CallingProcedures22");

 -- q1
delimiter $$
drop procedure if exists GetIsAboveAverage $$
create procedure GetIsAboveAverage(IN eid varchar(255), OUT isAboveAverage Boolean)
begin
    declare avgSalary float default 0;
    declare empSalary float default 0;
    select avg(salary) into avgSalary from employee;
    select salary into empSalary from employee where eid = eid;
    if empSalary > avgSalary then
        set isAboveAverage = TRUE;
    else
        set isAboveAverage = FALSE;
    end if;
end$$

delimiter $$
drop procedure if exists GeempIDResult $$
create procedure GeempIDResult(IN eid varchar(255), OUT result varchar(255))
begin
    call GetIsAboveAverage(eid, @isAboveAverage);
    if @isAboveAverage = 0 then
        set result =concat(eid, " is getting low salary from the compony");
    else
        set result =concat(eid, " is getting high salary from the compony");
    end if;
end$$

delimiter $$
drop procedure if exists main$$
create procedure main(out name varchar(10))
begin
declare x int default 0;
declare b varchar(10);
set b=(select eid  from employee limit 1 offset x);
while(b is not null) do
call FindIsAboveAverage(b);
set x=x+1;
set b=(select eid from employee limit 1 offset x);

end while;
end; $$
call  CallingProcedures1(@name);

-- q1 - satwik
select * from employee;$$
delimiter $$
drop procedure if exists FindIsAboveAverage$$
create procedure FindIsAboveAverage(in name varchar(10))
begin
    declare Sal int;
    declare result varchar(100);
    set Sal =(select avg(salary) from employee);
    if(Sal < (select salary from employee where eid=name)) then
        set result=name;
        select concat(result," is getting high salary from the company") as message;
    else
        set result=name;
        select concat(result," is getting less salary from the company" ) as message;
    end if;
end;$$


delimiter $$
drop procedure if exists CallingProcedures1$$
create procedure CallingProcedures1(out name varchar(10))
begin
    declare x int default 0;
    declare empID varchar(10);
    set empID = (select eid  from employee limit 1 offset x);
    while(empID is not null) do
        call FindIsAboveAverage(empID);
        set x = x + 1;
        set empID = (select eid from employee limit 1 offset x);
    end while;
end; $$

call  CallingProcedures1(@name); $$


-- q2
delimiter $$
drop procedure if exists CheckMinMax$$
create procedure CheckMinMax(in name varchar(10))
begin
    declare maxAge varchar(10);
    declare minAge varchar(10);
    declare empID varchar(100);

    set maxAge =(select max(age) from employee);
    set minAge=(select min(age) from employee);
    set empID = name;

    if(maxAge = ( select age from employee where eid = name)) then
        select concat(empID," is the oldest employee residing in ",(select city from employee where eid=name)) as message; 
    else
        if(minAge = (select age from employee where eid = name)) then
            select concat(empID," is the youngest employee residing in ",(select city from employee where eid=name)) as message; 
        else
            select concat(empID," is neither oldest nor youngest employee residing in ",(select city from employee where eid=name)) as message; 
        end if;
    end if;
end ;$$

delimiter $$
drop procedure if exists CallingProcedures2$$
create procedure CallingProcedures2(out name varchar(10))
begin
    declare x int default 0;
    declare empID varchar(10);
    set empID = (select eid  from employee limit 1 offset x);
    while(empID is not null) do
        call CheckMinMax(empID);
        set x = x + 1;
        set empID = (select eid from employee limit 1 offset x);
    end while;
end; $$

call  CallingProcedures2(@name);$$