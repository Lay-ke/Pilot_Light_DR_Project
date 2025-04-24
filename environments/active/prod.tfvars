aws_region    = "us-east-1"
environment   = "prod"
instance_type = "t3.medium"
vpc_cidr      = "192.168.0.0/16"
# public_subnets_cidrs = [
#   { cidr = "192.168.16.0/24", az = "${var.aws_region}a", name = "PublicSubnet1" },
#   { cidr = "192.168.32.0/20", az = "${var.aws_region}b", name = "PublicSubnet2" },
#   { cidr = "192.168.48.0/20", az = "${var.aws_region}c", name = "PublicSubnet3" }
# ]
# private_subnets_cidrs = [
#   { cidr = "192.168.64.0/20", az = "${var.aws_region}a", name = "PrivateSubnet1" },
#   { cidr = "192.168.80.0/20", az = "${var.aws_region}b", name = "PrivateSubnet2" },
#   { cidr = "192.168.96.0/20", az = "${var.aws_region}c", name = "PrivateSubnet3" }
# ]