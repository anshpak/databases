use world;

select * from country;

#-----------------------------------------------------------------------------------
# 2.1 Найдите страны, названия которых начинаются с буквы «A».
#-----------------------------------------------------------------------------------

select Name from country where Name like 'A%';

#-----------------------------------------------------------------------------------
# 2.2 Выведите все города мира, в которых можно услышать русский язык.
#-----------------------------------------------------------------------------------

select country.Name
from country
inner join countryLanguage
on country.Code = countryLanguage.countryCode
where countryLanguage.Language = 'Russian';

select distinct country.Name, countryLanguage.Language 
from country, countryLanguage
where country.Code = countryLanguage.countryCode and Language = "Russian";

#-----------------------------------------------------------------------------------
# 2.3 Выведите страны, среднее население в которых не превышает население в столице.
#-----------------------------------------------------------------------------------

# Сначала посчитаю число городов в каждой стране.

select country.Name as country_name, count(city.Name) as cities_amount
from city
inner join country
on city.countryCode = country.Code
group by country_name;

# Попрубую теперь вывести столицу каждой страны.

select country.Name, city.Name
from country
inner join city
on country.Capital = city.ID;

# Теперь попробую вывести вместе страну, столицу и количество городов.
# Можно вывести, например, страны, у которых больше трех городов.

select country.Name, city.Name, count.cities_amount
from city
inner join country
on city.ID = country.Capital
inner join
(
	select country.Name as country_name, count(city.Name) as cities_amount
    from country
    inner join city
    on country.Code = city.countryCode
    group by country_name
) as count
on country.Name = count.country_name
where count.cities_amount > 3;

# Основное задание.

select city.Name, count.cities_amount, country.Population / count.cities_amount as avg_pop, city.Population as capital_pop
from city
inner join country
on city.ID = country.Capital
inner join
(
	select country.Name as country_name, count(city.Name) as cities_amount
    from country
    inner join city
    on country.Code = city.countryCode
    group by country_name
) as count
on country.Name = count.country_name
where country.Population / count.cities_amount <= city.Population;

#-----------------------------------------------------------------------------------
# 2.4 Найдите количество городов в каждом регионе Азии.
#-----------------------------------------------------------------------------------

# Посмотрю регионы у каждой страны.

select Name, Region from country
where Region like '%Asia%';

select country.Region, count(city.Name) as cities_amount
from country
inner join city
on country.Code = city.countryCode
group by country.Region
having country.Region like '%Asia%';

#-----------------------------------------------------------------------------------
# 2.5 Вывести страны, в которых на неофициальных языках разговаривает больше людей, чем среднее население в 5 самых крупных городах страны.
# Названия этих городов вывести через запятую в отдельной ячейке.
#-----------------------------------------------------------------------------------

# Все неофициальные языки у каждой страны.

select country.Name, countrylanguage.Language, countrylanguage.Percentage
from country
inner join countrylanguage
on countrylanguage.countryCode = country.Code where countrylanguage.IsOfficial = 'F';

# Посчитаю количество людей, которые говорят на неофициальных языков для каждой страны.

select country.Name as country, unoff_lang_perc * country.Population / 100 as unnoficial_lang_speakers_amount
from country
inner join
(
	select country.Name as country, sum(countrylanguage.Percentage) as unoff_lang_perc
	from country
	inner join countrylanguage
	on countrylanguage.countryCode = country.Code where countrylanguage.IsOfficial = 'F'
	group by country.Name	
) as country_and_unoff_lang_persentage_table
on country.Name = country_and_unoff_lang_persentage_table.country;

# Страны, в которых не менее 5 городов.

select country.Name, cities_amount_table.amount
from country
inner join
(
	select country.Name as country, count(city.Name) as amount
	from country
	inner join city
	on country.Code = city.CountryCode
	group by country.Name
) as cities_amount_table
on country.Name = cities_amount_table.country
where cities_amount_table.amount >= 5
order by country.Name desc;

# Сортированные по населению города, у стран которых не менее 5 городов.

select countries_and_cities_but_five_and_more_table.Code, countries_and_cities_but_five_and_more_table.Name, city.Name, city.Population
from city
inner join
(
	select country.Code, country.Name, cities_amount_table.amount
	from country
	inner join
	(
		select country.Name as country, count(city.Name) as amount
		from country
		inner join city
		on country.Code = city.CountryCode
		group by country.Name
	) as cities_amount_table
	on country.Name = cities_amount_table.country
	where cities_amount_table.amount >= 5
) as countries_and_cities_but_five_and_more_table
on city.CountryCode = countries_and_cities_but_five_and_more_table.Code
order by countries_and_cities_but_five_and_more_table.Name, city.Population desc;

