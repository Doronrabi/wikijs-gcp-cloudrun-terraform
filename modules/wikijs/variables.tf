variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "service_account_email" {
  description = "Service account to manage cloud run"
  type        = string
}

variable "vpc_connector_id" {
  description = "vpc connector for cloud run private connection"
  type        = string
}

variable "db_host" {
  description = "SQL private ip address"
  type        = string
}

variable "db_name" {
  description = "Name of the SQL database"
  type        = string
}

variable "db_user" {
  description = "SQL user"
  type        = string
}

variable "db_password_secret_name" {
  description = "SQL password"
  type        = string
}

variable "image" {
  description = "Wiki.js container image"
  type        = string
}

variable "allow_public_access" {
  description = "Allow or deny public access to the cloud run service"
  type        = bool
}


