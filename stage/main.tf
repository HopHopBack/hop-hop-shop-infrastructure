terraform {
  backend "s3" {
    bucket         = "hophops3"
    key            = "terraform/state.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    acl            = "private"
    dynamodb_table = "hophopdynamodb"
  }
}

provider "tls" {}

provider "local" {}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.example.private_key_pem
  filename          = "${path.module}/private_key.pem"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "my-key"
  public_key = tls_private_key.example.public_key_openssh
}

module "vpc" {
  source = "/home/vva/Desktop/infrastructure-hop-hop-shop/modules/networks/vpc"
}

module "sg" {
  source = "/home/vva/Desktop/infrastructure-hop-hop-shop/modules/networks/sg"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "/home/vva/Desktop/infrastructure-hop-hop-shop/modules/ec2"

  key_name                    = aws_key_pair.ec2_key.key_name
  subnet_id                   = element(module.vpc.public_subnet_ids, 0)
  security_group_ids          = [module.sg.security_group_id]
  associate_public_ip_address = true
  ecs_cluster_name            = "hophopecscluster"

  instances = [
    {
      instance_type = "t2.micro"
      instance_name = "My ECS t2.micro Instance"
      volume_size   = 3
    },
    {
      instance_type = "t3.medium"
      instance_name = "My ECS t3.medium Instance 1"
      volume_size   = 5
    },
    {
      instance_type = "t3.medium"
      instance_name = "My ECS t3.medium Instance 2"
      volume_size   = 5
    }
  ]

  tags = {
    Environment = "production"
  }
}


module "ecr" {
  source = "/home/vva/Desktop/infrastructure-hop-hop-shop/modules/ecr"

  repository_name = "hophopregister"
}

module "rds" {
  source = "/home/vva/Desktop/infrastructure-hop-hop-shop/modules/rds"
  vpc_id = module.vpc.vpc_id
  subnet_ids = [
    element(module.vpc.public_subnet_ids, 0),
    element(module.vpc.public_subnet_ids, 1)
  ]
}

module "redis" {
  source = "/home/vva/Desktop/infrastructure-hop-hop-shop/modules/redis"
  vpc_id = module.vpc.vpc_id
  subnet_ids = [
    element(module.vpc.public_subnet_ids, 0),
    element(module.vpc.public_subnet_ids, 1)
  ]
}

module "alb" {
  source                     = "/home/vva/Desktop/infrastructure-hop-hop-shop/modules/alb"
  alb_name                   = "hophopalb"
  subnets                    = module.vpc.public_subnet_ids
  vpc_id                     = module.vpc.vpc_id
  target_group_name          = "hophop-target-group"
  enable_deletion_protection = true
  ec2_instance_ids           = module.ec2.instance_id
}

locals {
  instance_map = { for id in module.ec2.instance_id : id => id }
}

# Реєстрація EC2 інстансів у Next.js Target Group
resource "aws_lb_target_group_attachment" "nextjs_ec2_attachment" {
  for_each         = local.instance_map
  target_group_arn = module.alb.nextjs_target_group_arn
  target_id        = each.value
  port             = 3000
}

# Реєстрація EC2 інстансів у Django Target Group
resource "aws_lb_target_group_attachment" "django_ec2_attachment" {
  for_each         = local.instance_map
  target_group_arn = module.alb.django_target_group_arn
  target_id        = each.value
  port             = 8080
}

module "cloudwatch" {
  source = "/home/vva/Desktop/infrastructure-hop-hop-shop/modules/cloudwatch"

  cluster_name     = module.ecs.cluster_name
  service_name     = "hophop-cloudwatch"
  cpu_threshold    = 80
  memory_threshold = 75
}


module "ecs" {
  source                      = "/home/vva/Desktop/infrastructure-hop-hop-shop/modules/ecs"
  vpc_id                      = module.vpc.vpc_id
  sg_id                       = module.sg.security_group_id
  nextjs_image                = "fleek/next-js:lates"
  django_image                = "django:lates"
  alb_nextjs_target_group_arn = module.alb.nextjs_target_group_arn
  alb_django_target_group_arn = module.alb.django_target_group_arn
}


