output "kms_multi_region_key" {
  description = "KMS Key ID for RDS primary instance"
    value       = aws_kms_replica_key.replica_region_key.arn
}

output "kms_primary_key" {
    description = "KMS Key ID for RDS primary instance"
    value       = aws_kms_key.primary_region_key.arn
}