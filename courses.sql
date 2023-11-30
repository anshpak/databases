-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 3.3. Приведите указанную таблицу к 4НФ.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

drop database if exists courses;
create database courses;
use courses;

drop table if exists courses_info;
create table courses_info(
	student_name varchar(1),
    course_name varchar(20),
    guide_name varchar(20)
);

insert into courses_info
(student_name, course_name, guide_name)
values
('А', 'Информатика', 'Информатика'),
('А', 'Сети ЭВМ', 'Информатика'),
('А', 'Информатика', 'Сети ЭВМ'),
('А', 'Сети ЭВМ', 'Сети ЭВМ'),
('В', 'Программирование', 'Программирование'),
('В', 'Программирование', 'Теория Алгоритмов');

select * from courses_info;

drop table if exists guides;
create table guides(
    guide_name varchar(20) primary key
);

insert ignore into guides
(guide_name)
select guide_name from courses_info;

select * from guides;

drop table if exists courses;
create table courses(
	course_name varchar(20),
    primary key (course_name)
);

insert ignore into courses
(course_name)
select guide_name from guides limit 3;

select * from courses;

drop table if exists courses_and_guides;
create table courses_and_guides(
	course_name varchar(20),
    guide_name varchar(20),
    primary key(course_name, guide_name),
    constraint cn1 foreign key (course_name) references courses(course_name),
    constraint cn2 foreign key (guide_name) references guides(guide_name)
);

insert into courses_and_guides
(course_name, guide_name)
select course_name, guide_name from courses_info;

select * from courses_and_guides;

drop table if exists students_and_courses;
create table students_and_courses(
	student_name varchar(1),
    course_name varchar(20),
    primary key (student_name, course_name),
    constraint cn3 foreign key (course_name) references courses(course_name)
);

insert ignore into students_and_courses
(student_name, course_name)
select student_name, course_name from courses_info;

select * from students_and_courses;