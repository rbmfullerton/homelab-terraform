resource "kubernetes_namespace" "uptimekuma" {
  metadata {
    name = "uptimekuma"
  }
}
