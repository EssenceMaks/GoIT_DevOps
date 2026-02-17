resource "aws_db_instance" "default" {
  allocated_storage      = 20
  max_allocated_storage  = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "16.6" # Check for latest available on free tier
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres16"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = {
    Name = "${var.project_name}-rds"
  }
}
