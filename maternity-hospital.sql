drop database if exists hospital;
create database hospital;
use hospital;

create table hospital(
	emp_id int unsigned primary key,
    parent_first_name varchar(20),
	parent_last_name varchar(20),
    child_name varchar(50),
    child_birthday varchar(50)
);

insert into hospital
(emp_id, parent_first_name, parent_last_name, child_name, child_birthday)
values
(1001, 'Jane', 'Doe', 'Mary, Sam', '1/1/92, 5/15/94'),
(1002, 'John', 'Doe', 'Mary, Sam', '1/1/92, 5/15/94'),
(1003, 'Jane', 'Smith', 'John, Pat, Lee, Mary', '10/5/94, 10/12/90, 6/6/96, 8/21/94'),
(1004, 'John', 'Smith', 'Michael', '7/4/96'),
(1005, 'Jane', 'Jones', 'Edward, Martha', '10/21/95, 10/15/89');

select * from hospital;

#------------------------------------------------------------------------------------------

set sql_safe_updates = 0;

drop table if exists parents;
create table parents(
	parent_id int unsigned,
    first_name varchar(10),
    last_name varchar(10),
    primary key(parent_id)
);

insert into parents
(parent_id, first_name, last_name)
select emp_id, parent_first_name, parent_last_name from hospital;

select * from parents;

drop table if exists children;
create table children(
    child_name varchar(50),
    child_birthday date primary key
);

insert into children
(child_name, child_birthday)
select distinct substring_index(child_name, ', ', -1), str_to_date(substring_index(child_birthday, ', ', -1), '%m/%d/%y') from hospital;

insert ignore into children
(child_name, child_birthday)
select distinct substring_index(child_name, ', ', 1), str_to_date(substring_index(child_birthday, ', ', 1), '%m/%d/%y') from hospital 
where length(child_name) - length(replace(child_name, ',', '')) + 1 >= 2;

insert ignore into children
(child_name, child_birthday)
select distinct substring_index(substring_index(child_name, ', ', 2), ', ', -1), str_to_date(substring_index(substring_index(child_birthday, ', ', 2), ', ', -1), '%m/%d/%y') from hospital
where length(child_name) - length(replace(child_name, ',', '')) + 1 = 4;

insert ignore into children
(child_name, child_birthday)
select distinct substring_index(substring_index(child_name, ', ', -2), ', ', 1), str_to_date(substring_index(substring_index(child_birthday, ', ', -2), ', ', 1), '%m/%d/%y') from hospital
where length(child_name) - length(replace(child_name, ',', '')) + 1 = 4;

select * from children;

#------------------------------------------------------------------------------------------

drop table if exists parent_and_child;
create table parent_and_child(
	parent_id int unsigned,
    child_birthday date,
    primary key(parent_id, child_birthday),
    constraint cn1 foreign key (parent_id) references parents(parent_id),
    constraint cn2 foreign key (child_birthday) references children(child_birthday)
);

insert into parent_and_child
(parent_id, child_birthday)
select distinct emp_id, str_to_date(substring_index(child_birthday, ', ', -1), '%m/%d/%y') from hospital;

insert into parent_and_child
(parent_id, child_birthday)
select distinct emp_id, str_to_date(substring_index(child_birthday, ', ', 1), '%m/%d/%y') from hospital 
where length(child_name) - length(replace(child_name, ',', '')) + 1 >= 2;

insert into parent_and_child
(parent_id, child_birthday)
select distinct emp_id, str_to_date(substring_index(substring_index(child_birthday, ', ', 2), ', ', -1), '%m/%d/%y') from hospital
where length(child_name) - length(replace(child_name, ',', '')) + 1 = 4;

insert into parent_and_child
(parent_id, child_birthday)
select distinct emp_id, str_to_date(substring_index(substring_index(child_birthday, ', ', -2), ', ', 1), '%m/%d/%y') from hospital
where length(child_name) - length(replace(child_name, ',', '')) + 1 = 4;

select * from parent_and_child;