resource "kubernetes_manifest" "ingressroute" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind" = "IngressRoute"
    "metadata" = {
      "annotations" = {
        "kubernetes.io/ingress.class" = "traefik-external"
      }
      "name" =  var.app_name
      "namespace" = var.namespace
    }
    "spec" = {
      "entryPoints" = [
        "websecure",
      ]
      "routes" = [
        {
          "kind" = "Rule"
          "match" = "Host(`${var.app_name}.hozzlab.ca`)"
          "middlewares" = [
            {
              "name" = "default-headers"
              "namespace" = "authentik"
            },
          ]
          "priority" = 10
          "services" = [
            {
              "name" = var.app_name
              "port" = var.port
            },
          ]
        },
      ]
      "tls" = {
        "secretName" = "hozzlab-tls"
      }
    }
  }
}

