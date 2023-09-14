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

variable "cluster_host" {
  type        = string
  description = "cluster host endpoint"
}
variable "cluster_ca_certificate" {
  type        = string
  description = "cluster certificate"
}
