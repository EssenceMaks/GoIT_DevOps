output "grafana_admin_password" {
  description = "The admin password for Grafana"
  value       = var.grafana_admin_password
  sensitive   = true
}

output "grafana_service_name" {
  description = "The service name for Grafana"
  value       = "kube-prometheus-stack-grafana"
}
