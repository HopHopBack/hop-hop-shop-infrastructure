resource "aws_sns_topic" "alarm_topic" {
  name         = "ecs-monitoring-alarm-topic"
  display_name = "ECS Monitoring Alarm Topic"
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "ecs-cpu-utilization-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_description         = "This metric monitors ECS service CPU utilization"
  insufficient_data_actions = []
  ok_actions                = var.alarm_topic_arn != "" ? [var.alarm_topic_arn] : []
  alarm_actions             = var.alarm_topic_arn != "" ? [var.alarm_topic_arn] : []
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization" {
  alarm_name          = "ecs-memory-utilization-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = var.memory_threshold

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_description         = "This metric monitors ECS service memory utilization"
  insufficient_data_actions = []
  ok_actions                = var.alarm_topic_arn != "" ? [var.alarm_topic_arn] : []
  alarm_actions             = var.alarm_topic_arn != "" ? [var.alarm_topic_arn] : []
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/aws/ecs/${var.cluster_name}/logs"
}

resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
  name           = "ecs-log-stream"
  log_group_name = aws_cloudwatch_log_group.ecs_logs.name
}

resource "aws_cloudwatch_log_metric_filter" "ecs_error_logs" {
  name           = "ecs-error-logs"
  log_group_name = aws_cloudwatch_log_group.ecs_logs.name
  pattern        = "{ $.error = \"*\" }"

  metric_transformation {
    name      = "ECSErrorLogs"
    namespace = "ECS/Logs"
    value     = "1"
  }
}
