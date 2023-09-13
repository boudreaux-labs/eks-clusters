#Taken from example on https://github.com/terraform-aws-modules/terraform-aws-eks with a few values moved out into variables.tf, and a few sections removed like self managed nodes and Fargate

#Terraform needs to connect the the created cluster and use the cluster credentials to create the aws-auth configmap. Add this to the file that is creating the EKS cluster. 
#https://stackoverflow.com/questions/69655605/configmaps-aws-auth-not-found

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

output "cluster_id" {
  description = "The ID of the cluster."
  value       = module.aws_eks_cluster.cluster_id
}
#END

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.16.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets



  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    default_nodegroup = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }


  # # aws-auth configmap
  manage_aws_auth_configmap = true

    aws_auth_users = [
      {
        userarn  = "arn:aws:iam::842851109414:user/kenny"
        username = "kenny"
        groups   = ["system:masters"]
      },
    ]

  aws_auth_accounts = [
    "842851109414",
  ]

  tags = {
    Environment = var.stack
    Terraform   = "true"
  }


}
