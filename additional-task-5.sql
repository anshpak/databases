drop database if exists test;
create database test;
use test;

drop table if exists students;
create table students(
	student_id tinyint unsigned,
    subject_name varchar(4),
    professor_name varchar(10),
    primary key(student_id, professor_name)
);

insert into students
(student_id, subject_name, professor_name)
values
(101, 'Java', 'P.Java'),
(101, 'C++', 'P.Cpp'),
(102, 'Java', 'P.Java'),
(103, 'C#', 'P.Chash'),
(104, 'Java', 'P.Java');

select * from students;

drop table if exists professors_and_subjects;
create table professors_and_subjects(
	professor_name varchar(10),
    subject_name varchar(5),
    primary key(professor_name)
);

insert ignore into professors_and_subjects
(professor_name, subject_name)
select professor_name, subject_name from students;

select * from professors_and_subjects;

drop table if exists students_and_professors;
create table students_and_professors(
	student_id tinyint unsigned,
    professor_name varchar(10),
    primary key(student_id, professor_name),
    constraint cn1 foreign key (professor_name) references professors_and_subjects(professor_name)
);

insert into students_and_professors
(student_id, professor_name)
select student_id, professor_name from students;

select * from students_and_professors;