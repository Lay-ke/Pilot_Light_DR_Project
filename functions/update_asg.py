import json
import boto3
import logging
import os

# Initialize the Auto Scaling client
autoscaling_client = boto3.client('autoscaling')

def lambda_handler(event, context):
    # Get the Auto Scaling Group name, capacity increase, and minimum size increase from the event
    asg_name = event.get('asg_name', os.environ.get('asg_name'))  # Default to the passed ASG name
    increase_by = int(event.get('increase_by', os.environ.get('increase_by')))  # Default to increasing by the passed value
    min_increase_by = int(event.get('min_increase_by', os.environ.get('min_increase_by')))  # Default to increasing min size by the passed value
    
    if not asg_name:
        print("Error: asg_name is not provided.")
        return {
            'statusCode': 400,
            'body': json.dumps('Error: asg_name is required')
        }
    
    try:
        # Describe the Auto Scaling Group to get the current settings
        response = autoscaling_client.describe_auto_scaling_groups(
            AutoScalingGroupNames=[asg_name]
        )
        
        # Extract the current desired capacity and minimum size from the response
        if not response['AutoScalingGroups']:
            print(f"Error: Auto Scaling Group {asg_name} not found.")
            return {
                'statusCode': 404,
                'body': json.dumps(f"Error: Auto Scaling Group {asg_name} not found")
            }
        
        current_capacity = response['AutoScalingGroups'][0]['DesiredCapacity']
        current_min_size = response['AutoScalingGroups'][0]['MinSize']
        
        # Calculate the new desired capacity and minimum size
        new_capacity = increase_by
        new_min_size = min_increase_by
        
        # Update the Auto Scaling Group with the new desired capacity and minimum size
        update_response = autoscaling_client.update_auto_scaling_group(
            AutoScalingGroupName=asg_name,
            DesiredCapacity=new_capacity,
            MinSize=new_min_size
        )
        
        logging.info(f"Successfully updated ASG {asg_name}: Desired Capacity: {new_capacity}, Min Size: {new_min_size}")
        print(f"Successfully updated ASG {asg_name}: Desired Capacity: {new_capacity}, Min Size: {new_min_size}")
        
        return {
            'statusCode': 200,
            'body': json.dumps(f"Auto Scaling Group {asg_name} updated to desired capacity {new_capacity} and minimum size {new_min_size}.")
        }

    except Exception as e:
        logging.error(f"Error updating ASG {asg_name}: {str(e)}")
        print(f"Error updating ASG {asg_name}: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error: {str(e)}")
        }
