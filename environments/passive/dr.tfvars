aws_region    = "eu-central-1"
environment   = "dr"
instance_type = "t2.micro"
vpc_cidr      = "10.0.0.0/16"
# public_subnets_cidrs = [
#   { cidr = "10.0.16.0/24", az = "${var.aws_region}a", name = "PublicSubnet1" },
#   { cidr = "10.0.32.0/20", az = "${var.aws_region}b", name = "PublicSubnet2" },
#   { cidr = "10.0.48.0/20", az = "${var.aws_region}c", name = "PublicSubnet3" }
# ]
# private_subnets_cidrs = [
#   { cidr = "10.0.64.0/20", az = "${var.aws_region}a", name = "PrivateSubnet1" },
#   { cidr = "10.0.80.0/20", az = "${var.aws_region}b", name = "PrivateSubnet2" },
#   { cidr = "10.0.96.0/20", az = "${var.aws_region}c", name = "PrivateSubnet3" }
# ]