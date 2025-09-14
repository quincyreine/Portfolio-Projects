select * from dbo.['2018$']

select * from dbo.['2019$']

select * from dbo.['2020$']


--- 
SELECT *
INTO hotels 
FROM (
	select * from dbo.['2018$']
	union
	select * from dbo.['2019$']
	union
	select * from dbo.['2020$'] 
) AS CombinedData

Select * from hotels

Select 
arrival_date_year,
(stays_in_weekend_nights + stays_in_week_nights)*adr as Revenue 
from hotels


Select 
arrival_date_year, hotel,
round(sum((stays_in_weekend_nights+stays_in_week_nights)*adr),2) as Revenue 
from hotels
Group by arrival_date_year, hotel

select * from dbo.market_segment$

select * from hotels
left join dbo.market_segment$ 
on hotels.market_segment = market_segment$.market_segment
left join dbo.meal_cost$
on meal_cost$.meal = hotels.meal
