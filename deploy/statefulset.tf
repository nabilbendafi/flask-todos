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

          env {
            name  = "POSTGRES_DB"
            value = "todos"
          }
          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }
          env_from {
            secret_ref {
              name = "postgresql"
            }
          }

          volume_mount {
            name       = "initdb"
            mount_path = "/docker-entrypoint-initdb.d"
          }
        }

        volume {
          name = "initdb"

          config_map {
            name = "postgresql"
          }
        }
      }
    }
  }
}
