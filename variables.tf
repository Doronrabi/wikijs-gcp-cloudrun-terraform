variable "project_id" {
  description = "GCP project ID"
  type        = string

  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID must not be empty."
  }
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
  default     = "dev"
}

variable "db_kind" {
  description = "what kind of sql version/kind we'd like to use, list can be seen in here: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version-1"
  type        = string
  default     = "POSTGRES_15"
}

variable "db_name" {
  description = "name of the sql database"
  type        = string
  default     = "wikidb"
}

variable "db_user" {
  description = "name of the database user"
  type        = string
  default     = "wikiuser"
}

variable "db_password" {
  description = "database password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must be at least 8 characters long."
  }
}

variable "image" {
  description = "Wiki.js container image"
  type        = string
}

variable "allow_public_access_cloud_run" {
  description = "Allow or deny public access to the cloud run service"
  type        = bool
  default     = false
}