variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "final-project"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "final-project-eks"
}

variable "jenkins_admin_password" {
  description = "Jenkins Admin Password"
  type        = string
  sensitive   = true
}

variable "argocd_admin_password" {
  description = "ArgoCD Admin Password"
  type        = string
  sensitive   = true
}
