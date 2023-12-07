use world;

# Вывести те страны мира, у которых одним из официальных языков является хотя бы один из двух самых популярных неофициальных языков европейского региона.

select off_lang_table.country, off_lang_table.lng from 
(
	select countrylanguage.Language as lng, sum(countrylanguage.Percentage) as lng_percentage from country
	inner join countrylanguage
	on country.Code = countrylanguage.countryCode where countrylanguage.isOfficial = 'F' and region like '%Europe%'
	group by lng
	having lng_percentage > 0
	order by lng_percentage desc
	limit 2
) as unoff_most_pop_lang_table
inner join
(
	select country.Name as country, countrylanguage.Language as lng from country
	inner join countrylanguage
	on country.Code = countrylanguage.countryCode where countrylanguage.isOfficial = 'T'
) as off_lang_table
on unoff_most_pop_lang_table.lng = off_lang_table.lng;
