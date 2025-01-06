resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  namespace  = "llm-namespace"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.11.2"

  values = [
    file("${path.module}/values/ingress-nginx-values.yaml")
  ]

  depends_on = [kubernetes_namespace.llm-namespace]
}

resource "null_resource" "ingress" {
  depends_on = [aws_route53_record.grafana_dns,aws_route53_record.llm_api_dns,aws_route53_record.llm_dns]
  provisioner "local-exec" {
    command = <<EOT
    kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.8.0/cert-manager.crds.yaml
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.8.0 --create-namespace
    kubectl apply -f cert
    kubectl apply -f ingress
    EOT
  }
}