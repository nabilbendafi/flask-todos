resource "kubernetes_secret" "postgresql" {
  metadata {
    name      = "postgresql"
    namespace = "todos"
  }

  data = {
    POSTGRES_PASSWORD             = var.db_password
    POSTGRES_REPLICATION_PASSWORD = var.db_replication_password
    POSTGRES_APP_PASSWORD         = var.db_application_password
  }
}

resource "kubernetes_secret" "flask" {
  metadata {
    name      = "flask"
    namespace = "todos"
  }

  data = {
    POSTGRES_APP_PASSWORD = var.db_application_password
  }
}

resource "kubernetes_secret" "tls-ssl" {
  metadata {
    name      = "tls-ssl"
    namespace = "todos"
  }

  data = {
    "tls.crt" = file("${path.module}/files/server.crt")
    "tls.key" = file("${path.module}/files/server.key")
  }
}
