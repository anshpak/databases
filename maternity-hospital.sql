drop database if exists hospital;
create database hospital;
use hospital;

create table hospital(
	emp_id int unsigned primary key,
    parent_first_name varchar(20),
	parent_last_name varchar(20),
    childrens_names varchar(50),
    childrens_birthdays varchar(50)
);

insert into hospital
(emp_id, parent_first_name, parent_last_name, childrens_names, childrens_birthdays)
values
(1001, 'Jane', 'Doe', 'Mary, Sam', '1/1/92, 5/15/94'),
(1002, 'John', 'Doe', 'Mary, Sam', '1/1/92, 5/15/94'),
(1003, 'Jane', 'Smith', 'John, Pat, Lee, Mary', '10/5/94, 10/12/90, 6/6/96, 8/21/94'),
(1004, 'John', 'Smith', 'Michael', '7/4/96'),
(1005, 'Jane', 'Jones', 'Edward, Martha', '10/21/95, 10/15/89');

select * from hospital;

# Сначала нужно разобраться с родителями, у них есть нарушение 2НФ.
# Придется создать таблицу для имени, фамилии, а потом и для родителя.
# Создам и заполню по порядку.

#------------------------------------------------------------------------------------------

# Таблица имен.

drop table if exists first_names;
create table first_names(
	first_name_id tinyint unsigned primary key auto_increment,
    first_name varchar(10)
);

insert into first_names
(first_name)
select parent_first_name from hospital;

set sql_safe_updates = 0;

delete from first_names where first_name_id > 2;

select * from first_names;

#------------------------------------------------------------------------------------------

# Таблица фамилий.

drop table if exists last_names;
create table last_names(
	last_name_id tinyint unsigned primary key auto_increment,
    last_name varchar(30)
);

insert into last_names
(last_name)
select parent_last_name from hospital;

delete from last_names where last_name_id in (2, 4);

select * from last_names;

#------------------------------------------------------------------------------------------

# Таблица связи имен и фамилий родителей.

drop table if exists parents;
create table parents(
    first_name_id tinyint unsigned,
    last_name_id tinyint unsigned,
    primary key(first_name_id, last_name_id),
    constraint cn1 foreign key (first_name_id) references first_names(first_name_id),
    constraint cn2 foreign key (last_name_id) references last_names(last_name_id)
);

insert into parents
(first_name_id, last_name_id)
values
(1, 1),
(1, 3),
(1, 5),
(2, 1),
(2, 3);

select * from parents;

#------------------------------------------------------------------------------------------

# Теперь создам отдельную таблицу для имен детей, дней рождений и свяжу их.

drop table if exists children;
create table children(
	child_id tinyint unsigned primary key auto_increment,
    child_name varchar(50)
);

insert into children
(child_name)
select childrens_names from hospital;

delete from children where child_id = 1;

insert into children
(child_name)
select substring_index(child_name, ', ', 1) from children where child_id = 2;

update children
set child_name = substring_index(child_name, ', ', -1) where child_id = 2;

insert into children
(child_name)
select substring_index(child_name, ', ', 1) from children where child_id = 3;

update children
set child_name = substring(child_name, char_length(substring_index(child_name, ', ', 1)) + 3, char_length(child_name)),
child_name = substring(child_name, 1, char_length(child_name) - char_length(substring_index(child_name, ', ', -1)) - 2) where child_id = 3;

insert into children
(child_name)
select substring_index(child_name, ', ', -1) from children where child_id in (3, 5);

update children
set child_name = substring_index(child_name, ', ', 1) where child_id in (3, 5);

select * from children;

#------------------------------------------------------------------------------------------

# Дни рождения

drop table if exists birthdays;
create table birthdays(
	birthday_id tinyint unsigned primary key auto_increment,
    temp_date varchar(50),
    birthday date
);

insert into birthdays
(temp_date)
select childrens_birthdays from hospital;

delete from birthdays where birthday_id = 2;

insert into birthdays
(birthday)
select str_to_date(substring_index(temp_date, ', ', -1), '%m/%d/%y') from birthdays where birthday_id in (1, 3, 5);

update birthdays 
set temp_date = substring_index(temp_date, ', ', 1) where birthday_id in (1, 5);

insert into birthdays
(birthday)
select str_to_date(temp_date, '%m/%d/%y') from birthdays where birthday_id in (1, 4, 5);

insert into birthdays
(birthday)
select str_to_date(substring_index(temp_date, ', ', 1), '%m/%d/%y') from birthdays where birthday_id = 3;

update birthdays
set temp_date = substring(temp_date, char_length(substring_index(temp_date, ', ', 1)) + 3, char_length(temp_date) - char_length(substring_index(temp_date, ', ', 1)) - char_length(substring_index(temp_date, ', ', -1)) - 4) where birthday_id = 3;

insert into birthdays
(birthday)
select str_to_date(substring_index(temp_date, ', ', 1), '%m/%d/%y') from birthdays
where birthday_id = 3;

insert into birthdays
(birthday)
select str_to_date(substring_index(temp_date, ', ', -1), '%m/%d/%y') from birthdays
where birthday_id = 3;

alter table birthdays
drop column temp_date;

delete from birthdays where birthday_id < 8;

select * from birthdays;

#------------------------------------------------------------------------------------------

# Связь детей и дней рождений

drop table if exists child_cards;
create table child_cards(
	child_id tinyint unsigned,
    birthday_id tinyint unsigned,
    primary key(child_id, birthday_id),
    constraint cn3 foreign key (child_id) references children(child_id),
    constraint cn4 foreign key (birthday_id) references birthdays(birthday_id)
);

insert into child_cards
(child_id, birthday_id)
values
(2, 8),
(3, 15),
(4, 12),
(5, 13),
(8, 11),
(8, 9),
(9, 14),
(10, 16),
(11, 10);

select * from child_cards;

# Пробую их соединить.

drop table if exists parent_and_child;
create table parent_and_child(
	first_name_id tinyint unsigned,
    last_name_id tinyint unsigned,
    child_id tinyint unsigned,
    birthday_id tinyint unsigned,
    constraint cn5 foreign key (first_name_id, last_name_id) references parents(first_name_id, last_name_id),
    constraint cn6 foreign key (child_id, birthday_id) references child_cards(child_id, birthday_id)
);

insert into parent_and_child
(first_name_id, last_name_id, child_id, birthday_id)
values
(1, 1, 2, 8),
(1, 1, 8, 9),
(2, 1, 2, 8),
(2, 1, 8, 9),
(1, 3, 9, 14),
(1, 3, 3, 15),
(1, 3, 8, 11),
(1, 3, 10, 16),
(2, 3, 4, 12),
(1, 5, 5, 13),
(1, 5, 11, 10);

select * from parent_and_child;