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

output "update_asg_role_arn" {
  value = module.iam.update_asg_role_arn
}

output "replica_promotion_role_arn" {
  value = module.iam.replica_promotion_role_arn
}

output "destroy_primary_instance_role_arn" {
  value = module.iam.destroy_primary_instance_role_arn
}

output "active_dr_sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = module.sns.active_dr_sns_topic_arn
}

output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = module.acm.certificate_arn
}

output "primary_db_name" {
  description = "The name of the primary DB instance"
  value       = module.rds.db_primary_name
}

output "replica_db_name" {
  description = "The name of the read replica DB instance"
  value       = module.rds.db_replica_name
}