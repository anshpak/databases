drop database if exists students_activities;
create database students_activities;
use students_activities;

drop table if exists students;
create table students(
		student_name varchar(20),
        student_surname varchar(20),
        student_course enum("1", "2", "3", "4"),
        student_subgroup enum("1", "2"),
        student_activity set("sportsfcom", "profcom", "stroycom", "studotryad", "BRSM", "science conference 2023")
);

insert into students
(student_name, student_surname, student_course, student_subgroup, student_activity) 
values
("Ульяна", "Васильева", "1", "1", 'sportsfcom,profcom,stroycom'),
("Максим", "Рыбаков", "3", "1", 'BRSM'),
("Арина", "Авдеева", "2", "2", ''),
("Пантелеев", "Матвей", "4", "2", 'science conference 2023'),
("Кожевников", "Александр", "3", "1", 'profcom,stroycom,studotryad');
select * from students;