module "eks-load-balancer-controller" {
  source  = "lablabs/eks-load-balancer-controller/aws"
  version = "1.2.0"
  
  # insert the 3 required variables here
  cluster_name                     = module.eks_cluster.eks_cluster_id
  cluster_identity_oidc_issuer     = module.eks_cluster.eks_cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn

  #optional variables
  irsa_role_create                 = true
  irsa_policy_enabled              = true
}