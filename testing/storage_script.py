import os, uuid
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

try:
    print("Connecting to Azure Storage...")

    account_url = "https://<storageaccount>.blob.core.windows.net"
    default_credential = DefaultAzureCredential()

    print("Connected to Azure Storage")

    #Create BlobService object
    blob_service_client = BlobServiceClient(account_url, credential=default_credential)

    #Create a unique name for the container
    container_name = str(uuid.uuid4())

    #Create the container
    container_client = blob_service_client.create_container(container_name)

    #Create local directory to hold blob data
    local_path = "./data"
    os.mkdir(local_path)

    #Create file in local data directoy to upload and download
    local_file_name = str(uuid.uuid4()) + ".txt"
    upload_file_path = os.path.join(local_path, local_file_name)

    #Write text to the file
    file = open(upload_file_path, 'w')
    file.write("Hello, World!")
    file.close()

    #Create a blob client using local file name as name for the blob
    blob_client = blob_service_client.get_blob_client(container=container_name, blob=local_file_name)

    print("\nUploading to Azure Storage as blob:\n\t" + local_file_name)

    #Upload the created file
    with open(file=upload_file_path, mode="rb") as data:
        blob_client.upload_blob(data)

    print("Deleting blob container...")
    container_client.delete_container()

    print("Deleting the local source and downloaded files...")
    os.remove(upload_file_path)
    os.rmdir(local_path)

    print("Done")

except Exception as ex:
    print('Exception:')
    print(ex)