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

variable "vpc_range" {
  type        = string
  description = "VPC subnet IP range"
  default     = "10.10.0.0/24"
}

variable "private_service_prefix_length" {
  type        = number
  description = "VPC subnet IP range"
  default     = 16
}

variable "connector_range" {
  type    = string
  default = "10.30.0.0/28"
}
