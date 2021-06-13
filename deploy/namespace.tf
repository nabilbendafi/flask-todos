resource "kubernetes_namespace" "todos" {
  metadata {
    name = "todos"
  }
}
