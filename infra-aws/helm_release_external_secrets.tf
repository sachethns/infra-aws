resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  chart      = "external-secrets"
  repository = "https://charts.external-secrets.io"
  version    = "0.10.0"
  namespace  = "external-secrets"

  values = [
    file("${path.module}/values/external-secrets-values.yaml")
  ]

  depends_on = [kubernetes_namespace.external_secrets, aws_iam_policy.secret_reader_policy]
}

resource "aws_iam_policy" "secret_reader_policy" {
  name        = "SecretReaderPolicy"
  description = "Allows external secrets operator to get secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetRandomPassword",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:ListSecrets",
          "secretsmanager:BatchGetSecretvalue"
        ],
        "Resource" : ["*"]
      }
    ]
  })
}
resource "helm_release" "external_secrets_setup" {
  name  = "external-secrets-setup"
  chart = "${path.module}/charts/external-secrets-setup"

  depends_on = [helm_release.external_secrets]
}