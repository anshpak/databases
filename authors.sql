-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 2.1. Приведите указанную таблицу к 1НФ.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

drop database if exists bookshop;
create database bookshop;
use bookshop;

drop table if exists checks;
create table checks(
	first_author_name varchar(50),
    second_author_name varchar(50),
	title_name varchar(40),
    isbn varchar(10),
    price decimal(4, 2),
    customer_name varchar(30),
    customer_address varchar(50),
    purchase_date varchar(20)
);

insert into checks
(first_author_name, second_author_name, title_name, isbn, price, customer_name, customer_address, purchase_date)
values
('David Sklar', 'Adam Trachtenberg', 'PHP CookBook', '0596101015', 44.99, 'Emma Brown', '1565 Rainbow Road, Los Angeles, CA 90014', 'Mar 03 2009'),
('Danny Goodman', '', 'Dynamic HTML', '0596527403', 59.99, 'Darren Ryder', '4758 Emily Drive, Richmond, VA 23219', 'Dec 19 2008'),
('Hugh E. Williams', 'David Lane', 'PHP and MySQL', '0596005436', 44.95, 'Earl B. Thurston', '862 Gregory Lane, Frankfort, KY 40601', 'Jun 22 2009'),
('David Sklar', 'Adam Trachtenberg', 'PHP Cookbook', '0596101015', 44.99, 'Darren Ryder', '4758 Emily Drive, Richmond, VA 23219', 'Dec 19 2008'),
('Rasmus Lerdorf', 'Kevin Tatroe & Peter MacIntyre', 'Programming PHP', '0596006815', 39.99, 'David Miller', '3647 Cedar Lane, Waltham, MA 02154', 'Jan 16 2009');

select * from checks;

# В данной таблице нарушается 2НФ: фамилии авторов зависят от тайтлов, данные о покупателях зависят от купленного товара. 
# Создам три таблицы для общего чека, купленных товаров в чеке и авторов книг.

#-----------------------------------------------------------------------------------

# Поработаю с книгами и авторами. Добавлю еще одну таболицу, которая будет связывать id книги и id ее автора / авторов.

drop table if exists books;
create table books(
	book_id tinyint unsigned primary key auto_increment,
    title_name varchar(50),
    book_price decimal(4, 2),
    isbn varchar(10)
);

drop table if exists authors;
create table authors(
	author_id tinyint unsigned primary key auto_increment,
    author_name varchar(30)
);

#-----------------------------------------------------------------------------------

# Для начала заполню таблицу с авторами.

insert into authors
(author_name) 
select first_author_name from checks;

insert into authors
(author_name) 
select second_author_name from checks;

set sql_safe_updates = 0;

# Приведу записи в порядок.

delete from authors
where author_id in (4, 9, 11);

insert into authors
(author_name)
select substring(substring_index(author_name, '&', -1), 2, char_length(substring_index(author_name, '&', -1))) from authors where author_id = 12;

update authors
set author_name = substring(substring_index(author_name, '&', 1), 1, char_length(substring_index(author_name, '&', 1)) - 1) where author_id = 12;

select * from authors;

#-----------------------------------------------------------------------------------

# Заполню таблицу с книгами.

insert into books
(title_name, isbn, book_price)
select title_name, isbn, price from checks;

# Удалю ненужную дублирующуяся запись.

delete from books
where book_id = 4;

select * from books;

#-----------------------------------------------------------------------------------

# Добавлю таблицу для связи авторов и книг.

drop table if exists books_and_authors;
create table books_and_authors(
	book_id tinyint unsigned,
    author_id tinyint unsigned,
    constraint cn1 foreign key (book_id) references books(book_id),
    constraint cn2 foreign key (author_id) references authors(author_id)
);

insert into books_and_authors
(book_id, author_id)
values
(1, 1),
(1, 8),
(2, 2),
(3, 3),
(3, 10),
(5, 5),
(5, 12),
(5, 15);

select * from books_and_authors;

#-----------------------------------------------------------------------------------

# Удалю лишние столбцы из исходной таблицы.

alter table checks
drop column first_author_name, 
drop column second_author_name, 
drop column title_name, 
drop column isbn, 
drop column price;

# Создам и заполню таблицу, хранящую информацию о покупателях.

drop table if exists customers;
create table customers(
	customer_id tinyint unsigned primary key auto_increment,
    customer_name varchar(30),
	purchase_date date,
    customer_temp_address varchar(50),
    customer_index varchar(50),
    customer_street varchar(50),
    customer_city varchar(30),
    customer_state varchar(2),
    customer_private_number varchar(30)
);

insert into customers
(customer_name, customer_temp_address, purchase_date)
select customer_name, customer_address, str_to_date(purchase_date, '%b %d %Y') from checks;

# Формат %b соответствует трехбуквенному представлению месяца (например, 'Mar' для марта), %d соответствует числу дня, а %Y соответствует четырехзначному году.

delete from customers
where customer_id = 4;

update customers
set customer_index = substring_index(customer_temp_address, ' ', 1),
customer_temp_address = substring(customer_temp_address, char_length(customer_index) + 1, char_length(customer_temp_address)),
customer_street = substring_index(customer_temp_address, ',', 1),
customer_temp_address = substring(customer_temp_address, char_length(substring_index(customer_temp_address, ',', 1)) + 2, char_length(customer_temp_address)),
customer_city = substring_index(customer_temp_address, ',', 1),
customer_temp_address = substring(customer_temp_address, char_length(substring_index(customer_temp_address, ',', 1)) + 3, char_length(customer_temp_address)),
customer_state = substring_index(customer_temp_address, ' ', 1),
customer_private_number = substring_index(customer_temp_address, ' ', -1);

alter table customers
drop column customer_temp_address;

select * from customers;

#-----------------------------------------------------------------------------------

# Создам и заполню таблицу для хранения заказов.

drop table if exists purchases;
create table purchases(
	customer_id tinyint unsigned,
    book_id tinyint unsigned,
    constraint cn3 foreign key (customer_id) references customers(customer_id),
    constraint cn4 foreign key (book_id) references books(book_id)
);

# Костыль, чтобы удалит лишнюю дату.

insert into purchases
(customer_id, book_id)
values
(1, 1),
(2, 2),
(2, 1),
(3, 3),
(5, 5);

select * from purchases;