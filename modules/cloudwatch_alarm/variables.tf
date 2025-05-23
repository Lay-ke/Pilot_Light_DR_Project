variable "active_dr_sns_topic_arn" {
  description = "The name of the active DR SNS topic"
  type        = string
  
}

variable "asg_name" {
  description = "The name of the Auto Scaling Group"
  type        = string
}

variable "domain_health_check_id" {
  description = "The ID of the Route53 Health Check"
  type        = string
}