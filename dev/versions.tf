terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "boudreaux-labs-terraform-state"
    key            = "eks-clusters/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "boudreaux-labs-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }
  }
}
