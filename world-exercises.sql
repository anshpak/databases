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

# Сначала гляну проценты языков для стран.

select country.Name, countrylanguage.Language, countrylanguage.Percentage
from country
inner join countrylanguage
on countrylanguage.countryCode = country.Code
where countrylanguage.Percentage > 50;

# Попробую вывести максимальный язык по процентам.

select countrylanguage.Language, max(countrylanguage.Percentage)
from country
inner join countrylanguage
on countrylanguage.countryCode = country.Code
group by countrylanguage.Language;

# 5 и больше городов для стран.

select country.Name, city.Name, city.Population
from country
inner join city
on country.Code = city.countryCode
order by country.Name and city.Population;

# 5 самых больших городов стран.