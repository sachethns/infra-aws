# IAM Role for Node Group
resource "aws_iam_role" "eks_worker_node_role" {
  name = "eksWorkerNodeRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      # Enables integration with OIDC which allows Kubernetes service accounts to assume this role.
      {
        Effect = "Allow"
        Principal = {
          Federated = "${module.eks.oidc_provider_arn}" # Utilizes the terraform output variable 'oidc_provider_arn' from the EKS module
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:sub" : [
              # adding cluster autoscaler service account, fluent bit service account
              "system:serviceaccount:cluster-autoscaler-namespace:cluster-autoscaler",
              "system:serviceaccount:amazon-cloudwatch:fluent-bit",
              "system:serviceaccount:external-secrets:external-secrets-sa"
            ],
            "${module.eks.oidc_provider}:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  # Predefined policies provided by AWS
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy", # CloudWatch Logs policy for Fluent Bit
    "arn:aws:iam::637423520668:policy/SecretReaderPolicy",
    "arn:aws:iam::637423520668:policy/ClusterAutoscalerPolicy"
  ]
  depends_on = [aws_iam_policy.cluster_autoscaler_policy, aws_iam_policy.secret_reader_policy]
}
