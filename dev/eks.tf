#Taken from example on https://github.com/terraform-aws-modules/terraform-aws-eks with a few values moved out into variables.tf, and a few sections removed like self managed nodes and Fargate

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"
  
  name               = var.cluster_name
  kubernetes_version = var.cluster_version
  
  endpoint_public_access  = true
  endpoint_private_access = true
  
  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }  
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    default_nodegroup = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = var.stack
    Terraform   = "true"
  }
}
