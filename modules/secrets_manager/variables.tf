variable "db_instance_endpoint" {
  description = "The connection endpoint for the DB instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
  default = "plight"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}
