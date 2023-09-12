data "aws_availability_zones" "available" {}

#Terraform needs to connect the the created cluster and use the cluster credentials to create the aws-auth configmap. Add this to the file that is creating the EKS cluster.
#https://stackoverflow.com/questions/69655605/configmaps-aws-auth-not-found
data "aws_eks_cluster" "default" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_name
}
# END