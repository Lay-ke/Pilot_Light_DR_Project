variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "node_group_name" {
  description = "Name of the node group"
  type        = string
  default     = "workers"
}

variable "node_role_arn" {
  description = "ARN of the IAM role for the node group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the node group"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type        = string
  default     = "AL2_x86_64"
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}

variable "instance_types" {
  description = "List of instance types associated with the EKS Node Group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "ec2_ssh_key" {
  description = "EC2 Key Pair name that provides access for SSH"
  type        = string
  default     = null
}

variable "source_security_group_ids" {
  description = "Security groups that are allowed to access the EC2 instances"
  type        = list(string)
  default     = []
}

variable "kubernetes_labels" {
  description = "Kubernetes labels to apply to the nodes"
  type        = map(string)
  default     = {}
}

variable "ami_release_version" {
  description = "AMI version of the EKS Node Group"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "node_group_dependencies" {
  description = "Any dependencies for the node group"
  type        = list(any)
  default     = []
}