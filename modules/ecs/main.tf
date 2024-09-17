# modules/ecs/main.tf

# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "hophopecscluster"
}

# ECS Task Definition for Next.js
resource "aws_ecs_task_definition" "nextjs_task" {
  family                   = "nextjs-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  container_definitions = jsonencode([{
    name      = "nextjs-container"
    image     = var.nextjs_image
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
  task_role_arn = aws_iam_role.ecs_task_role.arn
}

# ECS Task Definition for Django
resource "aws_ecs_task_definition" "django_task" {
  family                   = "django-task"
  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  container_definitions = jsonencode([{
    name      = "django-container"
    image     = var.django_image
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
  }])
  task_role_arn = aws_iam_role.ecs_task_role.arn
}

# ECS Service for Next.js
resource "aws_ecs_service" "nextjs_service" {
  name            = "nextjs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.nextjs_task.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.alb_nextjs_target_group_arn
    container_name   = "nextjs-container"
    container_port   = 3000
  }

  depends_on = [var.alb_nextjs_target_group_arn] # Залежність від ALB
}

# ECS Service for Django
resource "aws_ecs_service" "django_service" {
  name            = "django-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.django_task.arn
  desired_count   = 1
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.alb_django_target_group_arn
    container_name   = "django-container"
    container_port   = 8080
  }

  depends_on = [var.alb_django_target_group_arn] # Залежність від ALB
}

# IAM Role for ECS Task
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role_new"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
