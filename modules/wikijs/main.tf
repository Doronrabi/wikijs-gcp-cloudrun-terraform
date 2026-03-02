# creates a cloud run instance with wiki.js docker container and configures it
resource "google_cloud_run_v2_service" "wikijs" {
  name                = "wikijs-${var.environment}"
  location            = var.region
  project             = var.project_id
  deletion_protection = false

  ingress = "INGRESS_TRAFFIC_ALL"

  template {

    service_account = var.service_account_email

    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }

    containers {
      image = var.image

      ports {
        container_port = 3000
      }

      env {
        name  = "DB_TYPE"
        value = "postgres"
      }

      env {
        name  = "DB_HOST"
        value = var.db_host
      }

      env {
        name  = "DB_PORT"
        value = "5432"
      }

      env {
        name  = "DB_NAME"
        value = var.db_name
      }

      env {
        name  = "DB_USER"
        value = var.db_user
      }

      env {
        name = "DB_PASS"
        value_source {
          secret_key_ref {
            secret  = var.db_password_secret_name
            version = "latest"
          }
        }
      }
      startup_probe {
        http_get {
          path = "/"
          port = 3000
        }

        initial_delay_seconds = 10
        timeout_seconds       = 5
        period_seconds        = 10
        failure_threshold     = 6
      }
    }

    vpc_access {
      connector = var.vpc_connector_id
      egress    = "PRIVATE_RANGES_ONLY"
    }
  }
}

resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  count = var.allow_public_access ? 1 : 0

  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.wikijs.name

  role   = "roles/run.invoker"
  member = "allUsers"
}