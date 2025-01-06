# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# helm search repo istio/gateway
# helm show values istio/gateway --version 1.17.1 > helm-defaults/gateway-default.yaml
# helm install gateway -n istio-ingress --create-namespace istio/gateway
resource "helm_release" "gateway" {
  name = "gateway"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.17.1"

  # set {
  #   name  = "service.externalTrafficPolicy"
  #   value = "Local"
  # }

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}