DROP DATABASE IF EXISTS mmf2020;
CREATE DATABASE mmf2020;
USE mmf2020;

# Нужно ли добавить дату зачисления?
# Добавить проверку id студента?
# Я не узнавал, сколько в реальности часов у того или иного предмета.
# Добавить формирование уникольного id по типу год поступления + код специяльности + ... для каждого студента?
# Подсчет среднего балла ведется автоматически после добавления студента в базу.
# Можно добавить физкультуры, которые будут отличаться только преподавателями.
# Можно добавить иностранные языки, которые будут отличаться только преподавателями.
# Можно ввести условность, что надбавка совершается в конце года, либо переделать таблицу так, чтобы выплаты уже помечались.
# Перерасчет степендии для студентов не первых курсов при добавлении в таблицу.

#-----------------------------------------------------------------------------------
# 1. Реализуйте на своём сервере учебную БД mmf2020 согласно схеме и примерам. Заполните её.
#-----------------------------------------------------------------------------------

DROP TABLE IF EXISTS studs;
CREATE TABLE studs(
	st_id INT PRIMARY KEY AUTO_INCREMENT,
    st_name VARCHAR(30),
    st_surname VARCHAR(30),
    st_speciality ENUM('Mathematics and Computer Science (Web Programming and Internet Technologies)', 
						'Mathematics and Computer Science (Mathematical and Software of Mobile Devices)',
                        'Mathematics and Computer Science (Mathematics)',
                        'Mathematics',
                        'Mechanics and Mathematical Modeling',
                        'Computer Mathematics and Systems Analysis',
                        'Mechanics and Mathematical Modeling (Joint Institute of BSU and DPU)'),
	st_group TINYINT UNSIGNED,
    st_course TINYINT UNSIGNED,
    st_form ENUM('budget', 'paid'),
    st_avg_mark FLOAT DEFAULT NULL,
    st_value DECIMAL(6, 2) DEFAULT NULL
);

