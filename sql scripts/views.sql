drop view if exists dw.vw_trips_average_per_week
Go
create view dw.vw_trips_average_per_week
as
	Select 
		region
		,AVG(number_tripes) average_tripes_for_week
		,COUNT(distinct week_name) count_weeks_with_trip
	From 
		(
			Select 
				region
				,datename(weekday,datetime) week_name
				,count(1) as number_tripes
			From [dw].[trips]
			group by 
				region
				,datename(weekday,datetime)
		) tripsForWeek
	Group by region	


go

drop view if exists dw.vw_latest_region
Go
create view dw.vw_latest_region
as
	Select top 1
		region_latest_datetime.region
		,region_latest_datetime.latest_datetime
	From 
		(
			Select
				region
				,max(datetime) latest_datetime
			From [dw].[trips]
			group by 
				region
		) region_latest_datetime
			Inner join 
				(
					Select top 2
						region
						,count(1) frequence
					From [dw].[trips]
					group by 
						region
					order by count(1) desc
				) region_frequence
				On region_latest_datetime.region = region_frequence.region

	order by latest_datetime desc



drop view if exists dw.vw_regions_per_cheap_mobile_datasource
Go
create view dw.vw_regions_per_cheap_mobile_datasource
as
	Select region
	From dw.region_per_datasource
	where datasource = 'cheap_mobile'



