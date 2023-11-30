drop database if exists test;
create database test;
use test;

drop table if exists favourite_movies;
create table favourite_movies(
	person_name varchar(25),
    movie_name varchar(30)
);

insert into favourite_movies
(person_name, movie_name)
values
('Быкова Анастасия', 'Kill Bill'),
('Гусев Илья', 'Minari'),
('Попов Максим', 'Shawshank Redemption'),
('Зайцев Матвей', 'Mamma Mia!'),
('Смирнов Лев', 'Dune'),
('Кузьмина Кристина', 'Social Network');

drop table if exists favourite_snacks;
create table favourite_snacks(
	person_name varchar(25),
	snack_name varchar(20)
);

insert into favourite_snacks
(person_name, snack_name)
values
('Орлова Анна', 'Sweets'),
('Быкова Анастасия', 'Sausages'),
('Гусев Илья', 'Milk'),
('Комаров Артём', 'Coke'),
('Зайцев Матвей', 'Strawberries'),
('Быкова Анастасия', 'Ice cream'),
('Кузьмина Кристина', 'Popcorn'),
('Кириллова Полина', 'Milkshake');

drop table if exists favourite_games;
create table favourite_games(
	person_name varchar(25),
	game_name varchar(20)
);

insert into favourite_games
(person_name, game_name)
values
('Кириллова Полина', 'Minecraft'),
('Быкова Анастасия', 'D&D'),
('Гусев Илья', 'Monopoly'),
('Комаров Артём', 'Monopoly'),
('Зайцев Матвей', 'Monopoly'),
('Муравьев Даниил', 'D&D'),
('Чижова Анна', 'Minecraft');

drop table if exists persons_info;
create table persons_info(
	person_name varchar(25) primary key,
	game_name varchar(20),
	snack_name varchar(20),
    movie_name varchar(30)
);

insert into persons_info
(person_name)
select person_name from favourite_movies;

insert ignore into persons_info
(person_name)
select person_name from favourite_snacks;

insert ignore into persons_info
(person_name)
select person_name from favourite_games;

set sql_safe_updates = 0;

update persons_info
join favourite_movies
on favourite_movies.person_name = persons_info.person_name
join favourite_games 
on favourite_games.person_name = persons_info.person_name
join favourite_snacks 
on favourite_snacks.person_name = persons_info.person_name
set persons_info.movie_name = favourite_movies.movie_name,
persons_info.snack_name = favourite_snacks.snack_name,
persons_info.game_name = favourite_games.game_name;

select * from persons_info;