DROP TABLE IF EXISTS debths;
CREATE TABLE debths(
    ref_st_id INT,
    exam_debth TINYINT UNSIGNED DEFAULT 0,
    credit_debth TINYINT UNSIGNED DEFAULT 0,
    CONSTRAINT debths_st FOREIGN KEY (ref_st_id) REFERENCES studs(st_id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS retakes;
CREATE TABLE retakes(
	ref_st_id INT,
    disc_id INT,
    disc_debth TINYINT UNSIGNED DEFAULT 0,
    CONSTRAINT retakes_st FOREIGN KEY (ref_st_id) REFERENCES studs(st_id) ON DELETE CASCADE
);

DROP TRIGGER IF EXISTS st_check;
DElIMITER //
CREATE TRIGGER st_check BEFORE INSERT ON studs
FOR EACH ROW 
BEGIN
	CASE NEW.st_form
		WHEN 'budget' THEN 
			SET NEW.st_value = 140;
		WHEN 'paid' THEN 
			SET NEW.st_value = 0;
	END CASE;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS fill_debths;
DELIMITER //
CREATE TRIGGER fill_debths AFTER INSERT ON studs
FOR EACH ROW
BEGIN
	INSERT INTO debths
    (ref_st_id)
    values
    (NEW.st_id);
END; //
DELIMITER ;

INSERT INTO studs 
(st_name, st_surname, st_speciality, st_form, st_group, st_course)
VALUES
('Ivan', 'Petrov', 'Mathematics and Computer Science (Web Programming and Internet Technologies)', 'budget', 6, 1),
('Ekaterina', 'Smirnova', 'Computer Mathematics and Systems Analysis', 'paid', 5, 1),
('Alexey', 'Kuznetsov', 'Mathematics and Computer Science (Web Programming and Internet Technologies)', 'budget', 6, 1),
('Maria', 'Ivanova', 'Mathematics and Computer Science (Web Programming and Internet Technologies)', 'paid', 6, 1),
('Dmitriy', 'Sokolov', 'Mathematics and Computer Science (Web Programming and Internet Technologies)', 'budget', 6, 1),
('Polina', 'Nikitina', 'Mathematics and Computer Science (Web Programming and Internet Technologies)', 'paid', 6, 1),
('Andrey', 'Ivanov', 'Mathematics and Computer Science (Web Programming and Internet Technologies)', 'budget', 6, 1),
('Yulia', 'Smirnova', 'Mathematics and Computer Science (Web Programming and Internet Technologies)', 'paid', 6, 1),
('Sergey', 'Popov', 'Mathematics and Computer Science (Web Programming and Internet Technologies)', 'budget', 6, 1),
('Anastasia', 'Ivanova', 'Mathematics and Computer Science (Web Programming and Internet Technologies)', 'paid', 6, 1),
('Artem', 'Kozlov', 'Mathematics and Computer Science (Web Programming and Internet Technologies)', 'budget', 6, 1),
('Anna', 'Petrova', 'Computer Mathematics and Systems Analysis', 'paid', 5, 1),
('Nikita', 'Ivanov', 'Computer Mathematics and Systems Analysis', 'budget', 5, 1),
('Elena', 'Smirnova', 'Computer Mathematics and Systems Analysis', 'paid', 5, 1),
('Vladimir', 'Sokolov', 'Computer Mathematics and Systems Analysis', 'budget', 5, 1),
('Olga', 'Kuznetsova', 'Computer Mathematics and Systems Analysis', 'paid', 5, 1),
('Igor', 'Ivanov', 'Computer Mathematics and Systems Analysis', 'budget', 5, 1),
('Yana', 'Kozlova', 'Computer Mathematics and Systems Analysis', 'paid', 5, 1),
('Maxim', 'Popov', 'Computer Mathematics and Systems Analysis', 'budget', 5, 1),
('Ekaterina', 'Smirnova', 'Computer Mathematics and Systems Analysis', 'paid', 5, 1),
('Natallia', 'Klimovich', 'Computer Mathematics and Systems Analysis', 'paid', 5, 3),
('Siarhei', 'Kavalchuk', 'Computer Mathematics and Systems Analysis', 'budget', 5, 3),
('Maryna', 'Zhyhailo', 'Computer Mathematics and Systems Analysis', 'paid', 5, 3),
('Viktar', 'Hlebik', 'Computer Mathematics and Systems Analysis', 'budget', 5, 3),
('Darya', 'Lahun', 'Computer Mathematics and Systems Analysis', 'paid', 5, 3),
('Andrei', 'Belski', 'Computer Mathematics and Systems Analysis', 'budget', 5, 3),
('Volha', 'Karaliova', 'Computer Mathematics and Systems Analysis', 'paid', 5, 3),
('Siarhei', 'Hryshchanka', 'Computer Mathematics and Systems Analysis', 'budget', 5, 3),
('Aliaksandr', 'Ivanou', 'Computer Mathematics and Systems Analysis', 'paid', 5, 3),
('Katsiaryna', 'Malashenka', 'Computer Mathematics and Systems Analysis', 'paid', 5, 3);

SELECT * FROM studs;

SELECT * FROM debths;

DELETE FROM studs;

DELETE FROM debths;

DROP TABLE IF EXISTS subjects;
CREATE TABLE subjects(
	sub_id INT PRIMARY KEY AUTO_INCREMENT,
    sub_name VARCHAR(100),
    sub_teacher VARCHAR(40),
    sub_hours INT
);

INSERT INTO subjects
(sub_name, sub_teacher, sub_hours)
VALUES
('Geometry', 'Dmitry Fedorovich Bazylev', 40),
('Programming and computer science methods', 'Nikolay Alekseevich Alensky', 40),
('Mathematical analysis', 'Natalia Vladimirovna Brovka', 60),
('Algebra and number theory', 'Valery Ivanovich Kursov', 40),
('Computer mathematics', 'Natalia Leonidovna Sheglova', 40),
('Introduction to the specialty', 'Alex Ernestovich Malevich', 40),
('Physical Culture', 'Pozniak Nikolay Victorovich', 40),
('Political science', 'Anton Vladimirovich Ivanov', 20),
('History of Belarus (in the third world civilizations)', 'Elena Nikitovna Filchuk', 20),
('Foreign language', 'Elena Yurievna Stolyarova', 40),
('Web programming', 'Artem Dmitrievich Vatican', 20),
('Belarusian language (professional vocabulary)', 'Mary Stepanova Ussika', 20),
('Databases', 'Alex Victorovich Kushnerov', 20),
('Databases', 'Alex Victorovich Kushnerov', 30),
('Differential equations', 'Valery Ivanovich Gromak', 40),
('Applied systems analysis', 'Kirill Georgievich Atrochau', 40),
('Differential geometry and topology', 'Dmitry Fedorovich Bazylev', 40),
('Computer mathematics', 'Olga Leonidovna Lavrova', 40),
('Computer mathematics', 'Larisa Leonidovna Sheglova', 40),
('Military training', 'Skvortsov Evgeniy Afrisov', 20),
('Mathematical foundations of information security', 'Alexey Ivanovich Kuznetsov', 40),
('Theory of functions of a complex variable', 'Elena Valerievna Gromak', 40),
('Neural networks and genetic algorithms', 'Alex Ernestovich Malevich', 40),
('Applied systems analysis. Visual modeling of complex systems using UML', 'Larisa Leonidovna Sheglova', 30),
('Business analisys', 'Kirill Georgievich Atrochau', 40),
('Functional analysis', 'Konstantin Vladimirovich Lykov', 40),
('Equations of mathematical physics', 'Victor Ivanovich Korziuk', 40),
('Discrete mathematics and graph theory', 'Michail Yourievich Metelskiy', 40),
('Mathematical foundations of computer graphics', 'Natalia Leonidovna Sheglova', 40),
('Mathematical programming', 'Olga Leonidovna Lavrova', 40),
('Numerical methods', 'Ekaterina Petrovna Smirnova', 30),
('Neural networks and genetic algorithms', 'Larisa Leonidovna Sheglova', 20),
('Economy and sociology', 'Dmitry Sergeyevich Sokolov', 20),
('Theoretical mechanics', 'Maria Alexandrovna Ivanova', 40),
('Mathematical modeling of dynamic processes', 'Artem Andreevich Kozlov', 20),
('Optimization methods', 'Olga Vladimirovna Kuznetsova', 40),
('Computer algebra', 'Semen Ivanovich Ivanov', 20),
('Information technology', 'Yulia Dmitrievna Smirnova', 40),
('Philosophy', 'Maxim Igorevich Popov', 20),
('Fundamentals of psychology and pedagogy', 'Ekaterina Sergeyevna Smirnova', 40),
('Wavelet analysis', 'Ivan Petrovich Ivanov', 20),
('Operations research', 'Ekaterina Vladimirovna Smirnova', 40),
('Extreme Challenges', 'Alexey Andreevich Kuznetsov', 20),
('Physics', 'Maria Ivanovna Sokolova', 40),
('Human life safety', 'Dmitry Sergeyevich Kozlov', 20);

SELECT * FROM subjects;

DROP TABLE IF EXISTS schedule;
CREATE TABLE schedule(
	class_id TINYINT PRIMARY KEY AUTO_INCREMENT,
	class_time VARCHAR(11)
);

INSERT INTO schedule(
class_time
)
VALUES
('08:15-09:35'),
('09:45-11:05'),
('11:15-12:35'),
('13:00-14:20'),
('14:30-15:50'),
('16:00-17:20'),
('17:40-19:00'),
('19:10-20:30');

DROP TABLE IF EXISTS credits;
CREATE TABLE credits(
	credit_id INT PRIMARY KEY AUTO_INCREMENT,
    ref_sub_id INT,
    ref_st_id INT,
    credit_date DATE,
    ref_credit_class_time TINYINT,
    credit_mark BOOLEAN,
    academic_semester TINYINT UNSIGNED,
    CONSTRAINT credits_st FOREIGN KEY (ref_st_id) REFERENCES studs(st_id) ON DELETE CASCADE,
    CONSTRAINT credits_sub FOREIGN KEY (ref_sub_id) REFERENCES subjects(sub_id),
    CONSTRAINT credits_class FOREIGN KEY (ref_credit_class_time) REFERENCES schedule(class_id)
);

DROP TRIGGER IF EXISTS fill_debths_after_inserting_credits;
DELIMITER //
CREATE TRIGGER fill_debths_after_inserting_credits AFTER INSERT ON credits
FOR EACH ROW
BEGIN
	IF NOT NEW.credit_mark THEN
		UPDATE debths
		SET credit_debth = credit_debth + 1 
        WHERE ref_st_id = NEW.ref_st_id;
	END IF;
END; //
DELIMITER ;

INSERT INTO credits
(ref_sub_id, ref_st_id, credit_date, ref_credit_class_time, credit_mark, academic_semester)
VALUES
(6, 1, '2022-12-18', 1, FALSE, 1),
(7, 1, '2022-12-20', 2, FALSE, 1),
(8, 1, '2022-12-22', 3, TRUE, 1),
(9, 1, '2022-12-26', 1, TRUE, 1),
(10, 1, '2022-12-27', 3, TRUE, 1),
(6, 9, '2022-12-18', 1, TRUE, 1),
(7, 9, '2022-12-20', 2, FALSE, 1),
(8, 9, '2022-12-22', 3, TRUE, 1),
(9, 9, '2022-12-26', 1, TRUE, 1),
(10, 9, '2022-12-27', 3, TRUE, 1),
(6, 14, '2022-12-18', 1, TRUE, 1),
(7, 14, '2022-12-20', 2, TRUE, 1),
(8, 14, '2022-12-22', 3, TRUE, 1),
(9, 14, '2022-12-26', 1, TRUE, 1),
(10, 14, '2022-12-27', 3, TRUE, 1),
(6, 19, '2022-12-18', 1, TRUE, 1),
(7, 19, '2022-12-20', 2, TRUE, 1),
(8, 19, '2022-12-22', 3, TRUE, 1),
(9, 19, '2022-12-26', 1, TRUE, 1),
(10, 19, '2022-12-27', 3, TRUE, 1);

SELECT * FROM credits;

SELECT * FROM debths;

CALL delete_students_after_exams();

CALL set_retakes_afrer_credit_sem();

SELECT * FROM retakes;

INSERT INTO credits
(ref_sub_id, ref_st_id, credit_date, credit_mark, academic_semester)
VALUES
(6, 1, '2023-03-10 12:12:12', FALSE, 1);

DROP PROCEDURE IF EXISTS set_retakes_afrer_credit_sem;
DELIMITER //
CREATE PROCEDURE set_retakes_afrer_credit_sem()
BEGIN
	INSERT INTO retakes
    (ref_st_id, disc_id)
	SELECT res1.ref_st_id, sub_id FROM subjects
    INNER JOIN
    (SELECT ref_st_id, ref_sub_id FROM credits WHERE NOT credit_mark) as res1
    ON subjects.sub_id = res1.ref_sub_id;
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS check_for_retake_credit;
DELIMITER //
CREATE TRIGGER check_for_retake_credit AFTER INSERT ON credits
FOR EACH ROW
BEGIN
	UPDATE retakes
    INNER JOIN credits
    ON NEW.ref_st_id = retakes.ref_st_id AND NEW.ref_sub_id = retakes.disc_id
    SET retakes.disc_debth = disc_debth + 1;
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS check_for_delete;
DELIMITER //
CREATE TRIGGER check_for_delete AFTER UPDATE ON retakes
FOR EACH ROW
BEGIN 
	DELETE studs FROM studs 
    INNER JOIN retakes
    on studs.st_id = retakes.ref_st_id WHERE retakes.disc_debth >= 3;
END; //
DELIMITER ;

#------------------------------------------------------------------------------------------------------------

set sql_safe_updates = 0;

SET GLOBAL log_bin_trust_function_creators = 1;

DROP TABLE IF EXISTS exams;
CREATE TABLE exams(
	exam_id INT PRIMARY KEY AUTO_INCREMENT,
    ref_sub_id INT,
    ref_st_id INT,
    exam_date DATETIME,
    exam_mark INT,
    academic_semester TINYINT UNSIGNED,
    CONSTRAINT exams_st FOREIGN KEY (ref_st_id) REFERENCES studs(st_id) ON DELETE CASCADE,
    CONSTRAINT exams_sub FOREIGN KEY (ref_sub_id) REFERENCES subjects(sub_id)
);

DROP FUNCTION IF EXISTS average_mark;
DELIMITER //
CREATE FUNCTION average_mark(id INT)
RETURNS FLOAT
BEGIN
	DECLARE avg_mark FLOAT;
    SELECT AVG(exam_mark) INTO avg_mark FROM exams
    WHERE ref_st_id = id;
    RETURN avg_mark;
END//
DELIMITER ;

DROP TRIGGER IF EXISTS avg_mark_after_insert_on_exams_trigger;
DELIMITER //
CREATE TRIGGER avg_mark_after_insert_on_exams_trigger
AFTER INSERT ON exams
FOR EACH ROW
BEGIN
	UPDATE studs
    set st_avg_mark = average_mark(NEW.ref_st_id) WHERE st_id = NEW.ref_st_id;
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS fill_debths_after_inserting_exams;
DELIMITER //
CREATE TRIGGER fill_debths_after_inserting_exams AFTER INSERT ON exams
FOR EACH ROW
BEGIN
	IF NEW.exam_mark < 4 THEN
		UPDATE debths
		SET exam_debth = exam_debth + 1 
        WHERE ref_st_id = NEW.ref_st_id;
	END IF;
END; //
DELIMITER ;

INSERT INTO exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, academic_semester)
VALUES
(1, 2, '2023-01-03-09-00', 9, 1),
(2, 2, '2023-01-06-09-00', 2, 1),
(3, 2, '2023-01-12-09-00', 8, 1),
(4, 2, '2023-01-18-09-00', 10, 1),
(5, 2, '2023-01-22-09-00', 7, 1),
(1, 12, '2023-01-03-09-00', 7, 1),
(2, 12, '2023-01-06-09-00', 7, 1),
(3, 12, '2023-01-12-09-00', 10, 1),
(4, 12, '2023-01-18-09-00', 9, 1),
(5, 12, '2023-01-22-09-00', 6, 1),
(1, 13, '2023-01-03-09-00', 9, 1),
(2, 13, '2023-01-06-09-00', 9, 1),
(3, 13, '2023-01-12-09-00', 2, 1),
(4, 13, '2023-01-18-09-00', 4, 1),
(5, 13, '2023-01-22-09-00', 6, 1),
(1, 14, '2023-01-03-09-00', 4, 1),
(2, 14, '2023-01-06-09-00', 5, 1),
(3, 14, '2023-01-12-09-00', 10, 1),
(4, 14, '2023-01-18-09-00', 9, 1),
(5, 14, '2023-01-22-09-00', 10, 1),
(1, 15, '2023-01-03-09-00', 7, 1),
(2, 15, '2023-01-06-09-00', 8, 1),
(3, 15, '2023-01-12-09-00', 6, 1),
(4, 15, '2023-01-18-09-00', 4, 1),
(5, 15, '2023-01-22-09-00', 9, 1),
(1, 16, '2023-01-03-09-00', 8, 1),
(2, 16, '2023-01-06-09-00', 9, 1),
(3, 16, '2023-01-12-09-00', 10, 1),
(4, 16, '2023-01-18-09-00', 7, 1),
(5, 16, '2023-01-22-09-00', 9, 1),
(1, 17, '2023-01-03-09-00', 10, 1),
(2, 17, '2023-01-06-09-00', 7, 1),
(3, 17, '2023-01-12-09-00', 8, 1),
(4, 17, '2023-01-18-09-00', 9, 1),
(5, 17, '2023-01-22-09-00', 5, 1),
(1, 18, '2023-01-03-09-00', 6, 1),
(2, 18, '2023-01-06-09-00', 4, 1),
(3, 18, '2023-01-12-09-00', 3, 1),
(4, 18, '2023-01-18-09-00', 2, 1),
(5, 18, '2023-01-22-09-00', 8, 1),
(1, 19, '2023-01-03-09-00', 9, 1),
(2, 19, '2023-01-06-09-00', 10, 1),
(3, 19, '2023-01-12-09-00', 6, 1),
(4, 19, '2023-01-18-09-00', 9, 1),
(5, 19, '2023-01-22-09-00', 3, 1),
(1, 20, '2023-01-03-09-00', 9, 1),
(2, 20, '2023-01-06-09-00', 8, 1),
(3, 20, '2023-01-12-09-00', 6, 1),
(4, 20, '2023-01-18-09-00', 9, 1),
(5, 20, '2023-01-22-09-00', 6, 1);

INSERT INTO exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, academic_semester)
VALUES
(1, 1, '2023-01-03-09-00', 9, 1),
(2, 1, '2023-01-06-09-00', 2, 1),
(3, 1, '2023-01-12-09-00', 8, 1),
(4, 1, '2023-01-18-09-00', 10, 1),
(5, 1, '2023-01-22-09-00', 7, 1),
(1, 3, '2023-01-03-09-00', 7, 1),
(2, 3, '2023-01-06-09-00', 6, 1),
(3, 3, '2023-01-12-09-00', 5, 1),
(4, 3, '2023-01-18-09-00', 3, 1),
(5, 3, '2023-01-22-09-00', 8, 1),
(1, 4, '2023-01-03-09-00', 7, 1),
(2, 4, '2023-01-06-09-00', 7, 1),
(3, 4, '2023-01-12-09-00', 10, 1),
(4, 4, '2023-01-18-09-00', 9, 1),
(5, 4, '2023-01-22-09-00', 6, 1),
(1, 5, '2023-01-03-09-00', 9, 1),
(2, 5, '2023-01-06-09-00', 9, 1),
(3, 5, '2023-01-12-09-00', 2, 1),
(4, 5, '2023-01-18-09-00', 4, 1),
(5, 5, '2023-01-22-09-00', 6, 1),
(1, 6, '2023-01-03-09-00', 4, 1),
(2, 6, '2023-01-06-09-00', 5, 1),
(3, 6, '2023-01-12-09-00', 10, 1),
(4, 6, '2023-01-18-09-00', 9, 1),
(5, 6, '2023-01-22-09-00', 10, 1),
(1, 7, '2023-01-03-09-00', 7, 1),
(2, 7, '2023-01-06-09-00', 8, 1),
(3, 7, '2023-01-12-09-00', 6, 1),
(4, 7, '2023-01-18-09-00', 4, 1),
(5, 7, '2023-01-22-09-00', 9, 1),
(1, 8, '2023-01-03-09-00', 8, 1),
(2, 8, '2023-01-06-09-00', 9, 1),
(3, 8, '2023-01-12-09-00', 10, 1),
(4, 8, '2023-01-18-09-00', 7, 1),
(5, 8, '2023-01-22-09-00', 9, 1),
(1, 9, '2023-01-03-09-00', 10, 1),
(2, 9, '2023-01-06-09-00', 7, 1),
(3, 9, '2023-01-12-09-00', 8, 1),
(4, 9, '2023-01-18-09-00', 9, 1),
(5, 9, '2023-01-22-09-00', 5, 1),
(1, 10, '2023-01-03-09-00', 6, 1),
(2, 10, '2023-01-06-09-00', 4, 1),
(3, 10, '2023-01-12-09-00', 3, 1),
(4, 10, '2023-01-18-09-00', 2, 1),
(5, 10, '2023-01-22-09-00', 8, 1),
(1, 11, '2023-01-03-09-00', 9, 1),
(2, 11, '2023-01-06-09-00', 10, 1),
(3, 11, '2023-01-12-09-00', 6, 1),
(4, 11, '2023-01-18-09-00', 9, 1),
(5, 11, '2023-01-22-09-00', 3, 1);

