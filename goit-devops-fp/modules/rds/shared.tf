resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow inbound traffic from EKS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from EKS cluster"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_security_group_id] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

# Parameter Group for Standard RDS
resource "aws_db_parameter_group" "default" {
  count = var.use_aurora ? 0 : 1

  name   = "${var.project_name}-pg-${var.engine}-16"
  family = "postgres16"

  parameter {
    name  = "log_statement"
    value = "none"
  }

  parameter {
    name         = "max_connections"
    value        = "100"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "work_mem"
    value = "4096"
  }

  tags = {
    Name = "${var.project_name}-pg"
  }
}

# Parameter Group for Aurora Cluster
resource "aws_rds_cluster_parameter_group" "aurora" {
  count = var.use_aurora ? 1 : 0

  name   = "${var.project_name}-aurora-pg"
  family = "aurora-postgresql16" # Ensure this matches the engine version

  parameter {
    name  = "log_statement"
    value = "none"
  }

  parameter {
    name  = "work_mem"
    value = "4096"
  }

  tags = {
    Name = "${var.project_name}-aurora-pg"
  }
}
