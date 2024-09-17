output "s3_bucket_id" {
  value       = aws_s3_bucket.terraform_state.id
  description = "name of s3"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_state_locks.name
  description = "name of dynamodb"
}
