output "db_instance_endpoint" {
  description = "The endpoint of the RDS PostgreSQL instance"
  value       = aws_db_instance.postgresql.endpoint
}

output "db_instance_id" {
  description = "The ID of the RDS PostgreSQL instance"
  value       = aws_db_instance.postgresql.id
}

output "db_instance_arn" {
  description = "The ARN of the RDS PostgreSQL instance"
  value       = aws_db_instance.postgresql.arn
}
