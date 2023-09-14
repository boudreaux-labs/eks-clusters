
output "kubeconfig_command" {
  value       = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region} --role-arn <your role here>"
  description = "eks command to update kubeconfig and connect to cluster"
}

output "argocd_url" {
  value = local.argocd.argocd_url
}
