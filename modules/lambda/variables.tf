variable "update_asg_lambda_name" {
  description = "The name of the Lambda function to update"
  type        = string
  default = "update_asg_capacity"
}

variable "promote_replica_lambda_name" {
  description = "The name of the Lambda function to promote read replica"
  type        = string
  default = "promote_read_replica"
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
  description = "The role arn for update asg role"
}

variable "replica_promotion_role_arn" {
  description = "The role arn for replica promotion role"
}