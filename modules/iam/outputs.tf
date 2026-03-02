output "service_account_email" {
  description = "Email of the service account to attach to Cloud Run."
  value       = google_service_account.cloud_run_sa.email
}
