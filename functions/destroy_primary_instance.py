import boto3
import os

rds = boto3.client('rds')

OLD_PRIMARY_ID = os.getenv("OLD_PRIMARY_DB_ID") 
NEW_REPLICA_ID = os.getenv("NEW_REPLICA_DB_ID")
DR_DB_ID = os.getenv("DR_DB_ID")

def lambda_handler(event, context):
    # Delete old primary
    try:
        print(f"Deleting old DB instance: {OLD_PRIMARY_ID}")
        rds.delete_db_instance(
            DBInstanceIdentifier=OLD_PRIMARY_ID,
            SkipFinalSnapshot=True,
            DeleteAutomatedBackups=True
        )
    except Exception as e:
        print(f"Error deleting DB: {str(e)}")

    # Create new replica from DR
    try:
        print(f"Creating replica in original region from DR: {DR_DB_ID}")
        rds.create_db_instance_read_replica(
            DBInstanceIdentifier=NEW_REPLICA_ID,
            SourceDBInstanceIdentifier=DR_DB_ID,
            SourceRegion="your-dr-region"
        )
    except Exception as e:
        print(f"Error creating replica: {str(e)}")

    return {"status": "done"}
