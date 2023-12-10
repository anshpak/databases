drop database if exists bookshop;
create database bookshop;
use bookshop;

drop table if exists checks;
create table checks(
	record_id tinyint unsigned primary key auto_increment,
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

#-----------------------------------------------------------------------------------
# Исправлю до 1НФ.

insert into checks
(first_author_name, second_author_name, title_name, isbn, price, customer_name, customer_address, purchase_date)
select first_author_name, second_author_name, title_name, isbn, price, customer_name, customer_address, purchase_date from checks
where second_author_name like '%&%';

set sql_safe_updates = 0;

update checks
set second_author_name = substring_index(second_author_name, '& ', -1) where record_id = 6;

update checks
set second_author_name = substring_index(second_author_name, ' & ', 1);

#-----------------------------------------------------------------------------------

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
select distinct first_author_name from checks;

insert into authors
(author_name) 
select distinct second_author_name from checks where second_author_name != '';

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
    author_id tinyint unsigned,
    author_name varchar(30),
    title_name varchar(50),
    # constraint cn1 foreign key (book_id) references books(book_id),
    constraint cn2 foreign key (author_id) references authors(author_id)
);

insert into books_and_authors
(author_id, author_name)
select distinct author_id, author_name from authors;

update books_and_authors
join checks
on author_name = first_author_name
set books_and_authors.title_name = checks.title_name;

update books_and_authors
join checks
on author_name = second_author_name
set books_and_authors.title_name = checks.title_name;

select * from books_and_authors;