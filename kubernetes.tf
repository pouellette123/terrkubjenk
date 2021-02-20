terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}


provider "kubernetes" {
   config_path = "/home/pouellet/.kube/config"
}

resource "kubernetes_service" "flask" {
  metadata {
    name = "flask-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flask.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 8079
      target_port = 8079
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "flask" {
  metadata {
    name = "scalable-flask-example"
    labels = {
      App = "ScalableFlaskExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableFlaskExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableFlaskExample"
        }
      }
      spec {
        container {
          image = "pouellette123/terrkubjenk:latest"
          name  = "example"

          port {
            container_port = 8079
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

