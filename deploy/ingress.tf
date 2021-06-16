resource "kubernetes_ingress" "todos" {
  metadata {
    name      = "todos"
    namespace = "todos"

    annotations = {
      "kubernetes.io/ingress.class"              = "gce"
      "networking.gke.io/v1beta1.FrontendConfig" = "todos"
    }
  }
  spec {
    backend {
      service_name = "flask"
      service_port = 80
    }
    tls {
      secret_name = "tls-ssl"
    }
  }

  wait_for_load_balancer = true
}

resource "k8s_manifest" "todos-frontendconfig" {
  content = file("${path.module}/files/frontendconfig.yml")
}
