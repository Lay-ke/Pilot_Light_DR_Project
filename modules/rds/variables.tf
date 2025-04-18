variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default     = "plight"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "layke"
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  default     = "passworddb"

}

variable "kms_key_arn" {}

variable "rds_sg_id" {
  description = "The security group ID for the RDS instance"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}

variable "environment" {
  description = "The environment for the RDS instance (e.g., dev, prod)"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy the RDS instance"
  type        = string
}

variable "db_instance_arn" {
  description = "The DB instance identifier"
  type        = string
}