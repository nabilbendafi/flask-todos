resource "kubernetes_deployment" "flask" {
  metadata {
    name      = "flask"
    namespace = "todos"

    labels = {
      app = "flask"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "flask"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask"
        }

      }

      spec {
        container {
          image = var.docker_image
          name  = "todos"
        }
      }
    }
  }
}
