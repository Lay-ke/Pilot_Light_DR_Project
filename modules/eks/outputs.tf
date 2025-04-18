output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = aws_eks_cluster.main.id
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS API server"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group ID of the EKS cluster"
  value       = var.create_cluster_security_group == false ? var.security_group_ids : null
  #value       = var.create_cluster_security_group ? aws_security_group.cluster[0].id : null
}

output "cluster_oidc_issuer_url" {
  description = "URL of the OIDC provider for the EKS cluster"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}