--truncate table [log].[trips_process]
--truncate table [stg].[trips]
--truncate table [dw].[trips]
--truncate table dw.region_per_datasource



select * From [log].[trips_process]
select * From [stg].[trips]



select * From [dw].[trips]
select * From dw.region_per_datasource



Select * From dw.vw_trips_average_per_week

Select * From dw.vw_latest_region

select * from vw_regions_for_cheap_mobile

