module "eks-external-dns" {
  source  = "lablabs/eks-external-dns/aws"
  version = "1.2.0"
  cluster_identity_oidc_issuer     = module.eks.oidc_provider
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  enabled = true
  irsa_role_create = true
  #argo_sync_policy = "sync"
}