# Только 5 самых крупных городов.

select sorted_countries_and_cities_table.Code, sorted_countries_and_cities_table.Name, sorted_countries_and_cities_table.Population from
(
	select countries_and_cities_but_five_and_more_table.Code, countries_and_cities_but_five_and_more_table.Name, row_number() over (partition by countries_and_cities_but_five_and_more_table.Code order by city.Name) as row_num, city.Population
	from city
	inner join
	(
		select country.Code, country.Name, cities_amount_table.amount
		from country
		inner join
		(
			select country.Name as country, count(city.Name) as amount
			from country
			inner join city
			on country.Code = city.CountryCode
			group by country.Name
		) as cities_amount_table
		on country.Name = cities_amount_table.country
		where cities_amount_table.amount >= 5
	) as countries_and_cities_but_five_and_more_table
	on city.CountryCode = countries_and_cities_but_five_and_more_table.Code
	order by countries_and_cities_but_five_and_more_table.Name, city.Population desc
) as sorted_countries_and_cities_table
where row_num <= 5;

# Среднее население в 5 самых крупных городах.

select countries_and_cities_but_five_and_more_table.Code, countries_and_cities_but_five_and_more_table.Name, city.Name, city.Population
from city
inner join
(
	select country.Code, country.Name, cities_amount_table.amount
	from country
	inner join
	(
		select country.Name as country, count(city.Name) as amount
		from country
		inner join city
		on country.Code = city.CountryCode
		group by country.Name
	) as cities_amount_table
	on country.Name = cities_amount_table.country
	where cities_amount_table.amount >= 5
) as countries_and_cities_but_five_and_more_table
on city.CountryCode = countries_and_cities_but_five_and_more_table.Code
order by countries_and_cities_but_five_and_more_table.Name, city.Population desc;

# Только 5 самых крупных городов.

select sorted_countries_and_cities_table.Code, sorted_countries_and_cities_table.Name, sum(sorted_countries_and_cities_table.Population) / 5 as mean_population_in_five_big_cities from
(
	select countries_and_cities_but_five_and_more_table.Code, countries_and_cities_but_five_and_more_table.Name, row_number() over (partition by countries_and_cities_but_five_and_more_table.Code order by city.Name) as row_num, city.Population
	from city
	inner join
	(
		select country.Code, country.Name, cities_amount_table.amount
		from country
		inner join
		(
			select country.Name as country, count(city.Name) as amount
			from country
			inner join city
			on country.Code = city.CountryCode
			group by country.Name
		) as cities_amount_table
		on country.Name = cities_amount_table.country
		where cities_amount_table.amount >= 5
	) as countries_and_cities_but_five_and_more_table
	on city.CountryCode = countries_and_cities_but_five_and_more_table.Code
	order by countries_and_cities_but_five_and_more_table.Name, city.Population desc
) as sorted_countries_and_cities_table
where row_num <= 5
group by sorted_countries_and_cities_table.Code;

# Решение задания.

select country_and_unoff_langs_population_table.country
from
(
	select country.Name as country, unoff_lang_perc * country.Population / 100 as unnoficial_lang_speakers_amount
	from country
	inner join
	(
		select country.Name as country, sum(countrylanguage.Percentage) as unoff_lang_perc
		from country
		inner join countrylanguage
		on countrylanguage.countryCode = country.Code where countrylanguage.IsOfficial = 'F'
		group by country.Name	
	) as country_and_unoff_lang_persentage_table
	on country.Name = country_and_unoff_lang_persentage_table.country
) as country_and_unoff_langs_population_table
inner join
(
	select sorted_countries_and_cities_table.Code, sorted_countries_and_cities_table.Name, sum(sorted_countries_and_cities_table.Population) / 5 as mean_population_in_five_big_cities from
	(
		select countries_and_cities_but_five_and_more_table.Code, countries_and_cities_but_five_and_more_table.Name, row_number() over (partition by countries_and_cities_but_five_and_more_table.Code order by city.Name) as row_num, city.Population
		from city
		inner join
		(
			select country.Code, country.Name, cities_amount_table.amount
			from country
			inner join
			(
				select country.Name as country, count(city.Name) as amount
				from country
				inner join city
				on country.Code = city.CountryCode
				group by country.Name
			) as cities_amount_table
			on country.Name = cities_amount_table.country
			where cities_amount_table.amount >= 5
		) as countries_and_cities_but_five_and_more_table
		on city.CountryCode = countries_and_cities_but_five_and_more_table.Code
		order by countries_and_cities_but_five_and_more_table.Name, city.Population desc
	) as sorted_countries_and_cities_table
	where row_num <= 5
	group by sorted_countries_and_cities_table.Code
) as sorted_countries_and_cities_mean_table
on sorted_countries_and_cities_mean_table.Name = country_and_unoff_langs_population_table.country
where country_and_unoff_langs_population_table.unnoficial_lang_speakers_amount > sorted_countries_and_cities_mean_table.mean_population_in_five_big_cities;

