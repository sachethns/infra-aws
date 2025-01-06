resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.1"

  values = ["${file("${path.module}/values/metrics-server-values.yaml")}"]

  depends_on = [null_resource.kubeconfig]
}
