# #Default Network ACL
# resource "aws_default_network_acl" "default" {
#   default_network_acl_id = module.vpc.default_network_acl_id

#   egress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "${var.my_ip}"
#     from_port  = 443
#     to_port    = 443
#   }

#   tags = {
#     Name = "main"
#   }
# }

# #Network ACL
# resource "aws_network_acl" "main" {
#   vpc_id = module.vpc.vpc_id

#   egress {
#     protocol   = "tcp"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "${var.my_ip}"
#     from_port  = 443
#     to_port    = 443
#   }

#   tags = {
#     Name = "main"
#   }
# }


#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "${var.stack}-vpc1"
  cidr                 = "${var.cidr_block}"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  private_subnet_tags = {
     "kubernetes.io/cluster/${var.cluster_name}" = "shared"
     Terraform = "true"
     Environment = "${var.stack}"
     "kubernetes.io/role/internal-elb" = 1
   }

  public_subnet_tags = {
   "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    Terraform = "true"
    Environment = "${var.stack}"
    "kubernetes.io/role/elb" = 1
  }



}

#Security Group for ALB Whitelisting
module "alb_whitelisting_sg" {
  source = "terraform-aws-modules/security-group/aws"

  # Replace these with appropriate values
  description = "alb_whitelisting_sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow inbound traffic on port 443"
      cidr_blocks = var.my_ip
      },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow inbound traffic on port 443"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