# Попробую получить города через запятую.

select sorted_countries_and_cities_table.Code, sorted_countries_and_cities_table.Name, group_concat(sorted_countries_and_cities_table.city_name SEPARATOR ', ') AS cities from
(
	select countries_and_cities_but_five_and_more_table.Code, countries_and_cities_but_five_and_more_table.Name, row_number() over (partition by countries_and_cities_but_five_and_more_table.Code order by city.Name) as row_num, city.Name as city_name, city.Population
	from city
	inner join
	(
		select country.Code, country.Name, cities_amount_table.amount
		from country
		inner join
		(
			select country.Name as country, count(city.Name) as amount
			from country
			inner join city
			on country.Code = city.CountryCode
			group by country.Name
		) as cities_amount_table
		on country.Name = cities_amount_table.country
		where cities_amount_table.amount >= 5
	) as countries_and_cities_but_five_and_more_table
	on city.CountryCode = countries_and_cities_but_five_and_more_table.Code
	order by countries_and_cities_but_five_and_more_table.Name, city.Population desc
) as sorted_countries_and_cities_table
where row_num <= 5
group by sorted_countries_and_cities_table.Code;

# Объединю все вместе.

select res_1_table.country, res_2_table.cities
from
(
	select country_and_unoff_langs_population_table.country
	from
	(
		select country.Name as country, unoff_lang_perc * country.Population / 100 as unnoficial_lang_speakers_amount
		from country
		inner join
		(
			select country.Name as country, sum(countrylanguage.Percentage) as unoff_lang_perc
			from country
			inner join countrylanguage
			on countrylanguage.countryCode = country.Code where countrylanguage.IsOfficial = 'F'
			group by country.Name	
		) as country_and_unoff_lang_persentage_table
		on country.Name = country_and_unoff_lang_persentage_table.country
	) as country_and_unoff_langs_population_table
	inner join
	(
		select sorted_countries_and_cities_table.Code, sorted_countries_and_cities_table.Name, sum(sorted_countries_and_cities_table.Population) / 5 as mean_population_in_five_big_cities from
		(
			select countries_and_cities_but_five_and_more_table.Code, countries_and_cities_but_five_and_more_table.Name, row_number() over (partition by countries_and_cities_but_five_and_more_table.Code order by city.Name) as row_num, city.Population
			from city
			inner join
			(
				select country.Code, country.Name, cities_amount_table.amount
				from country
				inner join
				(
					select country.Name as country, count(city.Name) as amount
					from country
					inner join city
					on country.Code = city.CountryCode
					group by country.Name
				) as cities_amount_table
				on country.Name = cities_amount_table.country
				where cities_amount_table.amount >= 5
			) as countries_and_cities_but_five_and_more_table
			on city.CountryCode = countries_and_cities_but_five_and_more_table.Code
			order by countries_and_cities_but_five_and_more_table.Name, city.Population desc
		) as sorted_countries_and_cities_table
		where row_num <= 5
		group by sorted_countries_and_cities_table.Code
	) as sorted_countries_and_cities_mean_table
	on sorted_countries_and_cities_mean_table.Name = country_and_unoff_langs_population_table.country
	where country_and_unoff_langs_population_table.unnoficial_lang_speakers_amount > sorted_countries_and_cities_mean_table.mean_population_in_five_big_cities
) as res_1_table
inner join
(
	select sorted_countries_and_cities_table.Code, sorted_countries_and_cities_table.Name, group_concat(sorted_countries_and_cities_table.city_name SEPARATOR ', ') AS cities from
	(
		select countries_and_cities_but_five_and_more_table.Code, countries_and_cities_but_five_and_more_table.Name, row_number() over (partition by countries_and_cities_but_five_and_more_table.Code order by city.Name) as row_num, city.Name as city_name, city.Population
		from city
		inner join
		(
			select country.Code, country.Name, cities_amount_table.amount
			from country
			inner join
			(
				select country.Name as country, count(city.Name) as amount
				from country
				inner join city
				on country.Code = city.CountryCode
				group by country.Name
			) as cities_amount_table
			on country.Name = cities_amount_table.country
			where cities_amount_table.amount >= 5
		) as countries_and_cities_but_five_and_more_table
		on city.CountryCode = countries_and_cities_but_five_and_more_table.Code
		order by countries_and_cities_but_five_and_more_table.Name, city.Population desc
	) as sorted_countries_and_cities_table
	where row_num <= 5
	group by sorted_countries_and_cities_table.Code
) as res_2_table
on res_1_table.country = res_2_table.Name;

