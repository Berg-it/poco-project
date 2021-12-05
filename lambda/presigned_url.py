import json
import boto3
import os
import string, random

s3 = boto3.client('s3')
bucket_name = os.environ.get('bucket_name')

def lambda_handler(event, context):

    presigned_upload_url = s3.generate_presigned_url(
            ClientMethod='put_object',
            Params={
                'Bucket': bucket_name,
                'Key': randStr()+".csv",
                'ContentType': 'application/pdf',
                'Expires': 3600
            }
        )

    response = {
        "statusCode": 200,
        "headers": {},
        "body": json.dumps({"url": presigned_upload_url})
    }
    return response

def randStr(chars = string.ascii_uppercase + string.digits, N=10):
	return ''.join(random.choice(chars) for _ in range(N))    