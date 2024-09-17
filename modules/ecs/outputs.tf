output "cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_cluster_id" {
  description = "The ECS cluster ID"
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "nextjs_service_name" {
  description = "Name of the Next.js ECS Service"
  value       = aws_ecs_service.nextjs_service.name
}

output "django_service_name" {
  description = "Name of the Django ECS Service"
  value       = aws_ecs_service.django_service.name
}
