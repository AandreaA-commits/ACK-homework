import json
import boto3

def lambda_handler(event, context):
    
    #AWS DynamoDB
    tableName = "ACK-races"
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(tableName)

    response = table.scan()
    data = response['Items']
     
    data = table.scan(
        ProjectionExpression="#id, email, race_name, race_date",
        ExpressionAttributeNames={
                "#id": "_id",
            },
        )
        
    return data["Items"]
