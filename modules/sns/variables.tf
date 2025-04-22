variable "sns_topic_name" {
  description = "The name of the SNS topic"
  type        = string
  default     = "active-dr-sns-topic"
}

variable "replica_promotion_lambda_arn" {
  description = "The ARN of the Lambda function in the DR region for promoting read replicas"
  type        = string
  
}

variable "update_asg_lambda_arn" {
  description = "The ARN of the Lambda function in the DR region for updating ASG capacity"
  type        = string
}