INSERT INTO exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, academic_semester)
VALUES
(2, 21, '2023-01-04-09-00', 7, 5),
(10, 21, '2023-01-06-09-00', 4, 5),
(15, 21, '2023-01-12-09-00', 9, 5),
(20, 21, '2023-01-16-09-00', 10, 5),
(24, 21, '2023-01-20-09-00', 7, 5),
(2, 22, '2023-01-04-09-00', 8, 5),
(10, 22, '2023-01-06-09-00', 7, 5),
(15, 22, '2023-01-12-09-00', 9, 5),
(20, 22, '2023-01-16-09-00', 9, 5),
(24, 22, '2023-01-20-09-00', 6, 5),
(2, 23, '2023-01-04-09-00', 8, 5),
(10, 23, '2023-01-06-09-00', 6, 5),
(15, 23, '2023-01-12-09-00', 5, 5),
(20, 23, '2023-01-16-09-00', 7, 5),
(24, 23, '2023-01-20-09-00', 8, 5),
(2, 24, '2023-01-04-09-00', 10, 5),
(10, 24, '2023-01-06-09-00', 5, 5),
(15, 24, '2023-01-12-09-00', 9, 5),
(20, 24, '2023-01-16-09-00', 6, 5),
(24, 24, '2023-01-20-09-00', 10, 5),
(2, 25, '2023-01-04-09-00', 7, 5),
(10, 25, '2023-01-06-09-00', 9, 5),
(15, 25, '2023-01-12-09-00', 6, 5),
(20, 25, '2023-01-16-09-00', 5, 5),
(24, 25, '2023-01-20-09-00', 9, 5),
(2, 26, '2023-01-04-09-00', 10, 5),
(10, 26, '2023-01-06-09-00', 9, 5),
(15, 26, '2023-01-12-09-00', 9, 5),
(20, 26, '2023-01-16-09-00', 7, 5),
(24, 26, '2023-01-20-09-00', 6, 5),
(2, 27, '2023-01-04-09-00', 10, 5),
(10, 27, '2023-01-06-09-00', 7, 5),
(15, 27, '2023-01-12-09-00', 8, 5),
(20, 27, '2023-01-16-09-00', 8, 5),
(24, 27, '2023-01-20-09-00', 7, 5),
(2, 28, '2023-01-04-09-00', 3, 5),
(10, 28, '2023-01-06-09-00', 4, 5),
(15, 28, '2023-01-12-09-00', 9, 5),
(20, 28, '2023-01-16-09-00', 9, 5),
(24, 28, '2023-01-20-09-00', 6, 5),
(2, 29, '2023-01-04-09-00', 7, 5),
(10, 29, '2023-01-06-09-00', 9, 5),
(15, 29, '2023-01-12-09-00', 8, 5),
(20, 29, '2023-01-16-09-00', 9, 5),
(24, 29, '2023-01-20-09-00', 8, 5),
(2, 30, '2023-01-04-09-00', 4, 5),
(10, 30, '2023-01-06-09-00', 8, 5),
(15, 30, '2023-01-12-09-00', 6, 5),
(20, 30, '2023-01-16-09-00', 4, 5),
(24, 30, '2023-01-20-09-00', 6, 5);

