drop database if exists students_group;
create database students_group;
use students_group;

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
-- select * from students_info;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1.1. Измените тип, название, порядок следования 3–ёх произвольных столбцов. Обратите внимание на приведение типов в MySQL.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- Сначала меняю тип у двух одинаковых столбцов student_name и student_surname, меняю у обоих, так как держать в таблице две колонки с разными типами char и varchar
-- не рекомендуется.

alter table students_info
modify student_name char(20),
modify student_surname char(20);

-- Теперь меняю тип обратно на varchar и изменяю имена у столбцов. 

alter table students_info
change student_name student_first_name varchar(15),
change student_surname student_last_name varchar(15);

-- Чтобы поставить столбец student_second_name после столбца student_first_name, мне нужно создать новый столбец, скопировать в него данные и удалить старый.  

alter table students_info
add column temp_column varchar(15) after student_first_name;

-- You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.

set sql_safe_updates = 0;

update students_info
set temp_column = student_last_name;

alter table students_info
drop column student_last_name,
rename column temp_column to student_last_name;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Теперь попробую поменять тип у столбца student_subgroup с set на enum.
-- Если в определении enum будет отсутствовать хотя бы одна из строк-значений, заданных в записях, то будет ошибка.

alter table students_info
modify student_subgroup enum('a', 'b', 'c');

-- Перемещу столбец student_sex после столбца student_subgroup.
-- Можно тоже создать новый столбец с лишним текстовым значением, но если убрать уже использующееся в записях, то будет ошибка.

alter table students_info
add column temp_column enum('male', 'female', 'nonbinary') after student_subgroup;

update students_info
set temp_column = student_sex;

alter table students_info
drop column student_sex,
rename column temp_column to student_sex;

-- Хочу переместить столбец has_students_debths после столбца grade_point_average.

alter table students_info
add column temp_column bool after grade_point_average;

update students_info
set temp_column = has_student_debths;

-- Булевский тип интересно приведется к enum: все значения true примут значения первой указанной в типе enum(str1, str2, ...) строки.

alter table students_info
drop column has_student_debths,
change temp_column has_student_debths enum('no', 'yes');

-- А текстовые значения преобразуются обратно в true.
-- Причем нельзя обратиться к переименованному столбцу в рамках одного alter table, так как пока инструкция не выполнена, столбец не считается переименовынным.

alter table students_info
modify has_student_debths bool;

select * from students_info;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1.2. . Добавьте столбец со средним баллом студента и размером стипендии и размером оплаты за учёбу (если таковых не было). Пусть необходимо увеличить все
-- стипендии на 10% и поднять плату за обучение на 15%. Реализуйте необходимый скрипт для обновления данных.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

update students_info
set monthly_scholarship = monthly_scholarship * 1.1,
tution_fee = tution_fee * 1.15;

select * from students_info;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1.3. Реализуйте скрипт для увеличения стипендии на 20% тем студентам, у которых в фамилии больше гласных букв, чем согласных.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- char_length возвращает число символов в строке, в отличие от length, которая символы считает по байтам.

update students_info
set monthly_scholarship = monthly_scholarship * 1.2 where char_length(replace(
replace(
	replace(
		replace(
			replace(
				replace(
					replace(
						replace(
							replace(lower(student_last_name), 'ю', ''), 'и', ''), 'я', ''), 'э', ''), 'о', ''), 'ы', ''), 'е', ''), 'у', ''), 'а', '')) < char_length(student_last_name) - char_length(replace(
replace(
	replace(
		replace(
			replace(
				replace(
					replace(
						replace(
							replace(lower(student_last_name), 'ю', ''), 'и', ''), 'я', ''), 'э', ''), 'о', ''), 'ы', ''), 'е', ''), 'у', ''), 'а', ''));
                            
select * from students_info;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1.3.1. Увеличьте также стипендию на столько процентов каждому студенту, сколько дней осталось до конца текущего года. 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

