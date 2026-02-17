output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://jenkins.${var.namespace}.svc.cluster.local:8080"
}

output "admin_password" {
  description = "Jenkins Admin Password"
  value       = var.admin_password
  sensitive   = true
}
