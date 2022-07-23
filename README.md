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
