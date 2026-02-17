variable "namespace" {
  description = "Namespace for Jenkins"
  type        = string
  default     = "jenkins"
}

variable "admin_password" {
  description = "Admin password for Jenkins"
  type        = string
  sensitive   = true
}
