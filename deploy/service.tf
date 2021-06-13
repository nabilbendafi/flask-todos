resource "kubernetes_service" "flask" {
  metadata {
    name      = "flask"
    namespace = "todos"
  }

  spec {
    selector = {
      app = "flask"
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "postgresql" {
  metadata {
    name      = "postgresql"
    namespace = "todos"
  }

  spec {
    selector = {
      app = "postgresql"
    }
  }
}
