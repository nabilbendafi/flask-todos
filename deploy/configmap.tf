resource "kubernetes_config_map" "postgresql" {
  metadata {
    name      = "postgresql"
    namespace = "todos"
  }

  data = {
    "init-user-db.sh" = file("${path.module}/files/init-user-db.sh")
  }
}
