terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

variable "gruss" {
  type    = string
  default = "Hallo aus OpenTofu"
}

resource "kubernetes_namespace_v1" "demo" {
  metadata {
    name = "tofu-demo"
  }
}

resource "kubernetes_config_map_v1" "gruss" {
  metadata {
    name      = "gruss"
    namespace = kubernetes_namespace_v1.demo.metadata[0].name
  }
  data = {
    GRUSS = var.gruss
  }
}

resource "helm_release" "podinfo" {
  name      = "podinfo"
  namespace = kubernetes_namespace_v1.demo.metadata[0].name
  chart     = "oci://ghcr.io/stefanprodan/charts/podinfo"

  set = [
    {
      name  = "replicaCount"
      value = "2"
    },
    {
      name  = "ui.message"
      value = var.gruss
    }
  ]
}

resource "kubernetes_ingress_v1" "podinfo" {
  metadata {
    name      = "podinfo"
    namespace = kubernetes_namespace_v1.demo.metadata[0].name
  }
  spec {
    ingress_class_name = "traefik"
    rule {
      host = "podinfo.localhost"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "podinfo"
              port {
                number = 9898
              }
            }
          }
        }
      }
    }
  }
}

output "url" {
  value = "http://podinfo.localhost"
}
