data "local_file" "amplify_build_spec" {
  filename = "${path.module}/amplify.yml"
}

resource "aws_amplify_app" "hophopnextjs" {
  name = "hophop-front"

  repository  = var.repository_url
  oauth_token = var.github_token

  tags = {
    Name = "hophopnextjs"
  }

  build_spec = data.local_file.amplify_build_spec.content

  environment_variables = {
    NEXT_PUBLIC_API_URL            = var.api
    NEXT_PUBLIC_CLARITY_PROJECT_ID = var.id
  }
}

resource "aws_amplify_branch" "hophopnextjs" {
  app_id            = aws_amplify_app.hophopnextjs.id
  branch_name       = var.branch_name
  enable_auto_build = true
}
