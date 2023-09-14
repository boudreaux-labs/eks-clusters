locals {
  argocd = {
    destination_server = "https://kubernetes.default.svc"
    name               = "add-ons"
    namespace          = "argocd"
    path               = "chart"
    project            = "default"
    repo_url           = "https://gitlab.com/boudreaux-labs/app-deploy"
  }
  argocd_url = "argocd-${stack}.boudreauxlabs.com"
}
