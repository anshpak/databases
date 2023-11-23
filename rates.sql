-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 3.3. Приведите указанную таблицу к НФБК.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

drop database if exists bowling;
create database bowling;
use bowling;

create table tracks_timetable_info(
	track_id tinyint unsigned,
    start_time varchar(5),
    end_time varchar(5),
    rate_type varchar(15)
);

insert into tracks_timetable_info
(track_id, start_time, end_time, rate_type)
values
(1, '09:30', '10:30', '\"Бережливый\"'),
(1, '11:00', '12:00', '\"Бережливый\"'),
(1, '14:00', '15:30', '\"Стандарт\"'),
(2, '10:00', '11:30', '\"Премиум-B\"'),
(2, '11:30', '13:30', '\"Премиум-B\"'),
(2, '15:00', '16:30', '\"Премиум-A\"');

select * from tracks_timetable_info;

drop table if exists rates;
create table rates(
	rate_id tinyint unsigned primary key auto_increment,
    rate_name varchar(15)
);

insert into rates
(rate_name)
select rate_type from tracks_timetable_info;

delete from rates where rate_id in (2, 5);

select * from rates;

create table tracks(
	track_id tinyint unsigned,
    start_time varchar(5),
    end_time varchar(5),
    primary key (track_id, start_time, end_time)
);

insert into tracks
(track_id, start_time, end_time)
select track_id, start_time, end_time from tracks_timetable_info;

select * from tracks;

create table tracks_and_rates(
	track_id tinyint unsigned,
    start_time varchar(5),
    end_time varchar(5),
    rate_id tinyint unsigned,
    constraint cn1 foreign key (track_id, start_time, end_time) references tracks(track_id, start_time, end_time),
    constraint cn2 foreign key (rate_id) references rates(rate_id)
);

insert into tracks_and_rates
(track_id, start_time, end_time, rate_id)
values
(1, '09:30', '10:30', 1),
(1, '11:00', '12:00', 1),
(1, '14:00', '15:30', 3),
(2, '10:00', '11:30', 4),
(2, '11:30', '13:30', 4),
(2, '15:00', '16:30', 6);

select * from tracks_and_rates;