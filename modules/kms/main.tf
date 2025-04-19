provider "aws" {
  region = var.replica_region  # Target region for the replica
  alias  = "replica"
}

data "aws_caller_identity" "current" {}


resource "aws_kms_key" "primary_region_key" {
  description        = "A multi-region KMS key"
  deletion_window_in_days = 30
#   enable_key_rotation = true
  multi_region        = true  # Make the key multi-region
  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "rds-key-policy",
    "Statement": [
      {
        "Sid": "Allow access through RDS for all principals in the account that are authorized to use RDS",
        "Effect": "Allow",
        "Principal": {
          Service = "rds.amazonaws.com"
        },
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:DescribeKey"
        ],
        "Resource": "*",
      },
      {
        "Sid": "Allow direct access to key metadata to the account",
        "Effect": "Allow",
        "Principal": {
          "AWS" = data.aws_caller_identity.current.arn
        },
        "Action": [
          "kms:*"
        ],
        "Resource": "*"
      },
      {
        "Sid": "Allow specific IAM user to access the key",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::711387121692:user/cli_user"  # Replace with the actual IAM user ARN
        },
        "Action": [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:DescribeKey"
        ],
        "Resource": "*"
      }
      ]
})
  tags = {
    Name = "multi-region-replica-key"
  }
}

# Replicate the multi-region key to the new region
resource "aws_kms_replica_key" "replica_region_key" {
  provider         = aws.replica  # Use the replica provider here
  primary_key_arn   = aws_kms_key.primary_region_key.arn  # Reference the primary key
  description      = "Replica of the multi-region key"
  deletion_window_in_days = 7
  policy = aws_kms_key.primary_region_key.policy  # Use the same policy as the primary key

  tags = {
    Name = "multi-region-replica-key"
  }
}
