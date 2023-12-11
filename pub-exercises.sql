use pub;

#-----------------------------------------------------------------------------------
# 3.a Запрос к 4–ем таблицам одновременно.
#-----------------------------------------------------------------------------------

select staff.employee_name, contracts.contract_start_date, contracts.contract_end_date, sells.sell_amount, sells.sell_date,
products.product_name from staff
inner join contracts
on staff.employee_id = contracts.contract_id
inner join sells
on staff.employee_id = sells.barman_id
inner join product_sells
on sells.sell_id = product_sells.sell_id
inner join products
on product_sells.product_id = products.product_id;

#-----------------------------------------------------------------------------------
# 3.b 5 запросов на группировку.
#-----------------------------------------------------------------------------------

# Сколько продаж за все время сделали люди с фамилией, заканчивающейся на 'ова' или 'ов'.

select sells.barman_id, ova_ov_surnames_table.employee_name, ova_ov_surnames_table.employee_surname, count(sells.sell_amount)
from sells
inner join
(
	select employee_id, employee_name, employee_surname from staff where employee_surname like '%ова' or '%ов'
) as ova_ov_surnames_table
on sells.barman_id = ova_ov_surnames_table.employee_id
group by sells.barman_id;

# Вывести сотрудников с зарплатой выше среднего.

select staff.employee_name, staff.employee_surname
from staff
inner join
(
	select contract_id
	from contracts
	where salary >
	(
		select avg(salary) from contracts as average_salary
	)
) salaries_above_average_table
on staff.employee_id = salaries_above_average_table.contract_id;

# Вывести сотрудника с минимальным возрастом, причем этот сотрудник продавал воду.

select *
from
(
	select min(staff.employee_age) as min_age
	from staff
	inner join
	(
		select distinct sells.barman_id
		from sells
		inner join
		(
			select product_sells.sell_id
			from product_sells
			inner join products
			on product_sells.product_id = products.product_id where products.product_type = 'Вода'
		) as vater_table
		on vater_table.sell_id = sells.sell_id
	) as vater_traders_ids
	on staff.employee_id = vater_traders_ids.barman_id
) as res1
inner join 
(
	select staff.employee_name, staff.employee_surname, staff.employee_age
    from staff
    inner join
    (
		select distinct sells.barman_id
		from sells
		inner join
		(
			select product_sells.sell_id
			from product_sells
			inner join products
			on product_sells.product_id = products.product_id where products.product_type = 'Вода'
		) as vater_table
		on vater_table.sell_id = sells.sell_id
    ) as vater_traders_ids_table
    on staff.employee_id = vater_traders_ids_table.barman_id
) as res2
on res1.min_age = res2.employee_age;

# Самый старший сотрудник.

select staff.employee_name, staff.employee_surname
from staff
inner join
(
	select max(staff.employee_age) as max_age from staff
) as old
on staff.employee_age = old.max_age;

# Сколько лет Корзюку.

select sum(employee_age) from staff;

#-----------------------------------------------------------------------------------
# 3.d 3 вложенных запроса.
#-----------------------------------------------------------------------------------

# На какую сумму продали товаров каждый из барменов, работавший 2023-09-17.

select staff.employee_name, staff.employee_surname, total_profit_for_night.money
from staff
inner join
(
	select products_prises_and_barmans_ids.barman_id, sum(products_prises_and_barmans_ids.product_price * sells.sell_amount) as money
	from sells
	inner join
	(
		select barmans_and_products_only_ids_table.barman_id, products.product_price, barmans_and_products_only_ids_table.sell_id
		from products
		inner join
		(
			select barmans_and_sells_only_ids_table.barman_id, product_sells.product_id, product_sells.sell_id
			from product_sells
			inner join
			(
				select barman_id, sell_id from sells where substring_index(sell_date, ' ', 1) = '2023-09-17'
			) as barmans_and_sells_only_ids_table
			on product_sells.sell_id = barmans_and_sells_only_ids_table.sell_id
		) as barmans_and_products_only_ids_table
		on products.product_id = barmans_and_products_only_ids_table.product_id
	) as products_prises_and_barmans_ids
	on sells.sell_id = products_prises_and_barmans_ids.sell_id
	group by barman_id
) as total_profit_for_night
on staff.employee_id = total_profit_for_night.barman_id;

# Зарплата барменов, которые продавали вино.

select staff.employee_name, staff.employee_surname, salaries_table.salary
from staff
inner join
(
	select contracts.contract_id, contracts.salary
	from contracts
	inner join
	(
		select distinct sells.barman_id
		from sells
		inner join
		(
			select product_sells.sell_id
			from product_sells
			inner join products
			on product_sells.product_id = products.product_id where products.product_type = 'Вино'
		) as vine_table
		on vine_table.sell_id = sells.sell_id
	) as barmans_who_trade_vine
	on contracts.contract_id = barmans_who_trade_vine.barman_id
) as salaries_table
on salaries_table.contract_id = staff.employee_id;

# Вывести столько сотрудников, сколько людей в штате родились после 1995 года и сделали хотя бы одну продажу.

select staff.employee_name, staff.employee_surname
from staff
inner join
(
	select count(distinct sells.barman_id) as barmans_who_made_one_and_more_sells
	from sells
	inner join
	(
		select employee_id
		from staff
		where employee_birth_date > '1995-01-01'
	) as were_born_after_1995_table
	on were_born_after_1995_table.employee_id = sells.barman_id
) as barmans_who_made_one_and_more_sells_amount_table
on staff.employee_id <= barmans_who_made_one_and_more_sells_amount_table.barmans_who_made_one_and_more_sells;

#-----------------------------------------------------------------------------------
# 3.e Запрос с использованием операций над множествами.
#-----------------------------------------------------------------------------------

# Сотрудники, которые ваще ничего не делали.

select employee_id, employee_name, employee_surname from staff
where employee_id not in (
    select barman_id from sells
);

#-----------------------------------------------------------------------------------
# 3.f Обновление таблиц с использованием оператора соединения.
#-----------------------------------------------------------------------------------

set sql_safe_updates = 0;

update staff
join sells on
sells.barman_id = staff.employee_id
set staff.employee_name = 'Andrey';

#-----------------------------------------------------------------------------------
# 3.g Запрос с использованием оконных функций.
#-----------------------------------------------------------------------------------

select staff.employee_id, staff.employee_name, staff.employee_surname, staff.employee_position,
row_number() over (partition by staff.employee_position order by staff.employee_id) as row_num
from staff;

#-----------------------------------------------------------------------------------
# 4. Создайте представления для различных участников проекта из ЛР1.
#-----------------------------------------------------------------------------------

select info_table.employee_id, info_table.employee_name, info_table.employee_surname, info_table.employee_position, 
info_table.sells, contracts.salary from 
(
	select staff.employee_id, staff.employee_name, staff.employee_surname, staff.employee_position, barmans_and_sells.sells
	from staff
	left join
	(
		select staff.employee_id, staff.employee_name, staff.employee_surname, staff.employee_position, count(sells.sell_amount) as sells
		from staff
		inner join sells
		on staff.employee_id = sells.barman_id
		group by staff.employee_id
	) as barmans_and_sells
	on staff.employee_id = barmans_and_sells.employee_id
) as info_table
inner join contracts
on contracts.contract_id = info_table.employee_id;




