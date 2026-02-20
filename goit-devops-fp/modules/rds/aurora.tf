resource "aws_rds_cluster" "aurora" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier      = "${var.project_name}-aurora-cluster"
  engine                  = "aurora-postgresql" # Aurora specific engine
  engine_version          = "16.1"              # Check acceptable Aurora version
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora[0].name
  skip_final_snapshot     = true

  tags = {
    Name = "${var.project_name}-aurora-cluster"
  }
}

resource "aws_rds_cluster_instance" "aurora_instances" {
  count = var.use_aurora ? 1 : 0 # 1 instance for demo, can be variable

  identifier           = "${var.project_name}-aurora-instance-${count.index}"
  cluster_identifier   = aws_rds_cluster.aurora[0].id
  instance_class       = var.instance_class # e.g. db.t3.medium
  engine               = aws_rds_cluster.aurora[0].engine
  engine_version       = aws_rds_cluster.aurora[0].engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.main.name

  tags = {
    Name = "${var.project_name}-aurora-instance-${count.index}"
  }
}
