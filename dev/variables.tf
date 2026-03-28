variable "my_ip" {
  default = "50.35.179.50/24"
  description = "My IP"
}
variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}
variable "stack" {
  description = "The environment stack (dev|qa|qaauto|uat|prod etc)"
  type        = string
  default     = "dev"
}
variable "cluster_version" {
  default = "1.31"
}
variable "cluster_name" {
  default = "eks-dev"
}
variable "cidr_block"{
  default = "10.0.0.0/16"
}
variable "cert_arn" {
  description = "ACM certificate ARN for boudreauxlabs.com — set via CERT_ARN GitHub Actions variable"
  type        = string
}
variable "argocd_admin_password" {
  description = "Admin password for ArgoCD"
  type        = string
  sensitive   = true
}

variable "ci_role_arn" {
  description = "IAM role ARN for CI/CD pipeline"
  type        = string
}
