module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # EKS Cluster Configuration
  cluster_name        = var.eks_cluster_name
  cluster_version     = var.eks_cluster_version
  authentication_mode = var.eks_cluster_authentication_mode
  cluster_ip_family   = var.eks_cluster_ip_family

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # OIDC Provider
  enable_irsa = true

  # Observability
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Encryption
  cluster_encryption_config = {
    resources        = ["secrets"]
    provider_key_arn = aws_kms_key.eks_secrets_key.arn
  }

  # Identity and Access
  iam_role_arn = aws_iam_role.eks_cluster_role.arn

  # Addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    # vpc-cni = {
    #   most_recent = true
    # }
    vpc-cni = {
      most_recent = true
      # This activates support for Kubernetes network policies, cause the default Amazon VPC CNI configuration doesn't.
      configuration_values = jsonencode({
        "enableNetworkPolicy" = "true"
      })
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
      most_recent              = true
    }
  }

  # Networking
  vpc_id                    = aws_vpc.main.id
  subnet_ids                = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id, aws_subnet.public_subnet_3.id, aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
  control_plane_subnet_ids  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]
  cluster_security_group_id = aws_security_group.security_group.id

  # Tags
  tags = {
    Name = var.eks_cluster_name
  }

  # Explicit Dependencies for EKS Cluster
  depends_on = [
    aws_subnet.public_subnet_1,
    aws_subnet.public_subnet_2,
    aws_subnet.public_subnet_3,
    aws_subnet.private_subnet_1,
    aws_subnet.private_subnet_2,
    aws_subnet.private_subnet_3,
    aws_security_group.security_group,
    aws_kms_key.eks_secrets_key
  ]

  eks_managed_node_groups = {
    eks_node_group = {
      name = var.eks_cluster_node_group_name

      # Scaling Configuration  
      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      # Node Configuration
      instance_types = var.node_group_instance_types
      ami_type       = var.node_group_instance_ami_type
      capacity_type  = var.node_group_instance_capacity_type
      disk_size      = var.node_group_instance_disk_size

      # Node IAM Role
      iam_role_arn = aws_iam_role.eks_worker_node_role.arn

      # Node Group Networking
      subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_3.id]

      # Optional: Set maximum unavailable nodes during updates
      update_config = {
        max_unavailable = var.node_group_instance_max_unavailable
      }

      # Node Group Tags
      tags = {
        Name = var.eks_cluster_node_group_name
        # These tags are needed by cluster autoscaler to recognize and manage the node group
        "k8s.io/cluster-autoscaler/${var.eks_cluster_name}" = "owned"
        "k8s.io/cluster-autoscaler/enabled"                 = "true"
      }

      # Explicit Dependencies for Node Group(s)
      depends_on = [
        aws_iam_role.eks_worker_node_role
      ]
    }
  }

  # Inbound rules required to be able to call Istio's sidecar injector webhook (present on the worker nodes) from EKS Master.
  node_security_group_additional_rules = {
    ingress_15017 = {
      description                   = "Cluster API - Istio Webhook namespace.sidecar-injector.istio.io"
      protocol                      = "TCP"
      from_port                     = 15017
      to_port                       = 15017
      type                          = "ingress"
      source_cluster_security_group = true
    }
    ingress_15012 = {
      description                   = "Cluster API to nodes ports/protocols"
      protocol                      = "TCP"
      from_port                     = 15012
      to_port                       = 15012
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }
  # Cluster access entry to add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.eks_cluster_name} --region ${var.aws_region}"
  }
  depends_on = [module.eks]
}