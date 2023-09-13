provider "aws" {
  region = var.region
}

#Terraform needs to connect the the created cluster and use the cluster credentials to create the aws-auth configmap. Add this to the file that is creating the EKS cluster. 
#https://stackoverflow.com/questions/69655605/configmaps-aws-auth-not-found
provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}
#END