provider "aws" {
  region = var.aws_region
}

# locals 
locals {
  env = var.environment == "prod" ? true : false
}

# Module for VPC
module "vpc" {
  source            = "../../modules/vpc"
  cidr_block        = var.vpc_cidr
  name              = "PLight-VPC-${var.environment}"
  public_subnet_ids = module.subnets.public_subnet_ids
}

# Module for Subnets
module "subnets" {
  source = "../../modules/subnets"
  vpc_id = module.vpc.vpc_id

  public_subnets = [
    { cidr = "192.168.16.0/24", az = "${var.aws_region}a", name = "PublicSubnet1" },
    { cidr = "192.168.32.0/20", az = "${var.aws_region}b", name = "PublicSubnet2" },
    { cidr = "192.168.48.0/20", az = "${var.aws_region}c", name = "PublicSubnet3" }
  ]

  private_subnets = [
    { cidr = "192.168.64.0/20", az = "${var.aws_region}a", name = "PrivateSubnet1" },
    { cidr = "192.168.80.0/20", az = "${var.aws_region}b", name = "PrivateSubnet2" },
    { cidr = "192.168.96.0/20", az = "${var.aws_region}c", name = "PrivateSubnet3" }
  ]
}

# Module for Security Groups
module "security_groups" {
  source = "../../modules/sg"
  vpc_id = module.vpc.vpc_id
}

# Module for ACM Certificate
module "acm" {
  source      = "../../modules/acm"
  environment = var.environment
}

# Module for Application Load Balancer (ALB)
module "alb" {
  source     = "../../modules/alb"
  name       = "PLight-ALB-${var.environment}"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnets.public_subnet_ids
  sg_id      = module.security_groups.lb_sg_id
  certificate_arn = module.acm.certificate_arn
}

# Module for EC2 instances behind the Load Balancer
module "ec2" {
  source                   = "../../modules/ec2"
  instance_type            = var.instance_type
  sg_id                    = module.security_groups.web_sg_id
  iam_instance_profile_arn = module.iam.instance_profile_arn
  ami_id                   = "ami-084568db4383264d4"
}

# Auto Scaling Group for EC2 instances using Launch Template
resource "aws_autoscaling_group" "this" {
  name                = "${var.environment}-web-asg"
  desired_capacity    = local.env ? 1 : 0
  max_size            = 5
  min_size            = local.env ? 1 : 0
  vpc_zone_identifier = module.subnets.public_subnet_ids

  launch_template {
    id      = module.ec2.launch_template_id
    version = "$Latest"
  }
  target_group_arns = [module.alb.target_group_arn] # To access the tg_arn I had to output it in the alb module

  health_check_type         = "EC2"
  health_check_grace_period = 300
  wait_for_capacity_timeout = "0"
  force_delete              = true

  depends_on = [module.secrets_manager]

  tag {
    key                 = "Name"
    value               = "WebServer"
    propagate_at_launch = true
  }
}

module "iam" {
  source                    = "../../modules/iam"
  environment               = var.environment
  cluster_name              = var.cluster_name
  enable_cluster_autoscaler = false
}

module "kms" {
  source      = "../../modules/kms"
  environment = var.environment
}

module "rds" {
  source          = "../../modules/rds"
  aws_region      = var.aws_region
  kms_key_arn     = module.kms.kms_primary_key
  db_instance_arn = var.db_instance_arn
  subnet_ids      = module.subnets.private_subnet_ids
  rds_sg_id       = module.security_groups.rds_sg_id
  environment     = var.environment
}

module "secrets_manager" {
  source               = "../../modules/secrets_manager"
  db_instance_endpoint = module.rds.db_instance_endpoint
  db_username          = module.rds.db_username
  db_password          = module.rds.db_password
  db_name              = module.rds.db_name
}

module "sns" {
  source                       = "../../modules/sns"
  replica_promotion_lambda_arn = var.promote_replica_lambda_arn
  update_asg_lambda_arn        = var.update_asg_lambda_arn
}

module "route53" {
  source = "../../modules/route53"
  environment = var.environment
  domain_name = "active.mintah.site"
  hosted_zone_id = module.acm.hosted_zone_id
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id = module.alb.alb_zone_id
}

module "cloudwatch_alarm" {
  source = "../../modules/cloudwatch_alarm"
  asg_name = aws_autoscaling_group.this.name
  active_dr_sns_topic_arn = module.sns.active_dr_sns_topic_arn
  domain_health_check_id = module.route53.health_check_id
}