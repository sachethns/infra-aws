# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# helm search repo istio/base
# helm show values istio/base --version 1.17.1 > helm-defaults/istio-base-default.yaml
# helm install my-istio-base-release -n istio-system istio/base --create-namespace --set global.istioNamespace=istio-system
resource "helm_release" "istio_base" {
  name = "my-istio-base-release"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = true
  version          = "1.17.1"

  set {
    name  = "global.istioNamespace"
    value = "istio-system"
  }

  depends_on = [module.eks]
}