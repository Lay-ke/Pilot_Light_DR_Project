import json
import boto3
import logging
import os

# Initialize the RDS client
rds_client = boto3.client('rds')

def lambda_handler(event, context):
    # The DB instance identifier of the read replica to promote
    db_instance_identifier = event.get('db_instance_identifier', os.environ.get('db_instance_identifier'))  # Default to the passed DB instance identifier

    if not db_instance_identifier:
        return {
            'statusCode': 400,
            'body': json.dumps('Error: db_instance_identifier is required')
        }
    
    try:
        # Promote the read replica to primary
        response = rds_client.promote_read_replica(
            DBInstanceIdentifier=db_instance_identifier
        )
        
        # Log the response
        logging.info(f"Successfully promoted read replica: {db_instance_identifier}")
        logging.info(f"Response: {response}")

        return {
            'statusCode': 200,
            'body': json.dumps(f"Read replica {db_instance_identifier} promoted successfully to primary.")
        }

    except Exception as e:
        logging.error(f"Error promoting read replica {db_instance_identifier}: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error: {str(e)}")
        }
