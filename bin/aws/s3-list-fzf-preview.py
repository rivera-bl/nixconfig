import sys
import boto3
import subprocess

# TODO --multi to download and open with vim
def list_and_preview_s3_objects(bucket_name):
    # Create an S3 client
    s3_client = boto3.client('s3')

    # List objects in the bucket
    response = s3_client.list_objects_v2(Bucket=bucket_name)

    # Iterate over the objects and print their names
    mykeys = ""
    if 'Contents' in response:
        for obj in response['Contents']:
            mykeys += f"{obj['Key']}\n"
    else:
        print('No objects found in the bucket.')

    command_fzf = f'''echo '{mykeys}' \
        | fzf \
        --header '| ctrl-space:preview |' \
        --prompt='{bucket_name}>' \
        --height=90% \
        --preview-window right,hidden,60% \
        --preview " \
            if [[ {{1}} == *.gz ]]; then
              aws s3api get-object --bucket {bucket_name} --key {{1}} /dev/stdout | gunzip -qc | jq . | bat -l json
            fi
            " \
            --bind 'ctrl-space:toggle-preview'
    '''

    subprocess.run(command_fzf, shell=True)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python script_name.py <bucket_name>")
        sys.exit(1)

    bucket_name = sys.argv[1]
    list_and_preview_s3_objects(bucket_name)

