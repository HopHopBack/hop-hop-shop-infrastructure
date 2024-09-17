resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "my-db-subnet-group"
  }
}

resource "aws_db_instance" "postgresql" {
  allocated_storage      = 20 # Free Tier provides 20 GB of storage
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "12.17"
  instance_class         = "db.t3.micro" # Free Tier eligible instance
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.default.id]

  # Optionally specify additional settings
  backup_retention_period = 7 # Days
  publicly_accessible     = true
  multi_az                = false
  skip_final_snapshot     = true

  tags = {
    Name = "FreeTierPostgresDB"
  }
}

resource "aws_security_group" "default" {
  name_prefix = "db-sg-"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}
