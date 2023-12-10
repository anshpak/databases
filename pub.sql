drop database if exists pub;
create database pub;
use pub;

drop table if exists staff;
create table staff(
	employee_id int primary key auto_increment,
    employee_name varchar(50) not null,
    employee_surname varchar(50) not null,
    employee_position enum('barman', 'cook'),
    employee_birth_date date,
    employee_nickname text default (concat(employee_position, employee_name, employee_surname, employee_birth_date, now())),
    employee_age int default (date_format(from_days(datediff(now(), employee_birth_date)), '%Y') + 0)
);

drop table if exists contracts;
create table contracts (
	contract_start_date date default (CURRENT_DATE()),
    contract_end_date date,
    salary int(11) not null default '0',
    contract_id int auto_increment,
    primary key (contract_id),
    constraint cn1 foreign key (contract_id) references staff(employee_id),
    constraint cont_start_end_const check (contract_start_date <> contract_end_date),
    constraint salary_max_cons check (salary < 10000)
);

drop table if exists sells;
create table sells (
	sell_id int(11) primary key,
    sell_date datetime not null,
    barman_id int(11) not null,
    sell_amount float not null,
    constraint cn2 foreign key (barman_id) references staff(employee_id)
);

drop table if exists products;
create table product (
	product_id int(11) primary key auto_increment,
    product_name varchar(50) not null,
    product_type varchar(30) not null,
    product_price float not null
);

drop table if exists product_sells;
create table product_sells (
	sell_id int(11) not null,
    product_id int(11) not null,
    primary key (sell_id, product_id),
    constraint cn3 foreign key (sell_id) references sells(sell_id),
    constraint cn4 foreign key (product_id) references product(product_id)
);
show tables;
insert into product
(product_name, product_type, product_price) 
values
('"Bonaqua"', 'Вода', '1.5'),
('"Rich" Apple', 'Cок', '3'),
('"India Pale Ale"', 'Эль', '5'),
('"Jp. Chenet"', 'Вино', '25.70'),
('"Бочковая Традиция"', 'Вино', '10.5'),
('"Бела-Кола"', 'Газированный напиток', 2.50),
('"Жигулевское"', 'Пиво', 3.20),
('"Lay''s" Огурцы', 'Закуска', 1.80),
('"Rich" Orange', 'Сок', 4.50),
('"Маргарита"', 'Пицца', 12.00),
('Кофе Латте', 'Кофе', 3.80),
('"Milka"', 'Шоколад', 2.75),
('Куриные крылья BBQ', 'Закуска', 8.50),
('"Российский"', 'Сыр', 5.25),
('"Шардоне"', 'Вино', 15.75);
select * from product;

insert into staff
(employee_name, employee_surname, employee_position, employee_birth_date) 
values
('Ульяна', 'Васильева', 'barman', '2000-12-11'),
('Максим', 'Рыбаков', 'cook', '1997-06-27'),
('Арина', 'Авдеева', 'cook', '2001-09-10'),
('Пантелеев', 'Матвей', 'barman', '1995-02-01'),
('Кожевников', 'Александр', 'cook', '1998-07-18'),
('Иван', 'Иванов', 'cook', '1990-05-15'),
('Петр', 'Петров', 'barman', '1985-08-20'),
('Анна', 'Сидорова', 'cook', '1993-02-10'),
('Мария', 'Козлова', 'barman', '1988-11-25'),
('Алексей', 'Смирнов', 'cook', '1995-04-03'),
('Екатерина', 'Федорова', 'barman', '1987-07-12'),
('Дмитрий', 'Морозов', 'cook', '1992-09-18'),
('Ольга', 'Кузнецова', 'barman', '1989-12-30'),
('Сергей', 'Павлов', 'cook', '1994-06-05'),
('Татьяна', 'Новикова', 'barman', '1991-03-08');
select * from staff;

insert into sells
(sell_id, sell_date, barman_id, sell_amount) 
values
(6, '2023-09-17 00:14:11', 1, 1),
(1, '2023-09-17 00:40:34', 1, 4),
(12, '2023-09-17 01:08:46', 1, 2),
(111, '2023-09-17 02:25:13', 1, 7),
(13, '2023-09-17 03:45:04', 4, 3);
select * from sells;

insert into product_sells
(sell_id, product_id) 
values
(6, 5),
(1, 5),
(12, 1),
(111, 4),
(13, 3);
select * from product_sells;

insert into contracts
(contract_start_date, contract_end_date, salary)
values
('2020-11-05', '2024-11-05', 1000),
('2022-05-19', '2025-05-19', 800),
('2023-09-25', '2025-09-25', 1100),
('2021-12-11', '2025-12-11', 900),
('2020-01-30', '2024-01-30', 1000),
('2019-04-05', '2025-09-30', 900),
('2022-07-01', '2027-12-31', 1500),
('2021-06-15', '2026-07-31', 1000),
('2016-01-01', '2023-12-31', 600),
('2020-05-20', '2025-08-31', 600),
('2023-08-12', '2028-11-15', 800),
('2024-09-25', '2029-10-31', 910),
('2025-10-30', '2030-12-15', 1105),
('2018-03-10', '2024-10-15', 960),
('2017-02-15', '2023-11-30', 700);
select * from product_sells;