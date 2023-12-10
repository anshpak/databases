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







