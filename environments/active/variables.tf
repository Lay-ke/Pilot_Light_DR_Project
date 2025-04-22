variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-demo-cluster"
}

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}


variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# variable "public_subnets_cidrs" {
#   type = list(object({
#     cidr = string
#     az   = string
#     name = string
#   }))
# }

# variable "private_subnets_cidrs" {
#   type = list(object({
#     cidr = string
#     az   = string
#     name = string
#   }))
# }


# EKS Variables
variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.32"
}

# Node Group Variables
variable "node_group_name" {
  description = "Name of the node group"
  type        = string
  default     = "workers"
}

variable "node_instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "enable_cluster_autoscaler" {
  description = "Whether to enable cluster autoscaler"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}


variable "instance_type" {
  type = string
}

variable "db_instance_arn" {
  description = "RDS instance ARN"
  type        = string
  default     = "value"
}

variable "promote_replica_lambda_arn" {
  description = "The arn of the Lambda function to promote read replica"
  type        = string
  default     = "arn:aws:lambda:eu-central-1:711387121692:function:promote_read_replica_function"
}

variable "update_asg_lambda_arn" {
  description = "The arn of the Lambda function to update"
  type        = string
  default     = "arn:aws:lambda:eu-central-1:711387121692:function:update_asg_capacity_function"
}