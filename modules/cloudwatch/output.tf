output "alarm_topic_arn" {
  value = aws_sns_topic.alarm_topic.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs_logs.name
}
