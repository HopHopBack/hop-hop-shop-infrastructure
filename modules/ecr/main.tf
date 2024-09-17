resource "aws_ecr_repository" "private_repo" {
  name = var.repository_name

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.private_repo.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Delete images older than 15 days"
        selection = {
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 15
          tagStatus   = "any"
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
