import json
import boto3
import boto3.dynamodb.conditions as conditions

def lambda_handler(event, context):
    if "body" in event:
        json_input = json.loads(event["body"])
        '''
        json_input = {}
        json_input['email'] = "a@b.com"
        json_input['race_name'] = "Vecchi"
        json_input['race_date'] = 15001
        '''
        if not("email" in json_input and "race_name" in json_input and "race_date" in json_input):
            return "bad body"
        
        response = "mi sono dimenticato di dare un valore a response"
            
        email = json_input["email"]
        race_date = json_input["race_date"]
        race_name = json_input["race_name"]
        
        
        #AWS DynamoDB
        ddb = boto3.resource("dynamodb")
        
        #get race_id and token
        update_result = ddb.Table("ACK-metadata").update_item(
            Key={
                    "_id": "nextRaceId",
                },
            UpdateExpression="SET #m = #m + :increment",
            ExpressionAttributeNames={
                "#m": "value",
            },
            ExpressionAttributeValues={
                ":increment": 1
            },
            ConditionExpression=conditions.Attr("_id").exists(),
            ReturnValues="UPDATED_NEW"
        )
        race_id = update_result["Attributes"]["value"]
        token = "token" + str(race_id)
        
        response = '{"token": "' + token + '", "race_id": "' + str(race_id) + '"}'
        
        
        
        #save race_id and token and stuff the user gave us in db
        
        new_race = {}
        new_race['token'] = token
        new_race['race_id'] = race_id
        new_race['email'] = email
        new_race['race_date'] = race_date
        new_race['race_name'] = race_name
        
        list_with_new_race = [new_race]
        
        
        update_result = ddb.Table("ACK-races").update_item(
            Key={
                    "_id": str(race_id),
                },
            UpdateExpression="""
            SET 
            #e= :email,
            #n = :race_name,
            #d = :race_date,
            #t = :token
            """,
            ExpressionAttributeNames={
                "#e": "email",
                "#n": "race_name",
                "#d": "race_date",
                "#t": "token",
            },
            ExpressionAttributeValues={
                ":race_name": race_name,
                ":race_date": race_date,
                ":email": email,
                ":token": token
            },
            ReturnValues="UPDATED_NEW"
        )
        
    
        return {
            'statusCode': 200,
            'body': response
        }
    else:
        return {
            'statusCode': 200,
            'body': "there is no body"
        }
