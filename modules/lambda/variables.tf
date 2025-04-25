variable "update_asg_lambda_name" {
  description = "The name of the Lambda function to update"
  type        = string
  default = "update_asg_capacity_function"
}

variable "promote_replica_lambda_name" {
  description = "The name of the Lambda function to promote read replica"
  type        = string
  default = "promote_read_replica_function"
}

variable "increase_by" {
  description = "The number of instances to increase in the ASG"
  type        = number
  default     = 3
}

variable "min_increase_by" {
  description = "The minimum number of instances to increase in the ASG"
  type        = number
  default     = 1
}

variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type        = string
}

variable "db_instance_id" {
  description = "The DB instance identifier"
  type        = string 
}

variable "update_asg_role_arn" {
  description = "The arn for update asg role"
}

variable "replica_promotion_role_arn" {
  description = "The arn for replica promotion role"
}

variable "active_dr_sns_topic_arn" {
  description = "The ARN of the SNS topic"
  type        = string 
}

variable "destroy_primary_instance_lambda_name" {
  description = "The name of the Lambda function to destroy primary instance"
  type        = string
  default = "replica_destroy_primary_instance_function"
  
}

variable "destroy_primary_instance_role_arn" {
  description = "The arn for destroy primary instance role"
}

variable "new_replica_db_id" {
  description = "The name of the new read replica"
  type        = string
  default     = "primary_replica_instance"
}

variable "primary_db_id" {
  description = "The DB instance identifier of the primary instance"
  type        = string
}

variable "dr_db_id" {
  description = "The DB instance identifier of the DR instance"
  type        = string
  
}

variable "primary_region" {
  description = "The primary region for the RDS instance"
  type        = string
  default     = "us-east-1"
  
}