import boto3

# Initialize the EC2 client
ec2 = boto3.client('ec2')

# Use describe_subnets method to get the subnet details
response = ec2.describe_subnets()

# Iterate through the subnets
for subnet in response['Subnets']:
    # Print the MapPublicIpOnLaunch attribute
    print("Subnet ID:", subnet['SubnetId'])
    print("MapPublicIpOnLaunch:", subnet['MapPublicIpOnLaunch'])

# obtain the MapPublicIpOnLaunch from a describe-subnets

# import boto3
# import json

# def get_account_id():
#     sts_client = boto3.client('sts')
#     return sts_client.get_caller_identity()['Account']

# def get_clusters():
#     eks_client = boto3.client('eks')
#     return [{'ClusterName': cluster['name'], 'ClusterVersion': cluster['version']}
#     for cluster in (eks_client.describe_cluster(name=cluster_name)['cluster']
#       for cluster_name in eks_client.list_clusters()['clusters'])]

# def main():
#     output = {'AccountId': get_account_id(), 'Clusters': get_clusters()}
#     with open('eks_cluster_versions.json', 'w') as f:
#         json.dump(output, f)

# if __name__ == "__main__":
#     main()


