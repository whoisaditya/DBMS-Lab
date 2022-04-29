create database lab_da_4;
use lab_da_4;

delimiter $$
drop procedure if exists loop_ ;
create procedure loop_()
begin
	declare x int;
	declare str varchar(255);
	set x = 1;
    set str = '';
    loop_label: loop
		if x >= 20 then 
			leave loop_label;
		end if;
	set x = x + 1;
    if( x mod 3) then
		iterate loop_label;
	else
		set str = concat(str,x,',');
	end if;
    end loop;
    select str;
end $$
call loop_();

drop table if exists shop;
create table shop(
    id int primary key,
    Name varchar(255)
);

delimiter $$
drop procedure if exists q2$$
create procedure q2()
begin
    declare count int;
    set count = 1;
    while count <=11 do
        insert into shop values(count+1,concat('shop', count));
    set count = count + 2;
    end while;
end$$
call q2();
select * from shop;
	
drop table if exists shop_name;
create table shop_name(
    Name varchar(255)
);

delimiter $$
drop procedure if exists q5$$
create procedure q5_1()
begin 
insert into shop_name values(@coursename);
end$$

delimiter $$
drop procedure if exists q5_2$$
create procedure q5_2()
begin
declare counter int;
declare maxid int;
set counter = 8;
set maxid = (select max(id) from shop);
set @coursename = '';
while(counter < maxid) do
    set @coursename = (select Name from shop where id = counter);
    call q5_1();
    set counter = counter + 2;
end while;
end$$
call q5_2();
select * from shop_name;




