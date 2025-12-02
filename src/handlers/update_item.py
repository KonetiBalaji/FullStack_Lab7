import json
import boto3
import os
from datetime import datetime

# Initialize DynamoDB client with X-Ray tracing
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.core import patch_all

patch_all()

dynamodb = boto3.resource('dynamodb')
table_name = os.environ['TABLE_NAME']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    """
    Update an existing item in DynamoDB
    PUT /items/{id}
    """
    try:
        # Get item ID from path parameters
        item_id = event.get('pathParameters', {}).get('id')
        
        if not item_id:
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'error': 'Missing item ID in path'
                })
            }
        
        # Parse request body
        body = json.loads(event.get('body', '{}'))
        
        # Check if item exists
        existing_item = table.get_item(Key={'id': item_id})
        if 'Item' not in existing_item:
            return {
                'statusCode': 404,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'error': 'Item not found'
                })
            }
        
        # Build update expression
        update_expression = "SET updatedAt = :updatedAt"
        expression_attribute_values = {
            ':updatedAt': datetime.utcnow().isoformat()
        }
        
        # Add updatable fields
        if 'name' in body:
            update_expression += ", #name = :name"
            expression_attribute_values[':name'] = body['name']
        if 'description' in body:
            update_expression += ", description = :description"
            expression_attribute_values[':description'] = body['description']
        if 'status' in body:
            update_expression += ", #status = :status"
            expression_attribute_values[':status'] = body['status']
        if 'category' in body:
            update_expression += ", category = :category"
            expression_attribute_values[':category'] = body['category']
        if 'priority' in body:
            update_expression += ", priority = :priority"
            expression_attribute_values[':priority'] = body['priority']
        
        # Expression attribute names for reserved words
        expression_attribute_names = {}
        if 'name' in body:
            expression_attribute_names['#name'] = 'name'
        if 'status' in body:
            expression_attribute_names['#status'] = 'status'
        
        # Update item in DynamoDB
        update_params = {
            'Key': {'id': item_id},
            'UpdateExpression': update_expression,
            'ExpressionAttributeValues': expression_attribute_values,
            'ReturnValues': 'ALL_NEW'
        }
        
        if expression_attribute_names:
            update_params['ExpressionAttributeNames'] = expression_attribute_names
        
        response = table.update_item(**update_params)
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': 'Item updated successfully',
                'item': response['Attributes']
            })
        }
        
    except Exception as e:
        print(f"Error updating item: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Internal server error',
                'message': str(e)
            })
        }

