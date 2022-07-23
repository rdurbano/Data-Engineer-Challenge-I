from ast import For
import os, uuid
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient, __version__

try:
    entries = 3
    local_file_path =r"C:\Users\Usuario\Desktop\jobsity\documentation"
    local_file_name = "trips.csv"
    blob_service_client = BlobServiceClient.from_connection_string("GET CONNECTION STRING ON KEY VAULT")
    
    for i in range(entries):
        destination_file_name = f"trips_{i}.csv"
        blob_client = blob_service_client.get_blob_client(container="landing", blob=destination_file_name)
        with open(os.path.join(local_file_path,local_file_name), "rb") as data:
            blob_client.upload_blob(data)

except Exception as ex:
    print(ex)
