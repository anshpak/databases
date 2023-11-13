-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 3.1. Приведите указанную таблицу к 1НФ.
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

drop database if exists auto;
create database auto;
use auto;

-- Автомоби́льный но́мер (регистрационный знак, номерной знак) — индивидуальный регистрационный знак транспортного средства (автомобиля и других сухопутных ТС),
-- значит его можно использовать в качестве первичного ключа

drop table if exists automobile_info;
create table automobile_info(
	auto_id varchar(15) primary key,
	auto_mark varchar(25),
    auto_year_of_creation year,
    auto_price decimal(6),
    auto_characteristics varchar(50)
);

insert into automobile_info
(auto_id, auto_mark, auto_year_of_creation, auto_price, auto_characteristics)
values
('АФ 1233 ФА', 'Mersedes-Benz G-400', '2002', 28000, 'Автомат, дизель, 4.0 л.'),
('FG 67 SPV', 'Mersedes-Benz G-400 AMG', '2002', 38500, 'Типтроник, дизель, 4.0 л.'),
('AO 1234 OA', 'Toyota Sequoia', '2012', 32500, 'Автомат, бензин, 5.7 л.'),
('AO 4254 AO', 'Toyota Avalon', '2015', 21000, 'Автомат, бензин, 3.5 л.'),
('TT 777 MH', 'Subaru Forester', '2016', 18800, 'Автомат, бензин, 2.5 л.'),
('SS 908 KLV', 'Suzuki SX4', '2020', 19000, 'Механическая, бензин, 1.6 л.');
select * from automobile_info;

-- Нарушается атомарность значений столбца auto_characteristics. Решение - создать новые столбцы, которые разделят существующие значения.

alter table automobile_info
add column transmission_type enum('Автомат', 'Типтроник', 'Механическая') after auto_characteristics,
add column fuel_type enum('Дизель', 'Бензин') after auto_characteristics,
add column engine_capacity float(3, 1) unsigned after auto_characteristics;

set sql_safe_updates = 0;

-- left() извлекает указанное количество символов из начала строки.

update automobile_info
set transmission_type = substring_index(auto_characteristics, ',', 1),
fuel_type = concat(upper(left(substring_index(substring_index(auto_characteristics, ' ', 2), ' ', -1), 1)), substring(substring_index(substring_index(auto_characteristics, ' ', 2), ' ', -1), 2, char_length(substring_index(substring_index(auto_characteristics, ' ', 2), ' ', -1)) - 2)),
engine_capacity = substring(substring_index(auto_characteristics, ',', -1), 2, char_length(substring_index(auto_characteristics, ',', -1)) - 3);

select * from automobile_info;  


