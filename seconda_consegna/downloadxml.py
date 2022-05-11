import json
import boto3

def lambda_handler(event, context):
    
    try:
        s3 = boto3.resource('s3')
        id = event["queryStringParameters"]["id"]
    except:
        return "Missing id parameter"
    
    try:
        fileName = "race" + str(id)
        filePath = "races/" + fileName + "/" + fileName + ".xml"
        obj = s3.Object("ack-races", filePath)
        xmlstr = obj.get()['Body'].read()
    except:
        return "Wrong race id"
    
    return {
        'statusCode': 200,
        'body': xmlstr
    }
