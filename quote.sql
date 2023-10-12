create database quote;
use quote;

create table quote (
	quote_id int(11) primary key auto_increment,
	content varchar(50) not null,
    first_mention date not null,
    quote_public_event_id int(11),
    constraint cn3 foreign key (quote_public_event_id) references public_event(event_id)
);

create table rate (
	rate_id int(11) primary key auto_increment,
	overall varchar(5),
    is_canceled boolean,
	constraint cn6 foreign key (rate_id) references quote(quote_id)
);

create table public_event (
	event_id int(11) primary key auto_increment,
	event_name varchar(20),
    public_event_type enum ('film presentetion',  'dinner party',  'awarding',  'morning show',  'private interview'),
    mentioned_quote_id int(11),
    amount_of_relatives int(11)
);

create table relatives (
	relative_id int(11) primary key auto_increment,
	relative_name varchar(20) not null,
    relative_type enum ('mother', 'father', 'sister', 'brother', 'uncle', 'aunt'),
    relative_surname varchar(20) not null,
    relatives_event_id int(11),
    constraint cn5 foreign key (relatives_event_id) references public_event(event_id)
);

create table press (
	press_id int(11) primary key auto_increment,
	press_name varchar(20) not null,
    amount_of_employee_on_event int(11) not null,
    public_event_id int(11) not null,
    constraint cn1 foreign key (public_event_id) references public_event(event_id)
);

create table interviewer (
	interviewer_id int(11) primary key auto_increment,
    interviewer_name varchar(20) not null,
    interviewer_surname varchar(20) not null,
    interviewer_press_id int(11),
    constraint cn2 foreign key (interviewer_press_id) references press(press_id)
);

create table celebrity (
	celebrity_id int(11) primary key auto_increment,
    celebrity_name varchar(20) not null,
    celebrity_surname varchar(20) not null,
    celebrity_type enum ('actor, singer', 'broadcaster', 'youtuber'),
    public_event_id int(11),
    constraint cn4 foreign key (public_event_id) references public_event(event_id)
);

drop database quote;