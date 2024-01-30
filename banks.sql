DROP DATABASE IF EXISTS BankDB;
CREATE DATABASE BankDB;
USE BankDB;

drop table if exists bank;
create table bank(
	bank_id int primary key auto_increment,
	bank_name varchar(30)
);

DROP TABLE IF EXISTS person;
CREATE TABLE person(
	person_id int PRIMARY KEY auto_increment,
    person_name varchar(30),
    person_surname varchar(30),
    person_address varchar(50),
    person_bank int,
    constraint cn1 foreign key (person_bank) references bank(bank_id)
);

DROP TABLE IF EXISTS acc;
CREATE TABLE acc(
	acc_owner int primary key,
	acc_balance double,
    acc_number varchar(50),
    acc_start_date DATETIME,
    constraint cn2 foreign key (acc_owner) references person(person_id)
);

insert into bank
(bank_name)
values
('Приорбанк'),
('Belinvest');

select * from bank;

insert into person
(person_name, person_surname, person_address, person_bank)
values
('Nikita', 'Ghy', 'Oktyabrskaya 7a', 1),
('Evgeniy', 'Oht', 'Karla Marksa 23', 2);

select * from person;

insert into acc
(acc_owner, acc_balance, acc_number, acc_start_date)
values
(1, 1500, '1233-1234-1235-1236', '2023-12-10'),
(2, 900, '3211-3212-3213-3214', '2023-10-20');

drop procedure if exists bank_transfer_from_one_to_second;
delimiter //
create procedure bank_transfer_from_one_to_second(in bank_id1 int, in bank_id2 int)
begin
	declare summ double;
	start transaction;
    select sum(acc.acc_balance) / count(*) into summ from acc
	inner join
	(
		select person_id from person where person.person_bank = 2
	) as res
	on res.person_id = acc.acc_owner;
    update acc
    set acc.acc_balance = acc.acc_balance + summ where acc.acc_owner in 
    (
		select person_id from person where person.person_bank = bank_id1
    );
    commit;
end; //
delimiter ;

call bank_transfer_from_one_to_second(1, 2);

select * from acc;

set sql_safe_updates = 0;

drop procedure if exists trans_on_num;
delimiter //
create procedure trans_on_num(in acc_num1 varchar(50), inout tru_sum double, in currency varchar(20))
begin
	declare check_sum int;
    declare temp_flag boolean;
    start transaction;
    If currency = 'dollar' then
		set tru_sum = tru_sum * 3.6;
        set temp_flag = 1;
	end if;
    If currency = 'euro' then
		set tru_sum = tru_sum * 4;
        set temp_flag = 1;
	else 
		rollback; 
        set temp_flag = 0;
	end if;
    select acc.acc_balance into check_sum from acc where acc.acc_number = acc_num1;
    If check_sum - tru_sum < 0 and temp_flag = 1 then 
		rollback;
    end if;
    if temp_flag = 1 then
		update acc
		set acc.acc_balance = acc_balance + tru_sum where acc.acc_number = acc_num1;
		commit;
    end if;
end //
delimiter ;

set @n = 5;
call trans_on_num('1233-1234-1235-1236', @n, 'eurod');

select * from acc;
