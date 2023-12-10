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
# 3.б 5 запросов на группировку.
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



#-----------------------------------------------------------------------------------
# 3.в 3 вложенных запроса.
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














