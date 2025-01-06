resource "kubernetes_namespace" "kafka" {
  metadata {
    name = "kafka-namespace"
    # labels = {
    #   istio-injection = "enabled"
    # }
  }

  depends_on = [module.eks, null_resource.kubeconfig]
}

resource "kubernetes_namespace" "cve-processor" {
  metadata {
    name = "cve-processor-namespace"
    labels = {
      istio-injection = "enabled"
    }
  }

  depends_on = [module.eks, null_resource.kubeconfig]
}

resource "kubernetes_namespace" "cve-consumer" {
  metadata {
    name = "cve-consumer-namespace"
    labels = {
      istio-injection = "enabled"
    }
  }

  depends_on = [module.eks, null_resource.kubeconfig]
}

# Namespace for Cluster Autoscaler
resource "kubernetes_namespace" "cluster-autoscaler-namespace" {
  metadata {
    name = "cluster-autoscaler-namespace"
    labels = {
      istio-injection = "enabled"
    }
  }

  depends_on = [module.eks, null_resource.kubeconfig]
}
resource "kubernetes_namespace" "operator-namespace" {
  metadata {
    name = "operator-namespace"
    labels = {
      istio-injection = "enabled"
    }
  }

  depends_on = [module.eks, null_resource.kubeconfig]
}

resource "kubernetes_namespace" "amazon-cloudwatch" {
  metadata {
    name = "amazon-cloudwatch"
  }

  depends_on = [module.eks, null_resource.kubeconfig]
}
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
  depends_on = [module.eks, null_resource.kubeconfig]
}
resource "kubernetes_namespace" "external_secrets" {
  metadata {
    name = "external-secrets"
  }
  depends_on = [module.eks, null_resource.kubeconfig]
}

resource "kubernetes_namespace" "llm-namespace" {
  metadata {
    name = "llm-namespace"
  }
  depends_on = [module.eks, null_resource.kubeconfig]
}