INSERT INTO exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, academic_semester)
VALUES
(1, 21, '2023-06-04-09-00', 7, 4),
(2, 21, '2023-06-06-09-00', 4, 4),
(3, 21, '2023-06-12-09-00', 9, 4),
(4, 21, '2023-06-16-09-00', 10, 4),
(5, 21, '2023-06-20-09-00', 7, 4),
(1, 22, '2023-06-04-09-00', 8, 4),
(2, 22, '2023-06-06-09-00', 7, 4),
(3, 22, '2023-06-12-09-00', 9, 4),
(4, 22, '2023-06-16-09-00', 9, 4),
(5, 22, '2023-06-20-09-00', 6, 4),
(1, 23, '2023-06-04-09-00', 8, 4),
(2, 23, '2023-06-06-09-00', 6, 4),
(3, 23, '2023-06-12-09-00', 5, 4),
(4, 23, '2023-06-16-09-00', 7, 4),
(5, 23, '2023-06-20-09-00', 8, 4),
(1, 24, '2023-06-04-09-00', 10, 4),
(2, 24, '2023-06-06-09-00', 5, 4),
(3, 24, '2023-06-12-09-00', 9, 4),
(4, 24, '2023-06-16-09-00', 6, 4),
(5, 24, '2023-06-20-09-00', 10, 4),
(1, 25, '2023-06-04-09-00', 7, 4),
(2, 25, '2023-06-06-09-00', 9, 4),
(3, 25, '2023-06-12-09-00', 6, 4),
(4, 25, '2023-06-16-09-00', 5, 4),
(5, 25, '2023-06-20-09-00', 9, 4),
(1, 26, '2023-06-04-09-00', 10, 4),
(2, 26, '2023-06-06-09-00', 9, 4),
(3, 26, '2023-06-12-09-00', 9, 4),
(4, 26, '2023-06-16-09-00', 7, 4),
(5, 26, '2023-06-20-09-00', 6, 4),
(1, 27, '2023-06-04-09-00', 10, 4),
(2, 27, '2023-06-06-09-00', 7, 4),
(3, 27, '2023-06-12-09-00', 8, 4),
(4, 27, '2023-06-16-09-00', 8, 4),
(5, 27, '2023-06-20-09-00', 7, 4),
(1, 28, '2023-06-04-09-00', 4, 4),
(2, 28, '2023-06-06-09-00', 4, 4),
(3, 28, '2023-06-12-09-00', 9, 4),
(4, 28, '2023-06-16-09-00', 9, 4),
(5, 28, '2023-06-20-09-00', 6, 4),
(1, 29, '2023-06-04-09-00', 7, 4),
(2, 29, '2023-06-06-09-00', 9, 4),
(3, 29, '2023-06-12-09-00', 8, 4),
(4, 29, '2023-06-16-09-00', 9, 4),
(5, 29, '2023-06-20-09-00', 8, 4),
(1, 30, '2023-06-04-09-00', 4, 4),
(2, 30, '2023-06-06-09-00', 8, 4),
(3, 30, '2023-06-12-09-00', 6, 4),
(4, 30, '2023-06-16-09-00', 4, 4),
(5, 30, '2023-06-20-09-00', 6, 4);

INSERT INTO exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, academic_semester)
VALUES
(1, 21, '2023-01-04-09-00', 7, 3),
(3, 21, '2023-01-06-09-00', 4, 3),
(4, 21, '2023-01-12-09-00', 4, 3),
(5, 21, '2023-01-16-09-00', 10, 3),
(15, 21, '2023-01-20-09-00', 7, 3),
(1, 22, '2023-01-04-09-00', 8, 3),
(3, 22, '2023-01-06-09-00', 8, 3),
(4, 22, '2023-01-12-09-00', 9, 3),
(5, 22, '2023-01-16-09-00', 9, 3),
(15, 22, '2023-01-20-09-00', 6, 3),
(1, 23, '2023-01-04-09-00', 9, 3),
(3, 23, '2023-01-06-09-00', 6, 3),
(4, 23, '2023-01-12-09-00', 5, 3),
(5, 23, '2023-01-16-09-00', 7, 3),
(15, 23, '2023-01-20-09-00', 9, 3),
(1, 24, '2023-01-04-09-00', 10, 3),
(3, 24, '2023-01-06-09-00', 5, 3),
(4, 24, '2023-01-12-09-00', 9, 3),
(5, 24, '2023-01-16-09-00', 5, 3),
(15, 24, '2023-01-20-09-00', 10, 3),
(1, 25, '2023-01-04-09-00', 7, 3),
(3, 25, '2023-01-06-09-00', 9, 3),
(4, 25, '2023-01-12-09-00', 6, 3),
(5, 25, '2023-01-16-09-00', 10, 3),
(15, 25, '2023-01-20-09-00', 9, 3),
(1, 26, '2023-01-04-09-00', 10, 3),
(3, 26, '2023-01-06-09-00', 9, 3),
(4, 26, '2023-01-12-09-00', 9, 3),
(5, 26, '2023-01-16-09-00', 6, 3),
(15, 26, '2023-01-20-09-00', 6, 3),
(1, 27, '2023-01-04-09-00', 10, 3),
(3, 27, '2023-01-06-09-00', 7, 3),
(4, 27, '2023-01-12-09-00', 4, 3),
(5, 27, '2023-01-16-09-00', 8, 3),
(15, 27, '2023-01-20-09-00', 7, 3),
(1, 28, '2023-01-04-09-00', 4, 3),
(3, 28, '2023-01-06-09-00', 6, 3),
(4, 28, '2023-01-12-09-00', 9, 3),
(5, 28, '2023-01-16-09-00', 9, 3),
(15, 28, '2023-01-20-09-00', 5, 3),
(1, 29, '2023-01-04-09-00', 7, 3),
(3, 29, '2023-01-06-09-00', 10, 3),
(4, 29, '2023-01-12-09-00', 8, 3),
(5, 29, '2023-01-16-09-00', 9, 3),
(15, 29, '2023-01-20-09-00', 8, 3),
(1, 30, '2023-01-04-09-00', 4, 3),
(3, 30, '2023-01-06-09-00', 7, 3),
(4, 30, '2023-01-12-09-00', 6, 3),
(5, 30, '2023-01-16-09-00', 4, 3),
(15, 30, '2023-01-20-09-00', 6, 3);

