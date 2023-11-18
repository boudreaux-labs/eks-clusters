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


#ArgoCD user management. ChatGPT helped with this one (a little, poorly)

# resource "kubectl_secret" "argocd_initial_admin_secret" {
#   metadata {
#     name      = "argocd-initial-admin-secret"
#     namespace = "argocd"
#   }

#   data = {
#     "admin.password" = base64encode(var.argocd_admin_pwd)
#   }
# }

resource "kubernetes_config_map" "argocd_cm" {
  metadata {
    name      = "argocd-cm"
    namespace = "argocd"
    labels = {
      "app.kubernetes.io/name"     = "argocd-cm"
      "app.kubernetes.io/part-of" = "argocd"
    }
  }
  data = {
    "accounts.kenny"                 = "apiKey, login"
    "accounts.kenny.enabled"         = "true"
  }
}

resource "kubernetes_secret" "argocd_kenny_secret" {
  metadata {
    name      = "argocd_kenny_secret"  # Update the name if needed
    namespace = "argocd"
  }

  data = {
    "accounts.kenny.password" = base64encode(var.argocd_admin_pwd)
  }
}