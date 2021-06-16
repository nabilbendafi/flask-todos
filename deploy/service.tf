resource "kubernetes_service" "flask" {
  metadata {
    name      = "flask"
    namespace = "todos"

    annotations = {
      "cloud.google.com/app-protocols":  '{"http":"HTTP"}'
    }
  }

  spec {
    selector = {
      app = "flask"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 5000
    }

    type = "NodePort"
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
    port {
      port = 5432
    }
  }
}
