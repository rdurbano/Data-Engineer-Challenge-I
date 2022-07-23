import logging
import pyodbc
import os
import azure.functions as func
import struct
import pandas as pd
import json

def main(req: func.HttpRequest) -> func.HttpResponse:
    
    try:      
        logging.info('Python HTTP trigger function processed a request.')
        server="jobsity-server.database.windows.net"
        database="jobsity-database"
        driver="{ODBC Driver 17 for SQL Server}"
        connection_string = 'DRIVER='+driver+';SERVER='+server+';DATABASE='+database
        
        if os.getenv("MSI_SECRET"):
            conn = pyodbc.connect(connection_string+';Authentication=ActiveDirectoryMsi')

        else:
            print("Local execution")
            # conn = pyodbc.connect('DRIVER='+driver+';SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
        
        switcher = {
                    "vw_latest_region": "Select * From dw.vw_latest_region",
                    "trips_process": "Select * From log.trips_process",
                    "vw_trips_average_per_week": "Select * From dw.vw_trips_average_per_week",
                    "vw_regions_per_cheap_mobile_datasource": "Select * From dw.vw_regions_per_cheap_mobile_datasource"}

        query = switcher.get(req.params.get('query'))
        
        df = pd.read_sql(query,conn)
        result = df.to_json(orient="records")
        parsed = json.loads(result)
        return func.HttpResponse(str(parsed))

    except Exception as ex:
        return func.HttpResponse(str(ex))

 