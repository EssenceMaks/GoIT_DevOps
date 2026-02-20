variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "eks_security_group_id" {
  description = "Security group ID of the EKS cluster (to allow access)"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

# --- New Variables for Universal Module ---

variable "use_aurora" {
  description = "If true, deploy AWS Aurora Cluster. If false, deploy standard RDS Instance."
  type        = bool
  default     = false
}

variable "engine" {
  description = "Database engine (e.g., postgres, aurora-postgresql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "16.6"
}

variable "instance_class" {
  description = "Instance class for RDS or Aurora instances"
  type        = string
  default     = "db.t3.micro"
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}
