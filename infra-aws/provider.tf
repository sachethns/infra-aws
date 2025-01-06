provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "eks" {
  depends_on = [module.eks]
  name       = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  depends_on = [module.eks]
  name       = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data) # needed by Helm provider to trust K8s API server
  token                  = data.aws_eks_cluster_auth.eks.token
  config_path            = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.eks.token
    config_path            = var.kubeconfig_path
  }
}