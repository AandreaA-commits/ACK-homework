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
    
    user_asked_for_class = True
    
    try:
        class_id = event["queryStringParameters"]["class"]
    except:
        user_asked_for_class = False
    
    if not(user_asked_for_class):
        try:
            organisation_id = event["queryStringParameters"]["organisation"]
        except:
            return {
                'statusCode': 404,
                'body': json.dumps("ERROR: organisation or class parameters needed")
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
    
    if user_asked_for_class:
        class_names_elements = root.findall("./ClassResult/Class[Id='" + class_id + "']/../PersonResult", _ns)
    else:
        class_names_elements = root.findall("./ClassResult/PersonResult/Organisation[Id='" + organisation_id + "']/..", _ns)
        
    person_results = [x for x in class_names_elements]
    response = []
    for p in person_results:
        surname = p.find('./Person/Name/Family', _ns).text
        name = p.find('./Person/Name/Given', _ns).text
        position = p.find('./Result/Position', _ns).text
        time = p.find('./Result/Time', _ns).text
        
        p_result = {}
        p_result["surname"] = surname
        p_result["name"] = name
        p_result["position"] = position
        p_result["time"] = time
        
        response.append(p_result)
    
    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }
