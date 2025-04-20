locals {
  parent_dir = dirname(dirname(path.cwd))
}

resource "aws_lambda_function" "update_asg_capacity" {
    function_name = "${var.update_asg_lambda_name}-function"
    
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
  function_name = "${var.promote_replica_lambda_name}-function"
  
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