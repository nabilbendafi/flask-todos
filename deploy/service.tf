resource "kubernetes_service" "flask" {
  metadata {
    name      = "flask"
    namespace = "todos"

    annotations = {
      "cloud.google.com/app-protocols" : "{'http': 'HTTP'}"
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
    port {
      name        = "tcp-postgresql"
      port        = 5432
      target_port = "tcp-postgresql"
    }

    selector = {
      "app.kubernetes.io/instance" = "postgresql"
      "app.kubernetes.io/name"     = "postgresql"
      role                         = "primary"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "postgresql_headless" {
  metadata {
    name      = "postgresql-headless"
    namespace = "todos"

    labels = {
      "service.alpha.kubernetes.io/tolerate-unready-endpoints" = "true"
    }
  }

  spec {
    port {
      name        = "tcp-postgresql"
      port        = 5432
      target_port = "tcp-postgresql"
    }

    selector = {
      "app.kubernetes.io/instance" = "postgresql"
      "app.kubernetes.io/name"     = "postgresql"
    }

    cluster_ip                  = "None"
    type                        = "ClusterIP"
    publish_not_ready_addresses = true
  }
}

resource "kubernetes_service" "postgresql_read" {
  metadata {
    name      = "postgresql-read"
    namespace = "todos"
  }

  spec {
    port {
      name        = "tcp-postgresql"
      port        = 5432
      target_port = "tcp-postgresql"
    }

    selector = {
      "app.kubernetes.io/instance" = "postgresql"
      "app.kubernetes.io/name"     = "postgresql"
      role                         = "read"
    }

    type = "ClusterIP"
  }
}
