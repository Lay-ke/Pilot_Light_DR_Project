variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "enable_cluster_autoscaler" {
  description = "Whether to enable cluster autoscaler IAM policy"
  type        = bool
  default     = false
}

variable "instance_role_name" {
  description = "Name of the EC2 instance role"
  type        = string
  default     = "PLight"

}

variable "environment" {
  description = "Environment name"
  type        = string
  
}

variable "lambda_role_name" {
  description = "Name of the Lambda role"
  type        = string
  default     = "PLightLambdaRole"
}