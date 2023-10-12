create database test;
use test;

create table quote (
	quote_id bigint primary key auto_increment,
	content varchar(50) not null,
    first_mention date not null,
	overall double,
    is_popular boolean,
    main_criticism varchar(50),
	event_name blob(20),
    public_event_type enum ('film presentetion',  'dinner party',  'awarding',  'morning show',  'private interview'),
    amount_of_relatives tinyint,
	relative_id int(11) primary key auto_increment,
	relative_name text(20) not null,
    relative_type enum ('mother', 'father', 'sister', 'brother', 'uncle', 'aunt'),
    relative_surname varchar(20) not null,
	press_name varchar(20) not null,
    amount_of_employee_on_event int(11) not null,
    interviewer_name varchar(20) not null,
    interviewer_surname tinytext not null,
    celebrity_name tinyblob not null,
    celebrity_surname char(20) not null,
    celebrity_type set ('actor, singer', 'broadcaster', 'youtuber')
);

drop database test;