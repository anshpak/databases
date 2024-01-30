drop database if exists test;
create database test;
use test;

drop table if exists to_norm_tb;
create table to_norm_tb (
	client_id int, 
	first_name varchar(30), 
	last_name varchar(30), 
	province varchar(30), 
	city varchar(30), 
	postal_code varchar(6)
);

insert into to_norm_tb
(client_id, first_name, last_name, province, city, postal_code)
values
(23, 'Khalid', 'Boulahrouz', 'Noord-Holland', 'Alkmaar', '1825HH'),
(24, 'ZinEndine', 'Zidane', 'Noord-Holland', 'Langedijk', '1834DK'),
(25, 'Ruud', 'van Nistelrooy', 'Noord-Holland', 'Schermer', '1844JJ'),
(19, 'Phillip', 'Cocu', 'Noord-Holland', 'Heilo', '1850WI');

# Нарушена 2НФ.

drop table if exists province;
create table province(
	province_id tinyint unsigned primary key auto_increment,
    province_name varchar(20)
);

insert into province
(province_name)
select distinct province from to_norm_tb;

select * from province;

drop table if exists address;
create table address(
	postal_code varchar(6) primary key,
    city varchar(30),
    province_id tinyint unsigned,
    constraint cn1 foreign key (province_id) references province(province_id)
);

set sql_safe_updates = 0;

insert into address
(postal_code, city)
select postal_code, city from to_norm_tb;

update address
join to_norm_tb
on to_norm_tb.postal_code = address.postal_code
join province 
on to_norm_tb.province = province.province_name
set address.province_id = province.province_id;

drop table if exists human;
create table human(
	client_id int primary key, 
	first_name varchar(30), 
	last_name varchar(30),
    postal_code varchar(6),
    constraint cn2 foreign key (postal_code) references address(postal_code)
);

insert into human
(client_id, first_name, last_name)
select client_id, first_name, last_name from to_norm_tb;

update human
join to_norm_tb
on human.client_id = to_norm_tb.client_id
set human.postal_code = to_norm_tb.postal_code;

select * from human;
select * from address;