INSERT INTO exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, academic_semester)
VALUES
(1, 21, '2022-06-03-09-00', 9, 2),
(2, 21, '2022-06-06-09-00', 8, 2),
(3, 21, '2022-06-12-09-00', 8, 2),
(4, 21, '2022-06-18-09-00', 10, 2),
(5, 21, '2022-06-22-09-00', 7, 2),
(1, 22, '2022-06-03-09-00', 7, 2),
(2, 22, '2022-06-06-09-00', 7, 2),
(3, 22, '2022-06-12-09-00', 10, 2),
(4, 22, '2022-06-18-09-00', 9, 2),
(5, 22, '2022-06-22-09-00', 6, 2),
(1, 23, '2022-06-03-09-00', 9, 2),
(2, 23, '2022-06-06-09-00', 9, 2),
(3, 23, '2022-06-12-09-00', 7, 2),
(4, 23, '2022-06-18-09-00', 4, 2),
(5, 23, '2022-06-22-09-00', 6, 2),
(1, 24, '2022-06-03-09-00', 4, 2),
(2, 24, '2022-06-06-09-00', 5, 2),
(3, 24, '2022-06-12-09-00', 10, 2),
(4, 24, '2022-06-18-09-00', 9, 2),
(5, 24, '2022-06-22-09-00', 10, 2),
(1, 25, '2022-06-03-09-00', 7, 2),
(2, 25, '2022-06-06-09-00', 8, 2),
(3, 25, '2022-06-12-09-00', 6, 2),
(4, 25, '2022-06-18-09-00', 4, 2),
(5, 25, '2022-06-22-09-00', 9, 2),
(1, 26, '2022-06-03-09-00', 8, 2),
(2, 26, '2022-06-06-09-00', 9, 2),
(3, 26, '2022-06-12-09-00', 10, 2),
(4, 26, '2022-06-18-09-00', 7, 2),
(5, 26, '2022-06-22-09-00', 9, 2),
(1, 27, '2022-06-03-09-00', 10, 2),
(2, 27, '2022-06-06-09-00', 7, 2),
(3, 27, '2022-06-12-09-00', 8, 2),
(4, 27, '2022-06-18-09-00', 9, 2),
(5, 27, '2022-06-22-09-00', 5, 2),
(1, 28, '2022-06-03-09-00', 6, 2),
(2, 28, '2022-06-06-09-00', 4, 2),
(3, 28, '2022-06-12-09-00', 8, 2),
(4, 28, '2022-06-18-09-00', 6, 2),
(5, 28, '2022-06-22-09-00', 8, 2),
(1, 29, '2022-06-03-09-00', 9, 2),
(2, 29, '2022-06-06-09-00', 10, 2),
(3, 29, '2022-06-12-09-00', 6, 2),
(4, 29, '2022-06-18-09-00', 9, 2),
(5, 29, '2022-06-22-09-00', 7, 2),
(1, 30, '2022-06-03-09-00', 9, 2),
(2, 30, '2022-06-06-09-00', 8, 2),
(3, 30, '2022-06-12-09-00', 6, 2),
(4, 30, '2022-06-18-09-00', 9, 2),
(5, 30, '2022-06-22-09-00', 6, 2);

INSERT INTO exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, academic_semester)
VALUES
(1, 21, '2021-01-03-09-00', 8, 1),
(2, 21, '2021-01-06-09-00', 10, 1),
(3, 21, '2021-01-12-09-00', 8, 1),
(4, 21, '2021-01-18-09-00', 10, 1),
(5, 21, '2021-01-22-09-00', 4, 1),
(1, 22, '2021-01-03-09-00', 7, 1),
(2, 22, '2021-01-06-09-00', 7, 1),
(3, 22, '2021-01-12-09-00', 10, 1),
(4, 22, '2021-01-18-09-00', 9, 1),
(5, 22, '2021-01-22-09-00', 7, 1),
(1, 23, '2021-01-03-09-00', 9, 1),
(2, 23, '2021-01-06-09-00', 9, 1),
(3, 23, '2021-01-12-09-00', 8, 1),
(4, 23, '2021-01-18-09-00', 4, 1),
(5, 23, '2021-01-22-09-00', 6, 1),
(1, 24, '2021-01-03-09-00', 4, 1),
(2, 24, '2021-01-06-09-00', 6, 1),
(3, 24, '2021-01-12-09-00', 10, 1),
(4, 24, '2021-01-18-09-00', 9, 1),
(5, 24, '2021-01-22-09-00', 10, 1),
(1, 25, '2021-01-03-09-00', 8, 1),
(2, 25, '2021-01-06-09-00', 8, 1),
(3, 25, '2021-01-12-09-00', 9, 1),
(4, 25, '2021-01-18-09-00', 4, 1),
(5, 25, '2021-01-22-09-00', 6, 1),
(1, 26, '2021-01-03-09-00', 8, 1),
(2, 26, '2021-01-06-09-00', 10, 1),
(3, 26, '2021-01-12-09-00', 10, 1),
(4, 26, '2021-01-18-09-00', 7, 1),
(5, 26, '2021-01-22-09-00', 9, 1),
(1, 27, '2021-01-03-09-00', 10, 1),
(2, 27, '2021-01-06-09-00', 7, 1),
(3, 27, '2021-01-12-09-00', 6, 1),
(4, 27, '2021-01-18-09-00', 9, 1),
(5, 27, '2021-01-22-09-00', 5, 1),
(1, 28, '2021-01-03-09-00', 6, 1),
(2, 28, '2021-01-06-09-00', 4, 1),
(3, 28, '2021-01-12-09-00', 7, 1),
(4, 28, '2021-01-18-09-00', 6, 1),
(5, 28, '2021-01-22-09-00', 8, 1),
(1, 29, '2021-01-03-09-00', 9, 1),
(2, 29, '2021-01-06-09-00', 10, 1),
(3, 29, '2021-01-12-09-00', 6, 1),
(4, 29, '2021-01-18-09-00', 8, 1),
(5, 29, '2021-01-22-09-00', 5, 1),
(1, 30, '2021-01-03-09-00', 9, 1),
(2, 30, '2021-01-06-09-00', 8, 1),
(3, 30, '2021-01-12-09-00', 6, 1),
(4, 30, '2021-01-18-09-00', 9, 1),
(5, 30, '2021-01-22-09-00', 6, 1);

SELECT * FROM studs;

SELECT * FROM exams;

SELECT * FROM debths;

CALL delete_students_after_exams();

CALL set_retakes_afrer_sem();

SELECT * FROM retakes;

INSERT INTO exams
(ref_sub_id, ref_st_id, exam_date, exam_mark, academic_semester)
VALUES
(2, 1, '2023-03-10 12:12:12', 2, 1);

#-----------------------------------------------------------

DROP PROCEDURE IF EXISTS delete_student;
DELIMITER //
CREATE PROCEDURE delete_student(id INT)
BEGIN
	DELETE FROM studs WHERE studs.st_id = id;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS delete_students_after_exams;
DELIMITER //
CREATE PROCEDURE delete_students_after_exams()
BEGIN
	DELETE studs FROM studs 
    INNER JOIN debths
    on studs.st_id = debths.ref_st_id WHERE debths.exam_debth >= 3 OR debths.credit_debth >= 3;
END; //
DELIMITER ;

