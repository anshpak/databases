-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 3.2. Приведите указанную таблицу к 4НФ.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

drop database if exists movieblog;
create database movieblog;
use movieblog;

drop table if exists movies;
create table movies(
	title varchar(15),
	actor varchar(20),
    producer varchar(20)
);

insert into movies
(title, actor, producer)
values
('Great Film', 'Lovely Lady', 'Money Bags'),
('Great Film', 'Handsome Man', 'Money Bags'),
('Great Film', 'Lovely Lady', 'Helen Pursestrings'),
('Great Film', 'Handsome Man', 'Helen Pursestrings'),
('Boring Movie', 'Lovely Lady', 'Helen Pursestrings'),
('Boring Movie', 'Precocious Child', 'Helen Pursestrings');

select * from movies;

drop table if exists actors;
create table actors(
	movie_title varchar(15),
	star varchar(20),
    primary key(movie_title, star)
);

set sql_safe_updates = 0;

insert into actors
(movie_title, star)
select title, actor from movies limit 2;

insert into actors
(movie_title, star)
select title, actor from movies where title = 'Boring Movie';

# Почему первым поставил Boring Movie?

drop table if exists producers;
create table producers(
	movie_title varchar(15),
	producer varchar(20),
    primary key(movie_title, producer),
    constraint cn1 foreign key (movie_title) references actors(movie_title)
);

insert into producers
(movie_title, producer)
select title, producer from movies where actor = 'Lovely Lady';

select * from actors;

select * from producers;