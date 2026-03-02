# Enable monitoring API
resource "google_project_service" "monitoring" {
  project = var.project_id
  service = "monitoring.googleapis.com"
}

# Extract hostname from full URL
locals {
  hostname = replace(var.service_url, "https://", "")
}

#Creates uptime check
resource "google_monitoring_uptime_check_config" "uptime" {
  display_name = "Cloud Run Uptime Check"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path    = "/"
    port    = 443
    use_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = local.hostname
    }
  }

  depends_on = [
    google_project_service.monitoring
  ]
}

# Alert policy
resource "google_monitoring_alert_policy" "uptime_alert" {
  display_name = "Cloud Run Uptime Check uptime failure"
  combiner     = "OR"
  enabled      = true

  conditions {
    display_name = "Failure of uptime check"

    condition_threshold {
      filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.uptime.uptime_check_id}\" AND resource.type=\"uptime_url\""

      comparison      = "COMPARISON_GT"
      threshold_value = 1
      duration        = "300s"

      aggregations {
        alignment_period     = "1200s"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.*"]
        per_series_aligner   = "ALIGN_NEXT_OLDER"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = []
}
