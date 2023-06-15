import boto3
import json

security_control_id = "KMS.4"
client = boto3.client('securityhub')
account_id = boto3.client('sts').get_caller_identity().get('Account')

# TODO tiene que estar ACTIVE
response = client.get_findings(
    Filters={
        'AwsAccountId': [
            {
                'Value': account_id,
                'Comparison': 'EQUALS'
            }
        ],
        'ComplianceStatus': [
            {
                'Value': 'FAILED',
                'Comparison': 'EQUALS'
            }
        ],
        'SeverityLabel': [
            {
                'Value': 'HIGH',
                'Comparison': 'EQUALS'
            },
        ],
        'ComplianceSecurityControlId': [
            {
                'Value': security_control_id,
                'Comparison': 'EQUALS'
            },
        ],
    },
    # NextToken='string',
    MaxResults=1
)

# save response into a file
with open('findings.json', 'w') as outfile:
    json.dump(response, outfile, indent=4, sort_keys=True, default=str)

# print the value of "Id" thats part of the key "Resources", for every finding
for finding in response['Findings']:
    print(finding['Resources'][0]['Id'])