# Добавлю запись в файл.

select res_1_table.country, res_2_table.cities
into outfile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/res.txt'
fields terminated by ': '
lines terminated by '.\n'
from
(
	select country_and_unoff_langs_population_table.country
	from
	(
		select country.Name as country, unoff_lang_perc * country.Population / 100 as unnoficial_lang_speakers_amount
		from country
		inner join
		(
			select country.Name as country, sum(countrylanguage.Percentage) as unoff_lang_perc
			from country
			inner join countrylanguage
			on countrylanguage.countryCode = country.Code where countrylanguage.IsOfficial = 'F'
			group by country.Name	
		) as country_and_unoff_lang_persentage_table
		on country.Name = country_and_unoff_lang_persentage_table.country
	) as country_and_unoff_langs_population_table
	inner join
	(
		select sorted_countries_and_cities_table.Code, sorted_countries_and_cities_table.Name, sum(sorted_countries_and_cities_table.Population) / 5 as mean_population_in_five_big_cities from
		(
			select countries_and_cities_but_five_and_more_table.Code, countries_and_cities_but_five_and_more_table.Name, row_number() over (partition by countries_and_cities_but_five_and_more_table.Code order by city.Name) as row_num, city.Population
			from city
			inner join
			(
				select country.Code, country.Name, cities_amount_table.amount
				from country
				inner join
				(
					select country.Name as country, count(city.Name) as amount
					from country
					inner join city
					on country.Code = city.CountryCode
					group by country.Name
				) as cities_amount_table
				on country.Name = cities_amount_table.country
				where cities_amount_table.amount >= 5
			) as countries_and_cities_but_five_and_more_table
			on city.CountryCode = countries_and_cities_but_five_and_more_table.Code
			order by countries_and_cities_but_five_and_more_table.Name, city.Population desc
		) as sorted_countries_and_cities_table
		where row_num <= 5
		group by sorted_countries_and_cities_table.Code
	) as sorted_countries_and_cities_mean_table
	on sorted_countries_and_cities_mean_table.Name = country_and_unoff_langs_population_table.country
	where country_and_unoff_langs_population_table.unnoficial_lang_speakers_amount > sorted_countries_and_cities_mean_table.mean_population_in_five_big_cities
) as res_1_table
inner join
(
	select sorted_countries_and_cities_table.Code, sorted_countries_and_cities_table.Name, group_concat(sorted_countries_and_cities_table.city_name SEPARATOR ', ') AS cities from
	(
		select countries_and_cities_but_five_and_more_table.Code, countries_and_cities_but_five_and_more_table.Name, row_number() over (partition by countries_and_cities_but_five_and_more_table.Code order by city.Name) as row_num, city.Name as city_name, city.Population
		from city
		inner join
		(
			select country.Code, country.Name, cities_amount_table.amount
			from country
			inner join
			(
				select country.Name as country, count(city.Name) as amount
				from country
				inner join city
				on country.Code = city.CountryCode
				group by country.Name
			) as cities_amount_table
			on country.Name = cities_amount_table.country
			where cities_amount_table.amount >= 5
		) as countries_and_cities_but_five_and_more_table
		on city.CountryCode = countries_and_cities_but_five_and_more_table.Code
		order by countries_and_cities_but_five_and_more_table.Name, city.Population desc
	) as sorted_countries_and_cities_table
	where row_num <= 5
	group by sorted_countries_and_cities_table.Code
) as res_2_table
on res_1_table.country = res_2_table.Name;