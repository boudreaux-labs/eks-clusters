#VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name                 = "${var.stack}-vpc1"
  cidr                 = var.cidr_block
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  private_subnet_tags = {
     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
     Terraform = "true"
     Environment = var.stack
     "kubernetes.io/role/internal-elb" = 1
   }

  public_subnet_tags = {
   "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Terraform = "true"
    Environment = var.stack
    "kubernetes.io/role/elb" = 1
  }

}

