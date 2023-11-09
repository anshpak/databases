drop database if exists quote;
create database quote;
use quote;

drop table if exists public_event;
create table public_event (
	event_id smallint unsigned primary key auto_increment,
	event_name varchar(30),
    public_event_type enum ('film presentetion',  'dinner party',  'awarding',  'morning show',  'private interview')
);

drop table if exists quote;
create table quote (
	quote_id smallint unsigned primary key auto_increment,
	content varchar(50) not null,
    first_mention date not null,
    public_event_id smallint unsigned,
    rate float(3, 1),
    is_cancelled_after_quote boolean,
    constraint cn1 foreign key (public_event_id) references public_event(event_id)
);

drop table if exists guests_at_the_event;
create table celebrity (
	guest_id smallint unsigned primary key auto_increment,
    guest_name varchar(30) not null,
    guest_surname varchar(30) not null,
    guest_type set("relative", "actor", "singer",  "broadcaster", "youtuber", "interviewer"),
    public_event_id smallint unsigned,
    constraint cn2 foreign key (public_event_id) references public_event(event_id)
);