variable "my_ip" {
  default = "104.28.116.0/24"
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
  default = "1.27"
}
variable "cluster_name" {
  default = "eks-dev"
}
variable "cidr_block"{
  default = "10.0.0.0/16"
}
variable "cert_arn" {
  default = "arn:aws:acm:us-east-1:842851109414:certificate/c7cadf29-ae16-4a0d-8c37-f89929ab4f8e"
}
variable "argocd_admin_password" {
  description = "Admin password for ArgoCD"
  type        = string
  sensitive   = true
}
