# ----------------------------------------
# RDS DB Subnet Group
# ----------------------------------------

resource "aws_db_subnet_group" "mysql" {
  name = "${local.name_prefix}-db-subnet-group"

  subnet_ids = aws_subnet.private_db[*].id

  tags = {
    Name = "${local.name_prefix}-db-subnet-group"
  }
}


# ----------------------------------------
# RDS MySQL Instance
# ----------------------------------------

resource "aws_db_instance" "mysql" {
  identifier = "${local.name_prefix}-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp3"

  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  port = 3306

  # RDS will be deployed into private DB subnets
  db_subnet_group_name = aws_db_subnet_group.mysql.name

  # Only ECS tasks can access MySQL
  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  # Do not assign public IP
  publicly_accessible = false

  # Single AZ for development
  multi_az = false

  # Automated backup retention
  backup_retention_period = 7

  # Development settings
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "${local.name_prefix}-mysql"
  }
}