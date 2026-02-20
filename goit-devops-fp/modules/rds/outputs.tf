output "rds_endpoint" {
  description = "Connection endpoint for standard RDS"
  value       = var.use_aurora ? null : aws_db_instance.default[0].endpoint
}

output "rds_address" {
  description = "Address for standard RDS"
  value       = var.use_aurora ? null : aws_db_instance.default[0].address
}

output "aurora_cluster_endpoint" {
  description = "Writer endpoint for Aurora Cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : null
}

output "aurora_reader_endpoint" {
  description = "Reader endpoint for Aurora Cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "db_connection_info" {
  value = {
    host     = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.default[0].address
    port     = 5432
    database = var.db_name
    username = var.db_username
  }
}
