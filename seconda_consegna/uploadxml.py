import json
import boto3
import boto3.dynamodb.conditions as conditions
from boto3.dynamodb.conditions import Key

def lambda_handler(event, context):
    url_params = event["queryStringParameters"]
    try:
        token = url_params["token"]
        body = event['body']
    except:
        return "Missing token parameter or body"
    
    #GET ID THROUGH DYNAMODB
    ddb = boto3.resource("dynamodb")
    scan_result = ddb.Table("ACK-races").scan(
        FilterExpression=Key('token').eq(token)
        )
    scan_result = scan_result.get('Items', [])[0]
    id = scan_result["_id"]
    
    #OVERWRITE PREVIOUS FILE OR MAKE A NEW ONE
    s3 = boto3.resource("s3")
    fileName = "race" + str(id)
    filePath = "races/" + fileName + "/" + fileName + ".xml"
    s3.Bucket("ack-races").put_object(Key=filePath, Body=body)
    
    return {
        'statusCode': 200,
        'body': "ok"
    }
