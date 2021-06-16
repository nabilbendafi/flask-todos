terraform {
  required_version = ">= 0.14.0"
  required_providers {
    k8s = {
      source  = "banzaicloud/k8s"
      version = "0.9.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.3.2"
    }
  }
}

provider "k8s" {
  config_path    = "~/.kube/config"
  config_context = "todos"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "todos"
}
