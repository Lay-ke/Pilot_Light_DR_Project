# IAM Role For EC2 Instance
resource "aws_iam_role" "instance_role" {
  name               = "${var.instance_role_name}-${var.environment}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "readonly" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# attaching s3 read-only access policy
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# attaching secrets manager read-only access policy
resource "aws_iam_role_policy_attachment" "secrets_manager_access" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# attaching rds read-only access policy
resource "aws_iam_role_policy_attachment" "rds_full_access" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.instance_role_name}-instance-profile"
  role = aws_iam_role.instance_role.name
}

##############################################################################################################################################
# IAM Role for Update ASG Lambda Function
resource "aws_iam_role" "update_asg_role" {
  name = "UpdateASG-${var.lambda_role_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_autoscaling_policy" {
  name        = "lambda-autoscaling-policy"
  description = "IAM policy to allow Lambda to update and describe Auto Scaling groups"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:DescribeAutoScalingInstances"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "asg_lambda_autoscaling_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_autoscaling_policy.arn
  role       = aws_iam_role.update_asg_role.name
}

resource "aws_iam_role_policy_attachment" "asg_lambda_basic_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.update_asg_role.name
}

resource "aws_iam_role_policy_attachment" "asg_lambda_cloudwatch_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role      = aws_iam_role.update_asg_role.name
}

#################################################################################################################################################
# IAM ROle for Replica Promotion Lambda Function
resource "aws_iam_role" "replica_promotion_role" {
  name = "ReplicaPromotion-${var.lambda_role_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "rds_promotion_policy" {
  name        = "rds-promotion-policy"
  description = "IAM policy to allow Lambda to promote rds replica to primary"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "rds:PromoteReadReplica",
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds:DescribeDBClusterSnapshots"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_lambda_cloudwatch_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role      = aws_iam_role.replica_promotion_role.name
}

resource "aws_iam_role_policy_attachment" "rds_lambda_basic_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.replica_promotion_role.name
}




# EKS Cluster IAM Role
# resource "aws_iam_role" "eks_cluster_role" {
#   name = "${var.cluster_name}-cluster-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "eks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks_cluster_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_service_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
#   role       = aws_iam_role.eks_cluster_role.name
# }

# # EKS Node Group IAM Role
# resource "aws_iam_role" "eks_node_role" {
#   name = "${var.cluster_name}-node-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eks_node_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks_node_role.name
# }

# resource "aws_iam_role_policy_attachment" "ec2_container_registry_read" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks_node_role.name
# }

# # Optional: Create a custom policy for cluster autoscaler
# resource "aws_iam_policy" "cluster_autoscaler" {
#   count       = var.enable_cluster_autoscaler ? 1 : 0
#   name        = "${var.cluster_name}-cluster-autoscaler-policy"
#   description = "Policy for cluster autoscaler"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "autoscaling:DescribeAutoScalingGroups",
#           "autoscaling:DescribeAutoScalingInstances",
#           "autoscaling:DescribeLaunchConfigurations",
#           "autoscaling:DescribeTags",
#           "autoscaling:SetDesiredCapacity",
#           "autoscaling:TerminateInstanceInAutoScalingGroup",
#           "ec2:DescribeLaunchTemplateVersions"
#         ]
#         Resource = "*"
#         Effect   = "Allow"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
#   count      = var.enable_cluster_autoscaler ? 1 : 0
#   policy_arn = aws_iam_policy.cluster_autoscaler[0].arn
#   role       = aws_iam_role.eks_node_role.name
# }