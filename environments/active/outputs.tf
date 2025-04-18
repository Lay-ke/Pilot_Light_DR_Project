output "db_instance_id" {
  description = "The DB instance identifier"
  value       = module.rds.db_instance_id
}

output "db_instance_arn" {
  description = "The DB instance identifier"
  value       = module.rds.db_instance_arn
}

output "kms_multi_region_key" {
  description = "Rds multi region kms key"
  value       = module.kms.kms_multi_region_key
}

output "instance_profile_arn" {
  description = "Name of the EC2 instance profile"
  value       = module.iam.instance_profile_arn
}


