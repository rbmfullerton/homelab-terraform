resource "kubernetes_namespace" "uptimekuma" {
  metadata {
    name = "uptimekuma"
  }
}

resource "kubernetes_namespace" "servarr-internal" {
  metadata {
    name = "servarr-internal"
  }
}

resource "kubernetes_namespace" "ai" {
  metadata {
    name = "ai"
  }
}
