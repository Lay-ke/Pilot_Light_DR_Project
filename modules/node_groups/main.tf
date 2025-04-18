resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-${var.node_group_name}"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  ami_type        = var.ami_type
  capacity_type   = var.capacity_type
  disk_size       = var.disk_size
  instance_types  = var.instance_types
  release_version = var.ami_release_version

  # remote_access {
  #   ec2_ssh_key               = var.ec2_ssh_key
  #   source_security_group_ids = var.source_security_group_ids
  # }

  labels = var.kubernetes_labels

  tags = merge(
    var.tags,
    {
      "Name" = "${var.cluster_name}-${var.node_group_name}"
    }
  )

  # Ensure that IAM Role permissions are created before and deleted after the EKS Node Group
  depends_on = [
    var.node_group_dependencies
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}