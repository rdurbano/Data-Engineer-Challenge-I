drop proc if exists log.usp_log
Go
create proc log.usp_log (@ctr_pipeline_run_id  varchar(500),@dat_start datetime,@dat_finish datetime,@sts_process varchar(100))
as

	if @sts_process = 'Started'
	Begin
		Insert into [log].trips_process (ctr_pipeline_run_id,dat_start,sts_process)
			values(@ctr_pipeline_run_id,@dat_start,@sts_process)
	End
	Else
	Begin
		update [log].trips_process
		Set dat_finish = @dat_finish
			,sts_process = @sts_process
		Where ctr_pipeline_run_id = @ctr_pipeline_run_id
	End
	


Go


drop proc if exists dw.usp_load_trips
Go
create proc dw.usp_load_trips
As
	
	drop table if exists #TMP_ingestion
	Select distinct ctr_pipeline_run_id
	Into #TMP_ingestion
	From stg.trips

	merge dw.trips as tgt
	Using 
		(
			Select distinct
				region
				,origin_coord
				,destination_coord
				,datetime
			From stg.trips trips
				Inner join #TMP_ingestion ing
					On trips.ctr_pipeline_run_id = ing.ctr_pipeline_run_id
		) as src
	On (tgt.origin_coord = src.origin_coord and tgt.destination_coord = src.destination_coord and tgt.datetime = src.datetime)
	When not Matched Then
		insert (region,origin_coord,destination_coord,datetime)
			values (src.region,src.origin_coord,src.destination_coord,src.datetime);

	merge dw.region_per_datasource as tgt
	Using 
		(
			Select distinct
				region
				,datasource
			From stg.trips trips
				Inner join #TMP_ingestion ing
					On trips.ctr_pipeline_run_id = ing.ctr_pipeline_run_id
		) as src
	On (tgt.region = src.region and tgt.datasource = src.datasource)
	When not Matched Then
		insert (region,datasource)
			values (src.region,src.datasource);


	delete trips
	from stg.trips trips
		Inner join #TMP_ingestion ing
			On trips.ctr_pipeline_run_id = ing.ctr_pipeline_run_id
	 
