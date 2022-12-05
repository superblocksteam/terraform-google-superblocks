resource "google_cloud_run_service" "superblocks" {
  name     = "${var.name_prefix}-cloud-run-service"
  location = var.region

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "${local.ingress_rule}"
    }
  }

  template {
    spec {
      containers {
        image = var.container_image
        resources {
          requests = {
            cpu    = "${var.container_requests_cpu}"
            memory = "${var.container_requests_memory}"
          }
          limits = {
            cpu    = "${var.container_limits_cpu}"
            memory = "${var.container_limits_memory}"
          }
        }
        ports {
          container_port = var.container_port
        }
        dynamic "env" {
          for_each = var.container_env
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "${var.container_min_capacity}"
        "autoscaling.knative.dev/maxScale" = "${var.container_max_capacity}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

}

resource "google_cloud_run_service_iam_member" "superblocks" {
  service  = google_cloud_run_service.superblocks.name
  location = google_cloud_run_service.superblocks.location
  role     = var.cloud_run_role
  member   = var.cloud_run_member
}
