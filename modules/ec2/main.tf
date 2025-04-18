locals {
  parent_dir = dirname(dirname(path.cwd))
}

# Example usage
output "parent_directory" {
  value = local.parent_dir
}

resource "aws_launch_template" "this" {
  name_prefix   = "lamp-launch-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg_id]
  }

  iam_instance_profile {
    arn = var.iam_instance_profile_arn
  }


  user_data = base64encode(file("${local.parent_dir}/scripts/user-data.sh"))


  lifecycle {
    create_before_destroy = true
  }
}