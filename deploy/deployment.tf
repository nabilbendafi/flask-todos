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
          name  = "flask"
          image = var.docker_image

          env {
            name  = "DATABASE_URI"
            value = "postgresql://flask:$(POSTGRES_APP_PASSWORD)@postgresql-headless.todos.svc.cluster.local/todos"
          }
          env_from {
            secret_ref {
              name = "flask"
            }
          }
        }
      }
    }
  }
}
