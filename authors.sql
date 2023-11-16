-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 2.1. Приведите указанную таблицу к 1НФ.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

drop database if exists orders;
create database orders;
use orders;

drop table if exists check_info;
create table check_info(
	first_author_name varchar(50),
    second_author_name varchar(50),
	title_name varchar(40),
    isbn varchar(10),
    price decimal(4, 2),
    customer_name varchar(30),
    customer_address varchar(50),
    purchase_date varchar(20)
);

insert into check_info
(first_author_name, second_author_name, title_name, isbn, price, customer_name, customer_address, purchase_date)
values
('David Sklar', 'Adam Trachtenberg', 'PHP CookBook', '0596101015', 44.99, 'Emma Brown', '1565 Rainbow Road, Los Angeles, CA 90014', 'Mar 03 2009'),
('Danny Goodman', '', 'Dynamic HTML', '0596527403', 59.99, 'Darren Ryder', '4758 Emily Drive, Richmond, VA 23219', 'Dec 19 2008'),
('Hugh E. Williams', 'David Lane', 'PHP and MySQL', '0596005436', 44.95, 'Earl B. Thurston', '862 Gregory Lane, Frankfort KY 40601', 'Jun 22 2009'),
('David Sklar', 'Adam Trachtenberg', 'PHP Cookbook', '0596101015', 44.99, 'Darren Ryder', '4758 Emily Drive, Richmond, VA 23219', 'Dec 19 2008'),
('Rasmus Lerdorf', 'Kevin Tatroe & Peter MacIntyre', 'Programming PHP', '0596006815', 39.99, 'David Miller', '3647 Cedar Lane Waltham, MA 02154', 'Jan 16 2009');

select * from check_info;

# В данной таблице нарушается 2НФ: фамилии авторов зависят от тайтлов, данные о покупателях зависят от купленного товара. 
# Создам три таблицы для общего чека, купленных товаров в чеке и авторов книг.

drop table if exists customer_info;
create table customer_info(
	order_id tinyint unsigned primary key,
    product_id tinyint unsigned,
    customer_name varchar(30),
    customer_address varchar(50),
    purchase_date varchar(30)
);

drop table if exists product_info;
create table product_info(
	product_id tinyint unsigned primary key auto_increment,
    author_id tinyint unsigned,
    title_name varchar(50),
    isbn varchar(10)
);

drop table if exists authors;
create table authors(
	author_id tinyint unsigned primary key auto_increment,
    title_id tinyint unsigned default 0,
    author_name varchar(30)
);

# Для начала заполню таблицу с авторами.

insert into authors
(author_name) 
select first_author_name from check_info;

insert into authors
(author_name) 
select second_author_name from check_info;

select * from authors;

set sql_safe_updates = 0;

delete from authors
where author_id in (4, 9, 11);

insert into authors
(author_name)
select substring(substring_index(author_name, '&', -1), 2, char_length(substring_index(author_name, '&', -1))) from authors where author_id = 12;

update authors
set author_name = substring(substring_index(author_name, '&', 1), 1, char_length(substring_index(author_name, '&', 1)) - 1) where author_id = 12;

select * from authors;