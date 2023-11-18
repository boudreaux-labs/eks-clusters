#Goal here is to bootstrap argo any time the cluster gets destroyed and redeployed

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.46.2"
  timeout    = 1200
  depends_on = [module.eks, module.eks-load-balancer-controller, module.vpc]
  values = [templatefile("${path.module}/argocd_config/values.yaml",
    {
      argocd_repo_url = local.argocd.repo_url
      argocd_url      = local.argocd.argocd_url
      my_ip           = var.my_ip
      cert_url        = var.cert_arn
  })]
  create_namespace = true
  namespace        = "argocd"
  description      = "The ArgoCD Helm Chart deployment configuration"
}


#ArgoCD user management. ChatGPT helped with this one (a little, poorly)

resource "kubernetes_config_map_v1_data" "argocd-configmap" {
  force = true
  metadata {
    name      = "argocd-configmap"
    namespace = "argocd"
  }

  data = {
    "admin.password" = base64encode(var.argocd_admin_pwd)
  }
}
