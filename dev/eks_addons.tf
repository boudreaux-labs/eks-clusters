module "eks-load-balancer-controller" {
  source  = "lablabs/eks-load-balancer-controller/aws"
  version = "1.2.0"
  cluster_name                     = var.cluster_name
  cluster_identity_oidc_issuer     = module.eks.oidc_provider
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn

  #optional variables
  irsa_role_create                 = true
  irsa_policy_enabled              = true
  helm_wait                        = true
  helm_wait_for_jobs               = true
}

module "eks-external-dns" {
  source  = "lablabs/eks-external-dns/aws"
  version = "1.2.0"
  cluster_identity_oidc_issuer     = module.eks.oidc_provider
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  enabled = true
  irsa_role_create = true
  settings = {
    policy = "sync"
  }
}