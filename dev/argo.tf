# resource "helm_release" "argocd" {
#   name       = "argocd"
#   repository = "https://nexusrepo.env.io/repository/argocd"
#   chart      = "argo-cd"
#   version    = "5.29.1" ## argocd v2.6.7
#   timeout    = 1200
#   values = [templatefile("${path.module}/argo_config/values.yaml.tftpl",
#     {
#       argocd_repo_url = local.argocd.repo_url
#       argocd_url      = local.argocd_url
#   })]
#   create_namespace = true
#   namespace        = local.argocd.namespace
#   description      = "The ArgoCD Helm Chart deployment configuration"

#   depends_on = [helm_release.calico]
# }
