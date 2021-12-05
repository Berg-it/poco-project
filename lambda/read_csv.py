import json

def lambda_handler(event, context):
    message = 'read csv lambda'
    response = {
        "statusCode": 200,
        "headers": {},
        "body": json.dumps({
            "message": "This is the message in a JSON object."
        })
    }
    return response