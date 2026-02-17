# AWS Load Balancer Controller - direct Helm install
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.11.0"
  
  depends_on = [module.eks, module.irsa-lb-controller]
  
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa-lb-controller.arn
  }
  
  set {
    name  = "region"
    value = "us-east-1"
  }
  
  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  wait          = true
  wait_for_jobs = true
  timeout       = 300
}

# External DNS - direct Helm install
resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = "1.15.0"
  
  depends_on = [module.eks, module.irsa-external-dns]
  
  set {
    name  = "provider.name"
    value = "aws"
  }
  
  set {
    name  = "policy"
    value = "sync"
  }
  
  set {
    name  = "sources[0]"
    value = "ingress"
  }
  
  set {
    name  = "sources[1]"
    value = "service"
  }
  
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  
  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }
  
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa-external-dns.arn
  }

  wait    = true
  timeout = 300
}
