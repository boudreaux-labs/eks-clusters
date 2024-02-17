#Goal here is to bootstrap argo any time the cluster gets destroyed and redeployed

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.2"
  timeout    = 1200
  depends_on = [module.eks, module.eks-load-balancer-controller, module.vpc]
  values = [templatefile("${path.module}/argo_config/values.yaml",
    {
      argocd_repo_url = local.argocd.repo_url
      argocd_url      = local.argocd.argocd_url
      my_ip           = var.my_ip
      cert_arn        = var.cert_arn
  })]
  create_namespace = true
  namespace        = "argocd"
  description      = "The ArgoCD Helm Chart deployment configuration"
}

#ArgoCD local  user management. Done by editing the existing "argocd_cm" config map

resource "kubernetes_secret" "argocd_kenny_secret" {
  metadata {
    name      = "argocd.kenny.secret"  # Update the name if needed
    namespace = "argocd"
  }
  data = {
    "accounts.kenny.password" = var.argocd_kenny_pwd  #this is coming from CICD vars
  }
}

data "kubernetes_secret" "argocd_kenny_secret" {
  metadata {
    name = "argocd.kenny.secret"
  }
}

resource "kubernetes_config_map_v1_data" "argocd_cm" {  #sourced: https://stackoverflow.com/questions/72903973/how-do-i-add-users-to-argo-cd-using-terraform-resource
  metadata {
    name      = "argocd-cm"
    namespace = "argocd"
  }
  data = {
    "accounts.kenny"                 = "apiKey, login"
    "accounts.kenny.enabled"         = "true"
    "accounts.kenny.password"        = "password234"
  }
}
