terraform {
  backend "s3" {
    bucket  = "pl-terraform-buck-1"
    key     = "terraform-state/prod/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
    # dynamodb_table = "terraform-state-lock-${terraform.workspace}"   // The name of your DynamoDB table for state locking
    acl = "bucket-owner-full-control"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.1"
    }
  }
}