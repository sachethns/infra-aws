# KMS Key for Kubernetes Secrets
resource "aws_kms_key" "eks_secrets_key" {
  description             = "KMS key for encrypting EKS secrets"
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true
  rotation_period_in_days = var.kms_key_rotation_period
  multi_region            = false
}
resource "aws_kms_key" "ebs_volumes_key" {
  description             = "KMS key for encrypting EBS volumes"
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true
  rotation_period_in_days = var.kms_key_rotation_period
  multi_region            = false
}

resource "aws_kms_alias" "eks_secrets_key_alias" {
  name          = var.eks_secrets_key_alias
  target_key_id = aws_kms_key.eks_secrets_key.id
}
resource "aws_kms_alias" "ebs_volumes_key_alias" {
  name          = var.ebs_volumes_key_alias
  target_key_id = aws_kms_key.ebs_volumes_key.id
}