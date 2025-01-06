# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# helm search repo istio/istiod
# helm show values istio/istiod --version 1.17.1 > helm-defaults/istiod-default.yaml
# helm install my-istiod-release -n istio-system --create-namespace istio/istiod --set telemetry.enabled=true --set global.istioNamespace=istio-system
resource "helm_release" "istiod" {
  name = "my-istiod-release"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.17.1"

  set {
    name  = "telemetry.enabled"
    value = "true"
  }

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }

  # Need to override ingressService and ingressSelector for gateway chart to be compatible
  set {
    # The name of the Kubernetes Service that will expose Istio's Ingress Gateway to external traffic.
    name  = "meshConfig.ingressService"
    value = "istio-gateway"
  }

  set {
    name  = "meshConfig.ingressSelector"
    value = "gateway"
  }

  set {
    # Ensures that the application container waits until the Envoy proxy is fully started to avoid failing of istio-proxy readiness probe.
    name  = "meshConfig.defaultConfig.holdApplicationUntilProxyStarts"
    value = "true"
  }

  depends_on = [module.eks, helm_release.istio_base]
}