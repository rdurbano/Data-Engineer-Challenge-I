Create schema stg

Go

Create schema [log]

Go

Create schema [dw]

Go

drop table if exists stg.trips
Create table stg.trips
(
	ctr_pipeline_run_id varchar(500)
	,[ctr_file_path] varchar(500)
	,region varchar(500)
	,origin_coord varchar(500)
	,destination_coord varchar(500)
	,datetime datetime
	,datasource varchar(500)
)

Go

drop table if exists [log].trips_process
Create table [log].trips_process
(
	ID int identity(1,1)
	,ctr_pipeline_run_id varchar(500)
	,dat_start datetime
	,dat_finish datetime
	,sts_process varchar(100)
	,Constraint PK_trips_process Primary Key (ID)
	,Constraint UK_trips_process Unique (ctr_pipeline_run_id)
)

Go

drop table if exists dw.trips
Create table dw.trips
(
	region varchar(500)
	,origin_coord varchar(500)
	,destination_coord varchar(500)
	,datetime datetime
)

Go

drop table if exists dw.region_per_datasource
Create table dw.region_per_datasource
(
	region varchar(500)
	,datasource varchar(500)
)


