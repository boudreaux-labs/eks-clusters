#Goal here is to bootstrap argo any time the cluster gets destroyed and redeployed

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd"
  chart      = "argo-cd"
  version    = "5.46.2"
  timeout    = 1200
  values = [templatefile("${path.module}/argo_config/values.yaml",
    {
      argocd_repo_url = local.argocd.repo_url
      argocd_url      = local.argocd.argocd_url
  })]
  create_namespace = true
  namespace        = argocd
  description      = "The ArgoCD Helm Chart deployment configuration"
}
