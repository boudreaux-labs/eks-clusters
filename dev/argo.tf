#Goal here is to bootstrap argo any time the cluster gets destroyed and redeployed

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.7.3"
  timeout    = 1200
  depends_on = [module.eks, helm_release.aws_load_balancer_controller, module.vpc]
  values = [templatefile("${path.module}/argo_config/values.yaml",
    {
      argocd_url = "argocd-${var.stack}.boudreauxlabs.com"
      cert_arn   = var.cert_arn
  })]
  
  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt(var.argocd_admin_password)
  }
  
  create_namespace = true
  namespace        = "argocd"
  description      = "The ArgoCD Helm Chart deployment configuration"
}

#resource "kubernetes_manifest" "application_set" {
#  manifest = yamldecode(file("${path.module}/argo_config/appset.yaml"))
#}
