resource "kubernetes_secret" "postgresql" {
  metadata {
    name      = "postgresql"
    namespace = "todos"
  }

  data = {
    POSTGRES_PASSWORD     = var.db_password
    POSTGRES_APP_PASSWORD = var.db_application_password
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
