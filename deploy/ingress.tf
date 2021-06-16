resource "kubernetes_ingress" "todos" {
  metadata {
    name      = "todos"
    namespace = "todos"

    annotations = {
      "kubernetes.io/ingress.class" = "gce"
    }
  }
  spec {
    backend {
      service_name = "flask"
      service_port = 80
    }
  }

  wait_for_load_balancer = true
}
