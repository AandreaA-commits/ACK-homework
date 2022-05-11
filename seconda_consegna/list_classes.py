import json
import xml.etree.ElementTree as ET
import boto3

def lambda_handler(event, context):
    
    s3 = boto3.resource('s3')
    
    try:
        id = event["queryStringParameters"]["id"]
    except:
        return {
            'statusCode': 404,
            'body': json.dumps("ERROR: id parameter not specified.")
        }
    
    try:
        fileName = "race" + str(id)
        filePath = "races/" + fileName + "/" + fileName + ".xml"
        obj = s3.Object("ack-races", filePath)
        xmlstr = obj.get()['Body'].read()
    except:
        return {
            'statusCode': 500,
            'body': json.dumps("ERROR: Id not found.")
        }
    
    root = ET.fromstring(xmlstr)
    _ns = {'':'http://www.orienteering.org/datastandard/3.0'}
    class_names_elements = root.findall('./ClassResult/Class/Name', _ns)
    classes = [x.text for x in class_names_elements]
    
    return {
        'statusCode': 200,
        'body': json.dumps(classes)
    }
