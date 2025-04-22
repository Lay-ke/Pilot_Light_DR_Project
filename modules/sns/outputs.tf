output "active_dr_sns_topic_arn" {
  value = aws_sns_topic.sns_topic_alarm.arn
}