variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "lesson-7"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "lesson-7-eks"
}

