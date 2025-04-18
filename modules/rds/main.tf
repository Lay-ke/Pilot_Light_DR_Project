# RDS DBInstance
locals {
  env = var.environment == "prod" ? true : false
}

provider "aws" {
  region = var.aws_region
  alias = "replica"
}

resource "aws_db_instance" "this" {
  count                   = local.env ? 1 : 0
  identifier              = "${var.db_name}-instance"
  allocated_storage       = 20
  instance_class          = "db.t3.micro"
  engine                  = "mysql"
  backup_retention_period = 2 # Number of days to retain backups
  username                = var.db_username
  password                = var.db_password
  kms_key_id = var.kms_key_arn
  apply_immediately       = true
  skip_final_snapshot     = true
  db_name                 = var.db_name
  publicly_accessible     = false
  storage_type            = "gp2"
  multi_az                = true
  vpc_security_group_ids  = [var.rds_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.id
  storage_encrypted       = true
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]
}

# Creating read replica
resource "aws_db_instance" "read_replica" {
  provider = aws.replica
  count          = local.env ? 0 : 1
  identifier     = "${var.db_name}-replica"
  instance_class = "db.t3.micro"
  engine         = "mysql"

  # Cross-region replica configuration
  replicate_source_db    = var.db_instance_arn # Reference to the primary DB instance ID
  kms_key_id = var.kms_key_arn
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [var.rds_sg_id]
  storage_type           = "gp2"
  # multi_az               = false # Read replicas don't need to be Multi-AZ
  storage_encrypted      = true
  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "${var.db_name}-${var.environment}-subnet-group"
  tags = {
    Name = "${var.db_name}-${var.environment}-subnet-group"
  }
  description = "Subnet group for RDS"
  subnet_ids = [
    for subnet in var.subnet_ids : subnet if subnet != null
  ]
}