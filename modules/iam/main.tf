# Create dedicated service account
resource "google_service_account" "cloud_run_sa" {
  account_id   = "wikijs-cloudrun-${var.environment}"
  display_name = "Wiki.js Cloud Run Service Account (${var.environment})"
  project      = var.project_id
}
# Grant cloud SQL access
resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}
# Grant Secret Manager Access
resource "google_secret_manager_secret_iam_member" "secret_accessor" {
  secret_id = var.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}
# Grant Logging Permissions
resource "google_project_iam_member" "logging_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}
