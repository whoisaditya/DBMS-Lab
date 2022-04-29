\sql
\connect root@localhost

drop database if exists lab_da_6;
create database lab_da_6;
use lab_da_6;

drop table if exists employee;
create table employee (
    eid varchar(255) primary key,
    ename varchar(255),
    eaddress varchar(255),
    emonthlysalary float
);

insert into employee values
("e01", "archi", "delhi", 60000.8),
("e02", "sumon", "chennai", 50000.1),
("e03", "ruchi", "mumbai", 55000.8),
("e04", "sameer", "delhi", 51000),
("e05", "prasun", "chennai", 65000),
("e06", "resulttam", "mumbai", 62000);//

-- trigger1
delimiter //
drop trigger if exists add_sal_bef_insert//
create trigger add_sal_bef_insert 
  before insert on employee for each row 
	begin 
      set new.emonthlysalary = new.emonthlysalary + 100; 
end //

insert into employee values("e07", "aditya m", "pune", 60000); //
select * from employee //

-- table creation for trigger2 and 5
drop table if exists final_salary;
create table final_salary(
    salary float
    );
insert into final_salary
select sum(emonthlysalary) from employee;
desc final_salary;

-- trigger2
delimiter //
drop trigger if exists total_sal;//
create trigger total_sal
  after insert on employee for each row 
  begin
  update final_salary
  set salary=salary+new.emonthlysalary;
end//

insert into employee values("e08", "avantika", "pune", 100000);//
insert into employee values("e09", "neha", "bangalore", 100000);//

select * from final_salary;//

--- reset table
drop table if exists employee;//
create table employee (
    eid varchar(255) primary key,
    ename varchar(255),
    eaddress varchar(255),
    emonthlysalary float
);//

insert into employee values
("e01", "archi", "delhi", 60000.8),
("e02", "sumon", "chennai", 50000.1),
("e03", "ruchi", "mumbai", 55000.8),
("e04", "sameer", "delhi", 51000),
("e05", "prasun", "chennai", 65000),
("e06", "resulttam", "mumbai", 62000);//
insert into employee values("e07", "aditya m", "pune", 60000); //
insert into employee values("e08", "avantika", "pune", 100000);//
insert into employee values("e09", "neha", "bangalore", 100000);//

-- trigger3
drop table if exists employee_log;//
create table employee_log
(
message varchar(100) not null
);//

delimiter //
drop trigger if exists before_update //
create trigger before_update
before update 
on employee for each row
begin 
    declare error_msg varchar(255);
    declare col varchar(50);
    delete from employee_log;
    set error_msg = ('trying to update');

    if old.eid <> new.eid then
        set col ='eid';

    else if old.ename <> new.ename then
        set col='ename';

    else if old.eaddress <> new.eaddress then
        set col = 'eaddress';

    else if old.emonthlysalary <> new.emonthlysalary then 
        set col = 'emonthlysalary';

    end if;
    end if;
    end if;
    end if;

    insert into employee_log
    values (concat(error_msg,' ',col));
end//

update employee set ename = "john" where eid = "e01";//
select * from employee_log;//

update employee set eid = "e10" where eid = "e01";//
select * from employee_log;//

update employee set emonthlysalary = 0 where eid = "e09";//
select * from employee_log;//

update employee set eaddress = "chennai" where eid = "e03";//
select * from employee_log;//

--- trigger 4
drop table if exists employee_log;//
create table employee_log (
    message varchar(200) not null
    );//

delimiter //
drop trigger if exists before_update;//
drop trigger if exists after_update;//
create trigger after_update
after update 
on employee for each row
    begin
    declare error_msg varchar(255);
    declare col varchar(100);
    declare old_value varchar(100);
    declare new_value varchar(100);

    delete from employee_log;
    set error_msg = ('previous name of');
    
    if old.eid <> new.eid then
        set col = 'eid';
        set old_value = old.eid;
        set new_value = new.eid;

    else if old.ename <> new.ename then
        set col = 'ename';
        set old_value = old.ename;
        set new_value = new.ename;

    else if old.eaddress <> new.eaddress then
        set col = 'eaddress';
        set old_value = old.eaddress;
        set new_value = new.eaddress;

    else if old.emonthlysalary <> new.emonthlysalary then
        set col = 'emonthlysalary';
        set old_value = old.emonthlysalary;
        set new_value = new.emonthlysalary;
    end if;
    end if;
    end if;
    end if;

    insert into employee_log (message) values (concat(error_msg, ' ', col, ' was ', old_value, ' new_value is ', new_value));
    end //

update employee set ename = 'poppy' where eid = 'e10'; //
select * from employee_log; //

update employee set eid = 'e01' where eid = 'e10'; //
select * from employee_log; //

update employee set emonthlysalary = '900' where eid = 'e09'; //
select * from employee_log; //

update employee set eaddress = 'chennai' where eid = 'e06'; //
select * from employee_log; //
    
--- Q5    
drop table if exists final_salary;//
create table final_salary(
    salary float
    );//
insert into final_salary
select sum(emonthlysalary) from employee;//

delimiter //
drop trigger if exists total_salary; //
create trigger total_salary
after delete 
on employee for each row
begin 
    declare old_s float;
    declare new_s float;
    declare msg varchar(200);
    select salary into old_s from final_salary;
    delete from employee_log;
    update final_salary set salary = salary - old.emonthlysalary;
    set new_s = old_s - old.emonthlysalary;

    set msg = concat('Old total salary was ', old_s, ' and after deleting the details of ', old.eid, ' total salary is ', new_s);

    insert into employee_log values (msg);
    end //

delete from employee where eid = 'e01'; //
select * from  employee_log; //

