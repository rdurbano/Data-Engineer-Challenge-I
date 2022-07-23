# Architecture for the challenge

![image](https://user-images.githubusercontent.com/12244452/180624022-f37a00c6-e1d5-4d53-b830-708dbda96039.png)

# Components 

## File generator (Python Script)

This python script has the objective to save several files on Azure Data Lake to proof that the solution could be scalable. 
[link to script](simulator/generate_files.py)

![image](https://user-images.githubusercontent.com/12244452/180624543-8403c320-2066-4560-80d0-e72708149d78.png)<br>
That variables need to be updated according to your environment.
- entries = number of files to simulate
- local_file_path = path of the sample file to generate the copies
- local_file_name = name of the sample file to generate the copies
- blob_service_client = Object with the connection string value. You need to access the https://kv-jobsity.vault.azure.net/ and collect the secret value ADLS-Connection-String to replace on that.


## Event Grid

This component was created automatically when we use trigger by event, the Event Grid is responsible to collect the events on Azure Data Lake and action the trigger on ADF

## Data Factory

There are two pipelines deployed in ADF that are:
- pl_ingestion = Actioned by event trigger (tigger_ingestion) and responsible to load data to staging area on Azure SQL Database
- pl_trips = Actioned by schedule trigger (trigger_trips) and responsible to load data from staging area to DW area. That for this case is where the user could do queries.

If you want to deploy the ADF in another Azure Environment there is the [link to arm template](adf/arm_template.zip)

## Azure SQL Database

Objects in the server:

![image](https://user-images.githubusercontent.com/12244452/180625286-a87a1607-7927-4503-aa12-eb83650d7f9e.png)

### tables

#### stg.trips 
The raw data that was loaded from .CSV files. The schema contains two metadata columns below:

column name | description
----------- | -----------
ctr_pipeline_run_id | Identify the ADF pipeline run ID that load this data
ctr_file_path | File name that is the origin.

This columns are used to load the data to DW area and log information.


#### dw.trips 
Data loaded from stg.trips applying the challenges requirements.That is the layer to consume the information.


#### log.trips_process
Where is registered the LOG of the ingestion process and it's can be consume using the API too.The schema contains the columns below:
column name | description
----------- | -----------
ID | Incremental ID
ctr_pipeline_run_id | Identify the ADF pipeline run ID
dat_start | When started the ingestion
dat_finish | When finished the ingestion
sts_process | Possible status "Started" or "Completed"


### views
view name | description | link
----------- | -----------| ---------
vw_latest_region | To attend the requirement "From the two most commonly appearing regions, which is the latest datasource ?"(BONUS) | [link to script](sql%20scripts/views.sql)
vw_regions_per_cheap_mobile_datasource | To attend the requirement "What regions has the "cheap_mobile" datasource appeared in?" (BONUS)  | [link to script](sql%20scripts/views.sql)
vw_trips_average_per_week | To attend the requirement "Develop a way to obtain the weekly average number of trips for an area, defined by a bounding box (given by coordinates) or by a region" | [link to script](sql%20scripts/views.sql)

### procedures
proc name | description | link
----------- | ----------- |-----------
dw.usp_load_trips | Procedure to load new trips to the Data Warehouse area| [link to script](sql%20scripts/procedures.sql)
log.usp_log | Procedure to update/insert log information |[link to script](sql%20scripts/procedures.sql)

## Azure Function

The function that was created is in python that is resposible to collect the data from Azure SQL Server and delivery using REST API.

Endpoint available: https://app-trips-function.azurewebsites.net/api/trips-details <br>
Parameter: query (valid values are: vw_latest_region,log_trips_process,vw_trips_average_per_week,vw_regions_per_cheap_mobile_datasource)

Request example: https://app-trips-function.azurewebsites.net/api/trips-details?query=vw_trips_average_per_week
![image](https://user-images.githubusercontent.com/12244452/180625946-d5f8ecba-2234-4b2b-b616-9586dc33540f.png)

The code of this function is here [link to function](function-app/api/trips-details/__init__.py) and if you want debug this on your own machine you need to install [Azure Funcion Core Tools](https://github.com/Azure/azure-functions-core-tools)

