import boto3
import json

# Initialize the EC2 client
ec2 = boto3.client('ec2')

# Use describe_subnets method to get the subnet details
response = ec2.describe_subnets()

# Initialize an empty dictionary to store the subnets
subnet_dict = {}

# Iterate through the subnets
for subnet in response['Subnets']:
    # Add the subnet details to the dictionary
    subnet_dict[subnet['SubnetId']] = {
        "MapPublicIpOnLaunch": subnet['MapPublicIpOnLaunch']
    }

# Get the AWS account ID
sts = boto3.client('sts')
account_id = sts.get_caller_identity().get('Account')

# Create a dictionary with the account ID as the key
output_dict = {account_id: subnet_dict}

# Convert the dictionary to JSON and print it
print(json.dumps(output_dict, indent=4))

