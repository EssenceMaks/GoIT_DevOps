variable "namespace" {
  description = "The namespace to deploy monitoring resources"
  type        = string
  default     = "monitoring"
}

variable "grafana_admin_password" {
  description = "The admin password for Grafana"
  type        = string
  sensitive   = true
}
