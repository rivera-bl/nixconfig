# Downloads a bucket preserving the folder structure,
# decompress the files
# and open the folder with nvim
# # made in the context of browsing config rules history from s3

import os
import json
import gzip
import shutil
import boto3
import subprocess
from json.decoder import JSONDecodeError

bucket_name = 'team-secretsmanagerconfigrules-16u1f-configbucket-e46s5bspuvb9'

def download_bucket_objects(bucket_name):
    s3_client = boto3.client('s3')
    base_path = os.path.join('/tmp/fs3', bucket_name)
    os.makedirs(base_path, exist_ok=True)

    def download_object(key, path):
        local_path = path

        s3_client.download_file(bucket_name, key, local_path)

        if key.endswith('.gz'):
            extracted_path = local_path[:-3]  # Remove the '.gz' extension
            with gzip.open(local_path, 'rb') as gz_file:
                with open(extracted_path, 'wb') as file:
                    shutil.copyfileobj(gz_file, file)
            os.remove(local_path)
            local_path = extracted_path

        try:
            with open(local_path, 'r') as file:
                data = json.load(file)

            # Format the JSON with indentation
            formatted_json = json.dumps(data, indent=4)

            # Save the formatted JSON back to the file
            with open(local_path, 'w') as file:
                file.write(formatted_json)

        except JSONDecodeError:
            # Error handling for invalid JSON files
            print(f"Skipping invalid JSON file: {local_path}")

    def download_objects_recursive(prefix, path):
        response = s3_client.list_objects_v2(Bucket=bucket_name, Prefix=prefix)

        if 'Contents' in response:
            for obj in response['Contents']:
                key = obj['Key']
                obj_name = key.split('/')[-1]
                obj_name = obj_name.replace(':', '.')
                obj_path = os.path.join(path, os.path.dirname(key))
                os.makedirs(obj_path, exist_ok=True)

                if obj_name:
                    obj_path = os.path.join(obj_path, obj_name)
                    download_object(key, obj_path)

        if 'CommonPrefixes' in response:
            for prefix_entry in response['CommonPrefixes']:
                prefix = prefix_entry['Prefix']
                subdir = prefix.split('/')[-2]
                subdir = subdir.replace(':', '.')
                subdir_path = os.path.join(path, subdir)
                os.makedirs(subdir_path, exist_ok=True)

                if subdir:
                    download_objects_recursive(prefix, subdir_path)

    download_objects_recursive('', base_path)

download_bucket_objects(bucket_name)

subprocess.run(f"nvim /tmp/fs3/{bucket_name}", shell=True)