DROP PROCEDURE IF EXISTS set_retakes_afrer_sem;
DELIMITER //
CREATE PROCEDURE set_retakes_afrer_sem()
BEGIN
	INSERT INTO retakes
    (ref_st_id, disc_id)
	SELECT res1.ref_st_id, sub_id FROM subjects
    INNER JOIN
    (SELECT ref_st_id, ref_sub_id FROM exams WHERE exam_mark < 4) as res1
    ON subjects.sub_id = res1.ref_sub_id;
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS check_for_retake;
DELIMITER //
CREATE TRIGGER check_for_retake AFTER INSERT ON exams
FOR EACH ROW
BEGIN
	UPDATE retakes
    INNER JOIN exams
    ON NEW.ref_st_id = retakes.ref_st_id AND NEW.ref_sub_id = retakes.disc_id
    SET retakes.disc_debth = disc_debth + 1;
END; //
DELIMITER ;

DROP TRIGGER IF EXISTS check_for_delete;
DELIMITER //
CREATE TRIGGER check_for_delete AFTER UPDATE ON retakes
FOR EACH ROW
BEGIN 
	DELETE studs FROM studs 
    INNER JOIN retakes
    on studs.st_id = retakes.ref_st_id WHERE retakes.disc_debth >= 3;
END; //
DELIMITER ;

#-----------------------------------------------------------

# Может не пригодится.

DELIMITER //
CREATE PROCEDURE give_studs()
BEGIN
	SELECT * FROM studs;
END//
DELIMITER ;

CALL give_studs;

DELIMITER //
CREATE PROCEDURE give_studs_by_course(IN course INT)
BEGIN
	SELECT * FROM studs
	WHERE st_course = course;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE studs_quant(OUT res INT)
BEGIN
	SELECT COUNT(*) INTO res FROM subjects;
END//
DELIMITER ;

CALL studs_quant(@xx);

SELECT @xx;

SET @fails = 0;

DELIMITER //
CREATE TRIGGER fail_count AFTER INSERT ON exams
FOR EACH ROW
BEGIN
	IF NEW.exam_mark < 4 THEN
		SET @fails = @fails + 1;
	END IF;
END//
DELIMITER ;

DElIMITER //
CREATE TRIGGER sub_check BEFORE INSERT ON subjects
FOR EACH ROW 
BEGIN
	IF NEW.sub_name = 'Databases' THEN
		signal SQLSTATE '45000';
	END IF;
END//
DELIMITER ;

#-----------------------------------------------------------------------------------
# 2.1. Хранение информации о всех оценках студента в семестре.
#-----------------------------------------------------------------------------------

# Пока что просто добавил столбец academic_semester в таблицу exams, если речь идет об оценках за экзамены.

#-----------------------------------------------------------------------------------
# 2.2. Хранение информации о посещаемости студента на каждом занятии.
#-----------------------------------------------------------------------------------

DROP TABLE IF EXISTS attendance;
CREATE TABLE attendance(
	attendance_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	ref_sub_id INT,
    ref_st_id INT,
    study_day DATE,
    ref_class_id TINYINT,
    is_present BOOLEAN,
    CONSTRAINT attendance_st_cn FOREIGN KEY (ref_st_id) REFERENCES studs(st_id) ON DELETE CASCADE,
    CONSTRAINT attendance_sub_cn FOREIGN KEY (ref_sub_id) REFERENCES subjects(sub_id),
    CONSTRAINT attendance_class_cn FOREIGN KEY (ref_class_id) REFERENCES schedule(class_id)
);

INSERT INTO attendance
(ref_sub_id, ref_st_id, study_day, ref_class_id, is_present)
VALUES
(1, 1, '2023-02-01', 3, 1),
(2, 2, '2023-03-15', 7, 0),
(3, 3, '2023-05-10', 2, 1),
(4, 4, '2023-04-22', 6, 0),
(5, 5, '2023-01-30', 1, 1),
(6, 6, '2023-06-18', 4, 1),
(7, 7, '2023-03-05', 8, 0),
(8, 8, '2023-02-14', 5, 1),
(9, 9, '2023-04-28', 3, 0),
(10, 10, '2023-05-25', 7, 1),
(11, 11, '2023-06-08', 2, 0),
(12, 12, '2023-03-12', 6, 1),
(13, 13, '2023-04-18', 1, 0),
(14, 14, '2023-01-15', 4, 1),
(15, 15, '2023-05-01', 8, 0),
(16, 16, '2023-02-28', 5, 1),
(17, 17, '2023-04-10', 3, 0),
(18, 18, '2023-06-25', 7, 1),
(19, 19, '2023-05-12', 2, 0),
(20, 20, '2023-03-20', 6, 1),
(21, 21, '2023-06-05', 1, 0),
(22, 22, '2023-02-20', 4, 1),
(23, 23, '2023-04-01', 8, 0),
(24, 24, '2023-07-15', 5, 1),
(25, 25, '2023-03-28', 3, 0),
(26, 26, '2023-05-17', 7, 1),
(27, 27, '2023-02-10', 2, 0),
(28, 28, '2023-04-22', 6, 1),
(29, 29, '2023-01-05', 1, 0),
(30, 30, '2023-06-12', 4, 1),
(31, 1, '2023-03-18', 8, 0),
(32, 2, '2023-04-08', 5, 1),
(33, 3, '2023-02-28', 3, 0),
(34, 4, '2023-05-15', 7, 1),
(35, 5, '2023-06-01', 2, 0),
(36, 6, '2023-04-18', 6, 1),
(37, 7, '2023-03-10', 1, 0),
(38, 8, '2023-05-20', 4, 1),
(39, 9, '2023-02-12', 8, 0),
(40, 10, '2023-04-28', 5, 1),
(41, 11, '2023-01-30', 3, 0),
(42, 12, '2023-06-15', 7, 1),
(43, 13, '2023-05-10', 2, 0),
(44, 14, '2023-03-25', 6, 1),
(35, 15, '2023-02-18', 1, 0),
(36, 16, '2023-04-05', 5, 1),
(37, 17, '2023-06-22', 3, 0),
(38, 18, '2023-05-08', 7, 1),
(39, 19, '2023-03-15', 2, 0),
(30, 20, '2023-01-25', 6, 1),
(31, 21, '2023-05-05', 1, 0),
(32, 22, '2023-02-28', 4, 1),
(23, 23, '2023-04-12', 8, 0),
(24, 24, '2023-06-18', 5, 1),
(25, 25, '2023-03-05', 3, 0),
(26, 26, '2023-05-30', 7, 1),
(27, 27, '2023-04-10', 2, 0),
(28, 28, '2023-02-14', 6, 1),
(29, 29, '2023-05-25', 1, 0),
(20, 30, '2023-06-08', 5, 1),
(21, 1, '2023-03-12', 8, 0),
(22, 2, '2023-04-18', 4, 1),
(23, 3, '2023-01-15', 6, 0),
(14, 4, '2023-05-01', 2, 1),
(15, 5, '2023-02-28', 7, 0),
(16, 6, '2023-04-10', 3, 1),
(17, 7, '2023-06-25', 5, 1),
(18, 8, '2023-03-28', 1, 0),
(19, 9, '2023-05-17', 6, 1),
(10, 10, '2023-02-10', 8, 0),
(11, 11, '2023-04-22', 4, 1),
(12, 12, '2023-01-05', 7, 1),
(13, 13, '2023-06-12', 2, 0),
(14, 14, '2023-03-18', 6, 1);

#-----------------------------------------------------------------------------------
# 2.3. Хранение информации об общественной нагрузке и активности студента.
#-----------------------------------------------------------------------------------

DROP TABLE IF EXISTS social_activity;
CREATE TABLE social_activity(
	event_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	ref_st_id INT,
	event_name VARCHAR(50),
	event_date DATE,
	CONSTRAINT event_st_cn FOREIGN KEY (ref_st_id) REFERENCES studs(st_id) ON DELETE CASCADE
);

 INSERT INTO social_activity
 (ref_st_id, event_name, event_date)
 values
 (2, 'National univercity day', '2023-03-11'),
 (2, 'STUD spring', '2023-04-18'),
 (9, 'Musical fest', '2023-05-12'),
 (9, 'Gastro fest', '2023-06-11'),
 (9, 'Blood donor', '2023-06-22'),
 (1, 'Spring Festival', '2023-04-05'),
