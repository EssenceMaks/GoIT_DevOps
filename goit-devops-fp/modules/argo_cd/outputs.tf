output "argocd_server_url" {
  value = "http://argocd-server.${var.namespace}.svc.cluster.local"
}
