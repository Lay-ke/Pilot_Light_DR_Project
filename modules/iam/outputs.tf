# output "eks_cluster_role_arn" {
#   description = "ARN of the EKS cluster IAM role"
#   value       = aws_iam_role.eks_cluster_role.arn
# }

# output "eks_node_role_arn" {
#   description = "ARN of the EKS node IAM role"
#   value       = aws_iam_role.eks_node_role.arn
# }

# output "eks_node_role_name" {
#   description = "Name of the EKS node IAM role"
#   value       = aws_iam_role.eks_node_role.name
# }

output "instance_profile_arn" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.this.arn
}

output "update_asg_role_arn" {
  description = "Update_asg role"
  value = aws_iam_role.update_asg_role.arn
}

output "replica_promotion_role_arn" {
  description = "Rds replica promotion role"
  value = aws_iam_role.replica_promotion_role.arn
}