resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = var.namespace
  create_namespace = true
  version    = "5.1.5" # Check for latest stable version

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "controller.admin.password"
    value = var.admin_password
  }
  
  set {
    name  = "controller.serviceType"
    value = "ClusterIP"
  }
}