update students_info
set monthly_scholarship = (100 + datediff('2023-12-31', curdate())) * monthly_scholarship / 100;

select monthly_scholarship from students_info;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1.4. Реализуйте последовательность команд для разделения мальчиков и девочек на 2 разных таблицы.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

drop table if exists students_sex_male_info;
create table students_sex_male_info(
	student_id tinyint unsigned primary key auto_increment,
	student_first_name varchar(15),
    student_last_name varchar(15),
    student_subgroup set('a', 'b'),
    grade_point_average float(4, 2) unsigned,
    has_student_debths bool,
    monthly_scholarship decimal(6, 2),
    tution_fee decimal(7, 2) default 0,
    participation set('Student Council', 'Student Council of Quality of Education', 'Council of Elders', 'BRYU', 'Council of Dormitries') default '',
    student_birth_date date,
    student_home_city varchar(15)
);

insert into students_sex_male_info
(student_first_name, student_last_name, student_subgroup, grade_point_average, has_student_debths, monthly_scholarship, tution_fee, participation, student_birth_date, student_home_city)
select student_first_name, student_last_name, student_subgroup, grade_point_average, has_student_debths, monthly_scholarship, tution_fee, participation, student_birth_date, student_home_city
from students_info where student_sex = 'male';

select * from students_sex_male_info;

drop table if exists students_sex_female_info;
create table students_sex_female_info
(
	student_id tinyint unsigned primary key auto_increment,
	student_first_name varchar(15),
    student_last_name varchar(15),
    student_subgroup set('a', 'b'),
    grade_point_average float(4, 2) unsigned,
    has_student_debths bool,
    monthly_scholarship decimal(6, 2),
    tution_fee decimal(7, 2) default 0,
    participation set('Student Council', 'Student Council of Quality of Education', 'Council of Elders', 'BRYU', 'Council of Dormitries') default '',
    student_birth_date date,
    student_home_city varchar(15)
);

insert into students_sex_female_info
(student_first_name, student_last_name, student_subgroup, grade_point_average, has_student_debths, monthly_scholarship, tution_fee, participation, student_birth_date, student_home_city)
select student_first_name, student_last_name, student_subgroup, grade_point_average, has_student_debths, monthly_scholarship, tution_fee, participation, student_birth_date, student_home_city
from students_info where student_sex = 'female';

select * from students_sex_female_info;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1.6 Добавьте к имени студента приставку в зависимости от места рождения. Например, «Саша» -> «Саша.Бобруйск». Важно! Названия городов хранятся в
-- другой таблице. Используйте оператор обновления с соединением таблиц.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Так как у меня уже есть столбец с городами, отделю его в новую таблицу. После чего уже объединю значение имени и города из двух таблиц.
-- Создаю новую таблицу с городами.

drop table if exists students_home_cities;
create table students_home_cities
(
	city_id tinyint unsigned primary key auto_increment,
    city_name varchar(15),
    constraint cn1 foreign key (city_id) references students_info(student_id)
);

insert into students_home_cities
(city_name)
select student_home_city from students_info;

select * from students_home_cities;

-- Удаляю ненужный столбец с городами из старой таблицы.

alter table students_info
drop column student_home_city;

-- Переименую старый столбец.

alter table students_info
change student_first_name student_nickname varchar(20);

-- Создаю никнейм для таблицы students_info.

update students_info
join students_home_cities on city_id = student_id
set student_nickname = concat(student_nickname, '.', city_name);

select * from students_info;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 1.5.1. Реализуйте оператор обновления, который изменяет некоторую дату на ближайший четверг чётного числа.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

update students_info
set student_birth_date = if(dayofmonth(date_add(curdate(), interval 4 - weekday(curdate()) day)) % 2 = 0, date_add(curdate(), interval 4 - weekday(curdate()) day), 
if(4 - weekday(curdate()) > 0, date_add(curdate(), interval -7 + 4 - weekday(curdate()) day), date_add(curdate(), interval 7 + 4 - weekday(curdate()) day)));

select * from students_info;













