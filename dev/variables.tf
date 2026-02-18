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
  default = "arn:aws:acm:us-east-1:842851109414:certificate/babbb338-a5aa-465d-88c3-2f9c94af261a"
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
