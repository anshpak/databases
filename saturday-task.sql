use world;

# Вывести ровно столько городов стран, у которых количество официальных языков превышает количество неофициальных, 
# сколько букв в названии страны будет совпадать с буквами из имени 'Andrey'. Если городов меньше окажется, то не буду выводить.

select res.row_num, res.country, res.Name from
(
	select countries_info.country, city.Name, row_number() over (partition by countries_info.country order by city.Name) as row_num, countries_info.char_count from
	(
		select lang_info.Code as code, lang_info.Name as country, count(city.Name) as city_count,
		length(lang_info.Name) - length(replace(lower(lang_info.Name), 'a', '')) + 
		length(lang_info.Name) - length(replace(lower(lang_info.Name), 'n', '')) + 
		length(lang_info.Name) - length(replace(lower(lang_info.Name), 'd', '')) + 
		length(lang_info.Name) - length(replace(lower(lang_info.Name), 'r', '')) + 
		length(lang_info.Name) - length(replace(lower(lang_info.Name), 'e', '')) + 
		length(lang_info.Name) - length(replace(lower(lang_info.Name), 'y', '')) as char_count  from
		(
			select country.Code, country.Name, count(countrylanguage.language) as total_count, unofficial_languages.unoff_count, 
            count(countrylanguage.language) - unofficial_languages.unoff_count as off_count
			from country
			inner join countrylanguage
			on country.Code = countrylanguage.countryCode
			inner join
			(
				select country.Name as country_name, count(countrylanguage.Language) as unoff_count from country
				inner join countrylanguage
				on country.Code = countrylanguage.countryCode where countrylanguage.isOfficial = 'F'
				group by country.Name
			) as unofficial_languages
			on country.Name = unofficial_languages.country_name
			group by country.Code
			having off_count > unofficial_languages.unoff_count
		) as lang_info
		inner join city
		on lang_info.Code = city.countryCode
		group by lang_info.Code
		having city_count > char_count
	) as countries_info
	inner join city
	on countries_info.code = city.countryCode
) as res
where row_num <= char_count;
