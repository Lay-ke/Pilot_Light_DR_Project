resource "aws_sns_topic" "sns_topic_alarm" {
  name = var.sns_topic_name
}

# add sns policy to lambda rolesj
resource "aws_sns_topic_subscription" "replica_promotion" {
  topic_arn = aws_sns_topic.sns_topic_alarm.arn
  protocol  = "lambda"
  endpoint  = var.replica_promotion_lambda_arn  # The ARN of Lambda in the DR region
}


resource "aws_sns_topic_subscription" "update_asg" {
  topic_arn = aws_sns_topic.sns_topic_alarm.arn
  protocol  = "lambda"
  endpoint  = var.update_asg_lambda_arn  # The ARN of Lambda in the DR region
}