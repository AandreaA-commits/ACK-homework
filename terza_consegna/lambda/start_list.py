import json
import xml.etree.ElementTree as ET
import boto3

def lambda_handler(event, context):
    
    s3 = boto3.resource('s3')
    try:
        id = event["queryStringParameters"]["id"]
        class_id = event["queryStringParameters"]["class"]
    except:
        return {
            'statusCode': 404,
            'body': json.dumps("ERROR: id or class parameter not specified.")
        }
    
    try:
        fileName = "race" + str(id)
        filePath = "races/" + fileName + "/startList" + str(id) + ".xml"
        obj = s3.Object("ack-races", filePath)
        xmlstr = obj.get()['Body'].read()
    except:
        return {
            'statusCode': 500,
            'body': json.dumps("ERROR: Id not found.")
        }
    
    root = ET.fromstring(xmlstr)
    _ns = {'':'http://www.orienteering.org/datastandard/3.0'}
    class_names_elements = root.findall("./ClassStart/Class[Id='" + class_id + "']/../PersonStart/Person", _ns)
    
    person_results = [x for x in class_names_elements]
    response = []
    for p in person_results:
        surname = p.find('./Name/Family', _ns).text
        name = p.find('./Name/Given', _ns).text
        
        p_result = {}
        p_result["surname"] = surname
        p_result["name"] = name
        
        response.append(p_result)
    
    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }
