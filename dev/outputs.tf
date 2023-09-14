
output "kubeconfig_command" {
  value       = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region} --role-arn ${aws_iam_role.masters.arn}"
  description = "eks command to update kubeconfig and connect to cluster"
}

output "masters_role" {
  value       = aws_iam_role.masters.arn
  description = "aws iam role with system:masters permissions to cluster"
}

output "read_role" {
  value       = aws_iam_role.read.arn
  description = "aws iam role with eks-read-only permissions to cluster"
}

output "argocd_url" {
  value = local.argocd.argocd_url
}
