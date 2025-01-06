resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.24.1"

  values = [
    file("${path.module}/values/prometheus-values.yaml")
  ]
  depends_on = [kubernetes_namespace.monitoring, helm_release.metrics_server, helm_release.kafka_exporter, helm_release.postgres]
}