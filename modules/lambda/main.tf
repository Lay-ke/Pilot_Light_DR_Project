locals {
  parent_dir = dirname(dirname(path.cwd))
}

provider "aws" {
  region = var.primary_region  # Target region for the replica
  alias  = "primary"
}


resource "aws_lambda_function" "update_asg_capacity" {
    function_name = var.update_asg_lambda_name
    
    runtime = "python3.13"
    role    = var.update_asg_role_arn
    handler = "update_asg.lambda_handler"

    # Path to your zipped Lambda function code (ensure the file is in the same directory or adjust the path)
    filename         = "${local.parent_dir}/functions/update_asg.zip"
    source_code_hash = filebase64sha256("${local.parent_dir}/functions/update_asg.zip")

    # Timeout and memory settings (adjust as needed)
    timeout = 60
    memory_size = 128
    environment {
        variables = {
            increase_by     = var.increase_by
            asg_name        = var.asg_name
            min_increase_by = var.min_increase_by
        }
    }
}

# Lambda function to promote read replica to primary
resource "aws_lambda_function" "promote_read_replica" {
  function_name = var.promote_replica_lambda_name
  
  runtime = "python3.13"
  role    = var.replica_promotion_role_arn
  handler = "replica_promotion.lambda_handler"

  # Path to your zipped Lambda function code (ensure the file is in the same directory or adjust the path)
  filename         = "${local.parent_dir}/functions/replica_promotion.zip"
  source_code_hash = filebase64sha256("${local.parent_dir}/functions/replica_promotion.zip")

  # Timeout and memory settings (adjust as needed)
  timeout = 60
  memory_size = 128
  environment {
    variables = {
      db_instance_identifier = var.db_instance_id
    }
  }
  
}

# Lambda function to destroy primary instance and create new read replica in primary region
resource "aws_lambda_function" "destroy_primary_instance" {
  # Use the primary region provider for this function
  provider = aws.primary
  function_name = var.destroy_primary_instance_lambda_name
  
  runtime = "python3.13"
  role    = var.destroy_primary_instance_role_arn
  handler = "destroy_primary_instance.lambda_handler"

  # Path to your zipped Lambda function code (ensure the file is in the same directory or adjust the path)
  filename         = "${local.parent_dir}/functions/destroy_primary_instance.zip"
  source_code_hash = filebase64sha256("${local.parent_dir}/functions/destroy_primary_instance.zip")

  # Timeout and memory settings (adjust as needed)
  timeout = 60
  memory_size = 128
  environment {
    variables = {
      OLD_PRIMARY_DB_ID = var.primary_db_id
      NEW_REPLICA_DB_ID = var.new_replica_db_id
      DR_DB_ID = var.dr_db_id
    }
  }
  
}


# Grant SNS permission to invoke the Lambda function in the DR region
resource "aws_lambda_permission" "sns_lambda_permission_promote_read_replica" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "sns.amazonaws.com"
  function_name = aws_lambda_function.promote_read_replica.function_name
  source_arn    = var.active_dr_sns_topic_arn
}

resource "aws_lambda_permission" "sns_lambda_permission_update_asg" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "sns.amazonaws.com"
  function_name = aws_lambda_function.update_asg_capacity.function_name
  source_arn    = var.active_dr_sns_topic_arn
}