(2, 'Cultural Night', '2023-02-15'),
(3, 'Health Awareness Campaign', '2023-05-20'),
(4, 'Literary Expo', '2023-03-08'),
(5, 'International Food Fair', '2023-06-30'),
(6, 'Fitness Challenge', '2023-04-10'),
(7, 'Environmental Cleanup', '2023-05-01'),
(8, 'Tech Expo', '2023-03-25'),
(9, 'Community Outreach Program', '2023-06-15'),
(10, 'Art Exhibition', '2023-02-28'),
(11, 'Science Fair', '2023-05-08'),
(12, 'Dance Competition', '2023-04-12'),
(13, 'Film Festival', '2023-03-18'),
(14, 'Career Workshop', '2023-06-25'),
(15, 'Fashion Show', '2023-05-05'),
(16, 'Global Hackathon', '2023-04-22'),
(17, 'Chess Tournament', '2023-03-12'),
(18, 'Volunteer Day', '2023-06-01'),
(19, 'International Friendship Day', '2023-07-30'),
(20, 'Drama Night', '2023-02-20'),
(21, 'Eco-friendly Fair', '2023-05-17'),
(22, 'Photography Contest', '2023-04-02'),
(23, 'Debate Competition', '2023-03-15'),
(24, 'Music Jam', '2023-06-08'),
(25, 'Culinary Workshop', '2023-05-10'),
(26, 'Book Fair', '2023-04-28'),
(27, 'Coding Challenge', '2023-03-05'),
(28, 'Wellness Retreat', '2023-07-10'),
(29, 'Youth Leadership Summit', '2023-06-18'),
(30, 'Summer Carnival', '2023-08-05'),
(1, 'Independence Day Celebration', '2023-07-04'),
(2, 'National Science Day', '2023-02-28'),
(3, 'Yoga and Meditation Session', '2023-04-15'),
(4, 'Winter Wonderland', '2023-01-15'),
(5, 'Earth Day Cleanup', '2023-04-22'),
(6, 'Tech Talk Symposium', '2023-03-10'),
(7, 'International Women\'s Day Event', '2023-03-08'),
(8, 'Carnival Parade', '2023-07-15'),
(9, 'Leadership Development Workshop', '2023-05-30'),
(10, 'Multicultural Fair', '2023-06-12'),
(11, 'Sports Day', '2023-05-02'),
(12, 'Startup Showcase', '2023-04-08'),
(13, 'Summer Music Festival', '2023-07-20'),
(14, 'Health and Fitness Expo', '2023-06-05'),
(15, 'International Student Day', '2023-11-17'),
(16, 'Community Garden Planting', '2023-04-01'),
(17, 'Robotics Expo', '2023-03-20'),
(18, 'Global Awareness Symposium', '2023-05-18'),
(19, 'World Food Day Celebration', '2023-10-16'),
(20, 'Artistic Showcase', '2023-07-25'),
(21, 'Midsummer Night\'s Dream Party', '2023-06-24'),
(22, 'Digital Marketing Seminar', '2023-03-28'),
(23, 'Cultural Diversity Day', '2023-05-21'),
(24, 'Language Exchange Fair', '2023-08-08'),
(25, 'Entrepreneurship Summit', '2023-05-14'),
(26, 'Film Screening and Discussion', '2023-04-18'),
(27, 'Global Health Symposium', '2023-09-12'),
(28, 'Mindfulness and Stress Relief Workshop', '2023-06-28'),
(29, 'Diversity and Inclusion Conference', '2023-05-07'),
(30, 'Winter Sports Challenge', '2023-01-30'),
(1, 'International Peace Day Event', '2023-09-21'),
(2, 'Music Therapy Session', '2023-08-01'),
(3, 'Entrepreneurial Bootcamp', '2023-07-08'),
(4, 'Winter Charity Drive', '2023-12-01'),
(5, 'Science and Technology Expo', '2023-08-15'),
(6, 'Holiday Bazaar', '2023-12-20'),
(7, 'Global Fashion Week', '2023-09-28'),
(8, 'Language and Culture Exchange', '2023-07-31'),
(9, 'International Volunteer Day', '2023-12-05'),
(10, 'Space Exploration Symposium', '2023-08-25'),
(11, 'International Education Fair', '2023-07-22'),
(12, 'Winter Ball', '2023-12-12'),
(13, 'Innovation Challenge', '2023-08-10');

SELECT * FROM social_activity;

#-----------------------------------------------------------------------------------
# 2.4. Хранение информации об оплате за обучение для платников, с возможностью рассрочки.
#-----------------------------------------------------------------------------------

DROP TABLE IF EXISTS individual_plan;
CREATE TABLE individual_plan(
	ref_st_id INT,
	month_name ENUM ('SEPTEMBER', 'OKTOBER', 'NOVEMBER', 'DECEMBER', 'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST'),
	payment_per_three_months DECIMAL(4) DEFAULT 3500
);

DROP TABLE IF EXISTS payment_info;
CREATE TABLE payment_info(
	ref_st_id INT,
	remaining_sum DECIMAL(5,2) DEFAULT 14000,
	ref_individual_payment_plan_id INT,
	CONSTRAINT payment_st_cn FOREIGN KEY (ref_st_id) REFERENCES studs(st_id),
	CONSTRAINT payment_individual_plan FOREIGN KEY (ref_individual_payment_plan_id) REFERENCES individual_plan(plan_id)
);

#-----------------------------------------------------------------------------------
# 2.4. Хранение информации о здоровье студента.
#-----------------------------------------------------------------------------------

DROP TABLE IF EXISTS health_info;
CREATE TABLE health_info(
	ref_st_id INT,
	st_clinic_num TINYINT UNSIGNED,
	st_last_medical_examination_date DATE,
    st_health_type ENUM('Main group', 'Special medical group', 'Therapeutic-optional group'),
	CONSTRAINT health_st_cn FOREIGN KEY (ref_st_id) REFERENCES studs(st_id) ON DELETE CASCADE
);

#-----------------------------------------------------------------------------------
# 4.1. Процедура для повышения всех стипендий на некоторое количество процентов.
#-----------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS up_all_st_values;
DELIMITER //
CREATE PROCEDURE up_all_st_values(percent INT)
BEGIN
	UPDATE studs
    SET studs.st_value = studs.st_value + (studs.st_value * percent) / 100;
END; //
DELIMITER ;

SELECT * from studs;

CALL up_all_st_values(20);

#-----------------------------------------------------------------------------------
# 4.2. Функция, вычисляющая среднюю оценку на экзамене у определённого преподавателя.
#-----------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS get_avg_by_teacher_name;
DELIMITER //
CREATE FUNCTION get_avg_by_teacher_name(name VARCHAR(40))
RETURNS FLOAT
BEGIN
	DECLARE avg FLOAT;
    SELECT AVG(exam_mark) INTO avg FROM exams
    INNER JOIN subjects ON
    exams.ref_sub_id = subjects.sub_id WHERE subjects.sub_teacher = name;
    RETURN avg;
END; //
DELIMITER ;

SELECT get_avg_by_teacher_name('Natalia Leonidovna Sheglova');

#-----------------------------------------------------------------------------------
# 4.3 Процедура для начисления надбавок общественно активным студентам. Критерий начисления 
# надбавок, должен быть привязан к некоторому числовому параметру.
#-----------------------------------------------------------------------------------

# За каждое третье мероприятие в этом году на 0.5 копеек.

SELECT * FROM studs;

DROP PROCEDURE IF EXISTS add_money_for_activists;
DELIMITER //
CREATE PROCEDURE add_money_for_activists()
BEGIN
	UPDATE studs
    join
	(SELECT ref_st_id, COUNT(event_id) / 3 = ROUND(COUNT(event_id) / 3) proof, COUNT(event_id) / 3 as coef
	FROM social_activity WHERE event_date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND CONCAT(YEAR(NOW()), '-12-31')
	GROUP BY ref_st_id) as res1
    on studs.st_id = res1.ref_st_id
    set studs.st_value = studs.st_value + res1.coef * 0.5 WHERE res1.proof = 1;
END//
DELIMITER ;

CALL add_money_for_activists();

#-----------------------------------------------------------------------------------
# 4.4 Процедуры для вывода топ-5 самых успешных студентов факультета, топ-5 «двоечников»,
# топ-5 самых активных. Результаты курсором записать в новые таблицы.
#-----------------------------------------------------------------------------------

