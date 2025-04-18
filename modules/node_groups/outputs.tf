output "node_group_id" {
  description = "ID of the node group"
  value       = aws_eks_node_group.main.id
}

output "node_group_arn" {
  description = "ARN of the node group"
  value       = aws_eks_node_group.main.arn
}

output "node_group_status" {
  description = "Status of the node group"
  value       = aws_eks_node_group.main.status
}

output "node_group_resources" {
  description = "Resources associated with the node group"
  value       = aws_eks_node_group.main.resources
}