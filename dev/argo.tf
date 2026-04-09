#Goal here is to bootstrap argo any time the cluster gets destroyed and redeployed

# Gives the LBC time to delete the ALB (and release subnet ENIs) after ArgoCD is
# destroyed, before Terraform attempts to tear down the VPC.
resource "time_sleep" "wait_for_alb_cleanup" {
  depends_on       = [module.vpc]
  destroy_duration = "120s"
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.7.3"
  timeout    = 1200
  depends_on = [module.eks, helm_release.aws_load_balancer_controller, module.vpc, time_sleep.wait_for_alb_cleanup]
  values = [templatefile("${path.module}/argo_config/values.yaml",
    {
      argocd_url = "argocd-${var.stack}.boudreauxlabs.com"
      cert_arn   = var.cert_arn
      my_ip      = var.my_ip
  })]
  
  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt(var.argocd_admin_password)
  }
  
  create_namespace = true
  namespace        = "argocd"
  description      = "The ArgoCD Helm Chart deployment configuration"
}
