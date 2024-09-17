output "instance_id" {
  value = [for instance in aws_instance.ecs_instance : instance.id]
}

output "public_ip" {
  value = [for instance in aws_instance.ecs_instance : instance.public_ip]
}

output "private_ip" {
  value = [for instance in aws_instance.ecs_instance : instance.private_ip]
}
