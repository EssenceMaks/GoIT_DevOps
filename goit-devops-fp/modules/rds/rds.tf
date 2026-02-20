resource "aws_db_instance" "default" {
  count = var.use_aurora ? 0 : 1

  allocated_storage      = 20
  max_allocated_storage  = 20
  storage_type           = "gp2"
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.default[0].name
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  multi_az               = var.multi_az

  tags = {
    Name = "${var.project_name}-rds"
  }
}
