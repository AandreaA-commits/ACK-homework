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
    all_organisation = root.findall('./ClassResult/PersonResult/Organisation', _ns)
    already_seen_organisations = []
    response = []
    
    for x in all_organisation:
        if x.find('./Id', _ns).text in already_seen_organisations:
            continue
        already_seen_organisations.append(x.find('./Id', _ns).text)
        organisation = {}
        organisation["id"] = x.find('./Id', _ns).text
        organisation["name"] = x.find('./Name', _ns).text
        organisation["country"] = x.find('./Country', _ns).text
        
        response.append(organisation)
    
    
    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }
