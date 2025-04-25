output "db_instance_id" {
  description = "The DB instance identifier"
  value       = length(aws_db_instance.this) > 0 ? aws_db_instance.this[0].id : null
}

output "db_instance_arn" {
  description = "The DB instance identifier"
  value       = length(aws_db_instance.this) > 0 ? aws_db_instance.this[0].arn : null
}

output "db_replica_name" {
  description = "RDS read replica name"
  value = "${var.db_name}-replica"
}

output "db_primary_name" {
  description = "RDS primary instance name"
  value = "${var.db_name}-instance"
}

output "db_instance_endpoint" {
  description = "The connection endpoint for the DB instance"
  value       = length(aws_db_instance.this) > 0 ? split(":", aws_db_instance.this[0].endpoint)[0] : split(":", aws_db_instance.read_replica[0].endpoint)[0]
  sensitive   = false
}

output "db_name" {
  description = "The name of the database to create"
  value       = var.db_name
  sensitive   = true
}

output "db_username" {
  description = "The username for the database"
  value       = var.db_username
  sensitive   = true
}

output "db_password" {
  description = "The password for the database"
  value       = var.db_password
  sensitive   = true
}