drop database if exists students_group;
create database students_group;
use students_group;

#--------------------------------------------------------------------------
# Поправить четверги.
#--------------------------------------------------------------------------

drop table if exists students_info;
create table students_info(
	student_id tinyint unsigned primary key auto_increment,
	student_name varchar(15),
    student_subgroup set('a', 'b'),
    grade_point_average float(4, 2) unsigned,
    monthly_scholarship decimal(6, 2),
    tution_fee decimal(7, 2) default 0,
    student_sex enum('male', 'female'),
    participation set('Student Council', 'Student Council of Quality of Education', 'Council of Elders', 'BRYU', 'Council of Dormitries') default '',
    student_birth_date date,
    student_surname varchar(15),
    has_student_debths bool,
    student_home_city varchar(15)
);

insert into students_info
(student_name, student_surname, student_subgroup, grade_point_average, monthly_scholarship, tution_fee, student_sex, participation, student_birth_date, has_student_debths, student_home_city)
values
('Михаил', 'Смирнов', 'a', 8.6, 220, default, 'male', default, '2004-06-11', false, 'Minsk'),
('Адам', 'Федоров', 'a', 5.2, 0, 1600, 'male', default, '2003-09-05', true, 'Borysov'),
('Ирина', 'Иванова', 'b', 6.4, 160, default, 'female', 'Student Council,BRYU', '2005-12-17', false, 'Minsk'),
('Роман', 'Черный', 'b', 10, 240, default, 'male', default, '2004-01-26', false, 'Mogilev'),
('Арина', 'Волкова', 'a', 9.3, 0, 1400, 'female', 'Council of Elders', '2005-05-21', false, 'Lida'),
('Артур', 'Кожевников', 'b', 7.7, 180, default, 'male', 'Student Council of Quality of Education,Council of Dormitries,BRYU', '2004-07-31', false, 'Slonim'),
('Игорь', 'Морохов', 'a', 8.4, 220, default, 'male', default, '2004-10-16', false, 'Dzerzinsk');

set sql_safe_updates = 0;

update students_info
set student_birth_date = '2003-01-10';

select * from students_info;

update students_info
set student_birth_date = if(dayofmonth(date_add(student_birth_date, interval 3 - weekday(student_birth_date) day)) % 2 = 0, date_add(student_birth_date, interval 3 - weekday(student_birth_date) day), 
if(3 - weekday(student_birth_date) > 0, date_add(student_birth_date, interval -7 + 3 - weekday(student_birth_date) day), date_add(student_birth_date, interval 7 + 3 - weekday(student_birth_date) day)));

select * from students_info;