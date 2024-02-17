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
      argocd_repo_url = "https://gitlab.com/boudreaux-labs/app-deploy"
      argocd_url      = "argocd-${var.stack}.boudreauxlabs.com"
      my_ip           = var.my_ip
      cert_arn        = var.cert_arn
  })]
  create_namespace = true
  namespace        = "argocd"
  description      = "The ArgoCD Helm Chart deployment configuration"
}