DROP TABLE IF EXISTS res_top;
CREATE TABLE res_top
(
res_id INT,
res_name VARCHAR(30),
res_surname VARCHAR(30)
);

DROP PROCEDURE IF EXISTS cursor_top;
DELIMITER //
CREATE PROCEDURE cursor_top()
BEGIN
	DECLARE id1, id2, id3 INT;
    DECLARE name1, name2, name3, surname1, surname2, surname3 VARCHAR(30);
    DECLARE is_end1, is_end2, is_end3 INT DEFAULT 0;
    
	DECLARE studs_cur1 CURSOR FOR SELECT res1.st_id, res1.st_name, res1.st_surname FROM 
    (
		SELECT studs.st_id, studs.st_name, studs.st_surname FROM studs
        INNER JOIN 
		(SELECT studs.st_id, studs.st_avg_mark from studs ORDER BY studs.st_avg_mark DESC LIMIT 5) as res
        ON res.st_id = studs.st_id
    ) as res1;
    
    DECLARE studs_cur2 CURSOR FOR SELECT res2.st_id, res2.st_name, res2.st_surname FROM 
    (
		SELECT studs.st_id, studs.st_name, studs.st_surname FROM studs
        INNER JOIN
		(SELECT studs.st_id, studs.st_avg_mark from studs ORDER BY studs.st_avg_mark ASC LIMIT 5) as res
        ON res.st_id = studs.st_id
    ) as res2;
    
    DECLARE studs_cur3 CURSOR FOR SELECT res3.st_id, res3.st_name, res3.st_surname FROM
    (
		SELECT studs.st_id, studs.st_name, studs.st_surname FROM studs
		INNER JOIN
		(
			SELECT ref_st_id, COUNT(event_id) AS coef
			FROM social_activity WHERE event_date BETWEEN DATE_FORMAT(NOW(), '%Y-01-01') AND CONCAT(YEAR(NOW()), '-12-31')
			GROUP BY ref_st_id ORDER BY coef DESC LIMIT 5
		) as res1
		ON res1.ref_st_id = studs.st_id
    ) as res3;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_end1 = 1, is_end2 = 1, is_end3 = 1;
    
    OPEN studs_cur1;
    curs1: LOOP
        FETCH studs_cur1 INTO id1, name1, surname1;
        IF is_end1 THEN
            LEAVE curs1;
        END IF;
        INSERT INTO res_top VALUES (id1, name1, surname1);
    END LOOP curs1;
    CLOSE studs_cur1;

    SET is_end2 = 0;

    OPEN studs_cur2;
    curs2: LOOP
        FETCH studs_cur2 INTO id2, name2, surname2;
        IF is_end2 THEN
            LEAVE curs2;
        END IF;
        INSERT INTO res_top VALUES (id2, name2, surname2);
    END LOOP curs2;
    CLOSE studs_cur2;
    
    SET is_end3 = 0;
    
    OPEN studs_cur3;
    curs3: LOOP
        FETCH studs_cur3 INTO id3, name3, surname3;
        IF is_end3 THEN
            LEAVE curs3;
        END IF;
        INSERT INTO res_top VALUES (id3, name3, surname3);
    END LOOP curs3;
    CLOSE studs_cur3;
END//
DELIMITER ;

CALL cursor_top();

SELECT * FROM res_top;

#-----------------------------------------------------------------------------------
# 4.5. Процедура для отчисления проблемных студентов. Подумайте о проверке условий отчисления. 
#-----------------------------------------------------------------------------------

# Так есть уже такая.

#-----------------------------------------------------------------------------------
# 4.6. Функция вычисляющую самую популярную оценку на факультете (в группе). 
#-----------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS get_pop_mark;
DELIMITER //
CREATE FUNCTION get_pop_mark()
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE res INT;
    SELECT exam_mark INTO res FROM 
    (SELECT exam_mark, COUNT(exam_mark) AS coeff FROM exams GROUP BY exam_mark ORDER BY coeff DESC LIMIT 1) AS res_tb;
    RETURN res;
END; //
DELIMITER ;

SELECT get_pop_mark();

#-----------------------------------------------------------------------------------
# 4.7. Процедура для вычисления процента пропущенных занятий для студентов определённой группы. 
#-----------------------------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE get_missed_classes(gr TINYINT UNSIGNED, course TINYINT UNSIGNED, OUT res INT)
BEGIN
    SELECT res3.pres / res2.whole * 100 INTO res FROM
    (
        SELECT COUNT(*) AS whole FROM attendance
        INNER JOIN
        (SELECT st_id FROM studs WHERE st_group = gr AND st_course = course) AS res1
        ON attendance.ref_st_id = res1.st_id
    ) AS res2
    INNER JOIN
    (
        SELECT COUNT(*) AS pres FROM attendance
        INNER JOIN
        (SELECT st_id FROM studs WHERE st_group = gr AND st_course = course) AS res1
        ON attendance.ref_st_id = res1.st_id
        WHERE attendance.is_present = 1
    ) AS res3;
END; //
DELIMITER ;

CALL get_missed_classes(5, 3, @xx);

SELECT @xx;

#-----------------------------------------------------------------------------------
# 4.8. Процедура для вычисления самых лояльных и предвзятых преподавателей на факультете. 
#-----------------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS get_loyal_and_worst;
DELIMITER //
CREATE PROCEDURE get_loyal_and_worst(OUT res VARCHAR(30))
BEGIN
	SELECT tb1.sub_teacher INTO res FROM
	(
	SELECT sub_teacher FROM
		(
			SELECT subjects.sub_teacher, COUNT(exams.ref_sub_id) as coef FROM exams 
			INNER JOIN subjects
			ON exams.ref_sub_id = subjects.sub_id
			WHERE exams.exam_mark = 10 OR exams.exam_mark = 9
			GROUP BY subjects.sub_teacher
			ORDER BY coef DESC LIMIT 2
		) AS res1
	) AS tb1
	INNER JOIN
	(
	SELECT sub_teacher FROM
		(
			SELECT subjects.sub_teacher, COUNT(exams.ref_sub_id) as coef FROM exams 
			INNER JOIN subjects
			ON exams.ref_sub_id = subjects.sub_id
			WHERE exams.exam_mark < 5
			GROUP BY subjects.sub_teacher
			ORDER BY coef DESC LIMIT 2
		) AS res1
	) AS tb2
	ON tb2.sub_teacher = tb1.sub_teacher;
END; //
DELIMITER ;

CALL get_loyal_and_worst(@xx);

SELECT @xx;

#-----------------------------------------------------------------------------------
# 4.9. Процедура для выдачи бонусов студентам. Принимаю на вход некоторый период времени
# начисляет надбавку к стипендии студентам, родившимся в этот период. Чем старше
# студент, тем больше надбавка. 
#-----------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------
# 4.10. Модифицируйте функцию из 4.9 таким образом, чтобы студентам, родившимся в
# определённый день недели надбавка выдавалась в трёхкратном размере.
#-----------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------
# 4.11. Процедура для вывода, ожидаемой оценки для студента на предстоящем экзамене.
# Ожидаемая оценка прогнозируется исходя из лояльности преподавателя, успешности
# студента и любых других параметров по вашему желанию.
#-----------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------
# 5.1. Триггер для автоматического изменения размера стипендии в зависимости от
# успеваемости.
#-----------------------------------------------------------------------------------

DROP TRIGGER IF EXISTS up_value
DELIMITER //
CREATE TRIGGER up_value AFTER
BEGIN
	
END; //
DELIMITER ;

#-----------------------------------------------------------------------------------
# 5.2. Триггер для автоматического снижения оплаты при успешной успеваемости.
#-----------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------
# 5.3. Проверочные триггеры для таблицы со студентами и предметами. На ваш вкус. Их можно
# придумать 100.
#-----------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------
# 5.5. Триггер помечающий потенциально проблемных студентов специальным модификатором.
#-----------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------
# 5.6. Триггер, не допускающий перевода на следующий курс студента с проблемами по линии
# здоровья.
#-----------------------------------------------------------------------------------

#-----------------------------------------------------------------------------------
# 5.7. Триггер для хранения истории изменений определённых полей таблиц.
#-----------------------------------------------------------------------------------


