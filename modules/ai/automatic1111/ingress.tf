resource "kubernetes_manifest" "ingressroute" {
  manifest = {
    "apiVersion" = "traefik.io/v1alpha1"
    "kind" = "IngressRoute"
    "metadata" = {
      "annotations" = {
        "kubernetes.io/ingress.class" = "traefik-external"
      }
      "name" =  "stable-diffusion-webui"
      "namespace" = "ai"
    }
    "spec" = {
      "entryPoints" = [
        "websecure",
      ]
      "routes" = [
        {
          "kind" = "Rule"
          "match" = "Host(`automatic1111.hozzlab.ca`)"
          "middlewares" = [
            {
              "name" = "default-headers"
              "namespace" = "traefik"
            },
          ]
          "priority" = 10
          "services" = [
            {
              "name" = "stable-diffusion-webui"
              "port" = "7860"
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

