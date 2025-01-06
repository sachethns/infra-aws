resource "helm_release" "kafka_exporter" {
  name       = "kafka-exporter"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus-kafka-exporter"
  version    = "2.10.0"

  namespace = "monitoring"

  values = [
    file("${path.module}/values/kafka-exporter-values.yaml")
  ]
  depends_on = [kubernetes_namespace.monitoring, helm_release.kafka]
}