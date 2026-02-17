output "grafana_admin_password" {
  description = "The admin password for Grafana"
  value       = "prom-operator" # Default for kube-prometheus-stack, usually retrieved from secret but simple output here
}

output "grafana_service_name" {
  description = "The service name for Grafana"
  value       = "kube-prometheus-stack-grafana"
}
