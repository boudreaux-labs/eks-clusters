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
      cert_url        = var.cert_arn
  })]
  create_namespace = true
  namespace        = "argocd"
  description      = "The ArgoCD Helm Chart deployment configuration"
}


#ArgoCD user management. ChatGPT helped with this one

resource "kubectl_manifest" "argocd_admin_password" {
  manifest = <<EOT
apiVersion: v1
kind: Secret
metadata:
  name: argocd-secret
  namespace: argocd
data:
  admin.password: ${base64encode(var.argo_admin_pwd)}
EOT
}
