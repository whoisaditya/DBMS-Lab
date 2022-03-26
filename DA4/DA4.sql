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
        insert into course values(count+1,concat('shop', count));
    set count = count + 2;
    end while;
end$$
call q2();
select * from shop;
	





