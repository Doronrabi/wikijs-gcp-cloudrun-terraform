variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g., dev, prod). Used for service account naming."
}

variable "secret_id" {
  type        = string
  description = "The ID of the Secret Manager secret storing the database password."
}
