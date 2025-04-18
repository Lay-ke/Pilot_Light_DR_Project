# variable "cluster_name" {}
# variable "cluster_version" {}
# variable "subnet_ids" {
#   type = list(string)
# }
# variable "vpc_id" {}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "endpoint_private_access" {
  description = "Whether the EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Whether the EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS cluster"
  type        = list(string)
  default     = []
}

variable "create_cluster_security_group" {
  description = "Whether to create a security group for the cluster"
  type        = bool
  default     = false
}

variable "enabled_cluster_log_types" {
  description = "List of EKS cluster log types to enable"
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "tags" {
  description = "Tags to apply to the EKS cluster"
  type        = map(string)
  default     = {}
}

variable "cluster_dependencies" {
  description = "List of resources the cluster depends on"
  type        = list(any)
  default     = []
}

