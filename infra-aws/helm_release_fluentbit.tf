resource "null_resource" "clone_repo_fluentbit" {
  provisioner "local-exec" {
    command = "git clone https://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@github.com/csye7125-su24-team17/helm-fluentBit-logs.git ./modules/charts/helm-fluentBit-logs"
  }
}

resource "helm_release" "fluentbit_logs" {
  name       = "fluentbit-logs"
  repository = "https://github.com/csye7125-su24-team17/helm-fluentBit-logs.git"
  chart      = var.chart_path_fluentbit
  version    = "0.1.0"
  namespace  = kubernetes_namespace.amazon-cloudwatch.metadata[0].name

  depends_on = [kubernetes_namespace.amazon-cloudwatch]
}