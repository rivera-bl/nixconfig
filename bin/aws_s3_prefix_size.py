import boto3

bucket_name = 'velero-234951'
prefix = 'magi/backups/'

s3 = boto3.client('s3')
response = s3.list_objects_v2(Bucket=bucket_name, Prefix=prefix)

# Function to convert bytes to a human-readable format
def convert_bytes_to_human_readable(size_in_bytes):
    size_in_bytes = float(size_in_bytes)
    kilo_bytes = size_in_bytes / 1024
    mega_bytes = kilo_bytes / 1024
    giga_bytes = mega_bytes / 1024

    if giga_bytes >= 1:
        return f"{giga_bytes:.2f} GB"
    elif mega_bytes >= 1:
        return f"{mega_bytes:.2f} MB"
    elif kilo_bytes >= 1:
        return f"{kilo_bytes:.2f} KB"
    else:
        return f"{size_in_bytes:.2f} Bytes"

# Group objects by the subfolder
grouped_objects = {}
for obj in response.get('Contents', []):
    key_parts = obj['Key'].split('/')
    
    if len(key_parts) > 2:  # Check if there is a subfolder
        subfolder_key = '/'.join(key_parts[1:-1])
        
        if subfolder_key not in grouped_objects:
            grouped_objects[subfolder_key] = {'Folder': subfolder_key, 'TotalSize': 0}
        
        grouped_objects[subfolder_key]['TotalSize'] += obj['Size']

# Print the results
for group in grouped_objects.values():
    total_size_human_readable = convert_bytes_to_human_readable(group['TotalSize'])
    print(f"Folder: {group['Folder']}, Total Size: {total_size_human_readable}")
