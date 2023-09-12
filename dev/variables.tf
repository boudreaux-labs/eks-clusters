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

