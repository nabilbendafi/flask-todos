resource "kubernetes_stateful_set" "postgresql_read" {
  depends_on = [kubernetes_service.postgresql_headless]

  metadata {
    name      = "postgresql-read"
    namespace = "todos"

    labels = {
      "app.kubernetes.io/instance"  = "postgresql"
      "app.kubernetes.io/name"      = "postgresql"
      "app.kubernetes.io/component" = "read"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "postgresql"
        "app.kubernetes.io/name"     = "postgresql"
        role                         = "read"
      }
    }

    template {
      metadata {
        name = "postgresql"

        labels = {
          "app.kubernetes.io/instance"  = "postgresql"
          "app.kubernetes.io/name"      = "postgresql"
          "app.kubernetes.io/component" = "read"
          role                          = "read"
        }
      }

      spec {
        volume {
          name = "dshm"

          empty_dir {
            medium = "Memory"
          }
        }

        container {
          name  = "postgresql"
          image = "docker.io/bitnami/postgresql:11.12.0-debian-10-r23"

          port {
            name           = "tcp-postgresql"
            container_port = 5432
          }

          env_from {
            secret_ref {
              name = "postgresql"
            }
          }

          env {
            name  = "BITNAMI_DEBUG"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_VOLUME_DIR"
            value = "/var/lib/postgresql"
          }

          env {
            name  = "POSTGRESQL_PORT_NUMBER"
            value = "5432"
          }

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data"
          }

          env {
            name  = "POSTGRES_REPLICATION_MODE"
            value = "slave"
          }

          env {
            name  = "POSTGRES_REPLICATION_USER"
            value = "repl_user"
          }

          env {
            name  = "POSTGRES_CLUSTER_APP_NAME"
            value = "todos"
          }

          env {
            name  = "POSTGRES_MASTER_HOST"
            value = "postgresql"
          }

          env {
            name  = "POSTGRES_MASTER_PORT_NUMBER"
            value = "5432"
          }

          env {
            name  = "POSTGRESQL_ENABLE_TLS"
            value = "no"
          }

          env {
            name  = "POSTGRESQL_LOG_HOSTNAME"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_LOG_CONNECTIONS"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_LOG_DISCONNECTIONS"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_PGAUDIT_LOG_CATALOG"
            value = "off"
          }

          env {
            name  = "POSTGRESQL_CLIENT_MIN_MESSAGES"
            value = "error"
          }

          env {
            name  = "POSTGRESQL_SHARED_PRELOAD_LIBRARIES"
            value = "pgaudit"
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          volume_mount {
            name       = "dshm"
            mount_path = "/dev/shm"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/postgresql"
          }

          liveness_probe {
            exec {
              command = ["/bin/sh", "-c", "exec pg_isready -U \"postgres\" -h 127.0.0.1 -p 5432"]
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          readiness_probe {
            exec {
              command = ["/bin/sh", "-c", "-e", "exec pg_isready -U \"postgres\" -h 127.0.0.1 -p 5432\n[ -f /opt/bitnami/postgresql/tmp/.initialized ] || [ -f /bitnami/postgresql/.initialized ]\n"]
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            run_as_user = 1001
          }
        }

        security_context {
          fs_group = 1001
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "read"
                    "app.kubernetes.io/instance"  = "postgresql"
                    "app.kubernetes.io/name"      = "postgresql"
                  }
                }

                namespaces   = ["todos"]
                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

    service_name = "postgresql-headless"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}

resource "kubernetes_stateful_set" "postgresql_primary" {
  depends_on = [kubernetes_service.postgresql_headless]

  metadata {
    name      = "postgresql-primary"
    namespace = "todos"

    labels = {
      "app.kubernetes.io/instance"  = "postgresql"
      "app.kubernetes.io/name"      = "postgresql"
      "app.kubernetes.io/component" = "primary"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "postgresql"
        "app.kubernetes.io/name"     = "postgresql"
        role                         = "primary"
      }
    }

    template {
      metadata {
        name = "postgresql"

        labels = {
          "app.kubernetes.io/instance"  = "postgresql"
          "app.kubernetes.io/name"      = "postgresql"
          "app.kubernetes.io/component" = "primary"
          role                          = "primary"
        }
      }

      spec {
        volume {
          name = "dshm"

          empty_dir {
            medium = "Memory"
          }
        }

        volume {
          name = "initdb"

          config_map {
            name = "postgresql"
          }
        }

        container {
          name  = "postgresql"
          image = "docker.io/bitnami/postgresql:11.12.0-debian-10-r23"

          port {
            name           = "tcp-postgresql"
            container_port = 5432
          }

          env_from {
            secret_ref {
              name = "postgresql"
            }
          }

          env {
            name  = "BITNAMI_DEBUG"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_PORT_NUMBER"
            value = "5432"
          }

          env {
            name  = "POSTGRESQL_VOLUME_DIR"
            value = "/var/lib/postgresql"
          }

          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data"
          }

          env {
            name  = "POSTGRES_REPLICATION_MODE"
            value = "master"
          }

          env {
            name  = "POSTGRES_REPLICATION_USER"
            value = "repl_user"
          }

          env {
            name  = "POSTGRES_CLUSTER_APP_NAME"
            value = "todos"
          }

          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }

          env {
            name  = "POSTGRESQL_ENABLE_LDAP"
            value = "no"
          }

          env {
            name  = "POSTGRESQL_ENABLE_TLS"
            value = "no"
          }

          env {
            name  = "POSTGRESQL_LOG_HOSTNAME"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_LOG_CONNECTIONS"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_LOG_DISCONNECTIONS"
            value = "false"
          }

          env {
            name  = "POSTGRESQL_PGAUDIT_LOG_CATALOG"
            value = "off"
          }

          env {
            name  = "POSTGRESQL_CLIENT_MIN_MESSAGES"
            value = "error"
          }

          env {
            name  = "POSTGRESQL_SHARED_PRELOAD_LIBRARIES"
            value = "pgaudit"
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          volume_mount {
            name       = "initdb"
            mount_path = "/docker-entrypoint-initdb.d"
          }

          volume_mount {
            name       = "dshm"
            mount_path = "/dev/shm"
          }

          volume_mount {
            name       = "data"
            mount_path = "/var/lib/postgresql"
          }

          liveness_probe {
            exec {
              command = ["/bin/sh", "-c", "exec pg_isready -U \"postgres\" -h 127.0.0.1 -p 5432"]
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          readiness_probe {
            exec {
              command = ["/bin/sh", "-c", "-e", "exec pg_isready -U \"postgres\" -h 127.0.0.1 -p 5432\n[ -f /opt/bitnami/postgresql/tmp/.initialized ] || [ -f /bitnami/postgresql/.initialized ]\n"]
            }

            initial_delay_seconds = 5
            timeout_seconds       = 5
            period_seconds        = 10
            success_threshold     = 1
            failure_threshold     = 6
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            run_as_user = 1001
          }
        }

        security_context {
          fs_group = 1001
        }

        affinity {
          pod_anti_affinity {
            preferred_during_scheduling_ignored_during_execution {
              weight = 1

              pod_affinity_term {
                label_selector {
                  match_labels = {
                    "app.kubernetes.io/component" = "primary"
                    "app.kubernetes.io/instance"  = "postgresql"
                    "app.kubernetes.io/name"      = "postgresql"
                  }
                }

                namespaces   = ["todos"]
                topology_key = "kubernetes.io/hostname"
              }
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]

        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }

    service_name = "postgresql-headless"

    update_strategy {
      type = "RollingUpdate"
    }
  }
}
