variable "my_ip" {
  default = "136.226.55.2/32"
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
  default = "$CERT_ARN"
}
variable "argo_admin_pwd" {
  default = "$ARGO_ADMIN_PWD"
}