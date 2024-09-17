output "redis_cluster_id" {
  value       = aws_elasticache_cluster.redis.cluster_id
  description = "The ID of the ElastiCache Redis cluster."
}

output "redis_security_group_id" {
  value       = aws_security_group.redis_sg.id
  description = "The ID of the security group associated with the ElastiCache Redis cluster."
}

output "redis_subnet_group_name" {
  value       = aws_elasticache_subnet_group.subnet_elasticache.name
  description = "The name of the ElastiCache Redis subnet group."
}
