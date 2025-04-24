# Cloudwatch Alarm for Route53 Health Check
# This alarm will trigger if the health check status is less than 1 (indicating unhealthy)
resource "aws_cloudwatch_metric_alarm" "primary_unhealthy" {
  alarm_name          = "PrimaryHealthCheckFailed"
  namespace           = "AWS/Route53"
  metric_name         = "HealthCheckStatus"
  statistic           = "Minimum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "LessThanThreshold"
  dimensions = {
    HealthCheckId = var.domain_health_check_id
  }

  alarm_actions = [var.active_dr_sns_topic_arn]
}


# CloudWatch Alarm for Auto Scaling Group Health
resource "aws_cloudwatch_metric_alarm" "asg_instance_health" {
  alarm_name                = "ASGInstanceHealthAlarm"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = 60  # Period is measured in seconds
  statistic                 = "Average"
  threshold                 = 0.5  # Adjust as necessary
  alarm_description         = "Alarm when instances in ASG are unhealthy"
  alarm_actions             = [var.active_dr_sns_topic_arn]
  insufficient_data_actions = []

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# # Cloudwatch Alarm for EC2 Health check
# resource "aws_cloudwatch_metric_alarm" "ec2_instance_health" {
#   alarm_name                = "EC2InstanceHealthAlarm"
#   comparison_operator       = "GreaterThanThreshold"
#   evaluation_periods        = 2
#   metric_name               = "StatusCheckFailed"
#   namespace                 = "AWS/EC2"
#   period                    = 60
#   statistic                 = "Minimum"
#   threshold                 = 1
#   alarm_description         = "Alarm when EC2 instances fail health check"
#   alarm_actions             = [aws_sns_topic.notification_topic.arn]
#   insufficient_data_actions = []

#   dimensions = {
#     InstanceId = "i-xxxxxxxxxxxxxxxxx"  # Replace with your EC2 instance ID
#   }
# }


# # Cloudwatch Alarm for EC2 CPU Utilization
# resource "aws_cloudwatch_metric_alarm" "ec2_cpu_utilization" {
#   alarm_name                = "EC2HighCPUUtilization"
#   comparison_operator       = "GreaterThanThreshold"
#   evaluation_periods        = 2
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   period                    = 300
#   statistic                 = "Average"
#   threshold                 = 80  # CPU utilization threshold (e.g., 80%)
#   alarm_description         = "Alarm when EC2 instance CPU utilization is high"
#   alarm_actions             = [aws_sns_topic.notification_topic.arn]
#   insufficient_data_actions = []

#   dimensions = {
#     InstanceId = "i-xxxxxxxxxxxxxxxxx"  # Replace with your EC2 instance ID
#   }
# }


# #Cloudwatch Alarm for RDS Connections
# resource "aws_cloudwatch_metric_alarm" "rds_db_connections" {
#   alarm_name                = "RDSDBConnectionsAlarm"
#   comparison_operator       = "GreaterThanThreshold"
#   evaluation_periods        = 5
#   metric_name               = "DatabaseConnections"
#   namespace                 = "AWS/RDS"
#   period                    = 300  # 5 minutes
#   statistic                 = "Average"
#   threshold                 = 1000  # Example: Alarm if connections exceed 1000
#   alarm_description         = "Alarm when RDS database connections exceed 1000 for 5 minutes"
#   alarm_actions             = [aws_sns_topic.notification_topic.arn]
#   insufficient_data_actions = []

#   dimensions = {
#     DBInstanceIdentifier = "my-primary-db-instance"  # Replace with your RDS primary instance ID
#   }
# }

