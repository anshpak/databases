drop database if exists covid;
create database covid;
use covid;

drop table if exists medical_establishment;
create table medical_establishment(
	medical_establishment_id int unsigned primary key auto_increment,
	medical_establishment_name varchar(50) not null,
    medical_establishment_address varchar(50) not null,
    medical_establishment_phone_number varchar(50) not null,
	amount_of_vaccinated_people int,
    vaccines_amount_available int
);

drop table if exists person;
create table person(
	person_id int unsigned primary key auto_increment,
    medical_establishment_id int unsigned,
    person_name varchar(50) not null,
    person_surname varchar(50) not null,
    person_status enum('alive', 'dead'),
    person_birth_date date,
	constraint cn1 foreign key (medical_establishment_id) references medical_establishment(medical_establishment_id)
);

drop table if exists vaccine;
create table vaccine(
	vaccine_id int unsigned primary key auto_increment,
	vaccine_name enum('Pfizer–BioNTech', 'Oxford–AstraZeneca', 'Sputnik V'),
    vaccine_type enum('RNA', 'Vector', 'Protein subunit'),
    vaccination_date date,
    constraint cn2 foreign key (vaccine_id) references person(person_id)
);

insert into medical_establishment
(medical_establishment_name, medical_establishment_address, medical_establishment_phone_number, amount_of_vaccinated_people, vaccines_amount_available) 
values
('Hospital № 1', 'Nezavisimosty ave 64', '+375 17 373 46 12', 123443, 5000),
('Hospital № 10', 'Uborevicha street 73', '	+375 44 552 51 83', 345323, 10000);
select * from medical_establishment;

insert into person
(medical_establishment_id, person_name, person_surname, person_status, person_birth_date) 
values
(1, 'Andrey', 'Shpak', 'alive', '2000-12-13'),
(2, 'Valentyna', 'Shynkevych', 'dead', '1950-10-11');
select * from person;

insert into vaccine
(vaccine_name, vaccine_type, vaccination_date) 
values
('Sputnik V', 'RNA', '2022-05-21'),
('Sputnik V', 'RNA', '2021-12-19');
select * from vaccine;