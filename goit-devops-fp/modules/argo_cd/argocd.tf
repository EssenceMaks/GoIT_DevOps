resource "helm_release" "argocd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = var.namespace
  create_namespace = true
  version          = "5.46.7" # Check for latest stable version

  values = [
    file("${path.module}/values.yaml")
  ]
}

resource "helm_release" "argocd_apps" {
  name       = "argocd-apps"
  chart      = "${path.module}/charts"
  namespace  = var.namespace
  depends_on = [helm_release.argocd]
  
  values = [
    file("${path.module}/charts/values.yaml")
  ]
}
