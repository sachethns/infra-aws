resource "kubernetes_secret" "grafana_secret" {
  metadata {
    name      = "grafana-credentials"
    namespace = "monitoring"
  }
  type = "Opaque"
  data = {
    admin-user     = var.grafana_username
    admin-password = var.grafana_password
  }
  depends_on = [kubernetes_namespace.monitoring]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "8.4.0"

  values = [
    file("${path.module}/values/grafana-values.yaml")
  ]

  set {
    name  = "admin.existingSecret"
    value = "grafana-credentials"
  }
  set {
    name  = "admin.userKey"
    value = "admin-user"
  }
  set {
    name  = "admin.passwordKey"
    value = "admin-password"
  }
  depends_on = [kubernetes_secret.grafana_secret, helm_release.prometheus]
}

# resource "kubernetes_secret" "tls_secret" {
#   metadata {
#     name      = "tls-secret"
#     namespace = "llm-namespace"
#   }

#   data = {
#     "tls.crt" = var.tls_cert
#     "tls.key" = var.tls_key
#   }

#   type = "kubernetes.io/tls"
#   depends_on = [ kubernetes_namespace.monitoring ]
# }