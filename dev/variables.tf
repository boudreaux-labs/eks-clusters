variable "my_ip" {
  default = "24.113.152.218/32"
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
  default = "arn:aws:acm:us-east-1:842851109414:certificate/d0347ead-df5b-4d02-8f71-9dbf38284f2c"
}
