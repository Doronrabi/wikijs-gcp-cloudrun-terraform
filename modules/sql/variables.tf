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

variable "vpc_id" {
  description = "object id of the vpc, need to come from terraform at runtime"
  type        = string
}
variable "db_kind" {
  description = "what kind of sql version/kind we'd like to use, list can be seen in here: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#database_version-1"
  type        = string
}

variable "db_name" {
  description = "name of the db"
  type        = string
}

variable "db_user" {
  description = "name of the database user"
  type        = string
}

variable "db_password" {
  description = "database password"
  type        = string
  sensitive   = true
  ephemeral   = true
}
