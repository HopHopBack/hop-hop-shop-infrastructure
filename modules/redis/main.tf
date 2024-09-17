resource "aws_elasticache_subnet_group" "subnet_elasticache" {
  name       = "my-elasticache-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "example-subnet-group"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "example-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.subnet_elasticache.name
  security_group_ids   = [aws_security_group.redis_sg.id]

  tags = {
    Name = "free-tier-redis"
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "redis_sg"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
