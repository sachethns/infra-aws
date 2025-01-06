resource "kubernetes_storage_class" "ebs_storage_class" {
  metadata {
    name = "ebs-storage-class"
  }

  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"
  reclaim_policy      = "Delete"

  parameters = {
    "csi.storage.k8s.io/fstype" = "xfs"
    "type"                      = "gp2"
    "iopsPerGB"                 = "50"
    "encrypted"                 = "true"
  }

  allowed_topologies {
    match_label_expressions {
      key = "topology.ebs.csi.aws.com/zone"
      values = [
        "us-east-1b",
        "us-east-1c",
        "us-east-1d"
      ]
    }
  }
  depends_on = [module.eks, null_resource.kubeconfig]
}

resource "helm_release" "postgres" {
  name       = "postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  version    = "15.5.20"
  namespace  = "cve-consumer-namespace"

  set {
    name  = "global.postgresql.auth.username"
    value = var.db_user
  }
  set {
    name  = "global.postgresql.auth.password"
    value = var.db_password
  }
  set {
    name  = "global.postgresql.auth.database"
    value = var.db_name
  }
  values     = ["${file("${path.module}/values/postgres-values.yaml")}"]
  depends_on = [kubernetes_storage_class.ebs_storage_class, kubernetes_namespace.cve-consumer]
}