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
	track_id tinyint unsigned,
    rate_name varchar(15),
    primary key(rate_name)
);

insert ignore into rates
(track_id, rate_name)
select track_id, rate_type from tracks_timetable_info;

select * from rates;

drop table if exists tracks;
create table tracks(
	rate_name varchar(15),
    start_time varchar(5),
    end_time varchar(5),
    primary key (rate_name, start_time, end_time),
    constraint cn1 foreign key (rate_name) references rates(rate_name)
);

insert into tracks
(rate_name, start_time, end_time)
select rate_type, start_time, end_time from tracks_timetable_info;

select * from tracks;