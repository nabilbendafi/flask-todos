resource "kubernetes_stateful_set" "postgresql" {
  metadata {
    name      = "postgresql"
    namespace = "todos"

    labels = {
      app = "postgresql"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "postgresql"
      }
    }

    service_name = "postgresql"

    template {
      metadata {
        labels = {
          app = "postgresql"
        }
      }

      spec {
        container {
          name  = "postgresql"
          image = "postgres"
        }
      }
    }
  }
}
